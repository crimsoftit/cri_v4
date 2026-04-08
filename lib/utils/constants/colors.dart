import 'package:flutter/material.dart';

class CColors {
  CColors._();

  // -- app basic colors
  static const Color primaryBrown = Colors.brown;
  static const Color primaryBlue = Color(0xff4b68ff);
  static const Color secondary = Color(0xFFFFE24B);
  static const Color accent = Color(0xFFb0c7ff);
  static const Color transparent = Colors.transparent;

  // -- gradient colors
  static const Gradient linearGradient = LinearGradient(
    begin: Alignment(0.0, 0.0),
    end: Alignment(0.707, -0.707),
    colors: [Color(0xffff9a9e), Color(0xfffad0c4), Color(0xfffad0c4)],
  );

  // -- text colors
  static const Color txtPrimary = Color(0xff333333);
  static const Color txtSecondary = Color(0xFF6c7570);
  static const Color txtWhite = Colors.white;

  // -- bg colors
  static const Color light = Color(0xfff6f6f6);
  static const Color dark = Color(0xFF272727);
  static const Color primaryBg = Color(0xfff3f5ff);

  // -- container bg colors
  static const Color lightContainer = Color(0xfff6f6f6);
  static Color darkContainer = CColors.white.withValues(alpha: 0.1);

  // -- button colors
  static const Color btnPrimary = Color(0xff4b68ff);
  static const Color btnSecondary = Color(0xFF6c757d);
  static const Color btnDisabled = Color(0xffc4c4c4);

  // -- border colors
  static const Color borderPrimary = Color(0xffd9d9d9);
  static const Color borderSecondary = Color(0xffe6e6e6);

  // -- neutral shades
  static const Color black = Color(0xff232323);
  static const Color white = Color(0xffffffff);
  static const Color darkGrey = Color(0xFF939393);
  static const Color darkerGrey = Color(0xff4f4f4f);
  static const Color grey = Color(0xffe0e0e0);
  static const Color softGrey = Color(0xFFf4f4f4);
  static const Color lightGrey = Color(0xfff9f9f9);

  // -- error & validation colors
  static const Color error = Color(0xffd32f2f);
  static const Color info = Color(0xff1976d2);
  static const Color success = Color(0xFF388e3c);
  static const Color warning = Color(0xfff57c00);

  // -- basic colors
  static const rBrown = Colors.brown;
}

/* -- LIST OF ALL COLORS --*/

const rBlue = Colors.blue;
const rOrange = Colors.orange;

const rPrimaryColor = Color.fromRGBO(255, 228, 0, 1);
const rPrimaryBrown = Color(0xffffdcbd);
const rSecondaryColor = Color(0xff272727);
const rAccentColor = Color(0xff001bff);

const rCardBgColor = Color(0xfff7f6f1);

/* -- ONBOARDING COLORS --*/
const rOnboardingPage1ColorLight = Colors.white;
var rOnboardingPage1ColorDark = rSecondaryColor;

const rOnboardingPage2ColorLight = Color.fromARGB(255, 211, 200, 196);
var rOnboardingPage2ColorDark = rSecondaryColor;

const rOnboardingPage3ColorLight = Color(0xffffdcbd);
var rOnboardingPage3ColorDark = rSecondaryColor;
