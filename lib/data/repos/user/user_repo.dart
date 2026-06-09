import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cri_v3/data/repos/auth/auth_repo.dart';
import 'package:cri_v3/features/personalization/models/user_model.dart';
import 'package:cri_v3/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:cri_v3/utils/exceptions/format_exceptions.dart';
import 'package:cri_v3/utils/exceptions/platform_exceptions.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CUserRepo extends GetxController {
  static CUserRepo get instance => Get.find();

  final RxBool locationServicesEnabled = false.obs;
  LocationPermission? permission;

  Position? currentPosition;

  final RxString currentAddress = ''.obs;

  final LocationSettings locationSettings = const LocationSettings(
    accuracy: LocationAccuracy.high,
    distanceFilter: 100,
  );

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /* ===== save user data to firestore ===== */
  Future<void> saveUserDetails(CUserModel users) async {
    try {
      await _db.collection("users").doc(users.id).set(users.toJson());
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebaseAuth exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      throw CPopupSnackBar.errorSnackBar(
        title: "firebase exception error",
        message: e.code.toString(),
      );
    } on FormatException catch (e) {
      // CPopupLoader.errorSnackBar(
      //   title: "format exception error",
      //   message: e.message,
      // );
      throw CPopupSnackBar.errorSnackBar(
        title: "format exception error",
        message: e.message,
      );
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.code.toString(),
      );
      throw CPlatformExceptions(e.code).message;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "An error occurred",
        message: e.toString(),
      );
      //throw 'something went wrong! please try again!';

      throw e.toString();
    }
  }

  /* == fetch user details based on user ID == */
  Future<CUserModel> fetchUserDetails() async {
    try {
      final docSnapshot = await _db
          .collection("users")
          .doc(AuthRepo.instance.authUser?.uid)
          .get();
      if (docSnapshot.exists) {
        return CUserModel.fromSnapshot(docSnapshot);
      } else {
        return CUserModel.empty();
      }
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebaseAuth exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebase exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FormatException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.message,
      );
      throw CFormatExceptions(e.message);
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.code.toString(),
      );
      throw CPlatformExceptions(e.code).message;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "An error occurred",
        message: e.toString(),
      );
      //throw 'something went wrong! please try again!';

      throw e.toString();
    }
  }

  /* == check if phone no. already exists == */
  Future<bool> checkIfPhoneNoExists(String phoneNo) async {
    try {
      final QuerySnapshot result = await _db
          .collection('users')
          .where('PhoneNo', isEqualTo: phoneNo)
          .limit(1)
          .get();

      final List<DocumentSnapshot> docs = result.docs;
      return docs.length == 1;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebase exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "An error occurred",
        message: e.toString(),
      );
      //throw 'something went wrong! please try again!';

      throw e.toString();
    }
  }

  /* == update user data in firestore == */
  Future<void> updateUserDetails(CUserModel updatedUser) async {
    try {
      if (AuthRepo.instance.authUser!.uid.isNotEmpty) {
        await _db
            .collection("users")
            .doc(AuthRepo.instance.authUser!.uid)
            .update(updatedUser.toJson());
      } else {
        if (kDebugMode) {
          print('user id not established...');
          CPopupSnackBar.errorSnackBar(
            title: 'invalid user id',
            message: 'user id not established!!!',
          );
        }
      }
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebaseAuth exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebase exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FormatException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.message,
      );
      throw CFormatExceptions(e.message);
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.code.toString(),
      );
      throw CPlatformExceptions(e.code).message;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "error updating user details",
        message: e.toString(),
      );
      //throw 'something went wrong! please try again!';

      throw e.toString();
    }
  }

  /* == update any fields in a Specific user's collection == */
  Future<void> updateSpecificUser(Map<String, dynamic> json) async {
    try {
      await _db
          .collection("users")
          .doc(AuthRepo.instance.authUser?.uid)
          .update(json);
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: "firebaseAuth exception error",
          message: e.code.toString(),
        );
      }
      CPopupSnackBar.errorSnackBar(
        title: "server error!",
        message: 'an error occurred while updating your details!',
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: "firebaseAuth exception error",
          message: e.code.toString(),
        );
      }
      CPopupSnackBar.errorSnackBar(
        title: "server error!",
        message: 'an error occurred while updating your details!',
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FormatException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "format exception error",
        message: e.message,
      );
      throw CFormatExceptions(e.message);
    } on PlatformException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: "platform exception error",
          message: e.code.toString(),
        );
      }
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: 'an unknown platform error occurred!',
      );
      throw CPlatformExceptions(e.code).message;
    } catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: "an error occurred while updating your details!",
          message: e.toString(),
        );
      }
      CPopupSnackBar.errorSnackBar(
        title: "an unknown error occurred!",
        message: 'an error occurred while updating your details!',
      );
      //throw 'something went wrong! please try again!';

      throw e.toString();
    }
  }

  /* == update any fields in a Specific user's collection == */
  Future<void> updateUserCurrency(String curCode) async {
    try {
      await _db.collection("users").doc(AuthRepo.instance.authUser?.uid).update(
        {'CurrencyCode': curCode},
      );
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebaseAuth exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebase exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FormatException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.message,
      );
      throw CFormatExceptions(e.message);
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.code.toString(),
      );
      throw CPlatformExceptions(e.code).message;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "An error occurred",
        message: e.toString(),
      );
      //throw 'something went wrong! please try again!';
      throw e.toString();
    }
  }

  /* == remove user data from firestore == */
  Future<void> deleteUserRecord(String userID) async {
    try {
      await _db.collection("users").doc(userID).delete();
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebaseAuth exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebase exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FormatException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.message,
      );
      throw CFormatExceptions(e.message);
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.code.toString(),
      );
      throw CPlatformExceptions(e.code).message;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "An error occurred",
        message: e.toString(),
      );
      //throw 'something went wrong! please try again!';
      e.toString();
    }
  }

  /* == upload user profile pic (or any image) == */
  Future<String> uploadImage(String imgPath, XFile imgFile) async {
    try {
      final ref = FirebaseStorage.instance.ref(imgPath).child(imgFile.name);
      await ref.putFile(File(imgFile.path));
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebaseAuth exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "firebase exception error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FormatException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.message,
      );
      throw CFormatExceptions(e.message);
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "platform exception error",
        message: e.code.toString(),
      );
      throw CPlatformExceptions(e.code).message;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "An error occurred",
        message: e.toString(),
      );
      throw 'something went wrong! please try again!';
    }
  }
}
