import 'package:cri_v3/common/widgets/appbar/app_bar.dart';
import 'package:cri_v3/common/widgets/appbar/tab_bar.dart';
import 'package:cri_v3/common/widgets/products/cart/positioned_cart_counter_widget.dart';
import 'package:cri_v3/common/widgets/search_bar/animated_search_bar.dart';
import 'package:cri_v3/features/store/controllers/checkout_controller.dart';
import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/features/store/controllers/search_bar_controller.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/features/store/screens/store_items_tings/widgets/inv_gridview_screen.dart';
import 'package:cri_v3/features/store/screens/store_items_tings/widgets/store_screen_header.dart';
import 'package:cri_v3/features/store/screens/store_items_tings/widgets/txn_items.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_floaty/flutter_floaty.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CStoreScreen extends StatelessWidget {
  const CStoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final cartController = Get.put(CCartController()); TODO: yaani never todo... <INTERFERES WITH SEARCH BOX>

    final checkoutController = Get.put(CCheckoutController());

    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final invController = Get.put(CInventoryController());
    final txnsController = Get.put(CTxnsController());

    final searchController = Get.put(CSearchBarController());

    txnsController.fetchTxns();

    //Get.put(CTxnsController());

    // if (!invController.isLoading.value &&
    //     !syncController.processingSync.value &&
    //     !txnsController.isLoading.value &&
    //     (invController.unSyncedAppends.isEmpty ||
    //         invController.unSyncedUpdates.isEmpty)) {
    //   invController.fetchUserInventoryItems();
    // }

    return DefaultTabController(
      animationDuration: Duration(
        milliseconds: 300,
      ),
      length: 5,
      child: Obx(
        () {
          // Define boundaries for the draggable area
          final boundaries = Rect.fromLTWH(
            0,
            0,
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height * 0.9,
          );
          return Scaffold(
            backgroundColor: CColors.rBrown.withValues(
              alpha: 0.2,
            ),
            appBar: CAppBar(
              horizontalPadding: 0,
              leadingWidget: searchController.showSearchField.value
                  ? null
                  : Padding(
                      padding: const EdgeInsets.only(
                        top: 5.0,
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Icon(
                            Iconsax.menu,
                            size: 25.0,
                            color: CColors.rBrown,
                          ),
                          Expanded(
                            child: searchController.showSearchField.value
                                ? CAnimatedSearchBar(
                                    hintTxt: 'inventory, transactions',
                                    boxColor:
                                        searchController.showSearchField.value
                                        ? CColors.white
                                        : Colors.transparent,
                                    controller: searchController.txtSearchField,
                                  )
                                : SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
              showBackArrow: false,
              backIconColor: isDarkTheme ? CColors.white : CColors.rBrown,
              title: CAnimatedSearchBar(
                hintTxt: 'inventory, transactions',
                boxColor: searchController.showSearchField.value
                    ? CColors.white
                    : Colors.transparent,
                controller: searchController.txtSearchField,
              ),
              backIconAction: () {
                // Navigator.pop(context, true);
              },
            ),
            body: NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrollable) {
                return [
                  SliverAppBar(
                    automaticallyImplyLeading: false,
                    pinned: true,
                    floating: false,
                    backgroundColor: CColors.transparent,
                    expandedHeight: 50.0,
                    flexibleSpace: Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: ListView(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: [
                          CStoreScreenHeader(
                            forStoreScreen: true,
                            title: 'Store',
                          ),
                          SizedBox(
                            height: 1.0,
                          ),
                        ],
                      ),
                    ),

                    /// -- tabs --
                    bottom: const CTabBar(
                      tabs: [
                        Tab(
                          child: Text('Inventory'),
                        ),

                        Tab(
                          child: Text('Receipts'),
                        ),
                        Tab(
                          child: Text('Invoices'),
                        ),
                        Tab(
                          child: Text('Sales (all)'),
                        ),
                        Tab(
                          child: Text('Refunds'),
                        ),
                      ],
                    ),
                  ),
                ];
              },
              body: const TabBarView(
                physics: BouncingScrollPhysics(),
                children: [
                  /// -- inventory list items --
                  CInvGridviewScreen(
                    mainAxisExtent: 185.20,
                  ),

                  // -- almost obsolete --
                  // CItemsListView(
                  //   space: 'sales',
                  // ),

                  /// -- transactions list view --
                  CTxnItemsListView(
                    space: 'receipts',
                  ),

                  CTxnItemsListView(
                    space: 'invoices',
                  ),

                  CTxnItemsListView(
                    space: 'sales',
                  ),
                  CTxnItemsListView(
                    space: 'refunds',
                  ),
                ],
              ),
            ),

            /// -- floating action button to scan item for sale --
            floatingActionButton: Stack(
              children: [
                FlutterFloaty(
                  backgroundColor: CNetworkManager.instance.hasConnection.value
                      ? CColors.rBrown
                      : CColors.darkerGrey,
                  borderRadius: 15.0,

                  builder: (context) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        invController.inventoryItems.isEmpty
                            ? SizedBox.shrink()
                            : Stack(
                                alignment: Alignment.center,
                                children: [
                                  FloatingActionButton.extended(
                                    elevation: 0,
                                    focusElevation: 0,
                                    label: Text(
                                      'CHECKOUT',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium!
                                          .apply(
                                            color: CColors.white,
                                            fontSizeDelta: 1.2,
                                            //fontWeightDelta: 2,
                                          ),
                                    ),
                                    onPressed: () {
                                      checkoutController.handleNavToCheckout();
                                    },
                                    backgroundColor: CColors.transparent,
                                    foregroundColor: Colors.white,
                                    heroTag: 'checkout',
                                    icon: const Icon(
                                      Iconsax.wallet_check,
                                      size: CSizes.iconSm,
                                    ),
                                  ),
                                  CPositionedCartCounterWidget(
                                    containerHeight: 14.0,
                                    containerWidth: 14.0,
                                    counterBgColor: CColors.white,
                                    counterTxtColor: CColors.rBrown,
                                    rightPosition: 62.0,
                                    topPosition: 10.0,
                                  ),
                                ],
                              ),
                      ],
                    );
                  },
                  growingFactor: 1.1,
                  height: 57.0,
                  initialX: CHelperFunctions.screenWidth() * .69,
                  initialY: CHelperFunctions.screenHeight() * .72,
                  intrinsicBoundaries: boundaries,

                  onDragBackgroundColor:
                      CNetworkManager.instance.hasConnection.value
                      ? CColors.rBrown.withValues(
                          alpha: .4,
                        )
                      : CColors.darkerGrey.withValues(
                          alpha: .4,
                        ),
                  shadow: BoxShadow(
                    blurRadius: 3.0,
                    color: CColors.grey.withValues(
                      alpha: .1,
                    ),
                    offset: const Offset(
                      0.0,
                      1.0,
                    ),
                    spreadRadius: 1.0,
                  ),
                  shape: BoxShape.rectangle,
                  width: 100.0,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
