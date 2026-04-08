import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CListViewLayout extends StatelessWidget {
  const CListViewLayout({
    super.key,
    required this.itemCount,
    this.mainAxisExtent = 220,
    required this.itemBuilder,
  });

  final int itemCount;
  final double? mainAxisExtent;
  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: itemCount,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const AlwaysScrollableScrollPhysics(),
      separatorBuilder: (context, index) {
        return const SizedBox(height: CSizes.spaceBtnItems);
      },
      itemBuilder: itemBuilder,
    );
  }
}
