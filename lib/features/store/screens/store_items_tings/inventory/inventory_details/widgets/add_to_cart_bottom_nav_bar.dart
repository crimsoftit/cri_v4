import 'package:cri_v3/common/widgets/buttons/icon_buttons/circular_icon_btn.dart';
import 'package:cri_v3/features/store/controllers/cart_controller.dart';
import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/features/store/models/inv_model.dart';
import 'package:cri_v3/utils/computations/date_time_computations.dart'
    show CDateTimeComputations;
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CAddToCartBottomNavBar extends StatelessWidget {
  const CAddToCartBottomNavBar({
    super.key,
    required this.inventoryItem,
    this.addIconBtnColor,
    this.addIconTxtColor,
    this.minusIconBtnColor,
    this.minusIconTxtColor,
    this.add2CartBtnBorderColor,
    this.fromCheckoutScreen = false,
  });

  final CInventoryModel inventoryItem;
  final Color? addIconBtnColor,
      addIconTxtColor,
      minusIconBtnColor,
      minusIconTxtColor,
      add2CartBtnBorderColor;
  final bool fromCheckoutScreen;

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CCartController());
    final invController = Get.put(CInventoryController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    //final txnsController = Get.put(CTxnsController());

    cartController.initializeItemCountInCart(inventoryItem);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: CSizes.defaultSpace,
        vertical: CSizes.defaultSpace / 2,
      ),
      decoration: BoxDecoration(
        color: isDarkTheme
            ? CColors.rBrown.withValues(alpha: 0.4)
            : CColors.light,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(CSizes.cardRadiusLg),
          topRight: Radius.circular(CSizes.cardRadiusLg),
        ),
      ),
      child: Obx(() {
        // if (txnsController.isLoading.value ||
        //     invController.isLoading.value ||
        //     invController.syncIsLoading.value ||
        //     cartController.cartItemsLoading.value) {
        //   return const CVerticalProductShimmer(
        //     itemCount: 3,
        //   );
        //   //return const DefaultLoaderScreen();
        // }
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CCircularIconBtn(
                  icon: Iconsax.minus,
                  iconBorderRadius: 100,
                  // bgColor: addIconBtnColor ??
                  //     (CNetworkManager.instance.hasConnection.value
                  //         ? CColors.rBrown
                  //         : CColors.black),
                  bgColor:
                      minusIconBtnColor ??
                      (CNetworkManager.instance.hasConnection.value
                          ? CColors.rBrown.withValues(alpha: 0.5)
                          : CColors.black.withValues(alpha: 0.5)),
                  width: 40.0,
                  height: 40.0,
                  iconColor: minusIconBtnColor ?? CColors.white,
                  onPressed: () {
                    cartController.itemQtyInCart.value < 0.1
                        ? null
                        : cartController.itemQtyInCart.value -=
                              inventoryItem.calibration == 'units' ? 1 : .25;
                  },
                ),
                //const CFavoriteIcon(),
                const SizedBox(width: CSizes.spaceBtnItems),
                Text(
                  inventoryItem.calibration == 'units'
                      ? '${cartController.itemQtyInCart.value.toStringAsFixed(0)} ${inventoryItem.calibration}'
                      : '${cartController.itemQtyInCart.value} ${inventoryItem.calibration}(s)',
                  style: Theme.of(context).textTheme.titleSmall,
                ),

                const SizedBox(width: CSizes.spaceBtnItems),

                CCircularIconBtn(
                  iconBorderRadius: 100,
                  bgColor:
                      addIconBtnColor ??
                      (CNetworkManager.instance.hasConnection.value
                          ? CColors.rBrown
                          : CColors.black),
                  icon: Iconsax.add,
                  iconColor: addIconTxtColor ?? CColors.white,
                  width: 40.0,
                  height: 40.0,
                  onPressed: () {
                    if (cartController.itemQtyInCart.value <
                        inventoryItem.quantity) {
                      cartController.itemQtyInCart.value +=
                          inventoryItem.calibration == 'units' ? 1 : .25;
                    } else {
                      CPopupSnackBar.warningSnackBar(
                        title:
                            'only ${inventoryItem.quantity} of ${inventoryItem.name} are stocked',
                        message:
                            'you can only add up to ${inventoryItem.quantity} ${inventoryItem.name} items to the cart',
                      );
                    }
                  },
                ),
              ],
            ),
            Visibility(
              visible: cartController.itemQtyInCart.value > 0,
              child: ElevatedButton.icon(
                icon: Icon(
                  Iconsax.shopping_cart,
                  color: CColors.white,
                ),
                label: Text(
                  cartController.itemQtyInCart.value > 0
                      ? 'update cart'
                      : 'add to cart'.toUpperCase(),
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.apply(color: CColors.white),
                ),
                onPressed: cartController.itemQtyInCart.value < 0.1
                    ? null
                    : () {
                        invController.fetchUserInventoryItems();
                        cartController.fetchCartItems();

                        /// -- check if item has expired before adding it to cart --
                        if (inventoryItem.expiryDate != '') {
                          var itemExpiry =
                              CDateTimeComputations.timeRangeFromNow(
                                inventoryItem.expiryDate.replaceAll('@ ', ''),
                              );
                          if (itemExpiry <= 0) {
                            CPopupSnackBar.warningSnackBar(
                              title: 'item is stale/expired',
                              message: '${inventoryItem.name} has expired!',
                            );
                            return;
                          }
                        }
                        cartController.addToCart(inventoryItem);
                        cartController.fetchCartItems();
                        if (fromCheckoutScreen) {
                          Navigator.pop(context);
                        }
                      },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(CSizes.md),
                  backgroundColor: CNetworkManager.instance.hasConnection.value
                      ? CColors.rBrown
                      : CColors.black,
                  side: BorderSide(
                    color: add2CartBtnBorderColor ?? CColors.rBrown,
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
