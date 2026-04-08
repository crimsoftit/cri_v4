import 'package:cri_v3/common/widgets/products/cart/positioned_cart_counter_widget.dart';
import 'package:cri_v3/features/store/controllers/checkout_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CCartCounterIcon extends StatelessWidget {
  const CCartCounterIcon({
    super.key,
    this.cartCounterRightPosition,
    this.counterBgColor,
    this.counterTxtColor,
    this.iconColor,
    required this.showCounterWidget,
  });

  final bool showCounterWidget;
  final Color? iconColor, counterBgColor, counterTxtColor;
  final double? cartCounterRightPosition;

  @override
  Widget build(BuildContext context) {
    final checkoutController = Get.put(CCheckoutController());

    return Stack(
      children: [
        IconButton(
          onPressed: () async {
            checkoutController.handleNavToCheckout();
          },
          icon: Icon(
            Iconsax.shopping_bag,
            color: iconColor,
          ),
        ),
        showCounterWidget
            ? CPositionedCartCounterWidget(
                counterBgColor: CColors.white,
                counterTxtColor: CColors.rBrown,
                rightPosition: cartCounterRightPosition ?? 5.0,
              )
            : SizedBox.shrink(),
      ],
    );
  }
}
