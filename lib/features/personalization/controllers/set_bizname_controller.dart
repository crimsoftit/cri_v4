import 'package:cri_v3/data/repos/auth/auth_repo.dart';
import 'package:cri_v3/data/repos/user/user_repo.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:cri_v3/utils/popups/full_screen_loader.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CSetBiznameController extends GetxController {
  static CSetBiznameController get instance => Get.find();

  /// -- variables --
  final bizNameField = TextEditingController();
  final userController = Get.put(CUserController());
  final userRepo = Get.put(CUserRepo());

  GlobalKey<FormState> editBizNameFormKey = GlobalKey<FormState>();

  /// -- initialize user data when home screen loads --
  @override
  void onInit() {
    initializeBizName();
    super.onInit();
  }

  /// -- fetch initial user record --
  Future<void> initializeBizName() async {
    bizNameField.text = userController.user.value.businessName;
  }

  /// -- update business name --
  Future<void> updateBizName() async {
    try {
      // -- start loader
      CFullScreenLoader.openLoadingDialog(
        'we\'re updating your info...',
        CImages.docerAnimation,
      );

      // -- check internet connectivity
      final isConnected = await CNetworkManager.instance.isConnected();
      if (!isConnected) {
        // stop loader
        CFullScreenLoader.stopLoading();
        return;
      }

      // -- form validation
      if (!editBizNameFormKey.currentState!.validate()) {
        CFullScreenLoader.stopLoading();
        return;
      }

      // -- update user's business name in the firebase firestore
      Map<String, dynamic> bizName = {'BusinessName': bizNameField.text.trim()};

      await userRepo.updateSpecificUser(bizName);

      // -- update the Rx User values
      userController.user.value.businessName = bizNameField.text.trim();

      // -- stop loader
      CFullScreenLoader.stopLoading();

      // -- show success message
      CPopupSnackBar.successSnackBar(
        title: 'update successful!',
        message: 'your business name was updated successfully.',
      );

      // -- redirect screens accordingly --
      AuthRepo.instance.screenRedirect();
    } catch (e) {
      CFullScreenLoader.stopLoading();
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: 'Oh Snap!',
          message: 'error updating business name $e',
        );
      }
      CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: 'error updating business name',
      );
      throw e.toString();
    }
  }
}
