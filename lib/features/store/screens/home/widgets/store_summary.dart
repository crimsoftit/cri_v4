import 'package:carousel_slider/carousel_slider.dart';
import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/store/controllers/dashboard_controller.dart';
import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/features/store/screens/home/widgets/store_summary_card.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/formatter.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CStoreSummary extends StatelessWidget {
  const CStoreSummary({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(CDashboardController());
    //final dateRangeController = Get.put(CDateRangeController());
    final invController = Get.put(CInventoryController());
    final txnsController = Get.put(CTxnsController());
    final userController = Get.put(CUserController());
    final userCurrency = CHelperFunctions.formatCurrency(
      userController.user.value.currencyCode,
    );
    return CRoundedContainer(
      bgColor: CColors.transparent,
      height: 78.01,
      width: CHelperFunctions.screenWidth(),
      child: Obx(
        () {
          return CarouselSlider(
            items: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //mainAxisSize: MainAxisSize.min,
                children: [
                  CStoreSummaryCard(
                    iconData: Iconsax.money_recive,
                    // subTitleTxt: 'money collected($userCurrency)',
                    subTitleTxt: 'money collected',
                    titleTxt: txnsController.moneyCollected.value
                        .toStringAsFixed(1),
                  ),
                  CStoreSummaryCard(
                    iconData: Iconsax.money_send,
                    subTitleTxt: 'cost of sales($userCurrency)',
                    // titleTxt:
                    //     '$userCurrency.${CFormatter.kSuffixFormatter(txnsController.costOfSales.value..toStringAsFixed(1))}',
                    titleTxt: txnsController.costOfSales.value.toStringAsFixed(
                      2,
                    ),
                  ),
                  CStoreSummaryCard(
                    iconData: Iconsax.money_tick,
                    subTitleTxt: 'g. profit($userCurrency)',
                    titleTxt: txnsController.totalProfit.value.toStringAsFixed(
                      1,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //mainAxisSize: MainAxisSize.min,
                children: [
                  CStoreSummaryCard(
                    iconData: Iconsax.money_send,
                    subTitleTxt: 'inventory value',
                    titleTxt:
                        '$userCurrency.${CFormatter.kSuffixFormatter(invController.totalInventoryValue.value..toStringAsFixed(2))}',
                    // titleTxt:
                    //     '$userCurrency.${invController.totalInventoryValue.value..toStringAsFixed(1)}',
                  ),
                  CStoreSummaryCard(
                    //iconColor: Colors.redAccent,
                    iconData: Iconsax.money_time,
                    subTitleTxt: 'gross revenue($userCurrency)',
                    //subTitleTxtColor: CColors.warning,
                    titleTxt:
                        '${txnsController.grossRevenue.value..toStringAsFixed(2)}',
                  ),
                  CStoreSummaryCard(
                    iconData: Iconsax.money_time,
                    subTitleTxt: 'credit($userCurrency)',
                    // titleTxt:
                    //     '$userCurrency.${CFormatter.kSuffixFormatter(txnsController.invoicesValue.value..toStringAsFixed(1))}',
                    titleTxt:
                        '${txnsController.invoicesValue.value..toStringAsFixed(2)}',
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CStoreSummaryCard(
                    // cardBgColor: invController.lowStockItemsCount.value > 0
                    //     ? CColors.warning.withValues(
                    //         alpha: .1,
                    //       )
                    //     : CColors.white,
                    iconColor: invController.lowStockItemsCount.value > 0
                        ? CColors.warning
                        : Colors.green,
                    iconData: invController.lowStockItemsCount.value > 0
                        ? Iconsax.warning_2
                        : Iconsax.tick_circle,
                    subTitleTxt:
                        'low-stock items(${invController.lowStockItemsCount.value})',
                    subTitleTxtColor: invController.lowStockItemsCount.value > 0
                        ? CColors.warning
                        : Colors.green,
                    titleTxt: invController.lowStockItemsValue.value
                        .toStringAsFixed(1),
                    titleTxtColor: invController.lowStockItemsCount.value > 0
                        ? CColors.warning
                        : Colors.green,
                    // titleTxt:
                    //     '$userCurrency.${invController.totalInventoryValue.value..toStringAsFixed(1)}',
                  ),

                  CStoreSummaryCard(
                    iconColor: invController.expiredItemsValue.value == 0
                        ? Colors.green
                        : CColors.error,
                    iconData: invController.expiredItemsValue.value == 0
                        ? Iconsax.tick_circle
                        : Iconsax.danger,
                    iconSize: invController.expiredItemsValue.value == 0
                        ? CSizes.iconSm
                        : CSizes.iconLg,
                    subTitleTxt: 'expired items',
                    subTitleTxtColor: invController.expiredItemsValue.value == 0
                        ? Colors.green
                        : CColors.error,
                    titleTxt:
                        '$userCurrency.${CFormatter.kSuffixFormatter(invController.expiredItemsValue.value..toStringAsFixed(1))}',
                    titleTxtColor: invController.expiredItemsValue.value == 0
                        ? Colors.green
                        : CColors.error,
                  ),
                  CStoreSummaryCard(
                    //iconColor: Colors.redAccent,
                    iconData: Iconsax.user_add,
                    subTitleTxt: 'new customers',

                    titleTxt: '0',
                  ),
                ],
              ),
            ],
            options: CarouselOptions(
              aspectRatio: 16 / 9,
              //autoPlay: dateRangeController.selectedDateRange.value == null && txnsController.dateRangeFieldController.text == '',
              autoPlay: !dashboardController.showSummaryFilterField.value,
              autoPlayAnimationDuration: const Duration(
                milliseconds: 300,
              ),
              autoPlayInterval: Duration(
                seconds: 5,
              ),
              enableInfiniteScroll: true,
              enlargeCenterPage: true,
              height: 90.001,

              viewportFraction: 1.0,
            ),
          );
        },
      ),
    );
  }
}
