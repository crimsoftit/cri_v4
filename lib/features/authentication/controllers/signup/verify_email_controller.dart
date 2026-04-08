import 'dart:async';

import 'package:cri_v3/common/widgets/success_screen/success_screen.dart';
import 'package:cri_v3/data/repos/auth/auth_repo.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/constants/txt_strings.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class CVerifyEmailController extends GetxController {
  static CVerifyEmailController get instance => Get.find();

  final userController = Get.put(CUserController());

  /* === send e-mail whenever verify email screen appears & set timer for auto redirect === */
  @override
  void onInit() {
    sendEmailVerification();
    setTimerForAutoRedirect();
    super.onInit();
  }

  // -- send email verification link --
  sendEmailVerification() async {
    try {
      await AuthRepo.instance.sendEmailVerification();
      CPopupSnackBar.successSnackBar(
        title: 'Verification e-mail sent!',
        message:
            'Please check your inbox or spam to verify your e-mail address',
      );
    } catch (e) {
      CPopupSnackBar.errorSnackBar(title: 'Oh Snap!', message: e.toString());
    }
  }

  // -- set timer to automatically redirect upon email verification --
  setTimerForAutoRedirect() {
    Timer.periodic(const Duration(seconds: 1), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user?.emailVerified ?? false) {
        timer.cancel();
        Get.off(
          () => CSuccessScreen(
            displayReceiptGenerationSection: false,
            image: CImages.successfulRegAnimation,
            title: CTexts.accountCreatedTitle,
            subTitle: CTexts.accountCreatedSubTitle,
            onContinueBtnPressed: () {
              AuthRepo.instance.screenRedirect();
            },
          ),
        );
      }
    });
  }

  // -- manually check if email was verified --
  checkEmailVerificationStatus() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null && currentUser.emailVerified) {
      Get.off(() {
        CSuccessScreen(
          displayReceiptGenerationSection: false,
          image: CImages.successfulRegAnimation,
          title: CTexts.accountCreatedTitle,
          subTitle: CTexts.accountCreatedSubTitle,
          onContinueBtnPressed: () {
            AuthRepo.instance.screenRedirect();
          },
        );
      });
    }
  }
}
