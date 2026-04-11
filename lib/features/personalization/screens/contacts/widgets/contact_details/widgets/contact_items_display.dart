import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/features/personalization/models/contacts_model.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CContactItemsDisplay extends StatelessWidget {
  const CContactItemsDisplay({
    super.key,
    this.includeTrailingWidget,
    this.leadingIcon,
    this.onLeadingIconPressed,
    this.subTitleWidget,
    this.titleColor,
    this.trailingIcon,
    required this.contactItem,
    required this.title,
  });

  final bool? includeTrailingWidget;
  final CContactsModel contactItem;
  final Color? titleColor;
  final Widget? leadingIcon, subTitleWidget, trailingIcon;
  final String title;

  final VoidCallback? onLeadingIconPressed;

  @override
  Widget build(
    BuildContext context,
  ) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    return CRoundedContainer(
      bgColor: CColors.rBrown.withValues(
        alpha: .2,
      ),
      borderRadius: CSizes.borderRadiusLg,
      height: 60.0,
      padding: const EdgeInsets.all(
        5.0,
      ),
      width: CHelperFunctions.screenWidth() * .845,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onLeadingIconPressed,
            // onPressed: contactItem.contactPhone == ''
            //     ? null
            //     : () {
            //         contactsController.launchPhoneDialer(
            //           contactItem.contactPhone,
            //         );
            //       },
            icon:
                leadingIcon ??
                Icon(
                  Iconsax.call,
                  color: isDarkTheme ? CColors.grey : CColors.rBrown,
                ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              top: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                SelectableText(
                  title,

                  style:
                      Theme.of(
                        context,
                      ).textTheme.headlineMedium!.apply(
                        color: titleColor,
                        fontSizeDelta: 1.1,
                      ),
                ),

                ?subTitleWidget,
              ],
            ),
          ),
          if (includeTrailingWidget!)
            IconButton(
              onPressed: () {},
              icon:
                  trailingIcon ??
                  Icon(
                    Iconsax.message,
                    color: titleColor,
                  ),
            ),
        ],
      ),
    );
  }
}
