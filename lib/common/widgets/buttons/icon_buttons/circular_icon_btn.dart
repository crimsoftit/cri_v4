import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CCircularIconBtn extends StatelessWidget {
  const CCircularIconBtn({
    super.key,
    this.width,
    this.height,
    this.iconSize,
    this.iconBorderRadius = 100.0,
    required this.icon,
    this.iconColor,
    this.bgColor,
    this.onPressed,
  });

  final double? width, height, iconSize;
  final double iconBorderRadius;
  final IconData icon;
  final Color? iconColor, bgColor;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(iconBorderRadius),
        //color: Colors.transparent,
        color: bgColor != null
            ? bgColor!
            : isDarkTheme
            ? CColors.rBrown.withValues(alpha: 0.6)
            : CColors.white.withValues(alpha: 0.9),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: iconColor, size: iconSize),
      ),
    );
  }
}
