import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/features/store/controllers/dashboard_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WeeklySalesBarGraphWidget extends StatelessWidget {
  const WeeklySalesBarGraphWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(CDashboardController());
    final isConnectedToInternet = CNetworkManager.instance.hasConnection.value;
    return Column(
      children: [
        Obx(
          () {
            /// -- compare last week's total sales to this week's --

            dashboardController.weeklyPercentageChange.value =
                ((dashboardController.currentWeekSalesAmount.value -
                        dashboardController.lastWeekSalesAmount.value) /
                    dashboardController.lastWeekSalesAmount.value) *
                100;
            return CRoundedContainer(
              bgColor: CColors.white,
              borderRadius: CSizes.cardRadiusSm / 2,
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
                    //width: CHelperFunctions.screenWidth() * .5,
                    height: 150.0,
                    child: BarChart(
                      BarChartData(
                        titlesData: dashboardController
                            .buildFlBarChartTitlesData(false),
                        borderData: FlBorderData(
                          show: true,
                          border: const Border(
                            top: BorderSide.none,
                            right: BorderSide.none,
                          ),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawHorizontalLine: true,
                          drawVerticalLine: true,
                          horizontalInterval:
                              dashboardController
                                  .weeklySalesHighestAmount
                                  .value /
                              4,
                          verticalInterval:
                              dashboardController
                                  .weeklySalesHighestAmount
                                  .value /
                              4,
                        ),
                        barGroups: dashboardController.thisWeekSalesList
                            .asMap()
                            .entries
                            .map(
                              (entry) => BarChartGroupData(
                                x: entry.key,
                                barRods: [
                                  BarChartRodData(
                                    width: 17.0,
                                    toY: entry.value,
                                    color: isConnectedToInternet
                                        ? CColors.rBrown
                                        : CColors.darkerGrey,
                                    borderRadius: BorderRadius.circular(
                                      CSizes.sm / 4,
                                    ),
                                  ),
                                ],
                              ),
                            )
                            .toList(),
                        groupsSpace: CSizes.spaceBtnItems / 2,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            getTooltipColor: (group) {
                              return CColors.secondary;
                            },
                          ),
                          touchCallback:
                              (
                                barTouchEvent,
                                barTouchResponse,
                              ) {},
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
