import 'package:cri_v3/common/widgets/appbar/v2_app_bar.dart';
import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/common/widgets/list_tiles/menu_tile.dart';
import 'package:cri_v3/common/widgets/loaders/default_loader.dart';
import 'package:cri_v3/data/repos/auth/auth_repo.dart';
import 'package:cri_v3/features/personalization/controllers/app_settings_controller.dart';
import 'package:cri_v3/features/personalization/controllers/camera_controller.dart';
import 'package:cri_v3/features/personalization/controllers/location_controller.dart';
import 'package:cri_v3/features/personalization/controllers/notification_tings/flutter_local_notifications/local_notifications_controller.dart';
import 'package:cri_v3/features/personalization/screens/location_tings/widgets/device_settings_btn.dart';
import 'package:cri_v3/main.dart';
import 'package:cri_v3/services/location_services.dart';
import 'package:cri_v3/services/permission_provider.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:developer';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:permission_handler/permission_handler.dart';

class CAppSettingsScreen extends StatefulWidget {
  const CAppSettingsScreen({super.key});

  @override
  State<CAppSettingsScreen> createState() => _CAppSettingsScreenState();
}

class _CAppSettingsScreenState extends State<CAppSettingsScreen> {
  /// -- variables --
  final CAppSettingsController appSettingsController =
      Get.put<CAppSettingsController>(CAppSettingsController());
  late StreamController<PermissionStatus> _permissionStatusStream;
  late StreamController<AppLifecycleState> _appCycleStateStream;
  late final AppLifecycleListener _listener;
  bool geoSwitchIsOn = false;

  final CLocationController locationController = Get.put<CLocationController>(
    CLocationController(),
  );
  final notificationsController = Get.put<CLocalNotificationsController>(
    CLocalNotificationsController(),
  );

