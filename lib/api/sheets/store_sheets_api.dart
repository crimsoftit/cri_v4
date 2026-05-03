import 'package:cri_v3/api/sheets/creds/gsheets_creds.dart';
import 'package:cri_v3/features/personalization/models/contacts_model.dart';
import 'package:cri_v3/features/personalization/models/gsheets_contact_model.dart';
import 'package:cri_v3/features/store/models/gsheet_models/inv_sheet_fields.dart';
import 'package:cri_v3/features/store/models/inv_model.dart';
import 'package:cri_v3/features/store/models/txns_model.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:gsheets/gsheets.dart';

class StoreSheetsApi extends GetxController {
  /// -- variables --
  static const gsheetCredentials = GsheetsCreds.credentials;
  static const spreadsheetId = GsheetsCreds.spreadSheetId;
  static final gsheets = GSheets(gsheetCredentials);
  static Worksheet? contactsSheet, invSheet, txnsSheet;

  static final RxBool deletingInvItems = false.obs;

  @override
  void onInit() async {
    deletingInvItems.value = false;

    await initSpreadSheets();
    //initSpreadSheets();
    super.onInit();
  }

  static Future initSpreadSheets() async {
    try {
      final spreadsheet = await gsheets.spreadsheet(spreadsheetId);

      contactsSheet = await getWorkSheet(
        spreadsheet,
        title: "ContactsSheet",
      );

      invSheet = await getWorkSheet(
        spreadsheet,
        title: 'InventorySheet',
      );

      txnsSheet = await getWorkSheet(
        spreadsheet,
        title: "TxnsSheet",
      );

      final contactsSheetHeaders =
          GsheetsContactModel.getContactsSheetHeaders();
      contactsSheet!.values.insertRow(
        1,
        contactsSheetHeaders,
      );

      final invSheetHeaders = InvSheetFields.getInvSheetHeaders();
      invSheet!.values.insertRow(
        1,
        invSheetHeaders,
      );

      final txnsHeaders = CTxnsModel.getHeaders();
      txnsSheet!.values.insertRow(
        1,
        txnsHeaders,
      );
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          message: '$e',
          title: 'error initializing gsheets!!',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'An unknown error occurred while initializing cloud data! Please try again later...',
          title: 'error initializing cloud data!!',
        );
      }
      rethrow;
    }
  }

  static Future<Worksheet?> getWorkSheet(
    Spreadsheet spreadsheet, {
    required String title,
  }) async {
    try {
      return await spreadsheet.addWorksheet(title);
    } catch (e) {
      return spreadsheet.worksheetByTitle(title);
    }
  }

  /// -- save unsynced inventory items to google sheets --
  static Future saveInvItemsToGSheets(
    List<Map<String, dynamic>> rowItems,
  ) async {
    try {
      if (invSheet == null) return;
      invSheet!.values.map.appendRows(rowItems);
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'error adding inventory data in cloud',
          message: e.toString(),
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'error adding inventory data in cloud',
          message:
              'an unknown error occurred while adding inventory data in cloud! please try again later.',
        );
      }

      rethrow;
    }
  }

  /// -- fetch inventory item by its id from google sheets --
  static Future<CInventoryModel?> fetchInvItemById(int id) async {
    if (invSheet == null) return null;

    final invMap = await invSheet!.values.map.rowByKey(id, fromColumn: 1);

    return CInventoryModel.gSheetFromJson(invMap!);
  }

  /// -- fetch all inventory items from the cloud --
  static Future<List<CInventoryModel?>?> fetchAllGsheetInvItems() async {
    if (invSheet == null) return null;

    final invList = await invSheet!.values.map.allRows();

    return invList == null
        ? <CInventoryModel>[]
        : invList.map(CInventoryModel.gSheetFromJson).toList();
  }

  /// -- update inventory data (entire row) in google sheets --
  static Future<bool> updateInvDataNoDeletions(
    int id,
    Map<String, dynamic> itemModel,
  ) async {
    try {
      if (invSheet == null) return false;
      return invSheet!.values.map.insertRowByKey(id, itemModel);
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'error updating cloud inventory data',
          message: e.toString(),
        );
      }

      rethrow;
    }
  }

  /// -- update data (a single cell) in google sheets --
  static Future<bool> updateInvStockCount({
    required int id,
    required String key,
    required dynamic value,
  }) async {
    try {
      if (invSheet == null) return false;
      return invSheet!.values.insertValueByKeys(
        value,
        columnKey: key,
        rowKey: id,
      );
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'error updating stockCount data in cloud',
          message: e.toString(),
        );
      }

      rethrow;
    }
  }

  /// -- update data (a single cell) in google sheets --
  static Future<bool> updateInvItemsSalesCount({
    required int id,
    required String key,
    required dynamic value,
  }) async {
    try {
      if (invSheet == null) return false;
      return invSheet!.values.insertValueByKeys(
        value,
        columnKey: key,
        rowKey: id,
      );
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'error updating sales count data in cloud',
          message: e.toString(),
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'error updating sales count data in cloud!',
          message:
              'an unknown error occurred while updating sales count data in cloud! please try again later.',
        );
      }

      //throw e.toString();
      rethrow;
    }
  }

  /// -- delete inventory data in google sheets by its id --
  static Future<bool> deleteInvItemByIdAndNotForUpdates(int id) async {
    try {
      // ignore: prefer_typing_uninitialized_variables
      var returnCmd;
      deletingInvItems.value = true;

      if (invSheet == null) return false;

      final invItemIndex = await invSheet!.values.rowIndexOf(
        id.toString().toLowerCase(),
      );

      if (invItemIndex.isNegative) {
        returnCmd = false;
        //deletingInvItems.value = false;
        return false;
      } else {
        returnCmd = invSheet!.deleteRow(invItemIndex);
        //deletingInvItems.value = false;
      }
      deletingInvItems.value = false;
      return returnCmd;
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'error deleting INVENTORY data from cloud!',
          message: e.toString(),
        );
      }
      deletingInvItems.value = false;
      //throw e.toString();
      rethrow;
    } finally {
      deletingInvItems.value = false;
    }
  }

  /// -- ## TRANSACTIONS - OPERATIONS ## --

  static Future<bool> saveTxnsToGSheets(
    List<Map<String, dynamic>> rowItems,
  ) async {
    try {
      if (txnsSheet == null) return false;
      txnsSheet!.values.map.appendRows(rowItems);
      return true;
    } catch (e) {
      // CPopupSnackBar.errorSnackBar(
      //   title: 'error syncing txns'.toUpperCase(),
      //   message: 'an error occurred while uploading txns to cloud',
      // );
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          message: '$e',
          title: 'error syncing txns'.toUpperCase(),
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'An unknown error occurred while syncing txns! Please try again later...',
          title: 'error syncing txns'.toUpperCase(),
        );
      }
      // throw 'ERROR SYNCING TXNS: $e';
      rethrow;
    }
  }

  static Future<List<CTxnsModel>?> fetchAllTxnsFromCloud() async {
    if (txnsSheet == null) return null;

    final txnsList = await txnsSheet!.values.map.allRows();

    return txnsList == null
        ? <CTxnsModel>[]
        : txnsList.map(CTxnsModel.gSheetFromJson).toList();
  }

  /// -- update receipt item --
  static Future<bool> updateReceiptItem(
    int soldItemId,
    Map<String, dynamic> receiptItemModel,
  ) async {
    try {
      if (txnsSheet == null) return false;
      return txnsSheet!.values.map.insertRowByKey(soldItemId, receiptItemModel);
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          message: e.toString(),
          title: 'error updating receipt item\'s cloud data',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'An unknown error occurred while updating receipt item\'s cloud data! Please try again later...',
          title: 'error updating receipt item\'s cloud data',
        );
      }

      rethrow;
    }
  }

  /// -- update txn item --
  static Future updateCloudTxnItems(
    int txnId,
    Map<String, dynamic> txnItemModel,
  ) async {
    try {
      if (txnsSheet == null) return false;
      return txnsSheet!.values.map.insertRowByKey(txnId, txnItemModel);
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          message: e.toString(),
          title: 'error updating receipt item\'s cloud data',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'An unknown error encountered while updating receipt item\'s cloud data! Please try again later.',
          title: 'error updating receipt item\'s cloud data',
        );
      }

      rethrow;
    }
  }

  /// -- ## CONTACTS - CRUD OPERATIONS ## --

  /// -- save unsynced contacts to google sheets --
  static Future addLocalContactsToCloud(
    List<Map<String, dynamic>> contacts,
  ) async {
    try {
      if (contactsSheet == null) return;
      contactsSheet!.values.map.appendRows(contacts);
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'error adding unsynced contacts to cloud!',
          message: e.toString(),
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'error adding unsynced contacts to cloud!',
          message:
              'An unknown error encountered while adding unsynced contacts to cloud! Please try again later.',
        );
      }

      rethrow;
    }
  }

  /// -- fetch contacts from cloud --
  static Future<List<CContactsModel?>?> fetchContactsFromCloud() async {
    try {
      if (contactsSheet == null) return null;

      final cloudContacts = await contactsSheet!.values.map.allRows();

      return cloudContacts == null
          ? <CContactsModel>[]
          : cloudContacts.map(CContactsModel.gSheetsFromJson).toList();
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'error fetching all contacts from cloud!',
          message: e.toString(),
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'error fetching all contacts from cloud!',
          message:
              'An unknown error encountered while fetching contacts from cloud! Please try again later.',
        );
      }

      rethrow;
    }
  }

  /// -- update contact details (entire row) in google sheets --
  static Future<bool> updateInitiallySyncedContacts(
    int contactId,
    Map<String, dynamic> contactItem,
  ) async {
    try {
      if (contactsSheet == null) return false;
      contactsSheet!.values.map.insertRowByKey(contactId, contactItem);
      return true;
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          message: e.toString(),
          title: 'error updating cloud contacts data',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message:
              'An unknown error occurred while updating cloud contacts data! Please try again later...',
          title: 'error updating cloud contacts data',
        );
      }

      rethrow;
    }
  }
}
