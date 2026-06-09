import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/common/widgets/loaders/animated_loader.dart';
import 'package:cri_v3/features/store/controllers/dashboard_controller.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CCustomMonthlySalesBarGraph extends StatelessWidget {
  const CCustomMonthlySalesBarGraph({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(CDashboardController());
    final isConnectedToInternet = CNetworkManager.instance.hasConnection.value;
    //final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final txnsController = Get.put(CTxnsController());

    return Column(
      children: [
        Obx(
          () {
            /// -- empty data widget --
            final noDataWidget = CAnimatedLoaderWidget(
              animation: CImages.noDataLottie,
              lottieAssetWidth: 110.0,
              showActionBtn: false,
              text:
                  'no sales for the period: ${dashboardController.selectedSalesFilterPeriod.value}'
                      .toUpperCase(),
              txtColor: CColors.rBrown,
            );

            if (dashboardController.selectedSalesFilterPeriod.value !=
                    'this week' &&
                !txnsController.salesExistForAnnualPeriod(
                  dashboardController.setDefaultSalesFilterPeriod(),
                )) {
              return CRoundedContainer(
                borderRadius: CSizes.cardRadiusSm / 2,
                child: noDataWidget,
              );
            }
            return CRoundedContainer(
              bgColor: CColors.white,
              borderRadius: CSizes.cardRadiusSm / 2,
              boxShadow: [
                BoxShadow(
                  blurRadius: 3.0,
                  color: CColors.grey.withValues(
                    alpha: .1,
                  ),
                  offset: const Offset(0.0, 3.0),
                  spreadRadius: 5.0,
                ),
              ],

              padding: const EdgeInsets.only(
                top: 5.0,
              ),
              width: CHelperFunctions.screenWidth(),
              child: Column(
                children: [
                  SizedBox(
                    height: 30.0,
                  ),
                  SizedBox(
                    height: 150.0,
                    child: BarChart(
                      BarChartData(
                        barGroups: dashboardController
                            .generateMonthlySalesWithoutMonths(
                              int.parse(
                                dashboardController
                                    .setDefaultSalesFilterPeriod(),
                              ),
                            )
                            .asMap()
                            .entries
                            .map(
                              (entry) {
                                return BarChartGroupData(
                                  x: entry.key,
                                  barRods: [
                                    BarChartRodData(
                                      borderRadius: BorderRadius.circular(
                                        CSizes.sm / 4,
                                      ),
                                      color: isConnectedToInternet
                                          ? CColors.rBrown
                                          : CColors.darkerGrey,
                                      toY: entry.value.totalSales,
                                      width: 15.0,
                                    ),
                                  ],
                                );
                              },
                            )
                            .toList(),
                        barTouchData: BarTouchData(
                          touchCallback:
                              (
                                barTouchEvent,
                                barTouchResponse,
                              ) {},
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (group) {
                              return CColors.secondary;
                            },
                          ),
                        ),
                        borderData: FlBorderData(
                          border: const Border(
                            right: BorderSide.none,
                            top: BorderSide.none,
                          ),

                          show: true,
                        ),
                        gridData: dashboardController.buildFlBarChartGridData(),
                        groupsSpace: CSizes.spaceBtnItems,
                        titlesData: dashboardController
                            .buildFlBarChartTitlesData(
                              true,
                            ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
