import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/themes/custom_themes/appbar_theme.dart';
import 'package:cri_v3/utils/themes/custom_themes/bottom_sheet_theme.dart';
import 'package:cri_v3/utils/themes/custom_themes/checkbox_theme.dart';
import 'package:cri_v3/utils/themes/custom_themes/chip_theme.dart';
import 'package:cri_v3/utils/themes/custom_themes/elevated_button_theme.dart';
import 'package:cri_v3/utils/themes/custom_themes/outlined_btn_theme.dart';
import 'package:cri_v3/utils/themes/custom_themes/text_field_theme.dart';
import 'package:cri_v3/utils/themes/custom_themes/txt_themes.dart';
import 'package:flutter/material.dart';

class CAppTheme {
  CAppTheme._();

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    //fontFamily: 'Poppins',
    fontFamily: 'IosevkaCharonMono',
    brightness: Brightness.light,
    primaryColor: CColors.rBrown,
    textTheme: CTextTheme.ligtTextTheme,
    chipTheme: RChipTheme.lightChipTheme,
    scaffoldBackgroundColor: CColors.white,
    appBarTheme: RAppBarTheme.lightAppBarTheme,
    checkboxTheme: RCheckboxTheme.lightCheckboxTheme,
    bottomSheetTheme: RBottomSheetTheme.lightBottomSheetTheme,
    elevatedButtonTheme: RElevatedButtonTheme.elevatedBtnLightTheme,
    outlinedButtonTheme: ROutlinedButtonTheme.outlinedBtnLightTheme,
    inputDecorationTheme: CTextFormFieldTheme.lightInputDecorationTheme,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'IosevkaCharonMono',
    brightness: Brightness.dark,
    primaryColor: CColors.rBrown,
    textTheme: CTextTheme.darkTextTheme,
    chipTheme: RChipTheme.darkChipTheme,
    scaffoldBackgroundColor: Colors.black,
    appBarTheme: RAppBarTheme.darkAppBarTheme,
    checkboxTheme: RCheckboxTheme.darkCheckboxTheme,
    bottomSheetTheme: RBottomSheetTheme.darkBottomSheetTheme,
    elevatedButtonTheme: RElevatedButtonTheme.elevatedBtnDarkTheme,
    outlinedButtonTheme: ROutlinedButtonTheme.outlinedBtnDarkTheme,
    inputDecorationTheme: CTextFormFieldTheme.darkInputDecorationTheme,
  );
}
