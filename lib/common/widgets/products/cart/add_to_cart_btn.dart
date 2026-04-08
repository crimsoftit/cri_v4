import 'package:cri_v3/features/store/controllers/cart_controller.dart';
import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/utils/computations/date_time_computations.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CAddToCartBtn extends StatelessWidget {
  const CAddToCartBtn({
    super.key,
    required this.pId,
    this.boxColor,
  });

  final Color? boxColor;
  final int pId;

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());

    return Obx(() {
      final cartController = CCartController.instance;
      final pQtyInCart = cartController.getItemQtyInCart(pId);
      var invItem = invController.inventoryItems.firstWhere(
        (item) => item.productId.toString() == pId.toString().toLowerCase(),
      );

      var itemExpiry = invItem.expiryDate != ''
          ? CDateTimeComputations.timeRangeFromNow(
              invItem.expiryDate.replaceAll('@ ', ''),
            )
          : null;
      return InkWell(
        onTap: () {
          cartController.fetchCartItems();

          if (itemExpiry != null && itemExpiry <= 0) {
            CPopupSnackBar.warningSnackBar(
              title: 'item is stale/expired',
              message: '${invItem.name} has expired',
            );
          } else {
            final cartItem = cartController.convertInvToCartItem(
              invItem,
              invItem.calibration == 'units' ? 1 : .25,
            );
            cartController.addSingleItemToCart(
              cartItem,
              false,
              null,
            );
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: pQtyInCart > 0
                ? CColors.success.withValues(
                    alpha: .5,
                  )
                : boxColor ??
                      (pQtyInCart > 0
                          ? CColors.success
                          : invItem.quantity <= invItem.lowStockNotifierLimit ||
                                (invItem.expiryDate != '' &&
                                    itemExpiry != null &&
                                    itemExpiry <= 0)
                          ? Colors.red
                          : CNetworkManager.instance.hasConnection.value
                          ? CColors.rBrown
                          : CColors.darkerGrey),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(CSizes.cardRadiusMd - 4),
              bottomRight: Radius.circular(CSizes.pImgRadius - 4),
            ),
          ),
          child: SizedBox(
            width: CSizes.iconLg,
            height: CSizes.iconLg,
            child: Center(
              child: pQtyInCart > 0
                  ? Text(
                      invItem.calibration == 'units'
                          ? pQtyInCart.toStringAsFixed(0)
                          : pQtyInCart.toString(),
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge!.apply(color: CColors.white),
                    )
                  : const Icon(
                      Iconsax.add,
                      color: CColors.white,
                    ),
            ),
          ),
        ),
      );
    });
  }
}
