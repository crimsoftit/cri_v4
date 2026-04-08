import 'package:cri_v3/common/widgets/sliders/auto_img_slider.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CFreshUserScreen extends StatelessWidget {
  const CFreshUserScreen({
    super.key,
    required this.isDarkTheme,
  });

  final bool isDarkTheme;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: CSizes.defaultSpace),

          //CCarouselSlider(),
          CAutoImgSlider(),
          const SizedBox(
            height: CSizes.defaultSpace / 1.5,
          ),
          Text(
            'welcome aboard!!'.toUpperCase(),
            style: Theme.of(context).textTheme.bodyLarge!.apply(
              // color: isDarkTheme
              //     ? CColors.darkGrey
              //     : CColors.rBrown,
              color: CColors.rBrown,
              fontSizeFactor: 1.3,
              fontWeightDelta: -2,
            ),
          ),
          const SizedBox(
            height: CSizes.defaultSpace / 2,
          ),
          Text(
            'your perfect dashboard is just a few sales away!'.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium!.apply(
              color: isDarkTheme ? CColors.darkGrey : CColors.rBrown,
            ),
          ),
        ],
      ),
    );
  }
}
