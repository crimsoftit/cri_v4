import 'package:cri_v3/features/personalization/controllers/notification_tings/flutter_local_notifications/local_notifications_controller.dart';
import 'package:cri_v3/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/formatter.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CAlertsListView extends StatelessWidget {
  const CAlertsListView({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final invController = Get.put(CInventoryController());
    final notsController = Get.put(CLocalNotificationsController());

    var items = notsController.allNotifications;

    return Obx(() {
      notsController.fetchUserNotifications();

      if (items.isEmpty) {
        return const Center(
          child: NoDataScreen(
            lottieImage: CImages.noDataLottie,
            txt: 'no notifications as yet!!',
          ),
        );
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(CSizes.borderRadiusLg),
        child: ListView.separated(
          itemCount: items.length,
          itemBuilder: (_, index) {
            // -- widget for no notifications --
            // if (items.isEmpty && !notsController.isLoading.value) {
            //   return const Center(
            //     child: NoDataScreen(
            //       lottieImage: CImages.noDataLottie,
            //       txt: 'no notifications yet',
            //     ),
            //   );
            // }
            return Card(
              color: isDarkTheme
                  ? CColors.rBrown.withValues(alpha: 0.3)
                  : CColors.lightGrey,
              margin: EdgeInsets.all(1),
              child: ListTile(
                contentPadding: EdgeInsets.only(left: 5, right: 10.0),
                leading: CircleAvatar(
                  backgroundColor: isDarkTheme
                      ? CColors.darkGrey
                      : CNetworkManager.instance.hasConnection.value
                      ? CColors.rBrown.withValues(alpha: .3)
                      : CColors.darkerGrey,
                  radius: 15.0,

                  child: Icon(
                    color: isDarkTheme ? CColors.grey : CColors.rBrown,
                    items[index].productId!.isGreaterThan(10)
                        ? Iconsax.information
                        : Iconsax.user,
                    size: CSizes.iconSm,
                  ),
                  // Text(
                  //   '${index + 1}',
                  //   style: Theme.of(context).textTheme.labelMedium!.apply(
                  //         color: CColors.grey,
                  //       ),
                  // ),
                ),
                //isThreeLine: true,
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -- date --
                    Align(
                      alignment: Alignment.topRight,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.access_alarms,
                            size: CSizes.iconSm * .7,
                            color: CColors.rBrown,
                          ),
                          const SizedBox(width: 4.0),
                          Text(
                            CFormatter.formatTimeRangeFromNow(
                              items[index].date.replaceAll('@ ', ''),
                            ),
                            style: Theme.of(context).textTheme.labelSmall!
                                .apply(
                                  color: isDarkTheme
                                      ? CColors.darkGrey
                                      : CColors.rBrown,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 2.0),

                    // -- alert title --
                    Text(
                      items[index].notificationTitle,
                      style: Theme.of(context).textTheme.labelMedium!.apply(
                        color: isDarkTheme ? CColors.darkGrey : CColors.rBrown,
                        //fontFamily: 'Roboto',
                        fontSizeDelta: 1.3,
                        fontWeightDelta: items[index].notificationIsRead == 0
                            ? 2
                            : 1,
                      ),
                    ),
                  ],
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // -- alert message (subtitle, body) --
                    Text(
                      items[index].notificationBody,
                      style: Theme.of(context).textTheme.labelMedium!.apply(
                        color: isDarkTheme ? CColors.darkGrey : CColors.rBrown,
                      ),
                    ),

                    /// -- other alert item details... --
                    Visibility(
                      visible: false,
                      child: Text.rich(
                        TextSpan(
                          children: [
                            TextSpan(
                              style: Theme.of(context).textTheme.labelMedium!
                                  .apply(
                                    color: isDarkTheme
                                        ? CColors.darkGrey
                                        : CColors.rBrown,
                                  ),
                              text:
                                  'alertId: ${items[index].notificationId}; notified: ${items[index].alertCreated}; isRead: ${items[index].notificationIsRead}; ',
                            ),
                            TextSpan(
                              style: Theme.of(context).textTheme.labelMedium!
                                  .apply(
                                    color: isDarkTheme
                                        ? CColors.darkGrey
                                        : CColors.rBrown,
                                  ),
                              text:
                                  'user: ${items[index].userEmail}; pId: ${items[index].productId} ',
                            ),
                            TextSpan(
                              style: Theme.of(context).textTheme.labelMedium!
                                  .apply(
                                    color: isDarkTheme
                                        ? CColors.darkGrey
                                        : CColors.rBrown,
                                  ),
                              text:
                                  'user: ${items[index].userEmail}; pId: ${items[index].productId} ',
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (items[index].productId != null)
                      Align(
                        alignment: Alignment.bottomRight,
                        child: TextButton.icon(
                          onPressed: () {
                            invController.fetchUserInventoryItems().then((_) {
                              var invItemIndex = invController.inventoryItems
                                  .indexWhere(
                                    (item) =>
                                        item.productId ==
                                        items[index].productId,
                                  );
                              if (invItemIndex >= 0) {
                                Get.toNamed(
                                  '/inventory/item_details/',
                                  arguments: items[index].productId,
                                );
                              } else {
                                Get.snackbar(
                                  'item not found',
                                  'the product associated with this alert was not found in inventory',
                                  snackPosition: SnackPosition.BOTTOM,
                                  backgroundColor: isDarkTheme
                                      ? CColors.darkGrey.withValues(alpha: 0.7)
                                      : CColors.lightGrey.withValues(
                                          alpha: 0.7,
                                        ),
                                  colorText: isDarkTheme
                                      ? CColors.rBrown
                                      : CColors.darkerGrey,
                                );
                              }
                            });
                          },
                          icon: Icon(
                            Iconsax.eye,
                            color: CNetworkManager.instance.hasConnection.value
                                ? CColors.rBrown
                                : CColors.darkerGrey,
                            size: CSizes.iconSm,
                          ),
                          label: Text(
                            'view product',
                            style: Theme.of(context).textTheme.labelMedium!
                                .apply(
                                  color:
                                      CNetworkManager
                                          .instance
                                          .hasConnection
                                          .value
                                      ? CColors.rBrown
                                      : CColors.darkerGrey,
                                ),
                          ),
                          // style: ElevatedButton.styleFrom(
                          //   backgroundColor: isDarkTheme
                          //       ? CColors.darkGrey
                          //       : CColors.rBrown.withValues(
                          //           alpha: 0.2,
                          //         ), // background color
                          //   foregroundColor: isDarkTheme
                          //       ? CColors.darkGrey
                          //       : CColors.rBrown, // foreground (text) color
                          //   shape: RoundedRectangleBorder(
                          //     borderRadius: BorderRadius.circular(
                          //       CSizes.borderRadiusSm,
                          //     ),
                          //   ),
                          // ),
                        ),
                      ),
                  ],
                ),

                // Text(
                //   items[index].notificationBody,
                //   style: Theme.of(context).textTheme.labelMedium!.apply(
                //         color:
                //             isDarkTheme ? CColors.darkGrey : CColors.rBrown,
                //         // fontWeightDelta:
                //         //     items[index].notificationIsRead == 0
                //         //         ? 2
                //         //         : 0,
                //       ),
                // ),
                trailing: InkWell(
                  onTap: () {
                    notsController.onDeleteBtnPressed(items[index]);
                  },
                  child: Icon(
                    Icons.close,
                    color: CNetworkManager.instance.hasConnection.value
                        ? CColors.rBrown
                        : CColors.darkerGrey,
                    size: CSizes.iconSm,
                  ),
                ),
              ),
            );
          },
          separatorBuilder: (_, __) {
            return SizedBox(height: CSizes.spaceBtnSections / 8);
          },
          shrinkWrap: true,
        ),
      );
    });
  }
}
