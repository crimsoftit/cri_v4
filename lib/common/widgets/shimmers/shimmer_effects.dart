import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class CShimmerEffect extends StatelessWidget {
  const CShimmerEffect({
    super.key,
    required this.width,
    required this.height,
    this.radius = 15.0,
    this.color,
  });

  final double width, height, radius;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Shimmer.fromColors(
      baseColor: isDarkTheme ? Colors.grey[850]! : Colors.grey[300]!,
      highlightColor: isDarkTheme ? Colors.grey[700]! : Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color ?? (isDarkTheme ? CColors.darkGrey : Colors.white),
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
