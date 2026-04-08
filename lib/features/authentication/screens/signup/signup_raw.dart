import 'package:cri_v3/common/widgets/login_signup/form_divider.dart';
import 'package:cri_v3/common/widgets/login_signup/social_buttons.dart';
import 'package:cri_v3/features/authentication/screens/login/login.dart';
import 'package:cri_v3/features/authentication/screens/signup/widgets/signup_form.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/constants/txt_strings.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SignupScreenRaw extends StatelessWidget {
  const SignupScreenRaw({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Scaffold(
      //backgroundColor: CColors.rBrown.withOpacity(0.2),
      appBar: AppBar(
        backgroundColor: CColors.rBrown,
        title: Text(
          'excited to have you!',
          style: Theme.of(
            context,
          ).textTheme.labelLarge!.apply(color: CColors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(CSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- title --
              Text(
                CTexts.signUpTitle,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: CSizes.spaceBtnSections / 4),

              // -- divider --
              // const CFormDivider(
              //   dividerText: 'already have an account?',
              // ),
              const SizedBox(height: CSizes.spaceBtnSections / 4),

              // -- signup form --
              const CSignupForm(),

              // -- divider --
              CFormDivider(dividerText: 'or'.capitalize!),
              TextButton(
                onPressed: () {
                  Get.offAll(const LoginScreen());
                },
                child: Text(
                  'click here to sign in',
                  style: Theme.of(context).textTheme.bodySmall!.apply(
                    color: isDarkTheme ? CColors.grey : CColors.rBrown,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),

              const SizedBox(height: CSizes.spaceBtnSections),

              // -- footer --
              const CSocialButtons(),
            ],
          ),
        ),
      ),
    );
  }
}
