import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CStoreSummaryCard extends StatelessWidget {
  const CStoreSummaryCard({
    this.containerWidth,
    super.key,
    required this.titleTxt,
    this.cardBgColor = CColors.white,
    this.iconColor = CColors.rBrown,
    this.iconData,
    this.iconSize,
    this.onTap,
    this.subTitleTxt,
    this.subTitleTxtColor = CColors.rBrown,
    this.titleTxtColor = CColors.rBrown,
  });

  final Color? cardBgColor, iconColor, subTitleTxtColor, titleTxtColor;
  final double? containerWidth, iconSize;
  final IconData? iconData;
  final String? subTitleTxt;
  final String titleTxt;

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// -- store summary widgets go here --
        Card(
          color: cardBgColor,
          elevation: 1.0,
          margin: EdgeInsets.all(1),
          child: CRoundedContainer(
            bgColor: CColors.transparent,
            borderRadius: CSizes.cardRadiusSm / 1.5,
            padding: EdgeInsets.zero,
            width: containerWidth ?? CHelperFunctions.screenWidth() * 0.28,
            child: ListTile(
              contentPadding: EdgeInsets.only(
                top: 2,
                bottom: CSizes.sm / 4,
                left: CSizes.sm / 4,
                right: CSizes.sm / 4,
              ),
              onTap: onTap,
              subtitle: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  subTitleTxt ?? '',
                  style:
                      Theme.of(
                        context,
                      ).textTheme.labelSmall!.apply(
                        color: subTitleTxtColor,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        titleTxt,
                        style: Theme.of(context).textTheme.labelLarge!.apply(
                          color: titleTxtColor,
                          fontSizeFactor: .9,
                        ),
                      ),
                      Icon(
                        iconData,
                        color: iconColor,
                        size: iconSize ?? CSizes.iconSm,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
