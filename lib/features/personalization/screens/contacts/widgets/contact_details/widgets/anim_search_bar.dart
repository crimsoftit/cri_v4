import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CAnimSearchBar extends StatelessWidget {
  const CAnimSearchBar({
    super.key,
    required this.animSearchBarController,
    this.barColor = CColors.transparent,
    this.barWidth = 400,

    this.helpText,
    this.onSuffixTap,
    this.txtFieldColor,
  });

  final Color? barColor, txtFieldColor;
  final double barWidth;
  final String? helpText;
  final TextEditingController animSearchBarController;
  final VoidCallback? onSuffixTap;

  @override
  Widget build(BuildContext context) {
    return AnimSearchBar(
      animationDurationInMilli: 1000,
      autoFocus: true,
      closeSearchOnSuffixTap: true,
      color: barColor,
      helpText: 'Search something...',
      onSubmitted: (value) {},
      onSuffixTap: onSuffixTap,
      prefixIcon: const Icon(
        Iconsax.search_normal,
        color: CColors.rBrown,
        size: CSizes.iconMd,
      ),
      textController: animSearchBarController,
      textFieldColor: txtFieldColor,
      width: barWidth,
    );
  }
}
