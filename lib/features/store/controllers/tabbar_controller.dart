import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:get/get.dart';

class CTabBarController extends GetxController {
  static CTabBarController get instance {
    return Get.find();
  }

  @override
  void onInit() {
    currentStoreScreenTab.value = 0;
    super.onInit();
  }

  /// -- variables --
  final RxInt currentStoreScreenTab = 0.obs;

  onTabItemTap(int currentTab) {
    currentStoreScreenTab.value = currentTab;
    CPopupSnackBar.customToast(
      message: '${currentStoreScreenTab.value}',
      forInternetConnectivityStatus: false,
    );
  }
}
