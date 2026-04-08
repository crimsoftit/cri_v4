import 'package:cri_v3/common/widgets/appbar/v2_app_bar.dart';
import 'package:cri_v3/common/widgets/dividers/custom_divider.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/personalization/screens/notifications/widgets/alerts_listview.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
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
    // AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
    //   if (!isAllowed) {
    //     // This is just a basic example. For real apps, you must show some
    //     // friendly dialog box before call the request method.
    //     // This is very important to not harm the user experience
    //     AwesomeNotifications().requestPermissionToSendNotifications();
    //   } else {
    //     Get.put<CNotificationServices>(CNotificationServices());
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    //final notsController = Get.put(CLocalNotificationsController());
    // final notServices = Get.put(CNotificationServices());
    final userController = Get.put(CUserController());

    return Container(
      color: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
        /// -- app bar --
        appBar: CVersion2AppBar(autoImplyLeading: true),
        backgroundColor: CColors.rBrown.withValues(alpha: 0.2),

        /// -- body --
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 15.0, top: 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(
                  () {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          userController.user.value.email,
                          style: Theme.of(context).textTheme.labelSmall!.apply(
                            color: CNetworkManager.instance.hasConnection.value
                                ? CColors.rBrown
                                : CColors.darkGrey,
                          ),
                        ),
                        Text(
                          'Alerts',
                          style: Theme.of(context).textTheme.labelLarge!.apply(
                            color: CNetworkManager.instance.hasConnection.value
                                ? CColors.rBrown
                                : CColors.darkGrey,
                            fontSizeFactor: 2.5,
                            fontWeightDelta: -7,
                          ),
                        ),

                        /// -- custom divider --
                        CCustomDivider(
                          leftPadding: 5.0,
                        ),
                      ],
                    );
                  },
                ),
                const SizedBox(
                  height: CSizes.spaceBtnSections,
                ),

                // -- list notifications on an ExpansionPanelList.radio widget --
                CAlertsListView(),

                // FilledButton(
                //   onPressed: () async {
                //     await notsController.fetchUserNotifications().then((
                //       _,
                //     ) async {
                //       var previousAlertId =
                //           notsController.allNotifications.isNotEmpty
                //           ? notsController.allNotifications.fold(
                //               notsController
                //                   .allNotifications
                //                   .first
                //                   .notificationId!,
                //               (max, element) {
                //                 return element.notificationId! > max
                //                     ? element.notificationId!
                //                     : max;
                //               },
                //             )
                //           : 0;
                //       var thisAlertId = previousAlertId + 1;
                //       await CNotificationServices.notify(
                //         alertLayout: NotificationLayout.Inbox,
                //         notificationId: thisAlertId,
                //         body: "alert body",

                //         payload: {
                //           'notification_id': thisAlertId.toString(),
                //           //'product_id': '102456',
                //         },
                //         summary:
                //             'this summary is useless... in fact, there\'s nothing here!',
                //         title: 'alert title',
                //       );
                //     });
                //   },
                //   child: Text('instant notifications'),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
