import 'package:cri_v3/common/widgets/appbar/tab_bar.dart';
import 'package:cri_v3/common/widgets/appbar/v2_app_bar.dart';
import 'package:cri_v3/features/personalization/controllers/contacts_controller.dart';
import 'package:cri_v3/features/personalization/screens/contacts/widgets/contacts_expansion_panel_view.dart';
import 'package:cri_v3/features/store/screens/store_items_tings/widgets/store_screen_header.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CContactsScreen extends StatelessWidget {
  const CContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactsController = Get.put(CContactsController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    contactsController.fetchMyContacts();
    return DefaultTabController(
      animationDuration: Duration(
        milliseconds: 300,
      ),
      length: 4,
      child: Container(
        color: isDarkTheme ? CColors.transparent : CColors.white,
        child: Scaffold(
          /// -- app bar --
          appBar: CVersion2AppBar(
            autoImplyLeading: false,
          ),
          backgroundColor: CColors.rBrown.withValues(alpha: 0.2),
          body: NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  automaticallyImplyLeading: true,
                  backgroundColor: CColors.transparent,
                  bottom: const CTabBar(
                    tabs: [
                      Tab(
                        child: Text(
                          'All',
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Suppliers',
                        ),
                      ),
                      Tab(
                        child: Text(
                          'Customers',
                        ),
                      ),

                      Tab(
                        child: Text(
                          'Friends',
                        ),
                      ),
                    ],
                  ),
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
                          forStoreScreen: false,
                          title: 'Contacts',
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                      ],
                    ),
                  ),
                  floating: false,
                  pinned: true,
                ),
              ];
            },
            body: const TabBarView(
              physics: BouncingScrollPhysics(),
              children: [
                CContactsExpansionPanelView(
                  space: 'all',
                ),
                CContactsExpansionPanelView(
                  space: 'suppliers',
                ),
                CContactsExpansionPanelView(
                  space: 'customers',
                ),

                CContactsExpansionPanelView(
                  space: 'friends',
                ),
              ],
            ),
          ),

          // SingleChildScrollView(
          //   child: Padding(
          //     padding: const EdgeInsets.only(
          //       left: 10.0,
          //       right: 10.0,
          //       top: 10.0,
          //     ),
          //     child: Obx(
          //       () {
          //         return Column(
          //           crossAxisAlignment: CrossAxisAlignment.start,
          //           children: [
          //             Text(
          //               'my contacts',
          //               style: Theme.of(context).textTheme.labelLarge!.apply(
          //                 color: CNetworkManager.instance.hasConnection.value
          //                     ? CColors.rBrown
          //                     : CColors.darkGrey,
          //                 fontSizeFactor: 2.5,
          //                 fontWeightDelta: -7,
          //               ),
          //             ),

          //             /// -- custom divider --
          //             CCustomDivider(leftPadding: 5.0),

          //             const SizedBox(
          //               height: CSizes.spaceBtnSections,
          //             ),
          //             CRoundedContainer(
          //               bgColor: CColors.transparent,
          //               child: TabBar(
          //                 tabs: [
          //                   Tab(
          //                     text: 'Suppliers',
          //                   ),
          //                   Tab(
          //                     text: 'Customers',
          //                   ),
          //                   Tab(
          //                     text: 'Friends',
          //                   ),
          //                 ],
          //               ),
          //             ),

          //             CRoundedContainer(
          //               bgColor: CColors.transparent,
          //               width: double.maxFinite,
          //               height: double.maxFinite,
          //               child: TabBarView(
          //                 physics: BouncingScrollPhysics(),
          //                 children: [
          //                   // Text(
          //                   //   'customer_1',
          //                   // ),
          //                   CTxnItemsListView(
          //                     space: 'sales',
          //                   ),
          //                   Text(
          //                     'supplier_1',
          //                   ),
          //                   Text(
          //                     'friend_1',
          //                   ),
          //                 ],
          //               ),
          //             ),
          //           ],
          //         );
          //       },
          //     ),
          //   ),
          // ),
        ),
      ),
    );
  }
}
