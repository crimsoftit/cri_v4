import 'package:cri_v3/common/widgets/products/product_cards/p_card_vertical.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CGridLayout extends StatelessWidget {
  const CGridLayout({
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
    return GridView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: CSizes.gridViewSpacing,
        crossAxisSpacing: CSizes.gridViewSpacing,
        mainAxisExtent: mainAxisExtent,
      ),
      itemBuilder: (context, index) {
        return CProductCardVertical(
          containerHeight: 182.0,
          itemName: '',
          pId: 0,
          pCode: '',
        );
      },
    );
  }
}
