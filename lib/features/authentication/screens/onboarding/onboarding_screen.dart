import 'package:cri_v3/features/authentication/controllers/onboarding/ob_controller.dart';
import 'package:cri_v3/features/authentication/screens/onboarding/widgets/ob_dot_nav_widget.dart';
import 'package:cri_v3/features/authentication/screens/onboarding/widgets/ob_next_btn_widget.dart';
import 'package:cri_v3/features/authentication/screens/onboarding/widgets/ob_screen_widget.dart';
import 'package:cri_v3/features/authentication/screens/onboarding/widgets/ob_skip_btn_widget.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/constants/txt_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final obController = Get.put(OnboardingController());

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          // -- horizontal scrollable pages
          PageView(
            controller: obController.pageController,
            onPageChanged: obController.updatePageIndicator,
            children: const [
              OnboardingScreenWidget(
                img: CImages.rOnboardingImg1,
                title: CTexts.rOnbaordingTitle1,
                subTitle: CTexts.rOnbaordingSubTitle1,
              ),
              OnboardingScreenWidget(
                img: CImages.rOnboardingImg2,
                title: CTexts.rOnbaordingTitle2,
                subTitle: CTexts.rOnbaordingSubTitle2,
              ),
              OnboardingScreenWidget(
                img: CImages.rOnboardingImg3,
                title: CTexts.rOnbaordingTitle3,
                subTitle: CTexts.rOnbaordingSubTitle3,
              ),
            ],
          ),

          // -- skip button
          const OnboardingSkipBtnWidget(),

          // -- dot navigation SmoothPageIndicator
          const OnboardingDotNavWidget(),

          // -- circular button
          const OnboardingNextBtnWidget(),
        ],
      ),
    );
  }
}
