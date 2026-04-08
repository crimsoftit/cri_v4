import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CMenuTile extends StatelessWidget {
  const CMenuTile({
    super.key,
    this.iconColor,
    this.displayLeadingIcon = true,
    this.displaySubTitle = true,
    this.displayTrailingWidget = true,
    this.icon,
    required this.title,
    this.subTitle = '',
    this.titleColor,
    this.trailing,
    this.onTap,
  });

  final bool displayLeadingIcon, displaySubTitle, displayTrailingWidget;
  final Color? iconColor, titleColor;
  final IconData? icon;
  final String title, subTitle;

  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: displayLeadingIcon
          ? Icon(
              icon,
              size: 28.0,
              color: iconColor ?? CColors.primaryBrown,
            )
          : SizedBox.shrink(),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium!.apply(
          color: iconColor ?? CColors.rBrown,
        ),
      ),
      subtitle: displaySubTitle
          ? Text(
              subTitle,
              style: Theme.of(context).textTheme.labelMedium,
            )
          : SizedBox.shrink(),
      trailing: displayTrailingWidget ? trailing : SizedBox.shrink(),
      onTap: onTap,
    );
  }
}
