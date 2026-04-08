import 'dart:async';
import 'dart:io';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class CNetworkManager extends GetxController {
  static CNetworkManager get instance => Get.find();

  /// -- variables --
  //final Connectivity _connectivity = Connectivity();
  StreamSubscription? _connectivitySubscription;
  // final Rx<ConnectivityResult> _connectionStatus = ConnectivityResult.none.obs;

  final RxBool hasConnection = false.obs;
  final RxBool connectionIsStable = false.obs;
  final deviceStorage = GetStorage();

  /// -- initialize the network manager and set up a stream to continually check the connection status --
  @override
  void onInit() {
    super.onInit();
    hasConnection.value = false;
    connectionIsStable.value = false;
    _connectivitySubscription = InternetConnection().onStatusChange.listen((
      event,
    ) async {
      switch (event) {
        case InternetStatus.connected:
          hasConnection.value = true;

          break;
        case InternetStatus.disconnected:
          hasConnection.value = false;
          CPopupSnackBar.customToast(
            forInternetConnectivityStatus: true,
            message: 'offline cruise...',
          );

          break;
      }
    });
  }

  /// -- check internet connection status --
  Future<bool> isConnected() async {
    try {
      final result = await InternetAddress.lookup('example.com');
      //final connectionSawa = await _connectivity.checkConnectivity();

      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        checkConnectionStability(2);
        if (await checkConnectionStability(2)) {
          hasConnection.value = true;
          return true;
        } else {
          hasConnection.value = false;
          return false;
        }
        // hasConnection.value = true;
        // return true;
      } else {
        hasConnection.value = false;
        return false;
      }
    } on SocketException catch (_) {
      hasConnection.value = false;
      // CPopupSnackBar.customToast(
      //   forInternetConnectivityStatus: true,
      //   message: 'offline cruise...',
      // );
      return false;
    } on PlatformException catch (_) {
      hasConnection.value = false;
      // CPopupSnackBar.customToast(
      //   forInternetConnectivityStatus: true,
      //   message: 'offline cruise...',
      // );
      return false;
    } catch (err) {
      hasConnection.value = false;
      CPopupSnackBar.errorSnackBar(
        title: 'internet connection error',
        message: err.toString(),
      );
      return false;
    }
  }

  /// -- check if internet connection is weak --
  Future<bool> checkConnectionStability(int durationInSeconds) async {
    try {
      final customChecker = InternetConnectionChecker.createInstance(
        checkTimeout: Duration(seconds: durationInSeconds),
      );

      if (await customChecker.hasConnection) {
        connectionIsStable.value = true;
        return true;
      } else {
        connectionIsStable.value = false;
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
        CPopupSnackBar.errorSnackBar(title: 'internet connection error');
      }
      return false;
    }
  }

  // -- update the connection status and show relevant popup --
  // Future<void> _updateConnectionStatus(ConnectivityResult result) async {
  //   _connectionStatus.value = result;
  //   if (result == ConnectivityResult.none) {
  //     CPopupSnackBar.customToast(
  //       message: 'please check your internet connection...',
  //     );
  //     // CPopupSnackBar.warningSnackBar(
  //     //   title: 'check your internet connection',
  //     // );
  //   }
  // }

  // -- dispose or close the active connectivity stream

  @override
  void dispose() {
    super.dispose();
    _connectivitySubscription?.cancel();
  }

  @override
  void onClose() {
    super.onClose();
    _connectivitySubscription?.cancel();
  }
}
