import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DefaultLoaderScreen extends StatelessWidget {
  const DefaultLoaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isConnectedToInternet =
          CNetworkManager.instance.hasConnection.value;

      return Scaffold(
        backgroundColor: isConnectedToInternet
            ? CColors.rBrown
            : CColors.black.withValues(
                alpha: 0.3,
              ),
        body: Center(
          child: CircularProgressIndicator(
            color: CColors.white,
          ),
        ),
      );
    });
  }
}
