import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CProfileMenu extends StatelessWidget {
  const CProfileMenu({
    super.key,
    required this.title,
    this.value,
    required this.onTap,
    this.trailingIcon = Iconsax.arrow_right_34,
    this.verticalPadding = CSizes.spaceBtnItems / 3,
    this.showTrailingIcon = true,
    this.valueIsWidget = false,
    this.valueWidget,
    this.onTrailingIconPressed,
    required this.titleFlex,
    required this.secondRowWidgetFlex,
  });

  final IconData trailingIcon;
  final String title;
  final String? value;
  final int titleFlex, secondRowWidgetFlex;
  final double? verticalPadding;
  final VoidCallback onTap;
  final VoidCallback? onTrailingIconPressed;
  final bool? showTrailingIcon, valueIsWidget;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: verticalPadding!),
        child: Row(
          children: [
            Expanded(
              flex: titleFlex,
              child: Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall!.apply(color: CColors.darkGrey),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Expanded(
              flex: secondRowWidgetFlex,
              child: valueIsWidget!
                  ? valueWidget!
                  : Text(
                      value!,
                      style: Theme.of(context).textTheme.bodyMedium!.apply(
                        color: CColors.rBrown,
                        fontWeightDelta: 1,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
            ),
            if (showTrailingIcon!)
              Expanded(
                child: IconButton(
                  onPressed: onTrailingIconPressed,
                  icon: Icon(trailingIcon, size: 18.0, color: CColors.rBrown),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
