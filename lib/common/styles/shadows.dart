import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CShadowStyle {
  static final verticalProductShadow = BoxShadow(
    color: CColors.darkGrey.withValues(alpha: 0.1),
    blurRadius: 50.0,
    spreadRadius: 7.0,
    offset: const Offset(0, 2),
  );

  static final horizontalProductShadow = BoxShadow(
    color: CColors.darkGrey.withValues(alpha: 0.1),
    blurRadius: 50.0,
    spreadRadius: 7.0,
    offset: const Offset(0, 2),
  );
}
