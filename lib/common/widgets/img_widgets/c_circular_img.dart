import 'package:cri_v3/common/widgets/shimmers/shimmer_effects.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CCircularImg extends StatelessWidget {
  const CCircularImg({
    super.key,
    this.fit = BoxFit.fill,
    required this.img,
    this.isNetworkImg = true,
    this.overlayColor,
    this.bgColor,
    this.width = 56,
    this.height = 56,
    this.padding = CSizes.sm,
  });

  final BoxFit? fit;
  final String img;
  final bool isNetworkImg;
  final Color? overlayColor, bgColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
        color: bgColor ?? (isDarkTheme ? CColors.rBrown : Colors.white),
        borderRadius: BorderRadius.circular(100),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100.0),
        child: Center(
          child: isNetworkImg
              ? CachedNetworkImage(
                  fit: fit,
                  color: overlayColor,
                  imageUrl: img,
                  progressIndicatorBuilder: (context, url, progress) =>
                      const CShimmerEffect(
                        width: 55.0,
                        height: 55.0,
                        radius: 55.0,
                      ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                )
              : Image(fit: fit, image: AssetImage(img), color: overlayColor),
        ),
      ),
    );
  }
}
