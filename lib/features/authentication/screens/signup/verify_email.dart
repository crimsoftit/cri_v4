import 'package:cri_v3/data/repos/auth/auth_repo.dart';
import 'package:cri_v3/features/authentication/controllers/signup/verify_email_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/constants/txt_strings.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key, this.email});

  final String? email;

  @override
  Widget build(BuildContext context) {
    final verifyEmailController = Get.put(CVerifyEmailController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () {
              //Get.offAll(() => const LoginScreen());
              AuthRepo.instance.logout();
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

              // -- title & subtitle --
              Text(
                CTexts.confirmEmail,
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: CSizes.spaceBtnItems),
              Text(
                email ?? '',
                style: Theme.of(
                  context,
                ).textTheme.labelMedium!.apply(color: CColors.darkerGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: CSizes.spaceBtnItems),
              Text(
                CTexts.confirmEmailSubTitle,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium!.apply(color: CColors.darkGrey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: CSizes.spaceBtnSections),
              Text(
                CTexts.emailNotReceived,
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
                    verifyEmailController.checkEmailVerificationStatus();
                  },
                  child: Text(
                    'CONTINUE',
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.apply(color: CColors.white),
                  ),
                ),
              ),
              const SizedBox(height: CSizes.spaceBtnItems),
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () {
                    verifyEmailController.sendEmailVerification();
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
