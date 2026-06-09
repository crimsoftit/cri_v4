import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/features/store/controllers/dashboard_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/formatter.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CCutomLineChart extends StatelessWidget {
  const CCutomLineChart({
    super.key,
    required this.chartHeight,
    required this.chartWidth,
    required this.lineChartData,
  });

  final double? chartHeight, chartWidth;
  final List<FlSpot> lineChartData;

  @override
  Widget build(BuildContext context) {
    return CRoundedContainer(
      borderRadius: 5.0,
      height: chartHeight,
      width: chartWidth,

      child: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.only(
            bottom: 5.0,
            left: 10.0,
            right: 10.0,
            top: 10.0,
          ),
          child: LineChart(
            LineChartData(
              borderData: _buildBorderData(),
              gridData: _buildGridData(),
              lineBarsData: [
                _buildLineChartBarData(),
              ],
              minX: 0.0,
              minY: 0.0,
              titlesData: _buildTitlesData(),
            ),
          ),
        ),
      ),
    );
  }

  /// -- build line chart bar data --
  LineChartBarData _buildLineChartBarData() {
    //final isDarkTheme = CHelperFunctions.isDarkMode(Get.overlayContext!);

    return LineChartBarData(
      barWidth: 1.0,
      color: CNetworkManager.instance.hasConnection.value
          ? CColors.rBrown
          : CColors.darkerGrey,
      isCurved: false,
      spots: lineChartData,
      // spots: lineChartData
      //     .map((spot) => spot.y < 0 ? FlSpot(spot.y, 0) : spot)
      //     .toList(),
      belowBarData: BarAreaData(
        show: true,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            CNetworkManager.instance.hasConnection.value
                ? CColors.rBrown
                : CColors.darkGrey,
            CNetworkManager.instance.hasConnection.value
                ? CColors.rBrown.withAlpha(1)
                : CColors.darkGrey.withAlpha(1),
          ],
        ),
      ),
    );
  }

  /// -- build line chart grid data --
  FlGridData _buildGridData() {
    return FlGridData(
      drawHorizontalLine: true,
      drawVerticalLine: true,
      show: true,
    );
  }

  /// -- build border data --
  FlBorderData _buildBorderData() {
    return FlBorderData(
      // border: Border.all(
      //   color: CColors.rBrown,
      //   width: 1.0,
      // ),
      border: Border(
        top: BorderSide.none,
        right: BorderSide.none,
      ),
      show: true,
    );
  }

  /// -- build titles data --
  FlTitlesData _buildTitlesData() {
    final dashboardController = Get.put(CDashboardController());
    // final isDarkTheme = CHelperFunctions.isDarkMode(Get.overlayContext!);

    return FlTitlesData(
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          getTitlesWidget: (value, meta) {
            return Text(
              value.toInt() > 12 && value.toInt() < 24
                  ? '${(value - 12).toInt()}pm'
                  : (value.toInt() == 12 ||
                        value.toInt() - 12 == 12 ||
                        value.toInt() == 0)
                  ? '${value.toInt()}:00'
                  : '${value.toInt()}am',
              style: TextStyle(
                color: CNetworkManager.instance.hasConnection.value
                    ? CColors.rBrown
                    : CColors.darkerGrey,
              ),
            );
          },
          interval: 3,
          maxIncluded: true,
          minIncluded: true,
          reservedSize: 20.0,
          showTitles: true,
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          getTitlesWidget: (value, meta) {
            return Text(
              CFormatter.kSuffixFormatter(value),
              style: TextStyle(
                color: CColors.rBrown,
              ),
            );
          },
          interval: dashboardController.peakSalesAmount.value / 2,
          maxIncluded: true,
          minIncluded: true,
          reservedSize: 40.0,
          showTitles: true,
        ),
      ),
      rightTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
      show: true,
      topTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
    );
  }
}
