import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CCustomTxtField extends StatelessWidget {
  const CCustomTxtField({
    super.key,
    this.fieldHeight = 40.0,
    required this.txtFieldController,
    required this.labelTxt,
  });

  final TextEditingController txtFieldController;
  final String labelTxt;
  final double fieldHeight;

  @override
  Widget build(BuildContext context) {
    //final checkoutController = Get.put(CCheckoutController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return SizedBox(
      height: fieldHeight,
      child: TextFormField(
        keyboardType: TextInputType.text,
        // focusNode: checkoutController
        //     .customerNameFocusNode
        //     .value,
        autofocus: false,

        controller: txtFieldController,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 7.0,
            vertical: 2.0,
          ),
          focusColor: CColors.rBrown.withValues(alpha: 0.3),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(CSizes.cardRadiusXs),
            borderSide: BorderSide(color: CColors.grey),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: CColors.rBrown.withValues(alpha: 0.3),
            ),
            borderRadius: BorderRadius.circular(CSizes.cardRadiusXs),
          ),
          labelText: labelTxt,
        ),
        style: TextStyle(
          fontWeight: FontWeight.normal,
          color: isDarkTheme ? CColors.white : CColors.rBrown,
        ),
      ),
    );
  }
}
