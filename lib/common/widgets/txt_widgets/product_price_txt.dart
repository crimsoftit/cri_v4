import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CProductPriceTxt extends StatelessWidget {
  const CProductPriceTxt({
    super.key,
    this.currencySign,
    this.fSizeFactor = 1,
    this.isLarge = false,
    this.lineThrough = false,
    this.maxLines = 1,
    this.priceCategory,
    required this.price,
    this.txtColor = Colors.black,
  });

  final String? priceCategory, currencySign;
  final double fSizeFactor;
  final String price;
  final int maxLines;
  final bool isLarge, lineThrough;
  final Color? txtColor;

  @override
  Widget build(BuildContext context) {
    final userController = Get.put(CUserController());
    final currency = CHelperFunctions.formatCurrency(
      userController.user.value.currencyCode,
    );
    return Text.rich(
      TextSpan(
        text: priceCategory,
        style: Theme.of(
          context,
        ).textTheme.labelMedium!.apply(color: txtColor, fontSizeDelta: 0.7),
        children: [
          TextSpan(
            text: currencySign ?? currency,
            style: Theme.of(context).textTheme.labelMedium!.apply(
              color: txtColor,
              fontSizeFactor: fSizeFactor,
              decoration: lineThrough ? TextDecoration.lineThrough : null,
            ),
          ),
          TextSpan(
            text: price,
            style: isLarge
                ? Theme.of(context).textTheme.headlineSmall!.apply(
                    color: txtColor,
                    fontSizeFactor: fSizeFactor,
                    decoration: lineThrough ? TextDecoration.lineThrough : null,
                  )
                : Theme.of(context).textTheme.labelMedium!.apply(
                    color: txtColor,
                    fontSizeFactor: fSizeFactor,
                    decoration: lineThrough ? TextDecoration.lineThrough : null,
                  ),
          ),
        ],
      ),
    );
    // Text(
    //   currencySign ?? '$currency.$price',
    //   maxLines: maxLines,
    //   overflow: TextOverflow.ellipsis,
    //   style: isLarge
    //       ? Theme.of(context).textTheme.headlineSmall!.apply(
    //             color: txtColor,
    //             decoration: lineThrough ? TextDecoration.lineThrough : null,
    //           )
    //       : Theme.of(context).textTheme.labelMedium!.apply(
    //             color: txtColor,
    //             //fontSizeDelta: 0.7,
    //             decoration: lineThrough ? TextDecoration.lineThrough : null,
    //           ),
    // );
  }
}
