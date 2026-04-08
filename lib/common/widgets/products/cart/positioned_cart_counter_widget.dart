import 'package:cri_v3/features/store/controllers/cart_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CPositionedCartCounterWidget extends StatelessWidget {
  const CPositionedCartCounterWidget({
    super.key,
    required this.counterBgColor,
    required this.counterTxtColor,
    this.rightPosition,
    this.topPosition,
    this.containerWidth,
    this.containerHeight,
  });

  final Color? counterBgColor;
  final Color? counterTxtColor;

  final double? containerWidth, containerHeight, rightPosition, topPosition;

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CCartController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Obx(
      () {
        if (cartController.cartItems.isEmpty) {
          return SizedBox.shrink();
        }
        return Positioned(
          right: rightPosition ?? 0,
          top: topPosition ?? 5.0,
          child: Container(
            width: containerWidth ?? 18.0,
            height: containerHeight ?? 15.0,
            decoration: BoxDecoration(
              color: counterBgColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Center(
              child: Text(
                cartController.cartItems.length.toString(),
                style: Theme.of(context).textTheme.labelSmall!.apply(
                  color:
                      counterTxtColor ??
                      (isDarkTheme ? CColors.rBrown : CColors.white),
                  fontSizeFactor: 1.0,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
