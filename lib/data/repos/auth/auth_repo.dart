import 'package:cri_v3/api/sheets/store_sheets_api.dart';
import 'package:cri_v3/data/repos/user/user_repo.dart';
import 'package:cri_v3/features/authentication/controllers/signup/signup_controller.dart';
import 'package:cri_v3/features/authentication/screens/login/login.dart';
import 'package:cri_v3/features/authentication/screens/onboarding/onboarding_screen.dart';
import 'package:cri_v3/features/authentication/screens/signup/verify_email.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/personalization/screens/profile/widgets/update_business_name.dart';
import 'package:cri_v3/features/personalization/screens/settings/app_settings_screen.dart';
import 'package:cri_v3/features/store/controllers/cart_controller.dart';
import 'package:cri_v3/features/store/controllers/checkout_controller.dart';
import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/features/store/controllers/nav_menu_controller.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/nav_menu.dart';
import 'package:cri_v3/utils/exceptions/firebase_auth_exceptions.dart';
import 'package:cri_v3/utils/exceptions/firebase_exceptions.dart';
import 'package:cri_v3/utils/exceptions/format_exceptions.dart';
import 'package:cri_v3/utils/exceptions/platform_exceptions.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:cri_v3/utils/local_storage/storage_utility.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthRepo extends GetxController {
  static AuthRepo get instance => Get.find();

  // -- variables --
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  final signupController = Get.put(SignupController());

  // -- get authenticated user data --
  User? get authUser => _auth.currentUser;

  // -- get IsAuthenticated User --
  bool get isAuthenticated => _auth.currentUser != null;

  // -- called from main.dart on app launch --
  @override
  void onReady() {
    // set persistence of authentication data to work offline --
    //_auth.setPersistence(Persistence.LOCAL); // -- only for web apps --

    // remove the native splash screen
    FlutterNativeSplash.remove();

    // redirect to the relevant screen
    screenRedirect();
  }

  // -- function to load the relevant screen
  void screenRedirect() async {
    final user = _auth.currentUser;

    final userController = Get.put(CUserController());

    if (user != null) {
      if (user.emailVerified) {
        // initialize user-specific local storage
        await CLocalStorage.init(user.uid);

        var userRepo = Get.put(CUserRepo());
        userController.fetchUserDetails();
        var userDets = await userRepo.fetchUserDetails();

        if (userDets.currencyCode == '' ||
            userDets.locationCoordinates == '' ||
            userDets.userAddress == '') {
          Get.offAll(() => const CAppSettingsScreen());
        } else if (userDets.businessName == '') {
          Get.offAll(
            () => const CUpdateBusinessNameScreen(autoImplyLeading: false),
          );
        } else {
          /// -- initialize spreadsheets --
          if (await CNetworkManager.instance.isConnected() ||
              CNetworkManager.instance.hasConnection.value) {
            await StoreSheetsApi.initSpreadSheets();
          }

          final invController = Get.put(CInventoryController());
          final txnsController = Get.put(CTxnsController());
          // check data sync status
          deviceStorage.writeIfNull('SyncInvDataWithCloud', true);
          deviceStorage.writeIfNull('SyncTxnsDataWithCloud', true);

          if (await userController.fetchUserDetails()) {
            await invController.initInvSync();
            await invController.fetchUserInventoryItems();

            await txnsController.initTxnsSync();
            await txnsController.fetchSoldItems();
            Get.put(CCheckoutController());

            final navController = Get.put(CNavMenuController());
            navController.selectedIndex.value =
                (invController.inventoryItems.isEmpty &&
                    txnsController.sales.isEmpty)
                ? 0
                : 1;
            Future.delayed(
              Duration.zero,
              () {
                WidgetsBinding.instance.addPostFrameCallback(
                  (_) {
                    Get.offAll(() => const NavMenu());
                  },
                );
              },
            );
            //Get.offAll(() => const NavMenu());
          } else {
            if (kDebugMode) {
              print('error fetching user details!!');
              CPopupSnackBar.errorSnackBar(
                title: 'error fetching user details!!',
              );
            }
          }
        }
      } else {
        Get.offAll(() => VerifyEmailScreen(email: _auth.currentUser?.email));
      }
    } else {
      // local storage
      deviceStorage.writeIfNull('IsFirstTime', true);

      // check if it's the first time launching the app
      deviceStorage.read('IsFirstTime') != true
          ? Get.offAll(() => const LoginScreen())
          : Get.offAll(() => const OnboardingScreen());
    }
  }

  /* ==== email & password sign-in, registration ===== */

  // -- [EmailAuthentication] - signIn --
  Future<UserCredential> logInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: "login error!",
          message: e.code.toString(),
        );
      }

      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: "login error",
          message: e.code.toString(),
        );
      }

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
      if (kDebugMode) {
        CPopupSnackBar.errorSnackBar(
          title: "a login error occurred",
          message: e.toString(),
        );
      }
      throw e.toString();
    }
  }

  // -- [EmailAuthentication] - register --
  Future<UserCredential> signupWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "signup error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "authentication error",
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
      throw e.toString();
    }
  }

  // -- [EmailAuthentication] -- MAIL VERIFICATION
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "authentication error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "authentication error",
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
      throw e.toString();
    }
  }

  /// -- [ReAuthenticate] - re-authenticate user --
  Future<void> reAuthWithEmailAndPassword(String email, String password) async {
    try {
      // create a credential
      AuthCredential credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      // re-authenticate
      await _auth.currentUser!.reauthenticateWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(title: e.code, message: e.message);
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(title: e.code, message: e.message);
      throw CFirebaseExceptions(e.code).message;
    } on FormatException catch (e) {
      CPopupSnackBar.errorSnackBar(title: 'Format ERROR!', message: e.message);
      throw CFormatExceptions(e.message);
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'Platform exception!',
        message: e.message,
      );
      throw CPlatformExceptions(e.code).message;
    } catch (e) {
      throw CPopupSnackBar.errorSnackBar(
        title: 'Oh Snap!',
        message: 'an unknown error occurred! please try again later',
      );
    }
  }

  /// -- [EmailVerification] - forgot password --
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "authentication error",
        message: e.code.toString(),
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: "authentication error",
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
      throw e.toString();
    }
  }

  /* ===== federated identity & social media sign-in ===== */

  /// -- [GoogleAuthentication] - GOOGLE --
  // Future<UserCredential> loginInWithGoogle() async {
  //   try {
  //     final GoogleSignIn googleSignIn = GoogleSignIn.instance;
  //     // trigger the authentication flow
  //     final GoogleSignInAccount? googleUser = await googleSignIn.s

  //     // obtain the auth details from the request
  //     final GoogleSignInAuthentication? googleAuth =
  //         await googleUser?.authentication;

  //     // create a new credential
  //     final credential = GoogleAuthProvider.credential(
  //       accessToken: googleAuth?.accessToken,
  //       idToken: googleAuth?.idToken,
  //     );

  //     // once signed in, return the UserCredential Object(class)
  //     return await FirebaseAuth.instance.signInWithCredential(credential);
  //   } on FirebaseAuthException catch (e) {
  //     final exception = CExceptions.fromCode(e.code);
  //     CPopupSnackBar.customToast(
  //       message: 'AUTHENTICATION ERROR!',
  //       forInternetConnectivityStatus: false,
  //     );
  //     throw exception.message;
  //   } catch (_) {
  //     const exception = CExceptions();
  //     CPopupSnackBar.customToast(
  //       message: 'AUTH ERROR!',
  //       forInternetConnectivityStatus: false,
  //     );
  //     throw exception.message;
  //   }
  // }

  /// -- [FacebookAuthentication] - FACEBOOK --

  /* ===== ./end federated identity & social media sign-in ===== */
  /// -- [LogoutUser] - valid for any authentication --
  Future<void> logout() async {
    try {
      // -- reset cloud sync keys --
      deviceStorage.write('SyncInvDataWithCloud', true);

      deviceStorage.write('SyncTxnsDataWithCloud', true);

      final cartController = Get.put(CCartController());

      cartController.clearCart();
      await GoogleSignIn.instance.signOut();
      await _auth.signOut();

      Get.offAll(() => const LoginScreen());
    } on FirebaseAuthException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'logout error',
        message: CFirebaseAuthExceptions(e.code).message,
      );
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'logout error',
        message: CFirebaseExceptions(e.code).message,
      );
      throw CFirebaseExceptions(e.code).message;
    } on FormatException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'logout format exception error',
        message: CFormatExceptions(e.message),
      );
      throw CFormatExceptions(e.message);
    } on PlatformException catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'logout platform exception error',
        message: CPlatformExceptions(e.code).message,
      );
      throw CPlatformExceptions(e.code).message;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'unknown error!',
        message: e.toString(),
      );
      //throw 'something went wrong! please try again!';

      throw e.toString();
    }
  }

  /// -- remove user Auth & Firestore account --
  Future<void> deleteAccount() async {
    try {
      await CUserRepo.instance.deleteUserRecord(_auth.currentUser!.uid);
      await _auth.currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      throw CFirebaseAuthExceptions(e.code).message;
    } on FirebaseException catch (e) {
      throw CFirebaseExceptions(e.code).message;
    } on FormatException catch (e) {
      throw CFormatExceptions(e.message);
    } on PlatformException catch (e) {
      throw CPlatformExceptions(e.code).message;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'unknown error!',
        message: e.toString(),
      );
      //throw 'something went wrong! please try again!';

      throw e.toString();
    }
  }
}
