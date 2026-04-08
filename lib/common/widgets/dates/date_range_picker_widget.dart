import 'package:cri_v3/features/store/controllers/dashboard_controller.dart';
import 'package:cri_v3/features/store/controllers/date_controller.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CDateRangePickerWidget extends StatelessWidget {
  const CDateRangePickerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(CDashboardController());
    final CDateController controller = Get.put(CDateController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final txnsController = Get.put(CTxnsController());

    return SizedBox(
      //borderRadius: CSizes.borderRadiusLg,
      height: 48.0,
      width: CHelperFunctions.screenWidth() * .9,

      child: TextFormField(
        controller: txnsController.dateRangeFieldController,
        decoration: InputDecoration(
          //border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17.0),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(17.0),
            borderSide: BorderSide.none,
          ),
          filled: true,

          fillColor: isDarkTheme
              ? CColors.rBrown.withValues(alpha: .3)
              : CColors.lightGrey,

          hintText: 'pick date range',
          prefixIcon: Icon(
            Iconsax.calendar,
            color: CColors.darkGrey,
            size: CSizes.iconSm + 4,
          ),
          suffixIcon: IconButton(
            icon: Icon(
              Icons.close,
              color: CColors.darkGrey,
              size: CSizes.iconSm,
            ),
            onPressed: () {
              txnsController.dateRangeFieldController.text = '';
              dashboardController.toggleDateFieldVisibility();
            },
          ),
        ),
        onTap: () {
          controller.pickDateRange(context);
        },
      ),
    );
  }
}
