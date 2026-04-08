import 'package:cri_v3/data/repos/auth/auth_repo.dart';
import 'package:cri_v3/features/authentication/screens/pswd_config/reset_password.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:cri_v3/utils/popups/full_screen_loader.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ForgotPasswordController extends GetxController {
  static ForgotPasswordController get instance => Get.find();

  // -- variables --
  final email = TextEditingController();
  GlobalKey<FormState> forgotPswdFormKey = GlobalKey<FormState>();

  // -- send password reset email --
  sendPasswordResetEmail() async {
    try {
      // start loader
      CFullScreenLoader.openLoadingDialog(
        'processing your request...',
        CImages.docerAnimation,
      );

      // check internet connectivity
      final isConnected = await CNetworkManager.instance.isConnected();
      if (!isConnected) {
        CFullScreenLoader.stopLoading();
        CPopupSnackBar.customToast(
          message: 'please check your internet connection',
          forInternetConnectivityStatus: true,
        );
        return;
      }

      // form validation
      if (!forgotPswdFormKey.currentState!.validate()) {
        CFullScreenLoader.stopLoading();
        return;
      }

      // send reset password email
      await AuthRepo.instance.sendPasswordResetEmail(email.text.trim());

      // stop loader
      CFullScreenLoader.stopLoading();

      // show success screen
      CPopupSnackBar.successSnackBar(
        title: 'password reset email sent...',
        message: 'please check your email for a password reset link'.tr,
      );

      // redirect to the relevant screen
      Get.to(() => ResetPasswordScreen(email: email.text.trim()));
    } catch (e) {
      // stop loader
      CFullScreenLoader.stopLoading();
      CPopupSnackBar.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // -- resend password reset email --
  resendPasswordResetEmail(String email) async {
    try {
      // start loader
      CFullScreenLoader.openLoadingDialog(
        'processing your request...',
        CImages.docerAnimation,
      );

      // check internet connectivity
      final isConnected = await CNetworkManager.instance.isConnected();
      if (!isConnected) {
        CFullScreenLoader.stopLoading();
        CPopupSnackBar.customToast(
          message: 'please check your internet connection',
          forInternetConnectivityStatus: true,
        );
        return;
      }

      // re-send reset password email
      await AuthRepo.instance.sendPasswordResetEmail(email);

      // stop loader
      CFullScreenLoader.stopLoading();

      // show success screen
      CPopupSnackBar.successSnackBar(
        title: 'password reset email has been re-sent...',
        message: 'please check your email for a password reset link'.tr,
      );
    } catch (e) {
      // stop loader
      CFullScreenLoader.stopLoading();
      CPopupSnackBar.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }
}
