import 'package:cri_v3/data/repos/user/user_repo.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/personalization/screens/profile/profile.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:cri_v3/utils/popups/full_screen_loader.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CUpdateNameController extends GetxController {
  static CUpdateNameController get instance => Get.find();

  // -- variables --
  final fullName = TextEditingController();
  final userController = CUserController.instance;
  final userRepo = Get.put(CUserRepo());

  GlobalKey<FormState> editNameFormKey = GlobalKey<FormState>();

  // -- initialize user data when home screen loads --
  @override
  void onInit() {
    initializeName();
    super.onInit();
  }

  // -- fetch user record --
  Future<void> initializeName() async {
    fullName.text = userController.user.value.fullName;
  }

  // -- update user details --
  Future<void> updateName() async {
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
      if (!editNameFormKey.currentState!.validate()) {
        CFullScreenLoader.stopLoading();
        return;
      }

      // -- update user's fullname in the firebase firestore
      Map<String, dynamic> name = {'FullName': fullName.text.trim()};
      await userRepo.updateSpecificUser(name);

      // -- update the Rx User values
      userController.user.value.fullName = fullName.text.trim();

      // -- stop loader
      CFullScreenLoader.stopLoading();

      // -- show success message
      CPopupSnackBar.successSnackBar(
        title: 'update successful!',
        message: 'your name was updated successfully.',
      );

      // -- go back to profile screen
      Get.off(() => const CProfileScreen());
    } catch (e) {
      CFullScreenLoader.stopLoading();
      if (kDebugMode) {
        print('error updating name: ${e.toString()}');
        CPopupSnackBar.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      }
      CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message:
            'an error occurred while updating your name! please try again later.',
      );
      rethrow;
    }
  }
}
