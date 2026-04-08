import 'package:cri_v3/features/personalization/controllers/notification_tings/flutter_local_notifications/local_notifications_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CAlertsCounterWidget extends StatelessWidget {
  const CAlertsCounterWidget({
    super.key,
    this.counterBgColor,
    this.counterTxtColor,
    this.rightPosition,
    this.topPosition,
    required this.alertsCount,
  });

  final Color? counterBgColor;
  final Color? counterTxtColor;

  final double? rightPosition, topPosition;
  final int alertsCount;

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final notsController = Get.put(CLocalNotificationsController());

    return Positioned(
      right: rightPosition,
      top: topPosition,
      child: Container(
        width: 18,
        height: 18,
        decoration: BoxDecoration(
          color: counterBgColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Obx(() {
            notsController.fetchUserNotifications();

            /// -- display count of only created notifications --

            return Text(
              '$alertsCount',
              style: Theme.of(context).textTheme.labelSmall!.apply(
                color:
                    counterTxtColor ??
                    (isDarkTheme ? CColors.rBrown : CColors.white),
                fontSizeFactor: 1.0,
              ),
            );
          }),
        ),
      ),
    );
  }
}
