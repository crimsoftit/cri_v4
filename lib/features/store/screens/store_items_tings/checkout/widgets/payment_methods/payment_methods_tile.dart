import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/features/store/controllers/checkout_controller.dart';
import 'package:cri_v3/features/store/models/payment_method_model.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CPaymentMethodsTile extends StatelessWidget {
  const CPaymentMethodsTile({super.key, required this.paymentMethod});

  /// -- variables --
  final CPaymentMethodModel paymentMethod;

  @override
  Widget build(BuildContext context) {
    //final cartController = Get.put(CCartController());
    final checkoutController = Get.put(CCheckoutController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      onTap: () {
        checkoutController.selectedPaymentMethod.value = paymentMethod;

        Navigator.pop(context);
      },
      leading: CRoundedContainer(
        width: 100.0,
        height: 100.0,
        padding: const EdgeInsets.all(CSizes.sm / 2),
        bgColor: isDarkTheme
            ? CColors.rBrown.withValues(alpha: 0.2)
            : CColors.white,
        child: Image(
          image: AssetImage(paymentMethod.platformLogo),
          fit: BoxFit.contain,
        ),
      ),
      title: Text(paymentMethod.platformName),
      trailing: const Icon(Iconsax.arrow_right_34),
    );
  }
}
