import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/device/device_utilities.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class CAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CAppBar({
    this.actions,
    this.backIconColor,
    this.bgColor,
    this.horizontalPadding = CSizes.md,
    this.leadingIcon,
    this.leadingOnPressed,
    this.leadingWidget,
    this.leadingWidth,
    this.showBackArrow = true,
    this.showSubTitle = false,
    this.title,

    required this.backIconAction,
    super.key,
  });

  final Widget? title;
  final Widget? leadingWidget;
  final bool showBackArrow;
  final bool? showSubTitle;
  final IconData? leadingIcon;
  final Color? backIconColor, bgColor;
  final List<Widget>? actions;
  final VoidCallback? leadingOnPressed;
  final VoidCallback backIconAction;
  final double? horizontalPadding, leadingWidth;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        //horizontal: CSizes.md,
        horizontal: horizontalPadding!,
      ),
      child: AppBar(
        automaticallyImplyLeading: showBackArrow ? true : false,
        //leadingWidth: 280.0,
        leadingWidth: showBackArrow
            ? CHelperFunctions.screenWidth() * 0.1
            : CHelperFunctions.screenWidth() * 0.815,
        backgroundColor: bgColor,

        leading: showBackArrow
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: CSizes.md),
                child: IconButton(
                  onPressed: backIconAction,
                  icon: Icon(Iconsax.arrow_left, color: backIconColor),
                ),
              )
            : leadingIcon != null
            ? Row(
                children: [
                  IconButton(
                    onPressed: leadingOnPressed,
                    icon: Icon(
                      leadingIcon,
                      color: backIconColor,
                      //color: CColors.white,
                    ),
                  ),
                  leadingWidget!,
                ],
              )
            : leadingWidget,
        title: title,
        actions: actions,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(CDeviceUtils.getAppBarHeight());
}
