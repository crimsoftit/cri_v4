import 'package:cri_v3/common/widgets/appbar/app_bar.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/constants/txt_strings.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CReAuthLoginForm extends StatelessWidget {
  const CReAuthLoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final userController = CUserController.instance;
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Scaffold(
      // -- custom appbar --
      appBar: CAppBar(
        showBackArrow: true,
        backIconColor: isDarkTheme ? CColors.white : CColors.rBrown,
        title: Text(
          'Re-Authenticate Login',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        backIconAction: () {
          Navigator.of(context).pop();
          //Get.back();
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(CSizes.defaultSpace),
          child: Form(
            key: userController.reAuthFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // -- email field --
                TextFormField(
                  controller: userController.verifyEmail,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: CTexts.email,
                  ),
                  validator: CValidator.validateEmail,
                ),
                const SizedBox(height: CSizes.spaceBtnInputFields),

                // -- password field --
                Obx(() {
                  return TextFormField(
                    obscureText: userController.hidePassword.value,
                    controller: userController.verifyPassword,
                    decoration: InputDecoration(
                      labelText: CTexts.password,
                      prefixIcon: const Icon(Iconsax.password_check),
                      suffixIcon: IconButton(
                        onPressed: () {
                          userController.hidePassword.value =
                              !userController.hidePassword.value;
                        },
                        icon: Icon(
                          userController.hidePassword.value
                              ? Iconsax.eye_slash
                              : Iconsax.eye,
                          color: userController.hidePassword.value
                              ? CColors.grey
                              : CColors.rBrown,
                        ),
                      ),
                    ),
                    validator: (value) {
                      return CValidator.validateEmptyText('password', value);
                    },
                  );
                }),
                const SizedBox(height: CSizes.spaceBtnInputFields),

                // -- login button --
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      userController.reAuthEmailAndPasswordUser();
                    },
                    child: const Text('verify'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
