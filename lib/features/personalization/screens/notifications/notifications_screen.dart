import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cri_v3/common/widgets/appbar/v2_app_bar.dart';
import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/common/widgets/dividers/custom_divider.dart';
import 'package:cri_v3/features/personalization/controllers/notification_tings/flutter_local_notifications/local_notifications_controller.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/personalization/screens/notifications/widgets/alerts_sliver_view.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CNotificationsScreen extends StatefulWidget {
  const CNotificationsScreen({super.key});

  @override
  State<CNotificationsScreen> createState() => _CNotificationsScreenState();
}

class _CNotificationsScreenState extends State<CNotificationsScreen> {
  @override
  void initState() {
    AwesomeNotifications().isNotificationAllowed().then(
      (isAllowed) {
        if (!isAllowed) {
          // This is just a basic example. For real apps, you must show some
          // friendly dialog box before call the request method.
          // This is very important to not harm the user experience
          AwesomeNotifications().requestPermissionToSendNotifications();
        }
      },
    );

    Future.delayed(
      Duration.zero,
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            final notsController = Get.put(CLocalNotificationsController());

            await notsController.updateNotificationsReadStatus();
          },
        );
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    // final notServices = Get.put(CNotificationServices());
    final userController = Get.put(CUserController());

    return Container(
      color: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
        /// -- app bar --
        appBar: CVersion2AppBar(
          autoImplyLeading: false,
          leftPadding: 10.0,
          rightPadding: 10.0,
        ),
        backgroundColor: CColors.rBrown.withValues(
          alpha: 0.2,
        ),

        /// -- body --
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: CColors.transparent,
              expandedHeight: 90.0,
              flexibleSpace: CRoundedContainer(
                bgColor: CColors.transparent,
                height: 80.0,
                padding: const EdgeInsets.only(
                  left: 10.0,
                  right: 10.0,
                ),
                showBorder: false,
                child: Stack(
                  //crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Positioned(
                      top: 0,
                      child: Text(
                        userController.user.value.email,
                        style: Theme.of(context).textTheme.labelSmall!.apply(
                          color: CNetworkManager.instance.hasConnection.value
                              ? CColors.rBrown
                              : CColors.darkGrey,
                        ),
                      ),
                    ),

                    Positioned(
                      top: 8.0,
                      child: Text(
                        'Alerts',
                        style: Theme.of(context).textTheme.labelLarge!.apply(
                          color: CNetworkManager.instance.hasConnection.value
                              ? CColors.rBrown
                              : CColors.darkGrey,
                          fontSizeFactor: 2.5,
                          fontWeightDelta: -7,
                        ),
                      ),
                    ),

                    /// -- custom divider --
                    Positioned(
                      top: 55.0,
                      child: CCustomDivider(
                        leftPadding: 0.0,
                      ),
                    ),
                  ],
                ),
              ),
              floating: true,
              pinned: true,
              //snap: true,
            ),
            CAlertsSliverView(),
          ],
        ),
      ),
    );
  }
}
