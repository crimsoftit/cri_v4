import 'package:cri_v3/common/widgets/dividers/custom_divider.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart'
    show CHelperFunctions;
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';

class AppScreenHeader extends StatelessWidget {
  const AppScreenHeader({
    super.key,
    required this.title,
    required this.subTitle,
    required this.includeAfterSpace,
    this.txtColor,
  });

  final bool includeAfterSpace;
  final Color? txtColor;
  final String title, subTitle;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.labelLarge!.apply(
                // color: CNetworkManager.instance.hasConnection.value
                //     ? CColors.rBrown
                //     : CColors.darkGrey,
                color: txtColor,
                fontSizeFactor: 2.5,
                fontWeightDelta: -7,
              ),
            ),
            const SizedBox(
              //width: double.infinity,
              child: Image(
                height: 40.0,
                //image: AssetImage( isDark ? RImages.darkAppLogo_1 : RImages.lightAppLogo_1),
                // image: AssetImage(
                //   isDarkTheme ? CImages.darkAppLogo : CImages.lightAppLogo,
                // ),
                image: AssetImage(CImages.darkAppLogo),
              ),
            ),
          ],
        ),
        CCustomDivider(leftPadding: 2.0),
        const SizedBox(height: CSizes.spaceBtnSections / 3),

        Text(
          subTitle,
          style: Theme.of(context).textTheme.labelMedium!.apply(
            color: isDarkTheme
                ? CColors.darkGrey
                : CNetworkManager.instance.hasConnection.value
                ? CColors.rBrown
                : CColors.darkGrey,
          ),
        ),

        const SizedBox(height: CSizes.spaceBtnSections / 2),
      ],
    );
  }
}
