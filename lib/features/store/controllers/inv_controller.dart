import 'package:cri_v3/api/sheets/store_sheets_api.dart';
import 'package:cri_v3/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:cri_v3/features/personalization/controllers/contacts_controller.dart';
import 'package:cri_v3/features/personalization/controllers/notification_tings/flutter_local_notifications/local_notifications_controller.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/store/controllers/cart_controller.dart';
import 'package:cri_v3/features/store/controllers/search_bar_controller.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/features/store/models/inv_dels_model.dart';
import 'package:cri_v3/features/store/models/inv_model.dart';
import 'package:cri_v3/features/store/screens/store_items_tings/inventory/widgets/inv_dialog.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/db/sqflite/db_helper.dart';
import 'package:cri_v3/utils/helpers/formatter.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:clock/clock.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:simple_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class CInventoryController extends GetxController {
  static CInventoryController get instance {
    return Get.find();
  }


  /// -- variables --
  final localStorage = GetStorage();

  DbHelper dbHelper = DbHelper.instance;

  // -- controllers --
  final cartController = Get.put(CCartController());
  final notificationsController = Get.put(CLocalNotificationsController());
  final searchController = Get.put(CSearchBarController());
  final userController = Get.put(CUserController());

  final RxBool isImportingInvCloudData = false.obs;
  final RxBool itemExists = false.obs;
  final RxBool gSheetInvItemExists = false.obs;
  final RxBool includeExpiryDate = false.obs;
  final RxBool includeSupplierDetails = false.obs;
  final RxBool supplierDetailsExist = false.obs;
  final RxBool syncingInvDeletions = false.obs;

  // -- double values --
  final RxDouble lowStockItemsValue = 0.0.obs;
  final RxDouble expiredItemsValue = 0.0.obs;
  final RxDouble unitBP = 0.0.obs;
  final RxDouble totalInventoryValue = 0.0.obs;

  // -- lists --
  final RxList<CInventoryModel> allGSheetData = <CInventoryModel>[].obs;
  final RxList<CInvDelsModel> dItems = <CInvDelsModel>[].obs;
  final RxList<CInventoryModel> foundInventoryItems = <CInventoryModel>[].obs;
  final RxList<CInventoryModel> inventoryItems = <CInventoryModel>[].obs;
  final RxList<CInventoryModel> lowStockItems = <CInventoryModel>[].obs;

  final RxList<CInvDelsModel> pendingUpdates = <CInvDelsModel>[].obs;

  // final RxList<CInventoryModel> invTopSellers = <CInventoryModel>[].obs;
  final RxList<CInventoryModel> unSyncedAppends = <CInventoryModel>[].obs;
  final RxList<CInventoryModel> unSyncedUpdates = <CInventoryModel>[].obs;
  final RxList<CInventoryModel> userGSheetData = <CInventoryModel>[].obs;

  final RxList<CInventoryModel> itemsNearingExpiry = <CInventoryModel>[].obs;

  final RxList<CInventoryModel> expiredItems = <CInventoryModel>[].obs;
  final RxList<String> demMetrics = [
    'units',
    'litre',
    'kg',
    'metre',
  ].obs;

  final RxString itemMetrics = ''.obs;

  final RxString scanResults = ''.obs;

  // -- integers --
  final RxInt currentItemId = 0.obs;
  final RxInt lowStockItemsCount = 0.obs;

  // -- text editing controllers --
  final txtExpiryDatePicker = TextEditingController();
  final txtId = TextEditingController();
  final txtNameController = TextEditingController();
  final txtCode = TextEditingController();
  final txtQty = TextEditingController();
  final txtBP = TextEditingController();
  final txtUnitSP = TextEditingController();
  final txtStockNotifierLimit = TextEditingController();
  final txtSupplierName = TextEditingController();
  final txtSupplierContacts = TextEditingController();
  final txtSyncAction = TextEditingController();

  final addInvItemFormKey = GlobalKey<FormState>();

  final isLoading = false.obs;
  final syncIsLoading = false.obs;

  @override
  void onInit() async {
    await fetchUserInventoryItems();

    fetchInvDels();
    fetchInvUpdates();

    await initInvSync();

    //await scheduleExpiryAlerts();

    super.onInit();
  }

  /// -- initialize cloud sync --
  initInvSync() async {
    if (localStorage.read('SyncInvDataWithCloud') == true) {
      await importInvDataFromCloud();
      if (await importInvDataFromCloud()) {
        localStorage.write('SyncInvDataWithCloud', false);
      } else {
        localStorage.write('SyncInvDataWithCloud', true);
      }

      await fetchUserInventoryItems();
    }

    /// TODO:-- schedule notifications for items nearing expiry date (NOT HERE - CAUSES SYSTEM CRASH) --
  }

  /// -- fetch list of inventory items from sqflite db --
  Future<List<CInventoryModel>> fetchUserInventoryItems() async {
    try {
      // start loader while products are fetched
      isLoading.value = true;

      foundInventoryItems.clear();

      // fetch items from sqflite db
      final fetchedItems = await dbHelper.fetchInventoryItems(
        userController.user.value.email,
      );

      // assign inventory items
      inventoryItems.assignAll(fetchedItems);

      if (searchController.showSearchField.value &&
          (searchController.txtSearchField.text == '' ||
              searchController.txtSearchField.text.isEmpty)) {
        foundInventoryItems.assignAll(fetchedItems);
      }

      // unsynced appends
      unSyncedAppends.value = inventoryItems
          .where(
            (appendItem) =>
                appendItem.syncAction.toLowerCase().contains('append'),
          )
          .toList();

      // unsynced updates
      unSyncedUpdates.value = inventoryItems
          .where(
            (updateItem) =>
                updateItem.syncAction.toLowerCase().contains('update'),
          )
          .toList();

      // -- assign low stock items --
      lowStockItems.value = inventoryItems
          .where(
            (item) => item.quantity <= item.lowStockNotifierLimit,
          )
          .toList();

      // -- assign items nearing expiry --
      itemsNearingExpiry.value = inventoryItems
          .where(
            (expiryItem) =>
                expiryItem.expiryDate != '' &&
                CFormatter.computeTimeRangeFromNow(
                      expiryItem.expiryDate.replaceAll('@ ', ''),
                    ) <=
                    2,
          )
          .toList();

      // -- assign expired items --
      expiredItems.value = inventoryItems
          .where(
            (expiryItem) =>
                expiryItem.expiryDate != '' &&
                CFormatter.computeTimeRangeFromNow(
                      expiryItem.expiryDate.replaceAll('@ ', ''),
                    ) <=
                    0,
          )
          .toList();

      // -- count and monetary value of expired items --
      expiredItemsValue.value = expiredItems.fold(
        0.0,
        (sum, item) => sum + (item.unitSellingPrice * item.quantity),
      );

      // -- initialize inventory summary --
      if (CTxnsController.instance.dateRangeFieldController.text == '') {
        await initializeInventorySummary();
      }

      // -- fetch contacts --
      final contactsController = Get.put(CContactsController());

      contactsController.fetchMyContacts();

      List<CInventoryModel> returnItems;
      if (inventoryItems.isNotEmpty) {
        returnItems = [];
      } else {
        returnItems = inventoryItems;
      }
      // stop loader
      isLoading.value = false;
      return returnItems;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print('error fetching inventory items: $e');
        CPopupSnackBar.errorSnackBar(
          title: 'error fetching inventory items!',
          message: e.toString(),
        );
      }

      rethrow;
    }
  }

  /// -- add inventory item to sqflite database --
  addInventoryItem(CInventoryModel inventoryItem) async {
    try {
      // start loader while products are fetched
      isLoading.value = true;

      // add inventory item into sqflite db
      inventoryItem.productId =
          inventoryItem.productId == null || inventoryItem.productId! <= 100
          ? CHelperFunctions.generateInvId()
          : inventoryItem.productId;

      // -- check internet connectivity

      if (await CNetworkManager.instance.isConnected() ||
          CNetworkManager.instance.hasConnection.value) {
        // -- save data to gsheets --
        var gSheetsInvData = CInventoryModel.withID(
          inventoryItem.productId,
          userController.user.value.id,
          userController.user.value.email,
          userController.user.value.fullName,
          txtCode.text.trim(),
          txtNameController.text.trim(),
          0,
          itemMetrics.value.trim(),
          double.parse(txtQty.text.trim()),
          0.0,
          0.0,
          double.parse(txtBP.text.trim()),
          unitBP.value,
          double.parse(txtUnitSP.text.trim()),
          txtStockNotifierLimit.text != ''
              ? double.parse(txtStockNotifierLimit.text.trim())
              : (double.parse(txtQty.text.trim()) / 5),
          txtSupplierName.text.trim(),
          txtSupplierContacts.text.trim(),
          DateFormat('yyyy-MM-dd @ kk:mm').format(clock.now()),
          DateFormat('yyyy-MM-dd @ kk:mm').format(clock.now()),
          txtExpiryDatePicker.text.trim(),
          1,
          'none',
        );
        await StoreSheetsApi.saveInvItemsToGSheets([gSheetsInvData.toMap()]);

        /// -- update sync status
        inventoryItem.isSynced = 1;
        inventoryItem.syncAction = 'none';
      } else {
        inventoryItem.isSynced = 0;
        inventoryItem.syncAction = 'append';
        CPopupSnackBar.customToast(
          message:
              'while this works offline, consider using an internet connection to back up your data online!',
          forInternetConnectivityStatus: true,
        );
      }

      await dbHelper.addInventoryItem(inventoryItem);
      await fetchUserInventoryItems();

      isLoading.value = false;

      // CPopupSnackBar.successSnackBar(
      //   title: 'item added successfully',
      //   message: '${inventoryItem.name} added successfully...',
      // );
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print('error adding inventory item: $e');
        CPopupSnackBar.errorSnackBar(
          title: 'error adding inventory item!',
          message: e.toString(),
        );
      }
      rethrow;
    }
    // finally {
    //   isLoading.value = false;
    // }
  }

  /// -- upload unsynced data to the cloud --
  Future<void> addUnsyncedInvToCloud() async {
    isLoading.value = true;
    await fetchUserInventoryItems();

    // -- check internet connectivity
    final isConnectedToInternet = await CNetworkManager.instance.isConnected();

    if (isConnectedToInternet) {
      var gSheetAppendItems = unSyncedAppends
          .map(
            (e) => {
              'productId': e.productId,
              'userId': e.userId,
              'userEmail': e.userEmail,
              'userName': e.userName,
              'pCode': e.pCode,
              'name': e.name,
              'markedAsFavorite': e.markedAsFavorite,
              'calibration': e.calibration,
              'quantity': e.quantity,
              'qtySold': e.qtySold,
              'qtyRefunded': e.qtyRefunded,
              'buyingPrice': e.buyingPrice,
              'unitBp': e.unitBp,
              'unitSellingPrice': e.unitSellingPrice,
              'lowStockNotifierLimit': e.lowStockNotifierLimit,
              'supplierName': e.supplierName,
              'supplierContacts': e.supplierContacts,
              'dateAdded': e.dateAdded,
              'lastModified': e.lastModified,
              'expiryDate': e.expiryDate,
              'isSynced': 1,
              'syncAction': 'none',
            },
          )
          .toList();

      if (unSyncedAppends.isNotEmpty) {
        if (kDebugMode) {
          print(gSheetAppendItems);
        }

        await StoreSheetsApi.saveInvItemsToGSheets(gSheetAppendItems);

        await updateSyncedInvAppends();
        isLoading.value = false;
      }
    }
  }

  Future updateSyncedInvAppends() async {
    try {
      // start loader while products are fetched
      isLoading.value = true;

      // -- check internet connectivity
      final isConnectedToInternet = await CNetworkManager.instance
          .isConnected();

      if (isConnectedToInternet) {
        unSyncedAppends.value = inventoryItems
            .where((item) => item.syncAction.toLowerCase().contains('append'))
            .toList();

        if (unSyncedAppends.isNotEmpty) {
          for (var element in unSyncedAppends) {
            var syncAppendsData = CInventoryModel.withID(
              element.productId,
              element.userId,
              element.userEmail,
              element.userName,
              element.pCode,
              element.name,
              element.markedAsFavorite,
              element.calibration,
              element.quantity,
              element.qtySold,
              element.qtyRefunded,
              element.buyingPrice,
              element.unitBp,
              element.unitSellingPrice,
              element.lowStockNotifierLimit,
              element.supplierName,
              element.supplierContacts,
              element.dateAdded,
              element.lastModified,
              element.expiryDate,
              1,
              'none',
            );

            await dbHelper.updateInventoryItem(
              syncAppendsData,
              element.productId!,
            );
            isLoading.value != isLoading.value;
          }
        }
      }
    } catch (e) {
      isLoading.value = false;

      if (kDebugMode) {
        print('error updating inventory appends: $e');
        CPopupSnackBar.errorSnackBar(
          title: 'error updating inventory appends!',
          message: e.toString(),
        );
      }
      rethrow;
    }
  }

  /// -- fetch inventory item by code --
  Future<List<CInventoryModel>> fetchItemByCodeAndEmail(String code) async {
    try {
      // start loader while products are fetched
      isLoading.value = true;

      // fetch scanned item from sqflite db
      final fetchedItem = await dbHelper.fetchInvItemByCodeAndEmail(
        code,
        userController.user.value.email,
      );

      //fetchInventoryItems();

      if (fetchedItem.isNotEmpty) {
        if (fetchedItem.first.supplierName != '' ||
            fetchedItem.first.supplierContacts != '') {
          supplierDetailsExist.value = true;
          includeSupplierDetails.value = true;
          txtSupplierName.text = fetchedItem.first.supplierName;
          txtSupplierContacts.text = fetchedItem.first.supplierContacts;
        } else {
          supplierDetailsExist.value = false;
          includeSupplierDetails.value = false;
          txtSupplierName.text = '';
          txtSupplierContacts.text = '';
        }
        if (fetchedItem.first.expiryDate != '') {
          includeExpiryDate.value = true;
          txtExpiryDatePicker.text = fetchedItem.first.expiryDate;
        } else {
          includeExpiryDate.value = false;
          txtExpiryDatePicker.text = '';
        }
        currentItemId.value = fetchedItem.first.productId!;

        itemExists.value = true;

        txtId.text = currentItemId.value.toString();
        txtNameController.text = fetchedItem.first.name;

        itemMetrics.value = fetchedItem.first.calibration;
        txtQty.text = (fetchedItem.first.quantity).toString();
        txtBP.text = (fetchedItem.first.buyingPrice).toString();
        unitBP.value = fetchedItem.first.unitBp;
        txtUnitSP.text = (fetchedItem.first.unitSellingPrice).toString();

        txtStockNotifierLimit.text = (fetchedItem.first.lowStockNotifierLimit)
            .toString();

        txtSyncAction.text = 'update';
      } else {
        itemExists.value = false;
        supplierDetailsExist.value = false;
        txtExpiryDatePicker.text = '';
        txtId.text = '';
        txtNameController.text = '';
        itemMetrics.value = '';
        txtQty.text = '';
        txtBP.text = '';
        unitBP.value = 0.0;
        txtUnitSP.text = '';
        txtStockNotifierLimit.text = '';
        txtSupplierName.text = '';
        txtSupplierContacts.text = '';
        txtExpiryDatePicker.text = '';
        txtSyncAction.text = 'append';
      }
      isLoading.value = false;
      return fetchedItem;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print('error fetching item by code and email: $e');
        CPopupSnackBar.errorSnackBar(
          title: 'error fetching item by code and email!',
          message: e.toString(),
        );
      }
      rethrow;
    }
  }

  void runInvScanner() {
    txtBP.text = "";
    txtCode.text = "";
    txtExpiryDatePicker.text = "";
    txtId.text = "";
    itemMetrics.value = '';
    txtQty.text = "";
    txtStockNotifierLimit.text = "";
    txtSupplierContacts.text = '';
    txtSupplierName.text = "";
    txtNameController.text = "";
    txtExpiryDatePicker.text = "";
    txtUnitSP.text = "";
    unitBP.value = 0.0;

    scanBarcodeNormal();
  }

  searchInventory(String value) {
    fetchUserInventoryItems();
    //foundInventoryItems.clear();

    var invSearchItems = inventoryItems
        .where(
          (element) =>
              element.name.toLowerCase().contains(value.toLowerCase()) ||
              element.productId.toString().toLowerCase().contains(
                value.toLowerCase(),
              ) ||
              element.pCode.toLowerCase().contains(value.toLowerCase()) ||
              element.dateAdded.toLowerCase().contains(value.toLowerCase()) ||
              element.lastModified.toLowerCase().contains(
                value.toLowerCase(),
              ) ||
              element.expiryDate.toLowerCase().contains(value.toLowerCase()),
        )
        .toList();

    foundInventoryItems.assignAll(invSearchItems);
  }

  /// -- update inventory item --
  updateInventoryItem(CInventoryModel inventoryItem) async {
    try {
      // -- start loader
      isLoading.value = true;

      // -- update entry
      // await dbHelper.updateInventoryItem(
      //   inventoryItem,
      //   int.parse(txtId.text.trim()),
      // );
      await dbHelper.updateInventoryItem(
        inventoryItem,
        inventoryItem.productId!,
      );

      // -- refresh inventory list
      fetchUserInventoryItems();

      // -- stop loader
      isLoading.value = false;
    } catch (e) {
      // -- stop loader
      isLoading.value = false;
      if (kDebugMode) {
        print('error updating inventory item: $e');
        CPopupSnackBar.errorSnackBar(
          title: 'error updating inventory item!',
          message: 'error updating inventory item: $e',
        );
      }
      CPopupSnackBar.errorSnackBar(
        title: 'error updating inventory item!',
        message: 'an unknown error occurred while updating inventory item!',
      );
      rethrow;
    }
  }

  /// -- delete inventory item entry --
  Future<void> deleteInventoryItem(CInventoryModel inventoryItem) async {
    try {
      // -- start loader
      isLoading.value = true;

      // -- check if item is in cart and remove it first --
      int forDeleteCartItemIndex = cartController.cartItems.indexWhere(
        (uCartItem) => uCartItem.productId == inventoryItem.productId,
      );

      if (kDebugMode) {
        print(forDeleteCartItemIndex);
        CPopupSnackBar.customToast(
          message: '$forDeleteCartItemIndex',
          forInternetConnectivityStatus: false,
        );
      }

      if (forDeleteCartItemIndex >= 0) {
        cartController.cartItems.clear();
        cartController.updateCart();
      }

      // -- delete entry
      await dbHelper.deleteInventoryItem(inventoryItem);

      // -- refresh inventory list
      fetchUserInventoryItems();

      searchController.txtSearchField.text = '';

      // -- stop loader
      isLoading.value = false;

      // -- success message
      CPopupSnackBar.successSnackBar(
        title: 'delete success',
        message: '${inventoryItem.name} deleted successfully...',
      );
    } catch (e) {
      // -- stop loader
      isLoading.value = false;

      if (kDebugMode) {
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'error deleting data',
          message: e.toString(),
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'error deleting data',
          message: 'unable to delete this item... please try again later!',
        );
      }

      rethrow;
    }
  }

  /// -- check if update is really necessary --
  Future<bool> invUpdateIsNecessary(CInventoryModel forUpdateItem) async {
    try {
      if (itemExists.value) {
        final originalContent = CInventoryModel.withID(
          forUpdateItem.productId,
          forUpdateItem.userId,
          forUpdateItem.userEmail,
          forUpdateItem.userName,
          forUpdateItem.pCode,
          forUpdateItem.name,
          forUpdateItem.markedAsFavorite,
          forUpdateItem.calibration,
          forUpdateItem.quantity,
          forUpdateItem.qtySold,
          forUpdateItem.qtyRefunded,
          forUpdateItem.buyingPrice,
          forUpdateItem.unitBp,
          forUpdateItem.unitSellingPrice,
          forUpdateItem.lowStockNotifierLimit,
          forUpdateItem.supplierName,
          forUpdateItem.supplierContacts,
          forUpdateItem.dateAdded,
          forUpdateItem.lastModified,
          forUpdateItem.expiryDate,
          forUpdateItem.isSynced,
          forUpdateItem.syncAction,
        );

        final newContent = CInventoryModel.withID(
          forUpdateItem.productId,
          userController.user.value.id,
          userController.user.value.email,
          userController.user.value.fullName,
          txtCode.text.trim(),
          txtNameController.text.trim(),
          forUpdateItem.markedAsFavorite,
          itemMetrics.value.trim(),
          double.parse(txtQty.text.trim()),
          forUpdateItem.qtySold,
          forUpdateItem.qtyRefunded,
          double.parse(txtBP.text.trim()),
          unitBP.value,
          double.parse(txtUnitSP.text.trim()),
          double.parse(txtStockNotifierLimit.text.trim()),
          txtSupplierName.text.trim(),
          txtSupplierContacts.text.trim(),
          forUpdateItem.dateAdded,
          forUpdateItem.lastModified,
          txtExpiryDatePicker.text.trim(),
          forUpdateItem.isSynced,
          forUpdateItem.syncAction,
        );

        if (originalContent == newContent) {
          CPopupSnackBar.customToast(
            forInternetConnectivityStatus: false,
            message: 'update is not necessary',
          );
          return false;
        } else {
          CPopupSnackBar.customToast(
            forInternetConnectivityStatus: false,
            message: 'UPDATE IS NECESSARY',
          );
          return true;
        }
      } else {
        return true;
      }
    } catch (e) {
      if (kDebugMode) {
        print('error updating inventory item: $e');
        CPopupSnackBar.errorSnackBar(
          title: 'error updating inventory item',
          message: e.toString(),
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'an unknown error occurred while adding/updating inventory item! please try again later.',
          title: 'error adding/updating inventory item',
        );
      }
      rethrow;
    }
  }

  /// -- add or update inventory item using sqflite
  Future<bool> addOrUpdateInventoryItem(CInventoryModel inventoryItem) async {
    try {
      // Validate returns true if the form is valid, or false otherwise.
      if (addInvItemFormKey.currentState!.validate()) {
        inventoryItem.userId = userController.user.value.id;
        inventoryItem.userEmail = userController.user.value.email;
        inventoryItem.userName = userController.user.value.fullName;

        inventoryItem.name = txtNameController.text.trim();
        inventoryItem.pCode = txtCode.text.trim();
        inventoryItem.calibration = itemMetrics.value;
        inventoryItem.quantity = double.parse(txtQty.text.trim());
        inventoryItem.buyingPrice = double.parse(txtBP.text.trim());
        inventoryItem.unitBp = unitBP.value;
        inventoryItem.unitSellingPrice = double.parse(txtUnitSP.text);
        inventoryItem.lowStockNotifierLimit = txtStockNotifierLimit.text != ''
            ? double.parse(txtStockNotifierLimit.text.trim())
            : (double.parse(txtQty.text.trim()) / 5) + 1;

        inventoryItem.supplierName = txtSupplierName.text.trim();
        inventoryItem.supplierContacts = txtSupplierContacts.text.trim();
        inventoryItem.lastModified = DateFormat(
          'yyyy-MM-dd @ kk:mm',
        ).format(clock.now());
        inventoryItem.expiryDate = txtExpiryDatePicker.text.trim();

        inventoryItem.syncAction = txtSyncAction.text.trim();

        if (itemExists.value) {
          // -- check internet connectivity
          final isConnectedToInternet = await CNetworkManager.instance
              .isConnected();

          if (isConnectedToInternet) {
            inventoryItem.isSynced = 1;
            inventoryItem.syncAction = 'none';
            updateInvSheetItem(int.parse(txtId.text.trim()), inventoryItem);
          } else {
            inventoryItem.syncAction = inventoryItem.isSynced == 1
                ? 'update'
                : 'append';

            final deleteItem = CInvDelsModel(
              inventoryItem.productId!,
              inventoryItem.name,
              'inventory',
              inventoryItem.isSynced,
              inventoryItem.syncAction,
            );
            await dbHelper.saveInvDelsForSync(deleteItem);
            CPopupSnackBar.customToast(
              message:
                  'While this works offline, consider using an internet connection to back up your data online!',
              forInternetConnectivityStatus: true,
            );
          }
          updateInventoryItem(inventoryItem).then(
            (_) {
              resetInvFields();
            },
          );
        } else {
          inventoryItem.dateAdded = DateFormat(
            'yyyy-MM-dd @ kk:mm',
          ).format(clock.now());
          addInventoryItem(inventoryItem).then(
            (_) {
              resetInvFields();
            },
          );
        }
      }

      return true;
    } catch (e) {
      if (kDebugMode) {
        print('error adding/updating inventory item: $e');
        CPopupSnackBar.errorSnackBar(
          title: 'error adding/updating inventory item',
          message: e.toString(),
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'an unknown error occurred while adding/updating inventory item! please try again later.',
          title: 'error adding/updating inventory item',
        );
      }
      rethrow;
    }
  }

  /// -- barcode scanner --
  void scanBarcodeNormal() async {
    try {
      scanResults.value = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'cancel',
        true,
        ScanMode.BARCODE,
        2000,
        CameraFace.back.toString(),
        ScanFormat.ALL_FORMATS,
      );
      txtCode.text = scanResults.value;
      fetchItemByCodeAndEmail(txtCode.text);
    } on PlatformException {
      scanResults.value = "ERROR!! failed to get platform version";
    } catch (e) {
      scanResults.value = "ERROR!! failed to get platform version";
      CPopupSnackBar.errorSnackBar(
        title: 'scan error',
        message: e.toString(),
      );
      rethrow;
    }
  }

  /// -- delete account warning popup snackbar --
  Future<void> deleteInventoryWarningPopup(
    CInventoryModel inventoryItem,
  ) async {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(CSizes.md),
      title: 'Permanently delete ${inventoryItem.name}?',
      middleText:
          'Are you certain you want to permanently delete this item? THIS ACTION CAN\'T BE UNDONE!',
      confirm: ElevatedButton(
        onPressed: () async {
          // -- check internet connectivity
          final isConnected = CNetworkManager.instance.hasConnection.value;

          if (isConnected) {
            if (inventoryItem.isSynced == 1) {
              deleteInvSheetItemNotForUpdates(inventoryItem.productId!);
            }
          } else {
            final delItem = CInvDelsModel(
              inventoryItem.productId!,
              inventoryItem.name,
              'inventory',
              inventoryItem.isSynced,
              'delete',
            );
            await dbHelper.saveInvDelsForSync(delItem);
          }
          await deleteInventoryItem(inventoryItem);

          Navigator.of(Get.overlayContext!).pop();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          side: const BorderSide(color: Colors.red),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: CSizes.lg),
          child: Text('delete'),
        ),
      ),
      cancel: OutlinedButton(
        onPressed: () {
          fetchUserInventoryItems();
          Navigator.of(Get.overlayContext!).pop();
        },
        child: const Text('cancel'),
      ),
    );
  }

  /// -- fetch list of inventory items from google sheets --
  Future fetchAllInvSheetItems() async {
    try {
      // fetch items from sqflite db
      var gsheetItemsList = (await StoreSheetsApi.fetchAllGsheetInvItems())!;

      allGSheetData.assignAll(gsheetItemsList as Iterable<CInventoryModel>);

      return allGSheetData;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print('error fetching all inventory sheet items: $e');
        CPopupSnackBar.errorSnackBar(
          title: 'error fetching all inventory sheet items!',
          message: e.toString(),
        );
      }
      rethrow;
    }
  }

  /// -- update single item cloud data --
  Future updateInvSheetItem(int id, CInventoryModel itemModel) async {
    try {
      //await StoreSheetsApi.initializeSpreadSheets();
      await StoreSheetsApi.updateInvDataNoDeletions(id, itemModel.toMap());
    } catch (e) {
      if (kDebugMode) {
        print('error updating inventory cloud data: $e');
        CPopupSnackBar.errorSnackBar(
          title: 'error updating inventory cloud data',
          message: e.toString(),
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Error updating inventory cloud data',
          message:
              'An unknown error occurred while updating inventory cloud data. Please try again later!',
        );
      }

      rethrow;
    }
  }

  /// -- delete inventory item from google sheets --
  Future deleteInvSheetItemNotForUpdates(int id) async {
    try {
      await StoreSheetsApi.deleteInvItemByIdAndNotForUpdates(id);
    } catch (e) {
      if (kDebugMode) {
        print('error deleting inventory cloud data: $e');
        CPopupSnackBar.errorSnackBar(
          title: 'error deleting inventory cloud data',
          message: e.toString(),
        );
      }

      rethrow;
    }
  }

  /// -- fetch inventory data from google sheets by userEmail --
  Future fetchUserInvSheetData() async {
    try {
      // fetch inventory items from cloud
      var gsheetItemsList = (await StoreSheetsApi.fetchAllGsheetInvItems())!;

      allGSheetData.assignAll(gsheetItemsList as Iterable<CInventoryModel>);

      userGSheetData.value = allGSheetData
          .where(
            (element) => element.userEmail.toLowerCase().contains(
              userController.user.value.email.toLowerCase(),
            ),
          )
          .toList();

      return userGSheetData;
    } catch (e) {
      isLoading.value = false;
      if (kDebugMode) {
        print('ERROR FETCHING USER GSHEET INV DATA');
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap! ERROR FETCHING USER GSHEET INV DATA',
          message: e.toString(),
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap! ',
          message:
              'an unknown error occurred while importing inventory data from cloud!',
        );
      }

      rethrow;
    }
  }

  /// -- import inventory data from google sheets --
  Future<bool> importInvDataFromCloud() async {
    try {
      isImportingInvCloudData.value = true;

      // -- check internet connectivity

      await fetchUserInvSheetData().then((_) async {
        if (userGSheetData.isNotEmpty) {
          for (var element in userGSheetData) {
            var dbData = CInventoryModel.withID(
              element.productId,
              element.userId,
              element.userEmail,
              element.userName,
              element.pCode,
              element.name,
              element.markedAsFavorite,
              element.calibration,
              element.quantity,
              element.qtySold,
              element.qtyRefunded,
              element.buyingPrice,
              element.unitBp,
              element.unitSellingPrice,
              element.lowStockNotifierLimit,
              element.supplierName,
              element.supplierContacts,
              element.dateAdded,
              element.lastModified,
              element.expiryDate,
              element.isSynced,
              element.syncAction,
            );

            // -- save imported data to local sqflite database --
            dbHelper.addInventoryItem(dbData);
          }
        }
      });
      // -- refresh inventory items' list --
      Future.delayed(Duration.zero, () {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await fetchUserInventoryItems();
        });
      });

      if (kDebugMode) {
        print("----------\n\n $userGSheetData \n\n ----------");
      }
      isImportingInvCloudData.value = false;
      return true;
    } catch (e) {
      isImportingInvCloudData.value = false;
      if (kDebugMode) {
        print('ERROR IMPORTING inventory DATA FROM CLOUD: $e');
        CPopupSnackBar.errorSnackBar(
          title: 'ERROR IMPORTING inventory DATA FROM CLOUD!',
          message: e.toString(),
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'ERROR IMPORTING inventory DATA FROM CLOUD!',
          message: e.toString(),
        );
      }
      rethrow;
    }
  }

  /// -- fetch items with pending deletions --
  Future<List<CInvDelsModel>> fetchInvDels() async {
    try {
      final dels = await dbHelper.fetchAllInvDels();
      dItems.assignAll(dels);

      return dItems.toList();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'DELS ERROR',
          message: e.toString(),
        );
      }

      rethrow;
    }
  }

  Future<bool> syncInvDelsAndNotForUpdates() async {
    try {
      // -- start loader --
      syncingInvDeletions.value = true;

      // -- check internet connectivity
      final isConnectedToInternet = await CNetworkManager.instance
          .isConnected();
      if (isConnectedToInternet) {
        final dels = await dbHelper.fetchAllInvDels();
        dItems.assignAll(dels);

        if (dItems.isNotEmpty) {
          for (var element in dItems) {
            await deleteInvSheetItemNotForUpdates(element.itemId!);

            final delItem = CInvDelsModel(
              element.itemId,
              element.itemName,
              'inventory',
              1,
              'none',
            );

            await dbHelper.updateDel(delItem);
          }
        }
      }
      syncingInvDeletions.value = false;
      return true;
    } catch (e) {
      syncingInvDeletions.value = false;
      if (kDebugMode) {
        print('$e : error syncing local inventory deletions!!');
        CPopupSnackBar.errorSnackBar(
          title: 'error syncing local inventory deletions!!',
          message: e.toString(),
        );
      }
      rethrow;
    }
  }

  /// -- fetch items with pending updates --
  Future<List<CInvDelsModel>> fetchInvUpdates() async {
    try {
      final pUpdates = await dbHelper.fetchAllInvUpdates();
      pendingUpdates.assignAll(pUpdates);

      return pendingUpdates;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'DELS ERROR',
          message: e.toString(),
        );
      }

      rethrow;
    }
  }

  Future syncInvUpdatesToCloud() async {
    await fetchUserInventoryItems();

    // -- check internet connectivity
    final isConnectedToInternet = await CNetworkManager.instance.isConnected();

    if (isConnectedToInternet) {
      if (unSyncedUpdates.isNotEmpty) {
        for (var element in unSyncedUpdates) {
          final invUpdateItem = CInventoryModel.withID(
            element.productId,
            element.userId,
            element.userEmail,
            element.userName,
            element.pCode,
            element.name,
            element.markedAsFavorite,
            element.calibration,
            element.quantity,
            element.qtySold,
            element.qtyRefunded,
            element.buyingPrice,
            element.unitBp,
            element.unitSellingPrice,
            element.lowStockNotifierLimit,
            element.supplierName,
            element.supplierContacts,
            element.dateAdded,
            element.lastModified,
            element.expiryDate,
            1,
            'none',
          );

          await StoreSheetsApi.updateInvDataNoDeletions(
            invUpdateItem.productId!,
            invUpdateItem.toMap(),
          ).then((result) {
            if (result) {
              dbHelper.updateInventoryItem(invUpdateItem, element.productId!);
              fetchUserInventoryItems();
            }
          });
        }
      } else {
        if (kDebugMode) {
          print('/n/n ----- /n all updates rada safi \n -----');
        }
      }
    }
  }

  Future<bool> cloudSyncInventory() async {
    try {
      // start loader
      syncIsLoading.value = true;
      await fetchUserInventoryItems();
      await fetchInvDels();

      // -- check internet connectivity

      if (await CNetworkManager.instance.isConnected()) {
        /// -- initialize spreadsheets --
        await StoreSheetsApi.initSpreadSheets();
        await syncInvDelsAndNotForUpdates();
        await addUnsyncedInvToCloud();
        await syncInvUpdatesToCloud();
        // stop loader
        syncIsLoading.value = false;
        return true;
      } else {
        // stop loader
        syncIsLoading.value = false;
        CPopupSnackBar.warningSnackBar(
          title: 'cloud sync requires internet',
          message: 'an internet connection is required for cloud sync...',
        );
        return false;
      }
    } catch (e) {
      // stop loader
      syncIsLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'inventory cloud sync ERROR!',
          message: 'inventory sync error: $e',
        );
      }
      rethrow;
    }
    // finally {
    //   // stop loader
    //   syncIsLoading.value = false;
    // }
  }

  /// -- fetch top sellers --
  // Future<List<CInventoryModel>> fetchTopSellersFromInventory() async {
  //   try {
  //     // start loader while products are fetched
  //     isLoading.value = true;

  //     await dbHelper.openDb();

  //     final topSellers = await dbHelper.fetchTopSellers(
  //       userController.user.value.email,
  //     );

  //     // assign top sold items to a list
  //     //.assignAll(topSellers);

  //     // stop loader
  //     isLoading.value = false;

  //     return invTopSellers;
  //   } catch (e) {
  //     isLoading.value = false;
  //     if (kDebugMode) {
  //       print(e.toString());
  //       CPopupSnackBar.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  //     }
  //     return [];
  //   }
  // }

  /// -- compute low stock threshold for alerts --
  computeLowStockThreshold(double qty) {
    var threshold = (qty * .2).toDouble();
    var formattedOutput = CFormatter.formatItemQtyDisplays(
      threshold == 0.0 ? threshold + 1 : threshold,
      itemMetrics.value,
    );
    // txtStockNotifierLimit.text = threshold == 0.0
    //     ? (threshold + 1).toString()
    //     : threshold.toString();
    txtStockNotifierLimit.text = formattedOutput;
  }

  /// -- compute unitBP --
  computeUnitBP(double bp, double qty) {
    unitBP.value = bp / qty;
  }

  toggleSupplierDetsFieldsVisibility(value) {
    includeSupplierDetails.value = value;
    if (value == false) {
      txtSupplierName.text = '';
      txtSupplierContacts.text = '';
    }
  }

  toggleExpiryDateFieldVisibility(value) {
    includeExpiryDate.value = value;
    if (!includeExpiryDate.value) {
      txtExpiryDatePicker.text = '';
    }
  }

  /// -- reset fields --
  Future resetInvFields() async {
    itemExists.value = false;
    itemMetrics.value = "";
    includeSupplierDetails.value = false;
    includeExpiryDate.value = false;
    txtId.text = "";
    txtNameController.text = "";
    txtCode.text = "";

    txtQty.text = "";
    txtBP.text = "";
    unitBP.value = 0.0;
    txtUnitSP.text = "";
    txtStockNotifierLimit.text = "";
    txtSupplierName.text = "";
    txtSupplierContacts.text = '';
    txtExpiryDatePicker.text = '';
    txtSyncAction.text = '';
  }

  /// -- bottomSheetModal for when usp is less than ubp --
  Future<dynamic> confirmInvalidUspModal(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(
            CSizes.lg / 3,
          ),
          child: Column(
            children: [
              const CSectionHeading(
                showActionBtn: false,
                title: 'You may be selling at a loss...',
                btnTitle: '',
                editFontSize: true,
              ),
              const SizedBox(
                height: CSizes.spaceBtnSections / 4,
              ),
            ],
          ),
        );
      },
    );
  }

  /// -- format & set item's expiry date --
  Future<void> pickExpiryDate() async {
    DateTime? expiryDate = await showDatePicker(
      context: Get.overlayContext!,
      firstDate: DateTime(2025),
      initialDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (expiryDate != null) {
      String formattedDate = DateFormat(
        "yyyy-MM-dd @ kk:mm",
      ).format(expiryDate);

      txtExpiryDatePicker.text = formattedDate;
    }
  }

  removeExpiry() {
    txtExpiryDatePicker.text = '';
    //includeExpiryDate.value = false;
  }

  /// -- toggle favorite status --
  Future<void> toggleFavoriteStatus(CInventoryModel inventoryItem) async {
    try {
      // -- start loader
      isLoading.value = true;

      inventoryItem.markedAsFavorite = inventoryItem.markedAsFavorite == 1
          ? 0
          : 1;

      // -- update entry
      await dbHelper.updateInventoryItem(
        inventoryItem,
        inventoryItem.productId!,
      );
      // -- refresh inventory list
      await fetchUserInventoryItems();
      inventoryItems.refresh();

      // -- stop loader
      isLoading.value = false;
    } catch (e) {
      // -- stop loader
      isLoading.value = false;
      if (kDebugMode) {
        print('error toggling favorite status: $e');
        CPopupSnackBar.errorSnackBar(
          title: 'error toggling favorite status',
          message: e.toString(),
        );
      }
      CPopupSnackBar.errorSnackBar(
        title: 'error toggling favorite status',
        message: 'unable to toggle favorite status, please try again later!',
      );
      rethrow;
    }
  }

  /// -- initialize inventory summary --
  Future<void> initializeInventorySummary() async {
    try {
      if (inventoryItems.isNotEmpty) {
        // -- total value of items in inventory --
        // totalInventoryValue.value = inventoryItems
        //     .where((invItem) => invItem.quantity > 0)
        //     .fold(0.0, (sum, item) => sum + (item.unitBp * item.quantity));
        totalInventoryValue.value = inventoryItems.fold(
          0.0,
          (sum, item) => sum + (item.unitBp * item.quantity),
        );

        // -- total count and value of low stock items in inventory --
        lowStockItemsCount.value = lowStockItems.length;
        // lowStockItemsValue.value = lowStockItems
        //     .where((item) => item.quantity >= 1)
        //     .fold(0.0, (sum, item) => sum + (item.unitBp * item.quantity));
        lowStockItemsValue.value = lowStockItems.fold(
          0.0,
          (sum, item) => sum + (item.unitBp * item.quantity),
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('error initializing inventory summary: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'error initializing inventory summary: $e',
          title: 'inventory summary init error!',
        );
      }
    }
  }

  Future<void> scheduleExpiryAlerts() async {
    try {
      final notsController = Get.put(CLocalNotificationsController());
      if (itemsNearingExpiry.isNotEmpty) {
        for (var expiryItem in itemsNearingExpiry) {
          notsController.scheduleExpiryNotification(
            alertId: await notsController.generateNotificationId(),
            expiryDate: DateTime.parse(
              expiryItem.expiryDate.replaceAll(' @', ''),
            ),
            itemName: expiryItem.name,
          );
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('error scheduling notifications: $e');
        CPopupSnackBar.errorSnackBar(
          title: 'scheduling notifications!',
          message: 'error scheduling notifications: $e',
        );
      }
      rethrow;
    }
  }

  String setItemMetrics() {
    itemMetrics.value = itemExists.value || itemMetrics.value != ''
        ? itemMetrics.value
        : demMetrics[0];
    return itemMetrics.value;
  }

  addInvItemDialogAction(bool fromHomeScreen) {
    resetInvFields();
    AddUpdateItemDialog dialog = AddUpdateItemDialog();

    showDialog(
      context: Get.overlayContext!,
      useRootNavigator: false,
      builder: (BuildContext context) => dialog.buildDialog(
        context,
        CInventoryModel(
          '',
          '',
          '',
          '',
          '',
          0,
          '',
          0,
          0,
          0,
          0.0,
          0.0,
          0.0,
          0,
          '',
          '',
          '',
          '',
          '',
          0,
          '',
        ),
        true,
        fromHomeScreen,
      ),
    );
  }

  @override
  void dispose() {
    // TODO: dispose controllers --
    // -- clean up the controller when the widget is removed from the widget tree --
    txtBP.dispose();
    txtCode.dispose();
    txtExpiryDatePicker.dispose();
    txtId.dispose();
    txtNameController.dispose();
    txtQty.dispose();
    txtStockNotifierLimit.dispose();
    txtSupplierContacts.dispose();
    txtSupplierName.dispose();
    txtSyncAction.dispose();
    txtUnitSP.dispose();

    super.dispose();
  }
}
