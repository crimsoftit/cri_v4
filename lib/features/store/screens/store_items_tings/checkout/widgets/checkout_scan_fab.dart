import 'package:cri_v3/features/store/controllers/checkout_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CCheckoutScanFAB extends StatelessWidget {
  const CCheckoutScanFAB({
    super.key,
    this.bgColor,
    this.elevation,
    this.foregroundColor,
  });

  final Color? bgColor, foregroundColor;
  final double? elevation;

  @override
  Widget build(BuildContext context) {
    final checkoutController = Get.put(CCheckoutController());

    //final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return FloatingActionButton(
      elevation: elevation, // -- removes shadow
      onPressed: () {
        checkoutController.scanItemForCheckout();
      },
      backgroundColor: bgColor,
      //backgroundColor: CColors.transparent,
      foregroundColor: foregroundColor ?? CColors.white,

      child: const Icon(
        // Iconsax.scan_barcode,
        Iconsax.scan,
      ),
    );
  }
}
