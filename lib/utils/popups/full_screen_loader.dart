/* === a utility class to handle a full-screen loading dialog === */
import 'package:cri_v3/common/widgets/loaders/animated_loader.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CFullScreenLoader {
  // -- open a full-screen loading dialog with a given text & animation
  // -- this method doesn't return anything
  // --
  // -- Parameters:
  //    - txt: text to be diplayed in the loading dialog widget
  //    - animation: the lottie animation to be displayed

  static void openLoadingDialog(String txt, String animator) {
    showDialog(
      context:
          Get.overlayContext!, // use Get.overlayContext for overlay dialogs
      barrierDismissible:
          false, // dialog won't be dismissed upon tapping outside it
      builder: (_) => PopScope(
        canPop: false, // disable popping with the back button
        child: Container(
          color: CHelperFunctions.isDarkMode(Get.context!)
              ? CColors.rBrown
              : CColors.rBrown.withValues(alpha: 0.1),
          width: double.infinity,
          height: double.infinity,
          child: Column(
            children: [
              // adjust spacing as required
              const SizedBox(height: 250.0),
              CAnimatedLoaderWidget(text: txt, animation: animator),
            ],
          ),
        ),
      ),
    );
  }

  // -- stop the currently open loading dialog --
  // this method doesn't return anything
  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
