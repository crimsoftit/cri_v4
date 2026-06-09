import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/common/widgets/txt_widgets/product_price_txt.dart';
import 'package:cri_v3/features/store/controllers/cart_controller.dart';
import 'package:cri_v3/features/store/controllers/checkout_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CBillingAmountSection extends StatelessWidget {
  const CBillingAmountSection({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CCartController());

    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Column(
      children: [
        /// -- sub total --
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       'subtotal',
        //       style: Theme.of(context).textTheme.bodyMedium,
        //     ),
        //     CProductPriceTxt(
        //       price: cartController.totalCartPrice.value.toStringAsFixed(2),
        //       isLarge: false,
        //       txtColor: isDarkTheme ? CColors.white : CColors.rBrown,
        //     ),
        //   ],
        // ),
        // SizedBox(
        //   height: CSizes.spaceBtnItems / 4,
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Discount', style: Theme.of(context).textTheme.bodyMedium),
            cartController.discount.value == 0
                ? IconButton(
                    icon: Icon(
                      Iconsax.add,
                      color: isDarkTheme ? CColors.white : CColors.rBrown,
                      size: CSizes.iconMd,
                    ),
                    onPressed: () {},
                  )
                : CProductPriceTxt(
                    price: cartController.discount.value.toStringAsFixed(2),
                    isLarge: false,
                    txtColor: isDarkTheme ? CColors.white : CColors.rBrown,
                  ),
          ],
        ),
        // SizedBox(
        //   height: CSizes.spaceBtnItems / 10,
        // ),
        // Row(
        //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //   children: [
        //     Text(
        //       'tax fee',
        //       style: Theme.of(context).textTheme.bodyMedium,
        //     ),
        //     cartController.taxFee.value == 0
        //         ? IconButton(
        //             icon: Icon(
        //               Iconsax.add,
        //               color: isDarkTheme ? CColors.white : CColors.rBrown,
        //               size: CSizes.iconMd,
        //             ),
        //             onPressed: () {},
        //           )
        //         : CProductPriceTxt(
        //             price: cartController.taxFee.value.toStringAsFixed(2),
        //             isLarge: false,
        //             txtColor: CColors.rBrown,
        //           ),
        //   ],
        // ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total amount (vatable)',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.apply(fontWeightDelta: 2),
            ),
            CProductPriceTxt(
              price: cartController.totalCartPrice.value.toStringAsFixed(2),
              isLarge: true,
              txtColor: isDarkTheme ? CColors.white : CColors.rBrown,
            ),
          ],
        ),

        SizedBox(height: CSizes.spaceBtnItems / 2),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Customer balance',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium!.apply(fontWeightDelta: 2),
            ),
            Obx(() {
              final checkoutController = Get.put(CCheckoutController());
              return Column(
                children: [
                  CProductPriceTxt(
                    price:
                        checkoutController.amtIssuedFieldController.text != ''
                        ? checkoutController.customerBal.toStringAsFixed(2)
                        : (0 - cartController.totalCartPrice.value)
                              .toStringAsFixed(2),
                    isLarge: true,
                    txtColor: checkoutController.customerBal.value < 0
                        ? Colors.red
                        : isDarkTheme
                        ? CColors.white
                        : CColors.rBrown,
                  ),
                  Visibility(
                    visible: false,
                    child: CRoundedContainer(
                      height: 40,
                      width: 100,
                      child: TextFormField(
                        controller: checkoutController.customerBalField,
                      ),
                    ),
                  ),
                ],
              );
            }),
          ],
        ),
      ],
    );
  }
}
