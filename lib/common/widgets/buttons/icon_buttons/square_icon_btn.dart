import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CSquareIconBtn extends StatelessWidget {
  const CSquareIconBtn({
    super.key,
    this.bgColor,
    this.iconSize = CSizes.md,
    required this.onBtnTap,
  });

  final Color? bgColor;
  final double? iconSize;
  final VoidCallback onBtnTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onBtnTap,
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: const BorderRadius.all(Radius.circular(0)),
        ),
        child: SizedBox(
          width: CSizes.iconLg,
          height: CSizes.iconLg,
          child: Center(
            child: Icon(
              Iconsax.edit,
              color: CColors.white,
              // size: CSizes.md,
              size: iconSize,
            ),
          ),
        ),
      ),
    );
  }
}
