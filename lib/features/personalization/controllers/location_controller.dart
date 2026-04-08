import 'dart:async';

import 'package:cri_v3/data/repos/user/user_repo.dart';
import 'package:cri_v3/features/authentication/controllers/signup/signup_controller.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/personalization/models/user_model.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:location/location.dart' as location;

class CLocationController extends GetxController {
  // -- variables --
  final RxBool processingLocationAccess = RxBool(false);
  final RxBool updateLoading = RxBool(false);
  final RxString errorDesc = ''.obs;
  final Rx<LocationData?> userLocation = Rx<LocationData?>(null);
  final RxString uAddress = RxString('');
  final RxString uCountry = RxString('');
  final RxString uCurCode = RxString('');

  final signupController = Get.put(SignupController());
  final userController = Get.put(CUserController());
  final userRepo = Get.put(CUserRepo());

  late StreamSubscription<ServiceStatus> serviceStatusStream;

  final location.Location _location = location.Location();

  final geocoding = Geolocator();

  @override
  void onInit() async {
    checkForServiceAvailability();
    super.onInit();
  }

  // -- initialize the network manager and set up a stream to continually check the connection status --

  void updateLocationAccess(bool hasAccess) {
    processingLocationAccess.value = hasAccess;
  }

  Future<bool> checkForServiceAvailability() async {
    bool locationIsEnabled = await _location.serviceEnabled();

    if (locationIsEnabled) {
      return Future.value(true);
    }

    locationIsEnabled = await _location.requestService();

    if (locationIsEnabled) {
      return Future.value(true);
    }

    return Future.value(false);
  }

  void updateUserLocation(LocationData locationData) {
    userLocation.value = locationData;
  }

  fetchUserCurrencyByCountry(String uCountry) {
    // -- load user's currency code --
    signupController.fetchUserCurrencyByCountry(uCountry);
    uCurCode.value = signupController.userCurrencyCode.value;
  }

  Future<bool> updateUserLocationAndCurrencyDetails() async {
    try {
      updateLoading.value = true;
      await userController.fetchUserDetails();
      var updatedUser = CUserModel(
        id: userController.user.value.id,
        fullName: userController.user.value.fullName,
        businessName: userController.user.value.businessName,
        email: userController.user.value.email,
        countryCode: userController.user.value.countryCode,
        phoneNo: userController.user.value.phoneNo,
        currencyCode: uCurCode.value,
        profPic: userController.user.value.profPic,
        locationCoordinates:
            'lat: ${userLocation.value!.latitude}, long: ${userLocation.value!.longitude}',
        userAddress: uAddress.value,
        role: userController.user.value.role,
        createdAt: userController.user.value.createdAt,
        updatedAt: DateTime.now(),
      );

      // Map<String, dynamic> updates = {
      //   'currencyCode': uCurCode.value,
      //   'locationCoordinates':
      //       'lat: ${userLocation.value!.latitude}, long: ${userLocation.value!.longitude}',
      //   'userAddress': uAddress.value,
      // };
      // await userRepo.updateSpecificUser(updates);

      userRepo.updateUserDetails(updatedUser);
      return true;
    } catch (e) {
      updateLoading.value = false;
      if (kDebugMode) {
        print('$e');
        CPopupSnackBar.errorSnackBar(
          title: "error updating user currency & location details",
          message: e.toString(),
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          title: "error updating your details",
          message:
              'an unknown error occurred while updating user currency & location details',
        );
      }

      return false;
    }
    // finally {
    //   updateLoading.value = false;
    // }
  }
}
