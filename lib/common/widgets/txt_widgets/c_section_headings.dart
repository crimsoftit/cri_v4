import 'package:flutter/material.dart';

class CSectionHeading extends StatelessWidget {
  const CSectionHeading({
    super.key,
    this.actionWidget,
    this.txtColor,
    required this.showActionBtn,
    required this.title,
    required this.btnTitle,
    this.onPressed,
    this.btnTxtColor,
    required this.editFontSize,
    this.fSize = 13.0,
    this.fWeight = FontWeight.w500,
  });

  final bool showActionBtn, editFontSize;
  final Color? txtColor, btnTxtColor;
  final double? fSize;
  final FontWeight? fWeight;
  final String title, btnTitle;
  final void Function()? onPressed;
  final Widget? actionWidget;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        editFontSize
            ? Text(
                title,
                style: TextStyle(
                  color: txtColor,
                  fontSize: fSize,
                  fontWeight: fWeight,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              )
            : Text(
                title,
                style: Theme.of(context).textTheme.headlineSmall!.apply(
                  color: txtColor,
                  fontSizeFactor: 0.75,
                  fontWeightDelta: 2,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
        if (showActionBtn)
          actionWidget ??
              TextButton(
                onPressed: onPressed,
                child: Text(
                  btnTitle,
                  style: Theme.of(context).textTheme.labelMedium!.apply(
                    color: txtColor,
                    //fontSizeFactor: 0.75,
                  ),
                ),
              ),
      ],
    );
  }
}
