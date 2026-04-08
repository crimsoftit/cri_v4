import 'package:cri_v3/features/personalization/controllers/location_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DeviceSettingsBtn extends StatelessWidget {
  const DeviceSettingsBtn({super.key, required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final CLocationController locationController = Get.put<CLocationController>(
      CLocationController(),
    );

    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          onPressed: onPressed,
          icon: Icon(
            Icons.arrow_circle_right_outlined,
            color: CColors.white,
            size: 20,
          ),
          label: Text(
            locationController.updateLoading.value ? 'loading...' : 'CONTINUE',
            style: Theme.of(context).textTheme.labelMedium!.apply(
              color: CColors.white,
              fontWeightDelta: 20,
            ),
          ),
        ),
      ),
    );
  }
}
