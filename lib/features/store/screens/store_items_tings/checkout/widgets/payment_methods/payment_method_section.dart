import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:cri_v3/features/store/controllers/checkout_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CPaymentMethodSection extends StatelessWidget {
  const CPaymentMethodSection({
    super.key,
    required this.platformName,
    required this.platformLogo,
    required this.txtFieldSpace,
  });

  final String platformName, platformLogo;
  final Widget txtFieldSpace;

  @override
  Widget build(BuildContext context) {
    //final cartController = Get.put(CCartController());
    final checkoutController = Get.put(CCheckoutController());
    //final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Column(
      children: [
        CSectionHeading(
          showActionBtn: true,
          title: 'Payment method',
          btnTitle: 'Change',
          btnTxtColor: CColors.darkerGrey,
          editFontSize: true,
          fSize: 13.0,
          onPressed: () {
            checkoutController.amtIssuedFieldController.text = '';
            checkoutController.customerBal.value = 0.0;
            checkoutController.selectPaymentMethod(context);
          },
        ),
        SizedBox(height: CSizes.spaceBtnItems / 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.center,
              child: Obx(() {
                return CRoundedContainer(
                  width: 50.0,
                  height: 50.0,
                  //bgColor: isDarkTheme ? CColors.light : CColors.white,
                  bgColor: CColors.transparent,
                  padding: const EdgeInsets.all(CSizes.sm / 4),
                  child:
                      checkoutController
                              .selectedPaymentMethod
                              .value
                              .platformName ==
                          'mPesa online'
                      ? SizedBox.shrink()
                      : Image(
                          image: AssetImage(
                            platformLogo,
                            //checkoutController.selectedPaymentMethod.value.platformLogo,
                          ),
                          fit: BoxFit.contain,
                        ),
                );
              }),
            ),
            // const SizedBox(
            //   width: CSizes.spaceBtnItems / 4,
            // ),
            if (platformName != '')
              Expanded(
                flex: 3,
                child: Text(
                  //checkoutController.selectedPaymentMethod.value.platformName,
                  platformName,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            txtFieldSpace,
            //Expanded(flex: 4, child: txtFieldSpace),
          ],
        ),
      ],
    );
  }
}
