import 'package:cri_v3/common/widgets/custom_shapes/containers/circular_container.dart';
import 'package:cri_v3/common/widgets/custom_shapes/curved_edges/curved_edges_widget.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CPrimaryHeaderContainer extends StatelessWidget {
  const CPrimaryHeaderContainer({super.key, required this.child, this.height});

  final Widget child;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return CCurvedEdgeWidget(
      child: Obx(() {
        return Container(
          color: CNetworkManager.instance.hasConnection.value
              ? CColors.primaryBrown
              : CColors.black,
          padding: const EdgeInsets.all(0),
          height: height,
          child: Stack(
            children: [
              // -- background custom shapes
              Positioned(
                top: -150,
                right: -250,
                child: CCircularContainer(
                  bgColor: CColors.txtWhite.withValues(alpha: 0.1),
                ),
              ),
              Positioned(
                top: 100,
                right: -300,
                child: CCircularContainer(
                  bgColor: CColors.txtWhite.withValues(alpha: 0.1),
                ),
              ),
              child,
            ],
          ),
        );
      }),
    );
  }
}
