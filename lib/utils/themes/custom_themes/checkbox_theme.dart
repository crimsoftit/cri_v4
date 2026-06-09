import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class RCheckboxTheme {
  RCheckboxTheme._();

  // -- customizable light text theme
  static CheckboxThemeData lightCheckboxTheme = CheckboxThemeData(
    shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    // shape: RoundedRectangleBorder(
    //   borderRadius: BorderRadius.circular(4.0),
    // ),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return CColors.white;
      } else {
        return CColors.rBrown;
      }
    }),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return CColors.rBrown;
      } else {
        return Colors.transparent;
      }
    }),
  );

  // -- customizable dark text theme
  static CheckboxThemeData darkCheckboxTheme = CheckboxThemeData(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.0)),
    checkColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return CColors.white;
      } else {
        return CColors.rBrown;
      }
    }),
    fillColor: WidgetStateProperty.resolveWith((states) {
      if (states.contains(WidgetState.selected)) {
        return CColors.rBrown;
      } else {
        return Colors.transparent;
      }
    }),
  );
}
