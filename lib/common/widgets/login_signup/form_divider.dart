import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CFormDivider extends StatelessWidget {
  const CFormDivider({
    super.key,
    required this.dividerText,
    this.dividerColor,
    this.dividerTxtColor,
    this.dividerTxtFontSizeFactor,
  });

  final Color? dividerColor, dividerTxtColor;
  final String dividerText;
  final double? dividerTxtFontSizeFactor;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Divider(
            color:
                dividerColor ?? (isDarkTheme ? CColors.grey : CColors.darkGrey),
            thickness: 0.5,
            indent: 60,
            endIndent: 5,
          ),
        ),
        Text(
          dividerText,
          style: Theme.of(context).textTheme.labelMedium?.apply(
            color: dividerColor ?? CColors.darkGrey,
            fontSizeFactor: dividerTxtFontSizeFactor ?? 0.8,
          ),
        ),
        Flexible(
          child: Divider(
            color:
                dividerTxtColor ??
                (isDarkTheme ? CColors.darkGrey : CColors.grey),
            thickness: 0.5,
            indent: 5,
            endIndent: 60,
          ),
        ),
      ],
    );
  }
}
