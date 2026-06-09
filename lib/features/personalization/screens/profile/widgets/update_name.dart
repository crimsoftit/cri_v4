import 'package:cri_v3/common/widgets/appbar/v2_app_bar.dart';
import 'package:cri_v3/features/personalization/controllers/update_name_controller.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CUpdateName extends StatelessWidget {
  const CUpdateName({
    super.key,
    required this.autoImplyLeading,
    this.displayMenuIcon = false,
  });

  final bool autoImplyLeading, displayMenuIcon;

  @override
  Widget build(BuildContext context) {
    final editNameController = Get.put(CUpdateNameController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final userController = Get.put(CUserController());

    return Container(
      color: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
        /// -- app bar --
        appBar: CVersion2AppBar(
          autoImplyLeading: autoImplyLeading,
          displayMenuIcon: displayMenuIcon,
        ),
        backgroundColor: CColors.rBrown.withValues(alpha: 0.2),

        /// -- body --
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(CSizes.defaultSpace),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // -- headings --
                const SizedBox(
                  child: Image(
                    height: 90.0,
                    image: AssetImage(CImages.darkAppLogo),
                  ),
                ),
                const SizedBox(height: CSizes.spaceBtnItems),
                Text(
                  'use your real name for easy verification. this name will appear on several pages...',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: CSizes.spaceBtnSections),

                // -- textfield & button --
                Form(
                  key: editNameController.editNameFormKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: editNameController.fullName,
                        validator: (value) =>
                            CValidator.validateEmptyText('full name', value),
                        expands: false,
                        decoration: const InputDecoration(
                          labelText: 'full name:',
                          prefixIcon: Icon(Iconsax.user),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: CSizes.spaceBtnSections / 4),
                Align(
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                    width: CHelperFunctions.screenWidth() * 0.5,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        if (editNameController.fullName.text.trim() ==
                            userController.user.value.fullName.trim()) {
                          Get.back();
                        } else {
                          editNameController.updateName();
                        }
                      },
                      label: const Text('SAVE & CONTINUE'),
                      icon: const Icon(Iconsax.save_2),
                    ),
                  ),
                  // TextButton.icon(
                  //   icon: Icon(
                  //     Iconsax.save_add,
                  //     size: CSizes.iconSm,
                  //     color: isDarkTheme ? CColors.white : CColors.rBrown,
                  //   ),
                  //   onPressed: () async {
                  //     final internetIsConnected = await CNetworkManager.instance
                  //         .isConnected();
                  //     if (internetIsConnected) {
                  //       bizNameController.updateBizName();
                  //     } else {
                  //       CPopupSnackBar.warningSnackBar(
                  //         title: 'offline',
                  //         message: 'internet connection required',
                  //       );
                  //     }
                  //   },
                  //   label: Text(
                  //     'save & continue',
                  //     style: Theme.of(context).textTheme.bodyMedium,
                  //   ),
                  // ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
