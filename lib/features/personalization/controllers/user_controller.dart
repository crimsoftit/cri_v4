import 'package:cri_v3/data/repos/auth/auth_repo.dart';
import 'package:cri_v3/data/repos/user/user_repo.dart';
import 'package:cri_v3/features/authentication/controllers/signup/signup_controller.dart';
import 'package:cri_v3/features/authentication/screens/login/login.dart';
import 'package:cri_v3/features/personalization/models/user_model.dart';
import 'package:cri_v3/features/personalization/screens/profile/widgets/re_authenticate_user_login_form.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:cri_v3/utils/popups/full_screen_loader.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CUserController extends GetxController {
  static CUserController get instance => Get.find();

  final profileLoading = false.obs;
  final imgUploading = false.obs;
  Rx<CUserModel> user = CUserModel.empty().obs;

  final hidePassword = true.obs;
  final verifyEmail = TextEditingController();
  final verifyPassword = TextEditingController();
  final userRepo = Get.put(CUserRepo());
  GlobalKey<FormState> reAuthFormKey = GlobalKey<FormState>();

  final auth = AuthRepo.instance;

  final signupController = Get.put(SignupController());

  @override
  void onInit() async {
    super.onInit();
    await fetchUserDetails();
  }

  /// -- fetch user details --
  Future<bool> fetchUserDetails() async {
    try {
      profileLoading.value = true;
      final user = await userRepo.fetchUserDetails();
      this.user(user);
      profileLoading.value = false;
      return true;
    } catch (e) {
      user(CUserModel.empty());
      return false;
    }
    // finally {
    //   profileLoading.value = false;
    // }
  }

  /// -- save user details from any reg/authentication  provider --
  Future<void> saveUserDetails(UserCredential? userCredentials) async {
    try {
      // -- first update Rx User then check if user details are already stored. if not, store new data --
      await fetchUserDetails();

      // -- if no record is already stored for the user --
      if (user.value.id.isNotEmpty) {
        if (userCredentials != null) {
          // -- map user data
          final user = CUserModel(
            id: userCredentials.user!.uid,
            fullName: userCredentials.user!.displayName ?? '',
            businessName: signupController.txtBusinessName.text,
            email: userCredentials.user!.email ?? '',
            phoneNo: userCredentials.user!.phoneNumber ?? '',
            profPic: userCredentials.user!.photoURL ?? '',
            currencyCode: signupController.userCurrencyCode.value,
            countryCode: signupController.countryCode.value,
            locationCoordinates: '',
            userAddress: '',
          );

          // -- save user data
          await userRepo.saveUserDetails(user);
        } else {
          CPopupSnackBar.warningSnackBar(
            title: 'userCredentials NULL',
            message: 'userCredentials NULL',
          );
        }
      }
    } catch (e) {
      CPopupSnackBar.warningSnackBar(
        title: 'login details not saved!',
        message:
            'something went wrong while saving your login info! you can re-save your info in your profile.',
      );
    }
  }

  /// -- delete account warning popup snackbar --
  void deleteAccountWarningPopup() {
    Get.defaultDialog(
      contentPadding: const EdgeInsets.all(CSizes.md),
      title: 'Delete account?',
      middleText:
          'Are you certain you want to permanently delete your account? This action can\'t be undone and all of your data will be removed permanently!',
      confirm: ElevatedButton(
        onPressed: () async {
          deleteUserAccount();
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
          Navigator.of(Get.overlayContext!).pop();
        },
        child: const Text('cancel'),
      ),
    );
  }

  /// -- re-authenticate user before deleting --
  Future<void> reAuthEmailAndPasswordUser() async {
    try {
      CFullScreenLoader.openLoadingDialog(
        'processing...',
        CImages.docerAnimation,
      );

      // check internet connectivity
      final isConnected = await CNetworkManager.instance.isConnected();
      if (!isConnected) {
        CFullScreenLoader.stopLoading();
        return;
      }

      // validate form
      if (!reAuthFormKey.currentState!.validate()) {
        CFullScreenLoader.stopLoading();
        return;
      }

      await auth.reAuthWithEmailAndPassword(
        verifyEmail.text.trim(),
        verifyPassword.text.trim(),
      );
      await auth.deleteAccount();
      CFullScreenLoader.stopLoading();
      CPopupSnackBar.successSnackBar(
        title: 'Account deleted',
        message: 'your account was successfully deleted.',
      );
      Get.offAll(() => const LoginScreen());
    } catch (e) {
      CFullScreenLoader.stopLoading();
      CPopupSnackBar.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  /// -- delete user account --
  void deleteUserAccount() async {
    try {
      CFullScreenLoader.openLoadingDialog(
        'processing...',
        CImages.docerAnimation,
      );

      // -- re-authenticate user first
      final auth = AuthRepo.instance;
      final provider = auth.authUser!.providerData
          .map((e) => e.providerId)
          .first;

      if (provider.isNotEmpty) {
        // re-verify auth email
        // if (provider == 'google.com') {
        //   await auth.loginInWithGoogle();
        //   await auth.deleteAccount();
        //   CFullScreenLoader.stopLoading();
        //   Get.offAll(() => const LoginScreen());
        // } else if (provider == 'password') {
        //   CFullScreenLoader.stopLoading();
        //   Get.to(() => const CReAuthLoginForm());
        // }
        CFullScreenLoader.stopLoading();
        Get.to(() => const CReAuthLoginForm());
      } else {
        CFullScreenLoader.stopLoading();
        CPopupSnackBar.warningSnackBar(
          title: "No Provider!",
          message: 'auth provider not found!',
        );
        return;
      }
    } catch (e) {
      CFullScreenLoader.stopLoading();
      CPopupSnackBar.errorSnackBar(title: "Oh Snap!", message: e.toString());
    }
  }

  /// -- upload user's profile picture --
  uploadUserProfPic() async {
    try {
      final img = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
        maxWidth: 512.0,
        maxHeight: 512.0,
      );

      if (img != null) {
        imgUploading.value = true;
        // -- upload image
        final imgUrl = await userRepo.uploadImage('users/images/profile', img);

        // -- update user profile picture data
        Map<String, dynamic> json = {'ProfPic': imgUrl};
        await userRepo.updateSpecificUser(json);

        user.value.profPic = imgUrl;
        user.refresh();

        CPopupSnackBar.successSnackBar(
          title: 'update successful!',
          message: 'your profile picture was updated successfully!',
        );
      }
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: 'an unknown error occurred: $e',
      );
    } finally {
      imgUploading.value = false;
    }
  }
}
