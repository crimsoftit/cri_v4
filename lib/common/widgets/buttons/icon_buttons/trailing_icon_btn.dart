import 'package:flutter/material.dart';

class CTrailingIconBtn extends StatelessWidget {
  const CTrailingIconBtn({
    super.key,
    this.iconColor,
    this.onPressed,
    required this.iconData,
  });

  final Color? iconColor;
  final IconData iconData;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: IconButton(
        icon: Icon(
          iconData,
          color: iconColor,
        ),
        onPressed: onPressed,
      ),
    );
  }
}
