import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CLoadingDialog {
  // -- show loader --
  static void showLoader([String? message]) {
    Get.dialog(
      Dialog(
        backgroundColor: CColors.rBrown,
        child: Padding(
          padding: const EdgeInsets.all(CSizes.defaultSpace),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: CColors.white),
              const SizedBox(height: CSizes.spaceBtnSections),
              Text(message ?? ''),
            ],
          ),
        ),
      ),
    );
  }

  // -- hide loader --
  static void hideLoader() {
    Navigator.of(Get.overlayContext!).pop();
  }
}
