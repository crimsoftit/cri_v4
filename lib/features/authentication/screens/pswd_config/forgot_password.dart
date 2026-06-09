import 'package:cri_v3/features/authentication/controllers/forgot_password/forgot_pswd_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/constants/txt_strings.dart';
import 'package:cri_v3/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final forgotPswdController = Get.put(ForgotPasswordController());

    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(CSizes.defaultSpace),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // -- headings --
            Text(
              CTexts.forgotPasswordTitle,
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: CSizes.spaceBtnItems),
            Text(
              CTexts.forgotPasswordSubTitle,
              style: Theme.of(
                context,
              ).textTheme.labelMedium!.apply(color: CColors.darkGrey),
            ),
            const SizedBox(height: CSizes.spaceBtnSections * 2),

            // -- email textfield --
            Form(
              key: forgotPswdController.forgotPswdFormKey,
              child: TextFormField(
                controller: forgotPswdController.email,
                style: const TextStyle(height: 0.7),
                decoration: const InputDecoration(
                  prefixIcon: Icon(Iconsax.direct_right),
                  labelText: CTexts.email,
                ),
                validator: CValidator.validateEmail,
              ),
            ),

            const SizedBox(height: CSizes.spaceBtnInputFields),

            // -- submit button --
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  forgotPswdController.sendPasswordResetEmail();
                },
                child: Text(
                  'Submit',
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.apply(color: CColors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
