import 'dart:math';

import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/features/store/models/monthly_sales_model.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/formatter.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:clock/clock.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:in_date_utils/in_date_utils.dart';

class CDashboardController extends GetxController {
  static CDashboardController get instance => Get.find();

  /// -- variables --
  final carouselSliderIndex = 0.obs;

  final invController = Get.put(CInventoryController());

  final RxBool isLoading = false.obs;

  final RxBool showSummaryFilterField = false.obs;
  final RxDouble currentWeekSalesAmount = 0.0.obs;
  final RxDouble lastWeekSalesAmount = 0.0.obs;

  final RxDouble salesPastMidnightTo3 = 0.0.obs;
  final RxDouble salesBtnMidnightTo3 = 0.0.obs;
  final RxDouble salesBtn3to6 = 0.0.obs;
  final RxDouble salesBtn6to9 = 0.0.obs;
  final RxDouble salesBtn9to12 = 0.0.obs;
  final RxDouble salesBtn12to15 = 0.0.obs;
  final RxDouble salesBtn15to18 = 0.0.obs;
  final RxDouble salesBtn18to21 = 0.0.obs;
  final RxDouble salesBtn21toMidnight = 0.0.obs;

  final RxDouble peakSalesAmount = 0.0.obs;

  final RxDouble monthlySalesHighestAmount = 0.0.obs;
  final RxDouble weeklyPercentageChange = 0.0.obs;
  final RxDouble weeklySalesHighestAmount = 0.0.obs;

  final RxList<CMonthlySalesModel> monthlySalesList =
      <CMonthlySalesModel>[].obs;
  final RxList<DateTime> salesDatesOnly = <DateTime>[].obs;
  final RxList<double> thisWeekSalesList = <double>[].obs;

  final RxList<String> salesFilters = <String>[].obs;

