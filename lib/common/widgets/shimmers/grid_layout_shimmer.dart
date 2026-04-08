import 'package:cri_v3/common/widgets/layouts/grid_layout.dart';
import 'package:cri_v3/common/widgets/shimmers/shimmer_effects.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CGridLayoutShimmer extends StatelessWidget {
  const CGridLayoutShimmer({super.key, required this.itemCount});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return CGridLayout(
      itemCount: itemCount,
      itemBuilder: (context, __) {
        return const SizedBox(
          width: 180.0,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- image section --
              CShimmerEffect(width: 160.0, height: 160.0),

              SizedBox(height: CSizes.spaceBtnItems),

              // -- text section --
              CShimmerEffect(width: 160.0, height: 15.0),

              SizedBox(height: CSizes.spaceBtnItems / 2),
              CShimmerEffect(width: 110.0, height: 15.0),
            ],
          ),
        );
      },
    );
  }
}
