import 'dart:async';
import 'dart:math';

import 'package:cri_v3/common/widgets/loaders/default_loader.dart';
import 'package:cri_v3/features/personalization/controllers/location_controller.dart';
import 'package:cri_v3/main.dart';
import 'package:cri_v3/services/location_services.dart';
import 'package:cri_v3/services/permission_provider.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';

class CLocationSettingsScreen1 extends StatefulWidget {
  const CLocationSettingsScreen1({super.key});

  @override
  State<CLocationSettingsScreen1> createState() =>
      _CLocationSettingsScreenState();
}

class _CLocationSettingsScreenState extends State<CLocationSettingsScreen1> {
  late StreamController<PermissionStatus> _permissionStatusStream;
  late StreamController<AppLifecycleState> _appCycleStateStream;
  late final AppLifecycleListener _listener;

  final CLocationController locationController = Get.put<CLocationController>(
    CLocationController(),
  );

  @override
  void initState() {
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

    CLocationServices.instance.getUserLocation(
      locationController: locationController,
    );

    super.initState();
  }

  void _onStateChange(AppLifecycleState state) {
    _appCycleStateStream.sink.add(state);
  }

  void _onResume() {
    log('onResume' as num);
    if (CPermissionProvider.permissionDialogRoute != null &&
        CPermissionProvider.permissionDialogRoute!.isActive) {
      Navigator.of(
        globalNavigatorKey.currentContext!,
      ).removeRoute(CPermissionProvider.permissionDialogRoute!);
    }
    Future.delayed(const Duration(milliseconds: 250), () async {
      checkPermissionAndListenLocation();
    });
  }

  void _onInactive() => log('onInactive' as num);

  void _onHide() => log('onHide' as num);

  void _onShow() => log('onShow' as num);

  void _onPause() => log('onPause' as num);

  void _onRestart() => log('onRestart' as num);

  void _onDetach() => log('onDetach' as num);

  @override
  void dispose() {
    _listener.dispose();
    _permissionStatusStream.close();
    _appCycleStateStream.close();

    super.dispose();
  }

  void checkPermissionAndListenLocation() {
    CPermissionProvider.handleLocationPermission().then((_) {
      _permissionStatusStream.sink.add(
        CPermissionProvider.locationPermission as PermissionStatus,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CColors.rBrown,
        title: Text(
          'device settings',
          style: Theme.of(
            context,
          ).textTheme.labelLarge!.apply(color: CColors.white),
        ),
      ),
      body: Obx(() {
        return locationController.processingLocationAccess.value
            ? const DefaultLoaderScreen()
            : Center(
                child:
                    locationController.errorDesc.value.isNotEmpty ||
                        locationController.userLocation.value == null
                    ? Column(
                        children: [Text(locationController.errorDesc.value)],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Text(
                            'latitude: ${locationController.userLocation.value!.latitude}',
                          ),
                          Text(
                            'longitude: ${locationController.userLocation.value!.longitude}',
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
                        ],
                      ),
              );
      }),
    );
  }
}
