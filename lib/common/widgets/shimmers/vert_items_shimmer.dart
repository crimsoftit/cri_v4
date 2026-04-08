import 'package:cri_v3/common/widgets/layouts/list_layout.dart';
import 'package:cri_v3/common/widgets/shimmers/shimmer_effects.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';

class CVerticalProductShimmer extends StatelessWidget {
  const CVerticalProductShimmer({super.key, required this.itemCount});

  final int itemCount;

  @override
  Widget build(BuildContext context) {
    return CListViewLayout(
      itemCount: itemCount,
      itemBuilder: (_, __) {
        return SizedBox(
          width: double.infinity,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // -- product initials section --
              const CShimmerEffect(width: 40.0, height: 40.0, radius: 40.0),
              const SizedBox(width: CSizes.spaceBtnItems / 4),

              // -- text section --
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CShimmerEffect(
                    width: CHelperFunctions.screenWidth() * 0.7,
                    //width: 170.0,
                    height: 15.0,
                  ),
                  const SizedBox(height: CSizes.spaceBtnItems / 4),
                  const CShimmerEffect(width: 145.0, height: 15.0),
                  const SizedBox(height: CSizes.spaceBtnItems / 4),
                  const CShimmerEffect(width: 140.0, height: 15.0),
                ],
              ),
              const SizedBox(width: CSizes.spaceBtnItems / 4),

              // -- trailing icon section
              const CShimmerEffect(width: 15.0, height: 26.0, radius: 5.0),
            ],
          ),
        );
      },
    );
  }
}
