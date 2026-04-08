import 'package:cri_v3/data/repos/auth/auth_repo.dart';
import 'package:cri_v3/features/personalization/controllers/location_controller.dart';
import 'package:cri_v3/utils/device/shared_preferences_service.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:get/get.dart';

class CAppSettingsController extends GetxController {
  static CAppSettingsController get instance => Get.find();

  /// -- variables --
  final CLocationController locationController = Get.put<CLocationController>(
    CLocationController(),
  );
  final service = ();
  RxBool dataSyncIsOn = false.obs;

  @override
  void onInit() async {
    //PermissionStatus status = await Permission.camera.status;isGranted;
    await loadSettings();
    super.onInit();
  }

  Future<void> loadSettings() async {
    try {
      final result = await CSharedPreferencesService.dataSyncIsOn();
      dataSyncIsOn.value = result;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'error loading sync settings',
        message: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> toggleSyncSettings(bool value) async {
    try {
      dataSyncIsOn.value = value;
      final result = await CSharedPreferencesService.setAutoSync(
        dataSyncIsOn.value,
      );
      return result;
    } catch (e) {
      CPopupSnackBar.errorSnackBar(
        title: 'error loading sync settings',
        message: e.toString(),
      );
      rethrow;
    }
  }

  Future<void> onContinueButtonPressed() async {
    if (!locationController.updateLoading.value) {
      locationController.updateUserLocationAndCurrencyDetails();
      if (await locationController.updateUserLocationAndCurrencyDetails()) {
        AuthRepo.instance.screenRedirect();
      }
    }
  }
}
