import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CCircularContainer extends StatelessWidget {
  const CCircularContainer({
    super.key,
    this.width = 400,
    this.height = 400,
    this.radius = 400,
    this.padding = 0,
    this.child,
    this.bgColor = CColors.rBrown,
    this.margin,
  });

  final double? width;
  final double? height;
  final double radius;
  final double padding;
  final EdgeInsets? margin;
  final Widget? child;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(radius),
        color: bgColor,
      ),
      height: height,
      margin: margin,
      padding: EdgeInsets.all(padding),
      width: width,
      child: child,
    );
  }
}
