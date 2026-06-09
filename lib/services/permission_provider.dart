import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:cri_v3/common/widgets/dialogs/location_permission_dialog.dart';
import 'package:cri_v3/main.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class CPermissionProvider {
  /// -- variables --
  static PermissionStatus locationPermission = PermissionStatus.denied;
  static bool locationServiceIsOn = false;
  static bool notificationsAllowed = false;

  static DialogRoute? permissionDialogRoute;

  /// -- handle permissions for location services --
  static Future<void> handleLocationPermission() async {
    locationServiceIsOn = await Permission.location.serviceStatus.isEnabled;
    locationPermission = await Permission.location.status;

    if (locationServiceIsOn) {
      switch (locationPermission) {
        case PermissionStatus.permanentlyDenied:
          permissionDialogRoute = locationDialogRoute(
            title: 'location services',
            contentTxt:
                'rIntel recommends location info to protect our sellers & buyers...',
            btnTxt: 'go to settings',
            onPressed: () {
              Navigator.of(globalNavigatorKey.currentContext!).pop();
              openAppSettings();
            },
          );
          Navigator.of(
            globalNavigatorKey.currentContext!,
          ).push(permissionDialogRoute!);

        case PermissionStatus.denied:
          Permission.location.request().then((value) {
            locationPermission = value;
          });
          break;
        default:
      }
    } else {
      permissionDialogRoute = locationDialogRoute(
        title: 'location services',
        contentTxt:
            'rIntel recommends location info to protect our sellers & buyers...',
        btnTxt: Platform.isAndroid ? 'turn it on' : 'ok',
        onPressed: () {
          Navigator.of(globalNavigatorKey.currentContext!).pop();

          if (Platform.isAndroid) {
            const AndroidIntent androidIntent = AndroidIntent(
              action: 'android.settings.LOCATION_SOURCE_SETTINGS',
            );
            androidIntent.launch();
          } else {
            // TODO: ios integration
          }
        },
      );

      Navigator.of(
        globalNavigatorKey.currentContext!,
      ).push(permissionDialogRoute!);
    }
  }

  static Future<bool> handleNotificationsPermission(bool value) async {
    final status = await Permission.notification.status;
    if (value) {
      if (!status.isGranted) {
        final result = await Permission.notification.request();
        if (result.isGranted) {
          notificationsAllowed = true;
          return true;
        } else {
          notificationsAllowed = false;
          return false;
        }
      } else {
        notificationsAllowed = true;
        return true;
      }
    } else {
      notificationsAllowed = false;
      return false;
    }
  }
}
