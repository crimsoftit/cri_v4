import 'package:cri_v3/features/authentication/controllers/signup/signup_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/constants/txt_strings.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';

class TandCCheckbox extends StatelessWidget {
  const TandCCheckbox({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = CHelperFunctions.isDarkMode(context);
    final controller = SignupController.instance;

    return Row(
      children: [
        SizedBox(
          width: 24.0,
          height: 24.0,
          child: Obx(
            () => Checkbox(
              value: controller.checkPrivacyPolicy.value,
              onChanged: (value) {
                controller.checkPrivacyPolicy.value =
                    !controller.checkPrivacyPolicy.value;
              },
            ),
          ),
        ),
        const SizedBox(width: CSizes.spaceBtnItems),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: CTexts.iAgreeTo,
                style: Theme.of(context).textTheme.labelSmall,
              ),
              TextSpan(
                text: CTexts.privacyPolicy,
                style: Theme.of(context).textTheme.labelMedium!.apply(
                  color: isDark ? CColors.white : Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: isDark ? CColors.white : Colors.blue,
                ),
              ),
              TextSpan(
                text: ' & ',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              TextSpan(
                text: CTexts.termsOfUse,
                style: Theme.of(context).textTheme.labelMedium!.apply(
                  color: isDark ? CColors.white : Colors.blue,
                  decoration: TextDecoration.underline,
                  decorationColor: isDark ? CColors.white : Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
