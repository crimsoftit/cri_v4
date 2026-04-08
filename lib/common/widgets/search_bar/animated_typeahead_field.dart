import 'package:cri_v3/features/store/controllers/search_bar_controller.dart';
import 'package:cri_v3/features/store/screens/search/widgets/c_typeahead_field.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CAnimatedTypeaheadField extends StatelessWidget {
  const CAnimatedTypeaheadField({
    super.key,
    this.boxColor,
    required this.searchBarWidth,
  });

  final Color? boxColor;
  final double searchBarWidth;

  @override
  Widget build(BuildContext context) {
    final searchBarController = Get.put(CSearchBarController());
    //final invController = Get.put(CInventoryController());

    //final screenWidth = CHelperFunctions.screenWidth();

    return Obx(() {
      return AnimatedContainer(
        padding: const EdgeInsets.only(right: 0.0),
        duration: const Duration(milliseconds: 200),
        width: searchBarWidth,
        // width: searchBarController.showAnimatedTypeAheadField.value
        //     ? screenWidth
        //     : 30.0,
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: searchBarController.showAnimatedTypeAheadField.value
              ? BorderRadius.circular(10.0)
              : BorderRadius.circular(20.0),
          color: boxColor,
          //boxShadow: kElevationToShadow[2],
        ),
        child: searchBarController.showAnimatedTypeAheadField.value
            ? SizedBox(
                child: const CTypeAheadSearchField(),
                // CRoundedContainer(
                //   //bgColor: Colors.green,
                //   borderRadius: 10.0,
                //   height: 40.0,
                //   padding: const EdgeInsets.all(0),
                //   showBorder: false,
                //   // width: screenWidth * .98,
                //   width: screenWidth,
                //   child: const CTypeAheadSearchField(),
                // ),
              )
            : Material(
                type: MaterialType.transparency,
                child: InkWell(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(0),
                    topRight: Radius.circular(32),
                    bottomLeft: Radius.circular(0),
                    bottomRight: Radius.circular(32),
                  ),
                  onTap: () {
                    searchBarController.onTypeAheadSearchIconTap();
                    //invController.fetchUserInventoryItems();
                  },
                  child: const Icon(
                    Iconsax.search_normal,
                    color: CColors.rBrown,
                    size: CSizes.iconMd,
                  ),
                ),
              ),
      );
    });
  }
}
