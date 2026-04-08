import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class ROutlinedButtonTheme {
  ROutlinedButtonTheme._(); // to avoid creating instances

  /* -- light mode (theme) -- */
  static final outlinedBtnLightTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      elevation: 0,
      foregroundColor: CColors.rBrown,
      side: const BorderSide(color: CColors.rBrown),
      textStyle: const TextStyle(
        fontSize: 11.0,
        color: CColors.rBrown,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
  );

  /* -- dark mode (theme)) -- */
  static final outlinedBtnDarkTheme = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: CColors.white,
      side: const BorderSide(color: rPrimaryBrown),
      textStyle: const TextStyle(
        fontSize: 11.0,
        color: CColors.white,
        fontWeight: FontWeight.w600,
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 10.0,
        //horizontal: 20.0,
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
    ),
  );
}
