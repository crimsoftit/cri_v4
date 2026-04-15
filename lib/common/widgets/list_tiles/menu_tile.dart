import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CMenuTile extends StatelessWidget {
  const CMenuTile({
    super.key,
    this.bgColor = CColors.transparent,
    this.containerWidth,
    this.displayLeadingIcon = true,
    this.displaySubTitle = true,
    this.displayTrailingWidget = true,
    this.icon,
    this.iconColor,
    this.leadingWidget,
    this.onTap,
    required this.title,
    this.subTitle = '',
    this.titleColor,
    this.titleMaxLines = 1,
    this.titleStyle,
    this.titleTopPadding = 0,
    this.trailing,
    this.useCustomLeadingWiget = false,
  });

  final bool useCustomLeadingWiget,
      displayLeadingIcon,
      displaySubTitle,
      displayTrailingWidget;
  final Color bgColor;
  final Color? iconColor, titleColor;
  final double? containerWidth, titleTopPadding;
  final int? titleMaxLines;
  final IconData? icon;
  final String title, subTitle;
  final TextStyle? titleStyle;

  final void Function()? onTap;
  final Widget? leadingWidget, trailing;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: CRoundedContainer(
        bgColor: bgColor,
        width: containerWidth,
        child: ListTile(
          leading: displayLeadingIcon && !useCustomLeadingWiget
              ? Icon(
                  icon,
                  size: 28.0,
                  color: iconColor ?? CColors.primaryBrown,
                )
              : useCustomLeadingWiget
              ? leadingWidget
              : SizedBox.shrink(),
          title: Padding(
            padding: EdgeInsets.only(
              top: titleTopPadding ?? 0,
            ),
            child: SelectableText(
              title,
              maxLines: titleMaxLines,
              style:
                  titleStyle ??
                  Theme.of(context).textTheme.titleMedium!.apply(
                    color: iconColor ?? CColors.rBrown,
                  ),
            ),
          ),
          subtitle: displaySubTitle
              ? SelectableText(
                  subTitle,
                  style: Theme.of(context).textTheme.labelMedium,
                )
              : SizedBox.shrink(),
          trailing: displayTrailingWidget ? trailing : SizedBox.shrink(),
          onTap: onTap,
        ),
      ),
    );
  }
}
