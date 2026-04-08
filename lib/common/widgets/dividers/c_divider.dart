import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';

class CDivider extends StatelessWidget {
  const CDivider({
    super.key,
    this.color = CColors.rBrown,
    this.endIndent = 20.0,
    this.startIndent = 20.0,
  });

  final Color? color;
  final double? endIndent, startIndent;

  @override
  Widget build(BuildContext context) {
    return Divider(
      color: color,
      endIndent: endIndent,
      indent: startIndent,
      thickness: 0.2,
    );
  }
}
