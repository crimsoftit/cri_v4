import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CRoundedContainer extends StatelessWidget {
  const CRoundedContainer({
    super.key,
    this.alignment,
    this.bgColor = CColors.white,
    this.borderRadius = CSizes.cardRadiusLg,
    this.borderColor = CColors.borderPrimary,
    this.boxShadow,
    this.child,
    this.height,
    this.margin,
    this.padding,
    this.showBorder = false,
    this.width,
    
    
    
    
    
    
    
    
    
  });

  final AlignmentGeometry? alignment;
  final double? width;
  final double? height;
  final double borderRadius;
  final Widget? child;
  final bool showBorder;
  final Color borderColor;
  final Color bgColor;
  final List<BoxShadow>? boxShadow;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: alignment,
      decoration: BoxDecoration(
        // boxShadow:
        //     boxShadow ??
        //     [
        //       BoxShadow(
        //         blurRadius: 3.0,
        //         color: CColors.grey.withValues(
        //           alpha: .1,
        //         ),
        //         offset: const Offset(0.0, 3.0),
        //         spreadRadius: 5.0,
        //       ),
        //     ],
        boxShadow: boxShadow,
        color: bgColor,
        borderRadius: BorderRadius.circular(borderRadius),
        border: showBorder ? Border.all(color: borderColor) : null,
      ),
      height: height,
      margin: margin,
      padding: padding,
      width: width,
      child: child,
    );
  }
}
