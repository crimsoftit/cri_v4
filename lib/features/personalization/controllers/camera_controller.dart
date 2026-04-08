import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CCameraController extends GetxController {
  static CCameraController get instance => Get.find<CCameraController>();

  /// -- variables -- ///
  final RxBool cameraIsAccessible = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await checkCameraAccessibility();
  }

  /// -- check camera accessibility -- ///
  Future<void> checkCameraAccessibility() async {
    final status = await Permission.camera.status;
    if (status.isGranted) {
      cameraIsAccessible.value = true;
    } else {
      cameraIsAccessible.value = false;
    }
  }

  /// -- request camera permission -- ///
  Future<void> toggleCameraPermission(bool value) async {
    final cameraAccessStatus = await Permission.camera.status;
    if (value) {
      if (cameraAccessStatus.isGranted) {
        return;
      } else {
        final status = await Permission.camera.request();
        switch (status) {
          case PermissionStatus.granted:
            cameraIsAccessible.value = true;
            break;
          default:
            cameraIsAccessible.value = false;
            break;
        }
      }
    } else {
      //await openAppSettings();
      cameraIsAccessible.value = false;
    }
  }

  Future<void> requestCameraPermission(bool value) async {
    PermissionStatus status = await Permission.camera.status;

    if (value) {
      if (status.isDenied) {
        status = await Permission.camera.request();
        cameraIsAccessible.value = false;
      }
      if (status.isGranted) {
        // Camera access is now available
        cameraIsAccessible.value = true;
      } else {
        cameraIsAccessible.value = false;
      }
      // else if (status.isPermanentlyDenied) {
      //   cameraIsAccessible.value = false;
      //   // you could as well show a dialog prompting the user to enable permission in settings
      // }
    } else {
      // If the user is revoking permission, we can't directly do that.
      // We can only guide them to app settings.
      //await openAppSettings();
      cameraIsAccessible.value = false;
      await Permission.camera.request();
    }
  }
}
