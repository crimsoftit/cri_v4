import 'package:cri_v3/common/styles/spacing_styles.dart';
import 'package:cri_v3/common/widgets/appbar/v2_app_bar.dart';
import 'package:cri_v3/common/widgets/switches/custom_switch.dart';
import 'package:cri_v3/features/personalization/controllers/app_settings_controller.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/store/controllers/sync_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CTxnSuccessScreen extends StatelessWidget {
  const CTxnSuccessScreen({
    super.key,
    required this.lottieImage,
    required this.title,
    required this.subTitle,
    this.onGenerateRecieptBtnPressed,
    required this.onContinueBtnPressed,
  });

  final String lottieImage, title, subTitle;
  final VoidCallback? onGenerateRecieptBtnPressed;
  final VoidCallback onContinueBtnPressed;

  @override
  Widget build(BuildContext context) {
    final appSettingsController = Get.put(CAppSettingsController());
    final syncController = Get.put(CSyncController());
    final userController = Get.put(CUserController());

    return Obx(() {
      return Scaffold(
        appBar: CVersion2AppBar(autoImplyLeading: false),
        body: SingleChildScrollView(
          child: Padding(
            padding: CSpacingStyle.paddingWithAppBarHeight * 2,
            child: Column(
              children: [
                // -- header image --
                Lottie.asset(
                  // CImages.paymentSuccessfulAnimation,
                  lottieImage,
                  width: MediaQuery.of(context).size.width * 0.8,
                ),

                const SizedBox(height: CSizes.spaceBtnSections),

                // -- title & subtitle --
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: CSizes.spaceBtnItems),
                Obx(
                  () => Text(
                    userController.user.value.email,
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium!.apply(color: CColors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: CSizes.spaceBtnItems),
                Text(
                  subTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium!.apply(color: CColors.darkGrey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: CSizes.spaceBtnSections),

                // -- continue button --
                Container(
                  alignment: Alignment.center,
                  height: 60.0,
                  width: CHelperFunctions.screenWidth(),
                  child: AnimatedContainer(
                    curve: Curves.easeIn,
                    duration: const Duration(milliseconds: 3000),
                    //height: 60.0,
                    width: syncController.processingSync.value
                        ? 60.0
                        : CHelperFunctions.screenWidth() * 0.8,
                    child: syncController.processingSync.value
                        ? buildLoadingBtn()
                        : SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: onContinueBtnPressed,
                              child: FittedBox(
                                child: Text(
                                  syncController.processingSync.value
                                      ? 'syncing...'
                                      : 'CONTINUE',
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.apply(color: CColors.white),
                                ),
                              ),
                            ),
                          ),
                  ),
                  // child: syncController.processingSync.value
                  //     ? buildLoadingBtn()
                  //     : SizedBox(
                  //         width: double.infinity,
                  //         child: ElevatedButton(
                  //           onPressed: onContinueBtnPressed,
                  //           child: Text(
                  //             'CONTINUE',
                  //             style: Theme.of(context)
                  //                 .textTheme
                  //                 .labelMedium
                  //                 ?.apply(
                  //                   color: CColors.white,
                  //                 ),
                  //           ),
                  //         ),
                  //       ),
                ),
                syncController.processingSync.value
                    ? const SizedBox.shrink()
                    : Align(
                        alignment: Alignment.bottomRight,
                        child: Obx(
                          () {
                            return CCustomSwitch(
                              label: 'auto-sync data',
                              onValueChanged: (syncValue) {
                                appSettingsController.toggleSyncSettings(
                                  syncValue,
                                );
                              },
                              switchValue:
                                  appSettingsController.dataSyncIsOn.value,
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget buildLoadingBtn() {
    return Container(
      width: 60.0,
      height: 60.0,
      decoration: BoxDecoration(color: CColors.rBrown, shape: BoxShape.circle),
      child: Center(child: CircularProgressIndicator(color: CColors.white)),
    );
  }
}
