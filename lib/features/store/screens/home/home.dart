import 'package:cri_v3/common/widgets/buttons/custom_dropdown_btn.dart';
import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/common/widgets/dates/date_range_picker_widget.dart';
import 'package:cri_v3/common/widgets/dividers/custom_divider.dart';
import 'package:cri_v3/common/widgets/products/cart/cart_counter_icon.dart';
import 'package:cri_v3/common/widgets/search_bar/animated_search_bar.dart';
import 'package:cri_v3/common/widgets/shimmers/horizontal_items_shimmer.dart';
import 'package:cri_v3/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:cri_v3/features/store/controllers/dashboard_controller.dart';
import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/features/store/controllers/nav_menu_controller.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/features/store/screens/home/fresh_dashboard.dart';
import 'package:cri_v3/features/store/screens/home/widgets/charts/bar_charts/monthly_sales_bar_graph.dart';
import 'package:cri_v3/features/store/screens/home/widgets/charts/bar_charts/weekly_sales_bar_graph.dart';
import 'package:cri_v3/features/store/screens/home/widgets/charts/line_charts/cutom_line_chart.dart';
import 'package:cri_v3/features/store/screens/home/widgets/dashboard_header.dart';
import 'package:cri_v3/features/store/screens/home/widgets/store_summary.dart';
import 'package:cri_v3/features/store/screens/home/widgets/top_sellers.dart';
import 'package:cri_v3/nav_menu.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/constants/txt_strings.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dashboardController = Get.put(CDashboardController());

    final invController = Get.put(CInventoryController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    final navController = Get.put(CNavMenuController());
    final txnsController = Get.put(CTxnsController());

    if (invController.inventoryItems.isEmpty || txnsController.sales.isEmpty) {
      return const CFreshDashboardScreen();
    }

    return Container(
      color: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(
              left: 0.5,
              right: 0.5,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Iconsax.menu,
                  size: 25.0,
                  color: CColors.rBrown,
                ),
                CCartCounterIcon(
                  iconColor: CColors.rBrown,
                  showCounterWidget: true,
                ),
              ],
            ),
          ),
        ),
        backgroundColor: CColors.rBrown.withValues(alpha: 0.2),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: CSizes.defaultSpace / 4.0,
              ),

              /// -- dashboard header widget --
              Obx(
                () {
                  return DashboardHeaderWidget(
                    actionsSection:
                        dashboardController.showSummaryFilterField.value
                        ? SizedBox.shrink()
                        : CAnimatedSearchBar(
                            controller: txnsController.dateRangeFieldController,
                            customTxtField: CDateRangePickerWidget(),
                            forSearch: false,
                            useCustomTxtField: true,
                            hintTxt: '',
                          ),
                    appBarTitle: CTexts.homeAppbarTitle,
                    isHomeScreen: true,
                    screenTitle: 'dashboard',
                    showAppBarTitle: false,
                  );
                },
              ),

              /// -- custom divider --
              CCustomDivider(),

              Padding(
                padding: const EdgeInsets.only(
                  left: 18.0,
                  right: 18.0,
                  top: 0,
                ),
                child: Obx(
                  () {
                    if ((invController.inventoryItems.isEmpty &&
                            !invController.isLoading.value) ||
                        (txnsController.sales.isEmpty &&
                            !txnsController.isLoading.value)) {
                      invController.fetchUserInventoryItems();
                    }
                    if (invController.isLoading.value &&
                            invController.inventoryItems.isNotEmpty ||
                        (txnsController.sales.isNotEmpty &&
                            txnsController.isLoading.value)) {
                      return CHorizontalProductShimmer();
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// -- store summary --
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: CSizes.defaultSpace / 6),
                            Visibility(
                              visible: dashboardController
                                  .showSummaryFilterField
                                  .value,
                              child: Align(
                                alignment: Alignment.topRight,
                                child: CAnimatedSearchBar(
                                  controller:
                                      txnsController.dateRangeFieldController,
                                  customTxtField: CDateRangePickerWidget(),
                                  forSearch: false,
                                  useCustomTxtField: true,
                                  hintTxt: '',
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: CSizes.defaultSpace / 6,
                            ),
                            CStoreSummary(),

                            /// -- top sellers --
                            CSectionHeading(
                              showActionBtn: true,
                              title: 'Top sellers...',
                              txtColor:
                                  CNetworkManager.instance.hasConnection.value
                                  ? CColors.rBrown
                                  : CColors.darkGrey,

                              btnTitle: 'View all',
                              btnTxtColor: CColors.rBrown,
                              editFontSize: true,
                              fWeight: FontWeight.w400,
                              onPressed: () {
                                navController.selectedIndex.value = 1;
                                Get.to(() => const NavMenu());
                              },
                            ),
                            CTopSellers(),
                            const SizedBox(
                              height: CSizes.defaultSpace / 4,
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: CSizes.defaultSpace * .5,
                        ),

                        /// -- peak sales hours line chart --
                        peakSalesHoursLineChart(),
                        const SizedBox(
                          height: CSizes.defaultSpace * .5,
                        ),

                        /// -- sales summary bar graph --
                        // CCustomBarChart(
                        //   selectedFilterPeriod: dashboardController
                        //       .setDefaultSalesFilterPeriod(),
                        // ),
                        CSectionHeading(
                          actionWidget: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                right: 8.0,
                              ),
                              child: CRoundedContainer(
                                borderRadius: 10.0,
                                height: 40.0,
                                padding: const EdgeInsets.all(
                                  5.0,
                                ),
                                showBorder: true,
                                child: CCustomDropdownBtn(
                                  defaultItemColor: CColors.black,
                                  defaultItemFontSizeFactor: 1.1,
                                  dropdownItems:
                                      dashboardController.salesFilters,
                                  dropdownBoxColor: CColors.rBrown.withValues(
                                    alpha: .4,
                                  ),
                                  selectedValue: dashboardController
                                      .setDefaultSalesFilterPeriod(),
                                  onValueChanged: (value) {
                                    dashboardController
                                        .onSalesFilterPeriodValueChanged(
                                          value,
                                        );
                                  },
                                  underlineColor: CColors.rBrown,
                                  underlineHeight: 0,
                                ),
                              ),
                            ),
                          ),
                          showActionBtn: true,
                          title: 'Sales summary...',
                          txtColor: CNetworkManager.instance.hasConnection.value
                              ? CColors.rBrown
                              : CColors.darkGrey,

                          btnTitle: '',
                          btnTxtColor: CColors.rBrown,
                          editFontSize: true,
                          fWeight: FontWeight.w400,
                          onPressed: () {},
                        ),
                        const SizedBox(
                          height: CSizes.defaultSpace / 2,
                        ),
                        dashboardController.setDefaultSalesFilterPeriod() ==
                                'this week'
                            ? WeeklySalesBarGraphWidget()
                            : CCustomMonthlySalesBarGraph(),

                        // const SizedBox(
                        //   height: CSizes.defaultSpace * .5,
                        // ),
                        // WeeklySalesBarGraphWidget(),
                        const SizedBox(
                          height: CSizes.defaultSpace * .5,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// -- peak sales hours line chart --
  Widget peakSalesHoursLineChart() {
    final dashboardController = Get.put(CDashboardController());

    return Column(
      children: [
        CSectionHeading(
          showActionBtn: false,
          title: "Peak hours' sales traffic...",
          txtColor: CNetworkManager.instance.hasConnection.value
              ? CColors.rBrown
              : CColors.darkGrey,

          btnTitle: '',
          btnTxtColor: CColors.rBrown,
          editFontSize: true,
          fWeight: FontWeight.w400,
          onPressed: () {},
        ),
        const SizedBox(
          height: CSizes.defaultSpace / 2,
        ),
        Obx(
          () {
            return CCutomLineChart(
              chartHeight: 180.0,
              chartWidth: CHelperFunctions.screenWidth(),
              lineChartData: [
                FlSpot(
                  0,
                  dashboardController.salesPastMidnightTo3.value,
                ),
                FlSpot(
                  3,
                  (dashboardController.salesBtn3to6.value),
                ),
                FlSpot(
                  6,
                  dashboardController.salesBtn6to9.value,
                ),
                FlSpot(
                  9,
                  dashboardController.salesBtn9to12.value,
                ),
                FlSpot(
                  12,
                  dashboardController.salesBtn12to15.value,
                ),
                FlSpot(
                  15,
                  dashboardController.salesBtn15to18.value,
                ),
                FlSpot(
                  18,
                  dashboardController.salesBtn18to21.value,
                ),
                FlSpot(
                  21,
                  dashboardController.salesBtn21toMidnight.value,
                ),
                FlSpot(
                  24,
                  dashboardController.salesBtnMidnightTo3.value,
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
