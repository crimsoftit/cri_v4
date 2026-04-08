import 'package:cri_v3/api/sheets/creds/gsheets_creds.dart';
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
  static Worksheet? invSheet, txnsSheet;

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

      invSheet = await getWorkSheet(spreadsheet, title: 'InventorySheet');

      txnsSheet = await getWorkSheet(spreadsheet, title: "TxnsSheet");

      final invSheetHeaders = InvSheetFields.getInvSheetHeaders();
      invSheet!.values.insertRow(1, invSheetHeaders);

      final txnsHeaders = CTxnsModel.getHeaders();
      // if (txnsSheet != null) {
      //   txnsSheet!.values.insertRow(1, txnsHeaders);
      // }
      txnsSheet!.values.insertRow(1, txnsHeaders);
    } catch (e) {
      if (kDebugMode) {
        print('gsheet api init error: $e');
        // CPopupSnackBar.errorSnackBar(
        //   title: 'error initializing gsheets!!',
        //   message: '$e',
        // );
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

  static Future saveInvItemsToGSheets(
    List<Map<String, dynamic>> rowItems,
  ) async {
    if (invSheet == null) return;
    invSheet!.values.map.appendRows(rowItems);
  }

  /// -- fetch inventory item by its id from google sheets --
  static Future<CInventoryModel?> fetchInvItemById(int id) async {
    if (invSheet == null) return null;

    final invMap = await invSheet!.values.map.rowByKey(id, fromColumn: 1);

    return CInventoryModel.gSheetFromJson(invMap!);
  }

  /// -- fetch all inventory items from google sheets --
  static Future<List<CInventoryModel?>?> fetchAllGsheetInvItems() async {
    if (invSheet == null) return null;

    final invList = await invSheet!.values.map.allRows();

    if (kDebugMode) {
      print(
        invList == null
            ? <CInventoryModel>[]
            : invList.map(CInventoryModel.gSheetFromJson).toList(),
      );
    }

    return invList == null
        ? <CInventoryModel>[]
        : invList.map(CInventoryModel.gSheetFromJson).toList();
  }

  /// -- update data (entire row) in google sheets --
  static Future<bool> updateInvDataNoDeletions(
    int id,
    Map<String, dynamic> itemModel,
  ) async {
    try {
      if (invSheet == null) return false;
      return invSheet!.values.map.insertRowByKey(id, itemModel);
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
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
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'error updating stockCount data in cloud',
          message: e.toString(),
        );
      }

      throw e.toString();
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
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'error updating sales count data in cloud',
          message: e.toString(),
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
        print(e.toString());
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
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'error syncing txns'.toUpperCase(),
          message: '$e',
        );
      }
      // throw 'ERROR SYNCING TXNS: $e';
      return false;
    }
  }

  static Future<List<CTxnsModel>?> fetchAllTxnsFromCloud() async {
    if (txnsSheet == null) return null;

    final txnsList = await txnsSheet!.values.map.allRows();

    if (kDebugMode) {
      print(
        txnsList == null
            ? <CTxnsModel>[]
            : txnsList.map(CTxnsModel.gSheetFromJson).toList(),
      );
    }

    return txnsList == null
        ? <CTxnsModel>[]
        : txnsList.map(CTxnsModel.gSheetFromJson).toList();
  }

  /// -- delete txn data from cloud by it's id --
  // static Future<bool> deleteReceiptItem(int id) async {
  //   try {
  //     // ignore: prefer_typing_uninitialized_variables
  //     var returnCmd;

  //     if (txnsSheet == null) return false;

  //     final receiptItemIndex =
  //         await txnsSheet!.values.rowIndexOf(id.toString().toLowerCase());

  //     if (receiptItemIndex.isNegative) {
  //       returnCmd = false;
  //       return returnCmd;
  //     } else {
  //       returnCmd = txnsSheet!.deleteRow(receiptItemIndex);
  //     }

  //     return returnCmd;
  //   } catch (e) {
  //     CPopupSnackBar.errorSnackBar(
  //       title: 'error deleting data in google sheet',
  //       message: e.toString(),
  //     );
  //     throw e.toString();
  //   }
  // }

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
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'error updating receipt item\'s cloud data',
          message: e.toString(),
        );
      }

      throw e.toString();
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
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'error updating receipt item\'s cloud data',
          message: e.toString(),
        );
      }

      throw e.toString();
    }
  }
}
