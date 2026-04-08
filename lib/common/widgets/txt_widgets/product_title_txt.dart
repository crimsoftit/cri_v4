import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CProductTitleText extends StatelessWidget {
  const CProductTitleText({
    super.key,
    required this.title,
    this.maxLines = 1,
    this.txtAlign = TextAlign.left,
    this.smallSize = false,
    this.txtColor = CColors.rBrown,
  });

  final String title;
  final bool smallSize;
  final int maxLines;
  final TextAlign? txtAlign;
  final Color? txtColor;

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Text(
        title,
        style: smallSize
            ? Theme.of(context).textTheme.labelSmall!.apply(
                color: txtColor,
              )
            : Theme.of(context).textTheme.titleSmall!.apply(
                color: txtColor,

                fontSizeFactor: 1.01,
                fontWeightDelta: 2,
              ),
        overflow: TextOverflow.ellipsis,
        maxLines: maxLines,
        textAlign: txtAlign,
      ),
    );
  }
}
