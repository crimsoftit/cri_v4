import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/features/store/controllers/search_bar_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CExpandedSearchField extends StatelessWidget {
  const CExpandedSearchField({
    super.key,
    required this.txtColor,
    required this.controller,
    this.hintTxt,
  });

  final Color txtColor;
  final String? hintTxt;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    final searchController = Get.put(CSearchBarController());
    final invController = Get.put(CInventoryController());
    final txnsController = Get.put(CTxnsController());

    

    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 6.0, left: 0.0),
            child: TextFormField(
              controller: controller,
              autofocus: true,
              onChanged: (value) {
                invController.searchInventory(value);
                txnsController.searchSales(value);
              },
              onFieldSubmitted: (value) {
                invController.searchInventory(value);
                txnsController.searchSales(value);
              },
              style: TextStyle(
                color: txtColor,
                fontSize: 14.0,
                fontWeight: FontWeight.normal,
              ),
              decoration: InputDecoration(
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(top: 9.0),
                  child: Icon(
                    Iconsax.search_normal,
                    color: CColors.rBrown.withValues(alpha: 0.6),
                    size: CSizes.iconSm,
                  ),
                ),

                // hintText: 'search $hintTxt',
                hintText:
                    hintTxt ?? 'search store (inventory, txns, dates, etc.)',
                hintStyle: TextStyle(
                  color: CColors.rBrown.withValues(alpha: 0.6),
                  //fontSize: 12.0,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
              ),
            ),
          ),
        ),
        Material(
          type: MaterialType.transparency,
          child: InkWell(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(0),
              topRight: Radius.circular(32),
              bottomLeft: Radius.circular(0),
              bottomRight: Radius.circular(32),
            ),
            onTap: () {
              searchController.toggleSearchFieldVisibility();
              invController.fetchUserInventoryItems();
              //txnsController.fetchSoldItems();
              txnsController.fetchTxns();
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.close,
                color: CColors.rBrown.withValues(alpha: 0.6),
                size: CSizes.iconSm,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
