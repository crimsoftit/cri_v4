import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CTextFormFieldTheme {
  CTextFormFieldTheme._();

  // -- light theme (mode) settings
  static InputDecorationTheme lightInputDecorationTheme = InputDecorationTheme(
    // errorMaxLines: 3,
    errorMaxLines: 1,
    prefixIconColor: CColors.darkGrey,
    suffixIconColor: CColors.darkGrey,
    labelStyle: const TextStyle().copyWith(
      fontSize: 11.0,
      color: CColors.rBrown,
      fontWeight: FontWeight.normal,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: 11.0,
      color: CColors.rBrown,
      fontWeight: FontWeight.normal,
    ),
    errorStyle: const TextStyle().copyWith(
      fontStyle: FontStyle.italic,
      color: CColors.error,
    ),
    floatingLabelStyle: const TextStyle().copyWith(
      //color: CColors.rBrown.withOpacity(0.8),
      color: CColors.rBrown.withValues(alpha: 0.8),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(
        width: 1.0,
        color: CColors.rBrown.withValues(alpha: .5),
      ),
    ),
    enabledBorder: OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(
        width: 1.0,
        color: CColors.rBrown.withValues(alpha: .5),
      ),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: BorderSide(width: 1.0, color: CColors.rBrown.shade100),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(2.0),
      borderSide: const BorderSide(
        width: 1.0,
        color: Colors.red,
      ),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(2.0),
      borderSide: const BorderSide(width: 2.0, color: rOrange),
    ),
  );

  // -- dark theme (mode) settings
  static InputDecorationTheme darkInputDecorationTheme = InputDecorationTheme(
    errorMaxLines: 1,
    prefixIconColor: CColors.grey,
    suffixIconColor: CColors.grey,
    labelStyle: const TextStyle().copyWith(
      fontSize: 11.0,
      color: CColors.white,
      // fontWeight: FontWeight.normal,
    ),
    hintStyle: const TextStyle().copyWith(
      fontSize: 11.0,
      color: CColors.white,
      fontWeight: FontWeight.normal,
    ),
    errorStyle: const TextStyle().copyWith(fontStyle: FontStyle.italic),
    floatingLabelStyle: const TextStyle().copyWith(
      color: CColors.white.withValues(alpha: 0.8),
    ),
    border: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: const BorderSide(
        width: 1.0,
        color: CColors.grey,
      ),
    ),
    enabledBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: const BorderSide(
        width: 1.0,
        color: CColors.grey,
      ),
    ),
    focusedBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(5.0),
      borderSide: const BorderSide(
        width: 1.0,
        color: CColors.white,
      ),
    ),
    errorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(
        5.0,
      ),
      borderSide: const BorderSide(
        width: 1.0,
        color: Colors.red,
      ),
    ),
    focusedErrorBorder: const OutlineInputBorder().copyWith(
      borderRadius: BorderRadius.circular(
        5.0,
      ),
      borderSide: const BorderSide(
        width: 2.0,
        color: CColors.error,
      ),
    ),
  );
}
