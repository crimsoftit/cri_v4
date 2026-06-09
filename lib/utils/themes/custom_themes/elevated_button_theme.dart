import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class RElevatedButtonTheme {
  RElevatedButtonTheme._(); // to avoid creating instances

  /* -- light mode(theme) -- */
  static final elevatedBtnLightTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: CColors.white,
      backgroundColor: CColors.rBrown,
      disabledForegroundColor: CColors.grey,
      disabledBackgroundColor: CColors.grey,
      side: BorderSide(color: CColors.rBrown.withValues(alpha: 0.2)),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      textStyle: const TextStyle(
        fontSize: 11.0,
        color: CColors.white,
        fontWeight: FontWeight.w600,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
  );

  /* -- dark mode(theme) -- */
  static final elevatedBtnDarkTheme = ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      elevation: 0,
      foregroundColor: CColors.white,
      backgroundColor: CColors.rBrown,
      disabledForegroundColor: CColors.grey,
      disabledBackgroundColor: CColors.grey,
      side: BorderSide(color: CColors.rBrown.withValues(alpha: 0.2)),
      textStyle: const TextStyle(
        fontSize: 11.0,
        color: CColors.white,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
  );
}
