import 'package:cri_v3/common/widgets/search_bar/expanded_search_field.dart';
import 'package:cri_v3/features/store/controllers/dashboard_controller.dart';
import 'package:cri_v3/features/store/controllers/search_bar_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CAnimatedSearchBar extends StatelessWidget {
  const CAnimatedSearchBar({
    super.key,
    required this.hintTxt,

    required this.controller,
    this.boxColor,
    this.customTxtField,
    this.forSearch = true,
    this.useCustomTxtField = false,
  });

  final bool? forSearch;
  final bool? useCustomTxtField;
  final Color? boxColor;
  final String hintTxt;

  final TextEditingController controller;
  final Widget? customTxtField;

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(CDashboardController());
    // final invController = Get.put(CInventoryController());
    // final txnsController = Get.put(CTxnsController());
    final searchController = Get.put(CSearchBarController());

    return Obx(
      () {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width:
              searchController.showSearchField.value ||
                  dashboardController.showSummaryFilterField.value
              ? double.maxFinite
              : forSearch!
              ? 40.0
              : 70.0,
          height: 40.0,
          padding: const EdgeInsets.only(
            right: 0.1,
          ),
          decoration: BoxDecoration(
            borderRadius: searchController.showSearchField.value
                ? BorderRadius.circular(10.0)
                : BorderRadius.circular(20.0),
            color: boxColor,
            //boxShadow: kElevationToShadow[2],
          ),
          child:
              (searchController.showSearchField.value ||
                  dashboardController.showSummaryFilterField.value)
              ? useCustomTxtField!
                    ? customTxtField
                    : searchController.showSearchField.value
                    ? CExpandedSearchField(
                        txtColor: CColors.rBrown,
                        controller: controller,
                      )
                    : DefaultSearchWidget(forSearch: forSearch)
              : DefaultSearchWidget(forSearch: forSearch),
        );
      },
    );
  }
}

class DefaultSearchWidget extends StatelessWidget {
  const DefaultSearchWidget({
    super.key,
    required this.forSearch,
  });

  final bool? forSearch;

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(CDashboardController());
    // final invController = Get.put(CInventoryController());
    // final txnsController = Get.put(CTxnsController());
    final searchController = Get.put(CSearchBarController());

    Future.delayed(
      Duration(milliseconds: 200),
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            dashboardController.showSummaryFilterField.value = false;
            searchController.showSearchField.value = false;
          },
        );
      },
    );

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(0),
          topRight: Radius.circular(32),
          bottomLeft: Radius.circular(0),
          bottomRight: Radius.circular(32),
        ),
        onTap: () {
          switch (forSearch) {
            case true:
              searchController.toggleSearchFieldVisibility();

              break;
            case false:
              dashboardController.toggleDateFieldVisibility();
              break;
            default:
              searchController.toggleSearchFieldVisibility();
              dashboardController.toggleDateFieldVisibility();
              break;
          }
          // invController.fetchUserInventoryItems();
          // txnsController.fetchSoldItems();
        },
        child: forSearch!
            ? const Icon(
                Iconsax.search_normal,
                color: CColors.rBrown,
                size: CSizes.iconMd,
              )
            : const Icon(
                //Iconsax.document_filter,
                // Iconsax.setting_5,
                Iconsax.setting_5,
                color: CColors.rBrown,
                size: CSizes.iconMd,
              ),
      ),
    );
  }
}
