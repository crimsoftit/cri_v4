import 'package:cri_v3/common/widgets/shimmers/shimmer_effects.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CHorizontalProductShimmer extends StatelessWidget {
  const CHorizontalProductShimmer({super.key, this.itemCount = 4});

  final int itemCount;
  //final

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: CSizes.spaceBtnSections),
      height: 50.0,
      child: ListView.separated(
        itemCount: itemCount,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        separatorBuilder: (context, index) {
          return const SizedBox(height: CSizes.spaceBtnItems * 2);
        },
        itemBuilder: (_, __) {
          return const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // -- product initials section --
              CShimmerEffect(width: 40.0, height: 40.0, radius: 40.0),

              // -- text section --
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: CSizes.spaceBtnItems / 2),
                  CShimmerEffect(width: 150.0, height: 15.0),
                  SizedBox(height: CSizes.spaceBtnItems / 2),
                  CShimmerEffect(width: 120.0, height: 15.0),
                  Spacer(),
                ],
              ),

              // -- trailing icon section
              CShimmerEffect(width: 15.0, height: 30.0),
            ],
          );
        },
      ),
    );
  }
}
