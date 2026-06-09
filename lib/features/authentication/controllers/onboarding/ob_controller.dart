import 'package:cri_v3/features/authentication/screens/login/login.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class OnboardingController extends GetxController {
  static OnboardingController get instance => Get.find();

  // -- variables
  final pageController = PageController();
  final localStorage = GetStorage();
  Rx<int> currentPageIndex = 0.obs;

  // -- update current index on page scroll
  void updatePageIndicator(index) {
    currentPageIndex.value = index;
  }

  // -- jump to the specific page as indicated by selected dot
  void dotNavigationClick(index) {
    currentPageIndex.value = index;
    pageController.jumpTo(index);
  }

  // -- update current index and jump to next page
  void nextPage() {
    if (currentPageIndex.value == 2) {
      localStorage.write('IsFirstTime', false);
      Get.offAll(const LoginScreen());
    } else {
      int nextPage = currentPageIndex.value + 1;
      pageController.jumpToPage(nextPage);
    }
  }

  // -- update current index and jump to last page
  void skipPage() {
    // currentPageIndex.value = 2;
    // pageController.jumpToPage(2);
    localStorage.write('IsFirstTime', false);
    Get.offAll(const LoginScreen());
  }
}
