import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CCustomDropdownBtn extends StatelessWidget {
  const CCustomDropdownBtn({
    super.key,
    required this.dropdownItems,
    required this.onValueChanged,
    this.defaultItemColor,
    this.defaultItemFontSizeFactor,
    this.dropdownBoxColor,
    this.iconColor,
    this.padding,
    this.selectedValue,
    this.underlineColor = CColors.white,
    this.underlineHeight,
  });

  final Color? defaultItemColor, dropdownBoxColor, iconColor, underlineColor;
  final EdgeInsetsGeometry? padding;
  final double? defaultItemFontSizeFactor, underlineHeight;
  final List<String> dropdownItems;
  final String? selectedValue;
  final void Function(String?) onValueChanged;

  @override
  Widget build(BuildContext context) {
    //final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return DropdownButton<String>(
      borderRadius: BorderRadius.circular(10.0),
      elevation: 8,
      items: dropdownItems.map(
        (
          String value,
        ) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: Theme.of(context).textTheme.labelMedium!.apply(
                // color: isDarkTheme ? CColors.white : CColors.rBrown,
                color: defaultItemColor ?? CColors.rBrown,
                fontSizeFactor: defaultItemFontSizeFactor ?? 1.0,
              ),
            ),
          );
        },
      ).toList(),
      onChanged: onValueChanged,
      style: Theme.of(context).textTheme.labelMedium!.apply(
        color: CColors.rBrown,
      ),
      dropdownColor:
          dropdownBoxColor ??
          CColors.white.withValues(
            alpha: 0.6,
          ),
      icon: Icon(
        Icons.arrow_drop_down,
        color: iconColor ?? CColors.rBrown,
      ),
      underline: Container(
        // color: isDarkTheme ? CColors.white : CColors.rBrown,
        color: underlineColor,
        height: underlineHeight ?? 2.0,
      ),
      padding:
          padding ??
          const EdgeInsets.only(
            left: 5.0,
            right: 5.0,
          ),
      value: selectedValue,
    );
  }
}