  final RxList<String> monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ].obs;

  final RxMap<int, double> monthlyTotals = <int, double>{}.obs;

  final RxString defautSalesFilterPeriod = ''.obs;
  final RxString selectedSalesFilterPeriod = ''.obs;

  final txnsController = Get.put(CTxnsController());

  @override
  void onInit() async {
    salesFilters.value = <String>[].obs;
    showSummaryFilterField.value = false;
    monthlySalesHighestAmount.value = 1000.0;
    weeklySalesHighestAmount.value = 1000.0;

    Future.delayed(
      Duration.zero,
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await txnsController.fetchSoldItems().then(
              (result) async {
                calculateCurrentWeekSales();
                calculateLastWeekSales();
                filterHourlySales();
              },
            );
          },
        );
      },
    );

    Future.delayed(
      Duration.zero,
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) async {
            await txnsController.fetchTopSellersFromSales();
          },
        );
      },
    );

    super.onInit();
  }

  Future<List<DateTime>> generateSalesFilterItems() async {
    int firstYr;
    int lastYr;
    if (txnsController.sales.isNotEmpty) {
      salesDatesOnly.value = txnsController.sales
          .map(
            (item) => DateTime.parse(item.lastModified.replaceAll(' @', '')),
          )
          .toList();

      firstYr = salesDatesOnly
          .map((date) => date.year)
          .reduce((a, b) => a < b ? a : b);
      lastYr = salesDatesOnly
          .map((date) => date.year)
          .reduce((a, b) => a > b ? a : b);
    } else {
      firstYr = DateTime.now().year - 1;
      lastYr = DateTime.now().year;
    }

    List<String> years = List.generate(
      firstYr - lastYr + 1,
      (index) => (firstYr - index).toString(),
    );

    salesFilters.value = [
      'this week',
      ...years,
      '${lastYr - 1}',
    ];

    return salesDatesOnly;
  }

  /// -- calculate this week's sales --
  void calculateCurrentWeekSales() async {
    // reset weeklySales values to zero
    thisWeekSalesList.value = List<double>.filled(7, 0.0);
    currentWeekSalesAmount.value = 0.0;

    txnsController.fetchSoldItems().then(
      (result) {
        if (result.isNotEmpty) {
          var demLegitSales = txnsController.sales
              .where((soldItem) => soldItem.quantity >= 0.01)
              .toList();
          for (var sale in demLegitSales) {
            final String rawSaleDate = sale.lastModified.trim();
            var formattedDate = rawSaleDate.replaceAll(' @', '');
            final DateTime currentWeekSalesStart =
                CHelperFunctions.getStartOfCurrentWeek(
                  DateTime.parse(formattedDate),
                );

            // check if sale date is within the current week
            if (currentWeekSalesStart.isBefore(clock.now()) &&
                currentWeekSalesStart
                    .add(const Duration(days: 7))
                    .isAfter(clock.now())) {
              int index = (DateTime.parse(formattedDate).weekday - 1) % 7;

              // ensure the index is non-negative
              index = index < 0 ? index + 7 : index;
              thisWeekSalesList[index] +=
                  (sale.unitSellingPrice * sale.quantity);
              currentWeekSalesAmount.value +=
                  (sale.unitSellingPrice * sale.quantity);

              // if (kDebugMode) {
              //   print(
              //     'date: $formattedDate, current week day: $currentWeekSalesStart, index: $index',
              //   );
              // }
            }
          }
        }

        weeklySalesHighestAmount.value = thisWeekSalesList.reduce(max) > 1
            ? thisWeekSalesList.reduce(max)
            : 1000;

        // if (kDebugMode) {
        //   print('===========\n');
        //   print('weekly sales: $thisWeekSalesList');
        //   print('===========\n');
        // }
      },
    );
  }

  /// -- calculate last week's sales --
  void calculateLastWeekSales() {
    // reset lastWeekSales value to zero
    lastWeekSalesAmount.value = 0.0;
    weeklyPercentageChange.value = 0.0;

    final now = DateTime.now();
    final lastWeekStart = now.subtract(
      Duration(days: now.weekday + 6),
    ); // Monday of last week
    final lastWeekEnd = lastWeekStart.add(
      Duration(days: 6),
    ); // Sunday of last week

    // if (kDebugMode) {
    //   print('last week start date: $lastWeekStart \n');
    //   print('last week end date: $lastWeekEnd \n');
    // }

    // Filter sales data for the last week
    Future.delayed(
      Duration.zero,
      () {
        WidgetsBinding.instance.addPostFrameCallback(
          (_) {
            txnsController.fetchSoldItems().then(
              (result) {
                if (result.isNotEmpty) {
                  var demLegitSales = txnsController.sales
                      .where((soldItem) => soldItem.quantity >= 0.001)
                      .toList();

                  // -- filter sales data for last week --
                  lastWeekSalesAmount.value = demLegitSales
                      .where((sale) {
                        final String rawSaleDate = sale.lastModified.trim();
                        var formattedDate = rawSaleDate.replaceAll(' @', '');

                        return DateTime.parse(
                              formattedDate,
                            ).isAfter(lastWeekStart) &&
                            DateTime.parse(formattedDate).isBefore(lastWeekEnd);
                      })
                      .fold(
                        0.0,
                        (sum, sale) =>
                            sum + (sale.unitSellingPrice * sale.quantity),
                      );
                }
              },
            );
          },
        );
      },
    );
  }

  FlTitlesData buildFlBarChartTitlesData(bool forAnnualData) {
    final isConnectedToInternet = CNetworkManager.instance.hasConnection.value;

    return FlTitlesData(
      show: true,
      bottomTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          getTitlesWidget: (value, meta) {
            // map index to the desired day of the week
            final period = forAnnualData
                ? monthNames
                : [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                    'Sun',
                  ];

            // calculate the index and ensure it wraps around the corresponding day of the week or month of they year
            final index = value.toInt() % period.length;

            // get the day corresponding to the calculated index
            final periodLabel = period[index];

            return SideTitleWidget(
              space: 0,
              fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
              meta: meta,
              child: Text(
                periodLabel,
                style: TextStyle(
                  color: isConnectedToInternet
                      ? CColors.rBrown
                      : CColors.darkGrey,
                  fontSize: 10.0,
                ),
              ),
            );
          },
        ),
      ),
      leftTitles: AxisTitles(
        sideTitles: SideTitles(
          showTitles: true,
          interval: forAnnualData
              ? monthlySalesHighestAmount.value / 4
              : weeklySalesHighestAmount.value / 2,
          reservedSize: 40.0,
          getTitlesWidget: (value, TitleMeta meta) {
            return SideTitleWidget(
              meta: meta,
              space: 0,
              fitInside: SideTitleFitInsideData.fromTitleMeta(meta),
              child: Text(
                CFormatter.kSuffixFormatter(value),
                style: TextStyle(
                  color: isConnectedToInternet
                      ? CColors.rBrown
                      : CColors.darkGrey,
                  fontSize: 10.0,
                ),
              ),
            );
          },
        ),
      ),
      rightTitles: const AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
      topTitles: const AxisTitles(
        sideTitles: SideTitles(
          showTitles: false,
        ),
      ),
    );
  }

  /// -- build grid data --
  FlGridData buildFlBarChartGridData() {
    return FlGridData(
      drawHorizontalLine: true,
      drawVerticalLine: true,
      horizontalInterval: defautSalesFilterPeriod.value == 'this week'
          ? weeklySalesHighestAmount.value / 4
          : monthlySalesHighestAmount.value / 4,
      verticalInterval: defautSalesFilterPeriod.value == 'this week'
          ? weeklySalesHighestAmount.value / 4
          : monthlySalesHighestAmount.value / 4,
    );
  }

  /// -- update carousel slider index --
  void updateCarouselSliderIndex(int index) {
    carouselSliderIndex.value = index;
  }

  toggleDateFieldVisibility() {
    showSummaryFilterField.value = !showSummaryFilterField.value;
    if (!showSummaryFilterField.value) {
      txnsController.dateRangeFieldController.text = '';
      txnsController.initializeSalesSummaryValues();
    }
  }

  @override
  void dispose() {
    txnsController.dateRangeFieldController
        .dispose(); // Dispose of the controller
    showSummaryFilterField.value = false;

    super.dispose();
  }

  filterHourlySales() {
    final timePastMidnight = 1;
    final timeAt3Hrs = 3 * 60;
    final timeAt6Hrs = 6 * 60;
    final timeAt9Hrs = 9 * 60;
    final timeAt12Hrs = 12 * 60;
    final timeAt15Hrs = 15 * 60;
    final timeAt18Hrs = 18 * 60;
    final timeAt21Hrs = 21 * 60;
    final timeAtMidnight = 24 * 60;

    /// -- sales btn midnight and 3:00hrs --
    var salesPast0and3 = txnsController.sales.where(
      (sale) {
        var formattedDate = DateTime.parse(
          sale.lastModified.replaceAll(' @', ''),
        );
        final timeInMunites = formattedDate.hour * 60 + formattedDate.minute;
        return timeInMunites >= timePastMidnight && timeInMunites < timeAt3Hrs;
      },
    ).toList();
    salesPastMidnightTo3.value = salesPast0and3.fold(
      0.0,
      (sum, sale) => sum + (sale.unitSellingPrice * sale.quantity),
    );

    var salesBtn0and3 = txnsController.sales.where(
      (sale) {
        var formattedDate = DateTime.parse(
          sale.lastModified.replaceAll(' @', ''),
        );
        final timeInMunites = formattedDate.hour * 60 + formattedDate.minute;
        return timeInMunites >= timeAtMidnight && timeInMunites < timeAt3Hrs;
      },
    ).toList();
    salesBtnMidnightTo3.value = salesBtn0and3.fold(
      0.0,
      (sum, sale) => sum + (sale.unitSellingPrice * sale.quantity),
    );

    /// -- sales btn 3:00hrs and 6:00hrs --
    var salesBtn3and6 = txnsController.sales.where(
      (sale) {
        var formattedDate = DateTime.parse(
          sale.lastModified.replaceAll(' @', ''),
        );
        final timeInMunites = formattedDate.hour * 60 + formattedDate.minute;
        return timeInMunites >= timeAt3Hrs && timeInMunites < timeAt6Hrs;
      },
    ).toList();

    salesBtn3to6.value = salesBtn3and6.fold(
      0.0,
      (sum, sale) => sum + (sale.unitSellingPrice * sale.quantity),
    );

    /// -- sales btn 6:00hrs and 9:00hrs --
    var salesBtn6and9 = txnsController.sales.where(
      (sale) {
        var formattedDate = DateTime.parse(
          sale.lastModified.replaceAll(' @', ''),
        );
        final timeInMunites = formattedDate.hour * 60 + formattedDate.minute;
        return timeInMunites >= timeAt6Hrs && timeInMunites < timeAt9Hrs;
      },
    ).toList();

    salesBtn6to9.value = salesBtn6and9.fold(
      0.0,
      (sum, sale) => sum + (sale.unitSellingPrice * sale.quantity),
    );

    /// -- sales btn 9:00hrs and 12:00hrs --
    var salesBtn9and12 = txnsController.sales.where(
      (sale) {
        var formattedDate = DateTime.parse(
          sale.lastModified.replaceAll(' @', ''),
        );
        final timeInMunites = formattedDate.hour * 60 + formattedDate.minute;
        return timeInMunites >= timeAt9Hrs && timeInMunites < timeAt12Hrs;
      },
    ).toList();
    salesBtn9to12.value = salesBtn9and12.fold(
      0.0,
      (sum, sale) => sum + (sale.unitSellingPrice * sale.quantity),
    );

    /// -- sales btn 12:00hrs and 15:00hrs --
    var salesBtn12and15 = txnsController.sales.where(
      (sale) {
        var formattedDate = DateTime.parse(
          sale.lastModified.replaceAll(' @', ''),
        );
        final timeInMunites = formattedDate.hour * 60 + formattedDate.minute;
        return timeInMunites >= timeAt12Hrs && timeInMunites < timeAt15Hrs;
      },
    ).toList();

    salesBtn12to15.value = salesBtn12and15.fold(
      0.0,
      (sum, sale) => sum + (sale.unitSellingPrice * sale.quantity),
    );

    /// -- sales btn 15:00hrs and 18:00hrs --
    var salesBtn15and18 = txnsController.sales.where(
      (sale) {
        var formattedDate = DateTime.parse(
          sale.lastModified.replaceAll(" @", ''),
        );
        final timeInMunites = formattedDate.hour * 60 + formattedDate.minute;
        return timeInMunites >= timeAt15Hrs && timeInMunites < timeAt18Hrs;
      },
    ).toList();

    salesBtn15to18.value = salesBtn15and18.fold(
      0.0,
      (sum, sale) => sum + (sale.unitSellingPrice * sale.quantity),
    );

    /// -- sales btn 18:00hrs and 21:00hrs --
    var salesBtn18and21 = txnsController.sales.where(
      (sale) {
        var formattedDate = DateTime.parse(
          sale.lastModified.replaceAll(' @', ''),
        );

        final timeInMunites = formattedDate.hour * 60 + formattedDate.minute;

        return timeInMunites >= timeAt18Hrs && timeInMunites < timeAt21Hrs;
      },
    ).toList();

    salesBtn18to21.value = salesBtn18and21.fold(
      0.0,
      (sum, sale) => sum + (sale.unitSellingPrice * sale.quantity),
    );

    /// -- sales btn 21:00hrs and midnight --
    var salesBtn21andMidght = txnsController.sales.where(
      (sale) {
        var formattedDate = DateTime.parse(
          sale.lastModified.replaceAll(' @', ''),
        );

        final timeInMunites = formattedDate.hour * 60 + formattedDate.minute;
        return timeInMunites >= timeAt21Hrs && timeInMunites < timeAtMidnight;
      },
    ).toList();

    salesBtn21toMidnight.value = salesBtn21andMidght.fold(
      0.0,
      (sum, sale) => sum + (sale.unitSellingPrice * sale.quantity),
    );

    /// -- peak sales amount --
    peakSalesAmount.value = txnsController.sales.fold(
      0.0,
      (sum, sale) => sum + (sale.unitSellingPrice * sale.quantity),
    );
  }

  String setDefaultSalesFilterPeriod() {
    defautSalesFilterPeriod.value = selectedSalesFilterPeriod.value == ''
        ? salesFilters[0]
        : selectedSalesFilterPeriod.value;
    selectedSalesFilterPeriod.value = defautSalesFilterPeriod.value;
    return selectedSalesFilterPeriod.value;
  }

  void onSalesFilterPeriodValueChanged(String? value) {
    selectedSalesFilterPeriod.value = value!;
    setDefaultSalesFilterPeriod();
  }

  List<CMonthlySalesModel> generateMonthlySalesWithoutMonths(int yr) {
    for (var monthSales in txnsController.sales) {
      final String rawSaleDate = monthSales.lastModified.trim();
      var formattedDate = DateTime.parse(rawSaleDate.replaceAll(' @', ''));

      if (formattedDate.year == yr) {
        final monthIndex = formattedDate.month;
        monthlyTotals[monthIndex] =
            (monthlyTotals[monthIndex] ?? 0) +
            (monthSales.unitSellingPrice * monthSales.quantity);
        monthlySalesHighestAmount.value = monthlyTotals.values.reduce(max) > 1
            ? monthlyTotals.values.reduce(max)
            : 1000;
      }
      // else {
      //   CPopupSnackBar.errorSnackBar(
      //     message: 'invalid yr!',
      //     title: 'invalid yr!',
      //   );
      // }
    }

    /// -- create the results list with month names and sales totals --
    return List.generate(
      12,
      (index) {
        final monthIndex = index + 1;
        final salesAmount = monthlyTotals[monthIndex] ?? 0.0;

        var returnValueWithoutMonths = CMonthlySalesModel(
          totalSales: salesAmount,
        );
        return returnValueWithoutMonths;
      },
    );
  }

  List<CMonthlySalesModel> generateMonthlySalesWithMonths(int yr) {
    for (var monthSales in txnsController.sales) {
      final String rawSaleDate = monthSales.lastModified.trim();
      var formattedDate = DateTime.parse(rawSaleDate.replaceAll(' @', ''));

      if (formattedDate.year == yr) {
        final monthIndex = formattedDate.month;
        monthlyTotals[monthIndex] =
            (monthlyTotals[monthIndex] ?? 0) +
            (monthSales.unitSellingPrice * monthSales.quantity);
      }
    }

    /// -- create the results list with month names and sales totals --
    return List.generate(
      12,
      (index) {
        final monthIndex = index + 1;
        final salesAmount = monthlyTotals[monthIndex] ?? 0.0;

        var returnValueWithMonths = CMonthlySalesModel.withMonth(
          month: monthNames[index],
          totalSales: salesAmount,
        );

        return returnValueWithMonths;
      },
    );
  }
}
