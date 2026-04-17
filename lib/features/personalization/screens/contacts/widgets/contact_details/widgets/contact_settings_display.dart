import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/features/personalization/models/contacts_model.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CContactSettingsDisplay extends StatelessWidget {
  const CContactSettingsDisplay({
    super.key,
    this.child,
    this.conatinerHeight = 100.0,
    this.includeTrailingWidget,
    this.leadingIcon,
    this.rowMainAxisAlignment = MainAxisAlignment.spaceBetween,
    this.onLeadingIconPressed,
    this.subTitleWidget,
    this.titleColor,
    this.titleTopPadding = 10.0,
    this.trailingIcon,
    required this.contactItem,
    required this.title,
  });

  final bool? includeTrailingWidget;
  final CContactsModel contactItem;
  final Color? titleColor;
  final double conatinerHeight, titleTopPadding;
  final MainAxisAlignment rowMainAxisAlignment;
  final Widget? child, leadingIcon, subTitleWidget, trailingIcon;
  final String title;

  final VoidCallback? onLeadingIconPressed;

  @override
  Widget build(
    BuildContext context,
  ) {
    //final isDarkTheme = CHelperFunctions.isDarkMode(context);
    return CRoundedContainer(
      bgColor: CColors.rBrown.withValues(
        alpha: .2,
      ),
      borderRadius: CSizes.borderRadiusLg,
      height: conatinerHeight,
      padding: const EdgeInsets.all(
        1.0,
      ),
      width: CHelperFunctions.screenWidth() * .855,
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: rowMainAxisAlignment,
              children: [
                Expanded(
                  flex: 1,
                  child: IconButton(
                    onPressed: onLeadingIconPressed,
                    icon: leadingIcon!,
                  ),
                ),
                const SizedBox(
                  width: CSizes.spaceBtnItems,
                ),
                Expanded(
                  flex: 4,
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: titleTopPadding,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SelectableText(
                          title,
                          style: Theme.of(context).textTheme.headlineMedium!
                              .apply(
                                color: titleColor,
                                fontSizeFactor: .9,
                              ),
                        ),
                        subTitleWidget!,
                      ],
                    ),
                  ),
                ),

                includeTrailingWidget!
                    ? Expanded(
                        flex: 1,
                        child: trailingIcon!,
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
          ?child,
        ],
      ),
    );
  }
}
