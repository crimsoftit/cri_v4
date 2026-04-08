import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class CSyncController extends GetxController {
  static CSyncController get instance => Get.find();

  /// -- variables --
  final invController = Get.put(CInventoryController());
  final RxBool processingSync = false.obs;
  final txnsController = Get.put(CTxnsController());

  @override
  void onInit() {
    processingSync.value = false;
    super.onInit();
  }

  // Future<bool> processSync() async {
  //   try {
  //     processingSync.value = true;

  //     await invController.fetchUserInventoryItems();
  //     await txnsController.fetchSoldItems();

  //     if (await invController.cloudSyncInventory()) {
  //       await txnsController.addUpdateSalesDataToCloud().then((_) async {
  //         if (invController.syncIsLoading.value ||
  //             txnsController.txnsSyncIsLoading.value) {
  //           processingSync.value = true;
  //         } else {
  //           processingSync.value = false;
  //         }
  //       });
  //     }

  //     processingSync.value = false;

  //     return processingSync.value;
  //   } catch (e) {
  //     if (kDebugMode) {
  //       print(e.toString());
  //       CPopupSnackBar.errorSnackBar(
  //         title: 'error processing sync (syncController)',
  //         message: e.toString(),
  //       );
  //     }
  //     rethrow;
  //   }
  // }

  Future<bool> processSync() async {
    try {
      processingSync.value = true;

      // await invController.fetchUserInventoryItems();
      // await txnsController.fetchSoldItems();

      if (await invController.cloudSyncInventory()) {
        await txnsController.addUpdateSalesDataToCloud().then(
          (result) {
            if (result) {
              processingSync.value = false;
            } else {
              processingSync.value = true;
            }
          },
        );
      }

      return processingSync.value;
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'error processing store cloud sync (syncController)',
          message: e.toString(),
        );
      }
      rethrow;
    }
  }
}
