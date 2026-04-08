import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class OnboardingScreenWidget extends StatelessWidget {
  const OnboardingScreenWidget({
    super.key,
    required this.img,
    required this.title,
    required this.subTitle,
  });

  final String img, title, subTitle;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Padding(
      padding: const EdgeInsets.all(CSizes.defaultSpace),
      child: Column(
        children: [
          Image(
            width: CHelperFunctions.screenWidth() * 0.8,
            height: CHelperFunctions.screenHeight() * 0.6,
            image: AssetImage(img),
          ),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium!.apply(
              color: isDarkTheme ? CColors.darkGrey : CColors.rBrown,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: CSizes.spaceBtnItems),
          Text(
            subTitle,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
