import 'package:cri_v3/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:cri_v3/utils/constants/colors.dart' show CColors;
import 'package:cri_v3/utils/constants/sizes.dart' show CSizes;
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';

class CCustomDivider extends StatelessWidget {
  const CCustomDivider({
    super.key,
    this.leftPadding = 20.0,
    this.lineHeight = 2.0,
  });

  final double leftPadding;
  final double? lineHeight;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: leftPadding,
      ),
      child: Row(
        children: [
          CCircularContainer(
            bgColor: CNetworkManager.instance.hasConnection.value
                ? CColors.rBrown
                : CColors.darkGrey,
            height: lineHeight,
            margin: const EdgeInsets.only(right: CSizes.spaceBtnItems / 2),
            width: 10.0,
          ),
          CCircularContainer(
            bgColor: CNetworkManager.instance.hasConnection.value
                ? CColors.rBrown
                : CColors.darkGrey,
            height: lineHeight,
            margin: const EdgeInsets.only(right: CSizes.spaceBtnItems / 2),
            width: 40.0,
          ),
        ],
      ),
    );
  }
}
