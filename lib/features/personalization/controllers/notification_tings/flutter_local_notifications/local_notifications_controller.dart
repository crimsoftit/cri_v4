import 'dart:convert';

import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/personalization/models/notification_model.dart';
import 'package:cri_v3/features/store/controllers/nav_menu_controller.dart';
import 'package:cri_v3/nav_menu.dart';
import 'package:cri_v3/utils/db/sqflite/db_helper.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class CLocalNotificationsController extends GetxController {
  /// -- constructor --
  static CLocalNotificationsController get instance => Get.find();

  @override
  void onInit() async {
    await fetchUserNotifications();
    super.onInit();
  }

  /// -- variables --
  DbHelper dbHelper = DbHelper.instance;
  final isLoading = false.obs;

  final RxBool notificationsEnabled = false.obs;
  final RxList<CNotificationsModel> allNotifications =
      <CNotificationsModel>[].obs;
  final RxList<CNotificationsModel> pendingAlerts = <CNotificationsModel>[].obs;
  final RxList<CNotificationsModel> readNotifications =
      <CNotificationsModel>[].obs;
  final RxList<CNotificationsModel> unreadNotifications =
      <CNotificationsModel>[].obs;

  final userController = Get.put(CUserController());
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static final onNotificationClicked = BehaviorSubject<String>();

  /// -- initialize the local notifications plugin. app_icon needs to be added as a drawable resource to the android head project --
  static Future initLocalNotifications() async {
    const AndroidInitializationSettings androidInitSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings darwinInitializationSettings =
        DarwinInitializationSettings();

    final LinuxInitializationSettings linuxInitSettings =
        LinuxInitializationSettings(defaultActionName: 'open notification');

    final InitializationSettings initSettings = InitializationSettings(
      android: androidInitSettings,
      iOS: darwinInitializationSettings,
      linux: linuxInitSettings,
    );

    _flutterLocalNotificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: onNotificationTap,
      onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  /// -- display a simple/basic notification --
  static Future displaySimpleAlert({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'channelId',
          'channelName',
          channelDescription: 'simple notification',
          channelShowBadge: true,
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      notificationDetails,
      payload: payload,
    );
  }

  /// -- display periodic notification at regular intervals --
  static Future displayPeriodicNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    const AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
          'channel2_Id',
          'channel2_Name',
          channelDescription: 'simple notification',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        );

    const NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
    );

    await _flutterLocalNotificationsPlugin.periodicallyShow(
      1,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      title,
      body,
      RepeatInterval.everyMinute,
      notificationDetails,
      payload: payload,
    );
  }

  /// -- trigger a scheduled local notification --
  static Future triggerScheduledNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    tz.initializeTimeZones();

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      3,
      title,
      body,
      tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'channel 3',
          'channelName',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
        ),
      ),
      // androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      payload: payload,
    );
  }

  Future<void> scheduleExpiryNotification({
    required int alertId,
    required DateTime expiryDate,
    required String itemName,
  }) async {
    final triggerDate = expiryDate.subtract(const Duration(days: 2));

    if (triggerDate.isBefore(DateTime.now())) {
      if (kDebugMode) {
        print('expiry reminder date is in the past.');
        CPopupSnackBar.warningSnackBar(
          title: 'expiry date reached..',
          message: 'expiry reminder date is in the past.',
        );
      }
      return;
    }

    if (kDebugMode) {
      print("*********");
      print("*TRIGGER DATE: $triggerDate");
      print("*********");
      CPopupSnackBar.customToast(
        message: triggerDate,
        forInternetConnectivityStatus: false,
      );
    }

    final tz.TZDateTime scheduledDate = tz.TZDateTime.from(
      triggerDate,
      tz.local,
    );

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'expiry_reminder_channel',
          'Expiry Reminder',
          channelShowBadge: true,
          importance: Importance.max,
          priority: Priority.max,
        );

    const DarwinNotificationDetails iOSPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      alertId,
      'expiry alert: ${itemName.toUpperCase()}',
      '$itemName expires in 2 days!!',
      scheduledDate,
      platformChannelSpecifics,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }

  /// -- cancel/close a specific channel notification --
  static Future closeNotification(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }

  /// -- cancel/close all notifications --
  static Future closeAllNotifications() async {
    await _flutterLocalNotificationsPlugin.cancelAll();
  }

  /// -- what ought to happen when a notification is clicked --
  static Future<void> onNotificationTap(
    NotificationResponse alertResponse,
  ) async {
    final userController = Get.put(CUserController());
    try {
      onNotificationClicked.add(alertResponse.payload!);

      if (alertResponse.payload != null) {
        // -- decode payload --
        Map<String, dynamic> payloadData = jsonDecode(alertResponse.payload!);

        var notificationItem = CNotificationsModel.withId(
          payloadData['notification_id'] != null
              ? int.parse(payloadData['notification_id'])
              : 0,
          1,
          payloadData['notification_title'],
          payloadData['notification_body'],

          1,
          payloadData['product_id'] != null
              ? int.parse(payloadData['product_id'])
              : 0,
          userController.user.value.email,
          payloadData['date'],
        );

        // -- insert notification item into sqflite db --
        await DbHelper.instance.updateNotificationItem(notificationItem);

        // -- redirect screens accrodingly --

        final navController = Get.put(CNavMenuController());
        navController.selectedIndex.value = 4;
        Get.offAll(() => const NavMenu());
      }

      if (kDebugMode) {
        print('notification payload: ${alertResponse.payload}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('error handling notification tap: $e');
        CPopupSnackBar.errorSnackBar(
          title: 'error handling notification tap!',
          message: 'error handling notification tap: $e',
        );
      }
      rethrow;
    }
  }

  /// -- fetch user notifications from local db --
  Future<List<CNotificationsModel>> fetchUserNotifications() async {
    try {
      // -- start loader --
      isLoading.value = true;

      // -- query local db for notifications --
      var fetchedNotifications = await dbHelper.fetchUserNotifications(
        userController.user.value.email,
      );

      // -- assign fetchedNotifications to allNotifications list --
      allNotifications.assignAll(fetchedNotifications);

      // -- assign read notifications to readNotifications list
      var readNots = allNotifications
          .where((readNotification) => readNotification.notificationIsRead == 1)
          .toList();

      readNotifications.assignAll(readNots);

      // -- assign read notifications to readNotifications list
      var unreadNots = allNotifications
          .where(
            (unreadNotification) => unreadNotification.notificationIsRead == 0,
          )
          .toList();

      unreadNotifications.assignAll(unreadNots);

      // -- assign pending notifications --
      var pendingNots = allNotifications
          .where((pendingNot) => pendingNot.alertCreated == 0)
          .toList();
      pendingAlerts.assignAll(pendingNots);

      // -- stop loader --
      isLoading.value = false;

      return allNotifications;
    } catch (e) {
      // -- stop loader --
      isLoading.value = false;

      if (kDebugMode) {
        print(e.toString());
        CPopupSnackBar.errorSnackBar(title: 'Oh Snap!', message: e.toString());
      }

      rethrow;
    }
  }

  /// -- generate notification id --
  Future<int> generateNotificationId() async {
    var previousAlertId = allNotifications.isNotEmpty
        ? allNotifications.fold(allNotifications.first.notificationId!, (
            max,
            element,
          ) {
            return element.notificationId! > max
                ? element.notificationId!
                : max;
          })
        : 0;
    var thisAlertId = previousAlertId + 1;
    return thisAlertId;
  }

  onDeleteBtnPressed(CNotificationsModel item) async {
    deleteNotification(item);
  }

  /// -- delete notification from from local db --
  Future<void> deleteNotification(CNotificationsModel item) async {
    try {
      // -- start loader
      isLoading.value = true;

      // -- delete entry
      await dbHelper.deleteNotification(item);

      // -- refresh notifications list
      fetchUserNotifications();

      // -- stop loader
      isLoading.value = false;
    } catch (e) {
      // -- stop loader
      isLoading.value = false;
      if (kDebugMode) {
        print(e.toString());
        CPopupSnackBar.errorSnackBar(
          title: 'error deleting notification!',
          message: e.toString(),
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: 'error deleting notification!',
          message:
              'an unknown error occurred while deleting this notification... please try again later!',
        );
      }

      rethrow;
    }
  }

  Future<void> handleNotificationPermissions(bool value) async {
    final PermissionStatus status = await Permission.notification.request();

    if (value) {
      if (status.isGranted) {
        notificationsEnabled.value = true;
      } else if (status.isDenied) {
        notificationsEnabled.value = false;
      } else if (status.isPermanentlyDenied) {
        // Notification permissions permanently denied, open app settings
        notificationsEnabled.value = false;
        await openAppSettings();
      }
    } else {
      notificationsEnabled.value = false;
    }
  }

  static Future<void> scheduleExpiryNotificationRaw({
    required String productName,
    required DateTime expiryDate,
    required int id,
  }) async {
    final scheduledDate = DateTime(
      expiryDate.year,
      expiryDate.month,
      expiryDate.day,
      24,
      0,
    ); // midnight
    if (scheduledDate.isBefore(DateTime.now())) return;

    final tz.TZDateTime zonedDate = tz.TZDateTime.from(scheduledDate, tz.local);

    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'expiry_channel',
          'Expiry Alerts',
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();
    final NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      'Expiry Alert: $productName',
      'This item expires today!',
      zonedDate,
      platformDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.dateAndTime,
    );
  }
}
