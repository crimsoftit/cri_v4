import 'package:cri_v3/features/authentication/controllers/login/login_controller.dart';
import 'package:cri_v3/features/authentication/screens/pswd_config/forgot_password.dart';
import 'package:cri_v3/features/authentication/screens/signup/signup.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/constants/txt_strings.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:cri_v3/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final loginController = Get.put(CLoginController());

    return Form(
      key: loginController.loginFormKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: CSizes.spaceBtnSections),
        child: Column(
          children: [
            // -- email field --
            TextFormField(
              controller: loginController.email,
              style: const TextStyle(height: 0.7),
              decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    width: .6,
                    color: isDarkTheme ? CColors.darkGrey : CColors.rBrown,
                  ),
                ),
                labelText: CTexts.email,
                prefixIcon: Icon(Iconsax.direct_right),
              ),
              validator: (value) {
                return CValidator.validateEmail(value);
              },
            ),

            const SizedBox(height: CSizes.spaceBtnInputFields),

            // -- password field --
            Obx(
              () => TextFormField(
                controller: loginController.password,
                obscureText: loginController.hidePswdTxt.value,
                style: const TextStyle(height: 0.8),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: .6,
                      color: isDarkTheme ? CColors.darkGrey : CColors.rBrown,
                    ),
                  ),
                  labelText: CTexts.password,
                  prefixIcon: const Icon(Iconsax.password_check),
                  suffixIcon: IconButton(
                    onPressed: () {
                      loginController.hidePswdTxt.value =
                          !loginController.hidePswdTxt.value;
                    },
                    icon: Icon(
                      loginController.hidePswdTxt.value
                          ? Iconsax.eye_slash
                          : Iconsax.eye,
                      color: loginController.hidePswdTxt.value
                          ? CColors.darkGrey
                          : CColors.rBrown,
                    ),
                  ),
                ),
                //validator: (value) => CValidator.validatePassword(value),
              ),
            ),

            const SizedBox(height: CSizes.spaceBtnInputFields / 2),

            // -- remember me & forgot password checkbox and textbutton --
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // -- remember me
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: loginController.rememberMe.value,
                        onChanged: (value) {
                          loginController.rememberMe.value =
                              !loginController.rememberMe.value;
                        },
                      ),
                    ),
                    Text(
                      CTexts.rememberMe,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),

                // -- forgot password
                TextButton(
                  onPressed: () {
                    Get.to(() => const ForgotPasswordScreen());
                  },
                  child: Text(
                    CTexts.forgotPassword,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ],
            ),
            const SizedBox(height: CSizes.spaceBtnInputFields / 2),

            // -- sign in button --
            Obx(() {
              return SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    loginController.emailAndPasswdSignIn();
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(
                      CNetworkManager.instance.hasConnection.value
                          ? CColors.rBrown
                          : CColors.black,
                    ),
                  ),
                  child: Text(
                    CTexts.signIn.toUpperCase(),
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium?.apply(color: CColors.white),
                  ),
                ),
              );
            }),

            const SizedBox(height: CSizes.spaceBtnItems / 2),

            // -- create account button --
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Get.to(() => const SignupScreen());
                },
                child: Text(
                  CTexts.createAccount.toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
