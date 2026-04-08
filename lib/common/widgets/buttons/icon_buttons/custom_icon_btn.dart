import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CCustomIconBtn extends StatelessWidget {
  const CCustomIconBtn({
    super.key,

    required this.iconData,
    required this.iconLabel,
    this.displayLabel = true,
    this.borderRadius,
    this.height,
    this.labelColor,
    this.onTap,

    this.width,
  });

  final bool displayLabel;
  final Color? labelColor;
  final double? borderRadius, height, width;

  final String iconLabel;
  final void Function()? onTap;
  final Widget iconData;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          CRoundedContainer(
            bgColor: CColors.rBrown.withValues(
              alpha: .2,
            ),
            borderRadius: CSizes.borderRadiusLg * 4,
            height: height ?? 60.0,
            width: width ?? 80.0,
            child: iconData,
          ),
          displayLabel
              ? Text(
                  iconLabel,
                  style: Theme.of(context).textTheme.labelLarge!.apply(
                    color:
                        labelColor ??
                        (isDarkTheme ? CColors.white : CColors.rBrown),
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    );
  }
}
