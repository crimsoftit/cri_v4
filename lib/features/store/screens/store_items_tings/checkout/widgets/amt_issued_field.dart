import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/features/store/controllers/cart_controller.dart';
import 'package:cri_v3/features/store/controllers/checkout_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class CAmountIssuedTxtField extends StatelessWidget {
  const CAmountIssuedTxtField({
    super.key,
    this.txtFieldHeight = 45.0,
    required this.txtFieldWidth,
  });

  final double txtFieldWidth, txtFieldHeight;

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CCartController());
    final checkoutController = Get.put(CCheckoutController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return CRoundedContainer(
      width: txtFieldWidth,
      height: txtFieldHeight,
      bgColor: isDarkTheme
          ? CColors.rBrown.withValues(alpha: 0.3)
          : CColors.white,
      child: TextFormField(
        keyboardType: const TextInputType.numberWithOptions(
          decimal: true,
          signed: false,
        ),
        inputFormatters: <TextInputFormatter>[
          FilteringTextInputFormatter.allow(RegExp(r'^\d+(\.\d*)?')),
        ],
        // autofocus: checkoutController
        //     .setFocusOnAmtIssuedField
        //     .value,
        autofocus: false,
        controller: checkoutController.amtIssuedFieldController,
        decoration: InputDecoration(
          focusColor: CColors.rBrown.withValues(alpha: 0.3),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(CSizes.cardRadiusLg),
            borderSide: BorderSide(color: CColors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CColors.rBrown.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(CSizes.cardRadiusLg),
          ),
          //border: InputBorder.none,
          labelText: 'amount issued by customer',
        ),
        style: const TextStyle(fontWeight: FontWeight.normal),
        onChanged: (value) {
          if (value != '') {
            checkoutController.computeCustomerBal(
              cartController.totalCartPrice.value,
              double.parse(value),
            );
          }
        },
      ),
    );
  }
}
