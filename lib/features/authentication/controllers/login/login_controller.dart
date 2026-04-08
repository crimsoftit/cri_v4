import 'package:cri_v3/data/repos/auth/auth_repo.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:cri_v3/utils/popups/full_screen_loader.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CLoginController extends GetxController {
  /// -- variables --
  final email = TextEditingController();
  final hidePswdTxt = true.obs;
  final localStorage = GetStorage();

  final password = TextEditingController();
  final rememberMe = false.obs;

  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final userController = Get.put(CUserController());

  @override
  void onInit() {
    super.onInit();
    String? rememberedEmail = localStorage.read('REMEMBER_ME_EMAIL');
    String? rememberedPasswd = localStorage.read('REMEMBER_ME_PASSWORD');
    if (rememberedEmail != null && rememberedPasswd != null) {
      email.text = localStorage.read('REMEMBER_ME_EMAIL');
      password.text = localStorage.read('REMEMBER_ME_PASSWORD');
    }
  }

  /// -- email & password signIn --
  Future<void> emailAndPasswdSignIn() async {
    try {
      // start the loader
      CFullScreenLoader.openLoadingDialog(
        'logging you in...',
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
      if (!loginFormKey.currentState!.validate()) {
        CFullScreenLoader.stopLoading();
        return;
      }

      // save data if rememberMe checkbox is checked
      if (rememberMe.value) {
        localStorage.write('REMEMBER_ME_EMAIL', email.text.trim());
        localStorage.write('REMEMBER_ME_PASSWORD', password.text.trim());
      }

      // sign in user using email & password authentication
      await AuthRepo.instance.logInWithEmailAndPassword(
        email.text.trim(),
        password.text.trim(),
      );

      // stop loader
      CFullScreenLoader.stopLoading();

      // redirect to relevant screen
      AuthRepo.instance.screenRedirect();
    } catch (e) {
      CFullScreenLoader.stopLoading();
      CPopupSnackBar.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// -- handles registration of an admin user --
  Future<void> registerAdmin() async {}

  /// -- Google signIn Authentication --
  // Future<void> googleSignIn() async {
  //   try {
  //     // -- start the loader
  //     CFullScreenLoader.openLoadingDialog(
  //       'logging you in...',
  //       CImages.docerAnimation,
  //     );

  //     // -- check internet connectivity
  //     final isConnected = await CNetworkManager.instance.isConnected();
  //     if (!isConnected) {
  //       CFullScreenLoader.stopLoading();

  //       return;
  //     }

  //     // -- google authentication
  //     final userCredentials = await AuthRepo.instance.loginInWithGoogle();

  //     // -- save user details
  //     await userController.saveUserDetails(userCredentials);

  //     // -- remove the loader
  //     CFullScreenLoader.stopLoading();

  //     // -- redirect to the relevant screen
  //     AuthRepo.instance.screenRedirect();
  //   } on FirebaseAuthException catch (error) {
  //     if (kDebugMode) print(error.message);
  //     CPopupSnackBar.errorSnackBar(
  //       title: 'Oh Snap!',
  //       message: error.toString(),
  //     );
  //   } catch (e) {
  //     if (kDebugMode) print(e.toString());
  //     CPopupSnackBar.errorSnackBar(title: 'Oh Snap!', message: e.toString());
  //   }
  // }
}
