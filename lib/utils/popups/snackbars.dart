import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CPopupSnackBar extends GetxController {
  static hideSnackBar() {
    ScaffoldMessenger.of(Get.context!).hideCurrentSnackBar();
  }

  RxBool forInternetConnectivityStatus = false.obs;
  IconData? iconData;

  static customToast({
    required message,
    required forInternetConnectivityStatus,
  }) async {
    final isDarkTheme = CHelperFunctions.isDarkMode(Get.context!);
    // -- check internet connectivity
    //final isConnected = await CNetworkManager.instance.isConnected();

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        elevation: 0,
        duration: const Duration(seconds: 4),
        backgroundColor: Colors.transparent,
        content: CRoundedContainer(
          bgColor: isDarkTheme
              ? CColors.darkGrey.withValues(alpha: 0.9)
              : CColors.grey.withValues(alpha: 0.9),
          borderRadius: 20.0,
          padding: const EdgeInsets.all(10.0),

          margin: const EdgeInsets.symmetric(horizontal: 20.0),

          child: Center(
            child: forInternetConnectivityStatus
                ? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.wifi_off,
                          color: isDarkTheme ? CColors.white : CColors.rBrown,
                          size: CSizes.iconSm,
                        ),
                      ),
                      // SizedBox(
                      //   width: CSizes.spaceBtnInputFields / 4,
                      // ),
                      Expanded(
                        flex: 7,
                        child: Text(
                          message,
                          style:
                              Theme.of(
                                Get.context!,
                              ).textTheme.labelLarge!.apply(
                                color: isDarkTheme
                                    ? CColors.white
                                    : CColors.rBrown,
                              ),
                        ),
                      ),
                    ],
                  )
                : Text(
                    message,
                    // style: Theme.of(Get.context!).textTheme.labelLarge!.apply(
                    //       color: CColors.black,
                    //     ),
                    style: Theme.of(
                      Get.context!,
                    ).textTheme.labelLarge!.apply(color: CColors.rBrown),
                  ),
          ),
        ),
      ),
    );
  }

  static successSnackBar({required title, message = '', duration = 5}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: CColors.white,
      backgroundColor: Colors.green,
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(10.0),
      icon: const Icon(Iconsax.check, color: CColors.white),
    );
  }

  static successSnackBar1({required title, message = '', duration = 5}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: CColors.white,
      backgroundColor: const Color.fromARGB(255, 235, 108, 108),
      snackPosition: SnackPosition.BOTTOM,
      duration: Duration(seconds: duration),
      margin: const EdgeInsets.all(10.0),
      icon: const Icon(Iconsax.check, color: CColors.white),
    );
  }

  static warningSnackBar({required title, message = ''}) {
    Get.snackbar(
      title,
      titleText: Text(
        title,
        style: Theme.of(
          Get.context!,
        ).textTheme.titleMedium!.apply(color: CColors.white),
      ),
      message,
      messageText: Text(
        message,
        style: Theme.of(
          Get.context!,
        ).textTheme.bodyMedium!.apply(color: CColors.white),
      ),
      isDismissible: true,
      shouldIconPulse: true,
      colorText: CColors.white,
      backgroundColor: Colors.orange,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 10),
      margin: const EdgeInsets.all(20.0),
      icon: const Icon(
        Iconsax.warning_2,
        color: CColors.white,
      ),
    );
  }

  static errorSnackBar({required title, message = ''}) {
    Get.snackbar(
      title,
      message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: CColors.white,
      backgroundColor: Colors.red.shade600,
      snackPosition: SnackPosition.BOTTOM,
      duration: const Duration(seconds: 4),
      margin: const EdgeInsets.all(20.0),
      icon: const Icon(Iconsax.warning_2, color: CColors.white),
    );
  }
}
