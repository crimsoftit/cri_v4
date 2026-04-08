import 'package:cri_v3/features/authentication/controllers/forgot_password/forgot_pswd_controller.dart';
import 'package:cri_v3/features/authentication/screens/login/login.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/constants/txt_strings.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(Get.overlayContext!).pop();
              // Get.back()
            },
            icon: const Icon(CupertinoIcons.clear),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(CSizes.defaultSpace),
          child: Column(
            children: [
              // -- header image --
              Image(
                image: const AssetImage(CImages.deliveredEmailIllustration),
                width: CHelperFunctions.screenWidth() * 0.6,
              ),
              const SizedBox(height: CSizes.spaceBtnSections),

              // -- email, title & subtitle --
              Text(
                email,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium!.apply(color: CColors.darkerGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: CSizes.spaceBtnItems),
              Text(
                CTexts.resetPswdTitle,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: CSizes.spaceBtnItems),

              Text(
                CTexts.resetPswdSubTitle,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium!.apply(color: CColors.darkGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: CSizes.spaceBtnSections),

              // -- buttons --
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAll(() => const LoginScreen());
                  },
                  child: Text(
                    'Done',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.apply(color: CColors.white),
                  ),
                ),
              ),

              const SizedBox(height: CSizes.spaceBtnItems),

              // -- resend password reset link button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    ForgotPasswordController.instance.resendPasswordResetEmail(
                      email,
                    );
                  },
                  child: Text(
                    CTexts.resendEmail,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
