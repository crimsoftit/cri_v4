import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CCustomSwitch extends StatelessWidget {
  const CCustomSwitch({
    super.key,
    required this.label,
    required this.onValueChanged,
    required this.switchValue,
    this.labelColor,
  });

  final bool switchValue;
  final Color? labelColor;
  final String label;
  final void Function(bool) onValueChanged;

  @override
  Widget build(BuildContext context) {
    //final invController = Get.put(CInventoryController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return SizedBox(
      height: 30.0,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.labelMedium!.apply(color: labelColor),
          ),
          Transform.scale(
            scale: .8,
            child: Switch(
              // onChanged: (value) {
              //   invController.toggleSupplierDetsFieldsVisibility(value);
              // },
              value: switchValue,
              activeThumbColor: CColors.rBrown,
              activeTrackColor: isDarkTheme
                  ? CColors.darkGrey
                  : CColors.rBrown.withValues(alpha: .2),
              inactiveThumbColor: CColors.white,
              inactiveTrackColor: CColors.darkGrey,
              onChanged: onValueChanged,
            ),
          ),
        ],
      ),
    );
  }
}
