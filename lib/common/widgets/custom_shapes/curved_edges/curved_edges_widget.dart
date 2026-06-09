import 'package:cri_v3/common/widgets/custom_shapes/curved_edges/curved_edges.dart';
import 'package:flutter/material.dart';

class CCurvedEdgeWidget extends StatelessWidget {
  const CCurvedEdgeWidget({super.key, this.child});

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(clipper: CCustomCurvedEdges(), child: child);
  }
}
