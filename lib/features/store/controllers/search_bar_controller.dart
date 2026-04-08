import 'package:cri_v3/features/store/controllers/cart_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CSearchBarController extends GetxController {
  static CSearchBarController get instance {
    return Get.find();
  }

  /// -- variables --
  final cartController = Get.put(CCartController());

  RxBool showAnimatedTypeAheadField = false.obs;

  RxBool showSearchField = false.obs;

  final txtSearchField = TextEditingController();
  final txtTypeAheadFieldController = TextEditingController();

  @override
  void onInit() {
    showSearchField.value = false;

    showAnimatedTypeAheadField.value = false;
    txtSearchField.text = '';
    super.onInit();
  }

  // onSearchBtnPressed(String searchSpace) {
  //   if (searchSpace == 'inventory') {
  //     invShowSearchField.value = !invShowSearchField.value;
  //   } else if (searchSpace == 'inventory, transactions') {
  //     salesShowSearchField.value = !salesShowSearchField.value;
  //   }
  // }

  toggleSearchFieldVisibility() {
    showSearchField.value = !showSearchField.value;

    if (!showSearchField.value) {
      txtSearchField.text = '';
    }
  }

  onTypeAheadSearchIconTap() {
    showAnimatedTypeAheadField.value = !showAnimatedTypeAheadField.value;
    cartController.itemQtyInCart.value = 0;
  }
}
