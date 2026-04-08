import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';

class CProductCardHorizontal extends StatelessWidget {
  const CProductCardHorizontal({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
  });

  final int itemCount;

  final Widget? Function(BuildContext, int) itemBuilder;

  @override
  Widget build(BuildContext context) {
    return CRoundedContainer(
      bgColor: CColors.transparent,
      child: ListView.separated(
        itemBuilder: itemBuilder,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,

        separatorBuilder: (_, __) {
          return SizedBox(
            width: CSizes.spaceBtnItems / 2,
          );
        },
        itemCount: itemCount,
      ),
    );
  }
}