  @override
  void initState() {
    super.initState();

    _permissionStatusStream = StreamController<PermissionStatus>();
    _appCycleStateStream = StreamController<AppLifecycleState>();
    _listener = AppLifecycleListener(
      onStateChange: _onStateChange,
      onResume: _onResume,
      onInactive: _onInactive,
      onHide: _onHide,
      onShow: _onShow,
      onPause: _onPause,
      onRestart: _onRestart,
      onDetach: _onDetach,
    );
    _appCycleStateStream.sink.add(SchedulerBinding.instance.lifecycleState!);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      checkPermissionAndListenLocation();
    });

    if (CPermissionProvider.locationServiceIsOn) {
      setState(() {
        geoSwitchIsOn = true;
      });
      CLocationServices.instance.getUserLocation(
        locationController: locationController,
      );
    }
    // CLocationServices.instance
    //     .getUserLocation(locationController: locationController);
  }

  void _onStateChange(AppLifecycleState state) =>
      _appCycleStateStream.sink.add(state);

  void _onResume() {
    log('onResume');
    if (CPermissionProvider.permissionDialogRoute != null &&
        CPermissionProvider.permissionDialogRoute!.isActive) {
      Navigator.of(
        globalNavigatorKey.currentContext!,
      ).removeRoute(CPermissionProvider.permissionDialogRoute!);
    }
    Future.delayed(const Duration(milliseconds: 250), () async {
      checkPermissionAndListenLocation();
    });

    if (CPermissionProvider.locationServiceIsOn) {
      setState(() {
        geoSwitchIsOn = true;
      });
      CLocationServices.instance.getUserLocation(
        locationController: locationController,
      );
    }
    // CLocationServices.instance
    //     .getUserLocation(locationController: locationController);
  }

  void _onInactive() => log('onInactive');

  void _onHide() => log('onHide');

  void _onShow() => log('onShow');

  void _onPause() => log('onPause');

  void _onRestart() => log('onRestart');

  void _onDetach() => log('onDetach');

  @override
  void dispose() {
    _listener.dispose();
    _permissionStatusStream.close();
    _appCycleStateStream.close();
    super.dispose();
  }

  void checkPermissionAndListenLocation() {
    CPermissionProvider.handleLocationPermission().then((_) {
      _permissionStatusStream.sink.add(CPermissionProvider.locationPermission);
    });
  }

  @override
  Widget build(BuildContext context) {
    final cameraController = Get.put(CCameraController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Container(
      color: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
        appBar: CVersion2AppBar(autoImplyLeading: false),
        backgroundColor: CColors.rBrown.withValues(alpha: 0.2),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 5.0, top: 10.0),
            child: SizedBox(
              height: CHelperFunctions.screenHeight() * .95,
              child: Column(
                children: [
                  /// -- screen header --
                  CRoundedContainer(
                    bgColor: CColors.transparent,
                    padding: const EdgeInsets.only(
                      left: 5.0,
                      right: 5.0,
                      //top: 20.0,
                      //bottom: 20.0,
                    ),
                    width: CHelperFunctions.screenWidth() * .9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'allow app permissions',
                          style: Theme.of(context).textTheme.headlineMedium!
                              .apply(color: CColors.rBrown, fontWeightDelta: 1),
                          textAlign: TextAlign.start,
                        ),
                        const SizedBox(height: CSizes.defaultSpace),
                        Text(
                          'data protection is our priority; we only use these services to enhance your experience. you can change permissions anytime in device settings.',
                          style: Theme.of(
                            context,
                          ).textTheme.labelMedium!.apply(color: CColors.rBrown),
                          textAlign: TextAlign.start,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: StreamBuilder<PermissionStatus>(
                        stream: _permissionStatusStream.stream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const DefaultLoaderScreen(); // Display a loading indicator when waiting for data
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                            ); // Display an error message if an error occurs
                          } else if (!snapshot.hasData) {
                            return const Text(
                              'No Data Available',
                            ); // Display a message when no data is available
                          } else {
                            return Column(
                              children: [
                                Visibility(
                                  visible: false,
                                  child: Text(
                                    'location service: ${CPermissionProvider.locationServiceIsOn ? "On" : "Off"}\n${snapshot.data}',
                                    // style: const TextStyle(fontSize: 24),
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodyLarge!.apply(),
                                  ),
                                ),
                                const SizedBox(height: CSizes.spaceBtnSections),
                                CMenuTile(
                                  icon: Iconsax.location,
                                  title: 'enable location services',
                                  subTitle:
                                      'rIntel requires location info to function properly and to protect buyers & sellers',
                                  trailing: Switch(
                                    value:
                                        CPermissionProvider.locationServiceIsOn,
                                    activeThumbColor: CColors.rBrown,
                                    onChanged: (value) {
                                      setState(() {
                                        CPermissionProvider
                                                .locationServiceIsOn =
                                            value;
                                      });

                                      if (geoSwitchIsOn) {
                                        CLocationServices.instance
                                            .getUserLocation(
                                              locationController:
                                                  locationController,
                                            );
                                      }
                                    },
                                  ),
                                ),
                                // const SizedBox(height: CSizes.spaceBtnSections),
                                Obx(
                                  () => CMenuTile(
                                    icon: Iconsax.camera,
                                    title: 'camera access',
                                    subTitle:
                                        'rIntel requires access to your camera to scan barcodes',
                                    trailing: Switch(
                                      value: cameraController
                                          .cameraIsAccessible
                                          .value,
                                      activeThumbColor: CColors.rBrown,
                                      onChanged: (value) {
                                        cameraController
                                            .requestCameraPermission(value);
                                      },
                                    ),
                                  ),
                                ),

                                Obx(
                                  () => CMenuTile(
                                    icon: Iconsax.notification,
                                    title: 'notifications',
                                    subTitle:
                                        'get notified about stock/inventory updates etc.',
                                    trailing: Switch(
                                      value: notificationsController
                                          .notificationsEnabled
                                          .value,
                                      activeThumbColor: CColors.rBrown,
                                      onChanged: (value) {
                                        notificationsController
                                            .handleNotificationPermissions(
                                              value,
                                            );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: StreamBuilder<AppLifecycleState>(
                        stream: _appCycleStateStream.stream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const DefaultLoaderScreen(); // Display a loading indicator when waiting for data
                          } else if (snapshot.hasError) {
                            return Text(
                              'Error: ${snapshot.error}',
                            ); // Display an error message if an error occurs
                          } else if (!snapshot.hasData) {
                            return const Text(
                              'No data available',
                            ); // Display a message when no data is available
                          } else {
                            return Obx(() {
                              //if (locationController.processingLocationAccess.value)
                              if (locationController
                                          .processingLocationAccess
                                          .value &&
                                      locationController.uAddress.value == '' ||
                                  locationController.uCurCode.value == '') {
                                if (!geoSwitchIsOn) {
                                  return DeviceSettingsBtn(onPressed: () {});
                                } else {
                                  return const DefaultLoaderScreen();
                                }
                              }

                              if (geoSwitchIsOn) {
                                CLocationServices.instance.getUserLocation(
                                  locationController: locationController,
                                );
                              }

                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Visibility(
                                      visible: false,
                                      child: Column(
                                        children: [
                                          Text(
                                            'latitude: ${locationController.userLocation.value!.latitude ?? ''}',
                                          ),
                                          Text(
                                            'longitude: ${locationController.userLocation.value!.longitude ?? ''}',
                                          ),
                                          Text(
                                            'user country: ${locationController.uCountry.value}',
                                          ),
                                          Text(
                                            'user Address: ${locationController.uAddress.value}',
                                          ),
                                          Text(
                                            'user currency code: ${locationController.uCurCode.value}',
                                          ),
                                          Text(
                                            '${snapshot.data}',
                                            style: const TextStyle(
                                              fontSize: 24,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    DeviceSettingsBtn(
                                      onPressed: () {
                                        CPermissionProvider.locationServiceIsOn
                                            ? appSettingsController
                                                  .onContinueButtonPressed()
                                            : CPopupSnackBar.customToast(
                                                message:
                                                    'please enable location services to continue',
                                                forInternetConnectivityStatus:
                                                    false,
                                              );
                                      },
                                    ),
                                    // const SizedBox(
                                    //   height: CSizes.defaultSpace,
                                    // ),
                                    Center(
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Iconsax.logout,
                                            size: 28.0,
                                            color: CColors.primaryBrown,
                                          ),
                                          const SizedBox(
                                            width: CSizes.spaceBtnInputFields,
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              AuthRepo.instance.logout();
                                            },
                                            child: Text(
                                              'log out',
                                              style: TextStyle(
                                                color: isDarkTheme
                                                    ? CColors.grey
                                                    : CColors.darkGrey,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
