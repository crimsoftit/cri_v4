import 'package:cri_v3/common/widgets/appbar/tab_bar.dart';
import 'package:cri_v3/common/widgets/appbar/v2_app_bar.dart';
import 'package:cri_v3/common/widgets/shimmers/shimmer_effects.dart';
import 'package:cri_v3/features/personalization/controllers/contacts_controller.dart';
import 'package:cri_v3/features/personalization/screens/contacts/widgets/alphabet_scroll_view.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CContactsScreen extends StatelessWidget {
  const CContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final contactsController = Get.put(CContactsController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    //contactsController.fetchMyContacts();

    return DefaultTabController(
      animationDuration: Duration(
        milliseconds: 300,
      ),
      length: 5,
      child: Container(
        color: isDarkTheme ? CColors.transparent : CColors.white,
        child: Scaffold(
          /// -- app bar --
          appBar: CVersion2AppBar(
            autoImplyLeading: false,
          ),
          backgroundColor: CColors.rBrown.withValues(
            alpha: 0.2,
          ),
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

                      Tab(
                        child: Text(
                          'Trashed',
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
                    child: Obx(
                      () {
                        return ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          children: [
                            // CStoreScreenHeader(
                            //   forStoreScreen: false,
                            //   title: 'Contacts',
                            // ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Contacts',
                                  style: Theme.of(context).textTheme.labelLarge!
                                      .apply(
                                        color:
                                            CNetworkManager
                                                .instance
                                                .hasConnection
                                                .value
                                            ? CColors.rBrown
                                            : CColors.darkGrey,
                                        fontSizeFactor: 2.5,
                                        fontWeightDelta: -7,
                                      ),
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        contactsController
                                            .addContactActionModal(
                                              context,
                                            );
                                      },
                                      icon: Icon(
                                        Iconsax.add,
                                        color:
                                            CNetworkManager
                                                .instance
                                                .hasConnection
                                                .value
                                            ? CColors.rBrown
                                            : CColors.darkGrey,
                                      ),
                                    ),
                                    contactsController
                                            .processingContactsSync
                                            .value
                                        ? CShimmerEffect(
                                            width: 40.0,
                                            height: 40.0,
                                            radius: 40.0,
                                          )
                                        : IconButton(
                                            onPressed:
                                                contactsController
                                                        .unsyncedContactAppends
                                                        .isEmpty &&
                                                    contactsController
                                                        .unsyncedContactUpdates
                                                        .isEmpty
                                                ? null
                                                : () async {
                                                    contactsController
                                                        .processContactsSync();
                                                  },
                                            icon: Icon(
                                              contactsController
                                                          .unsyncedContactAppends
                                                          .isEmpty &&
                                                      contactsController
                                                          .unsyncedContactUpdates
                                                          .isEmpty
                                                  ? Iconsax.cloud_add
                                                  : Iconsax.cloud_change,
                                              color:
                                                  CNetworkManager
                                                      .instance
                                                      .hasConnection
                                                      .value
                                                  ? CColors.rBrown
                                                  : CColors.darkGrey,
                                            ),
                                          ),

                                    IconButton(
                                      onPressed: () async {},
                                      icon: Icon(
                                        Iconsax.trash,
                                        color:
                                            CNetworkManager
                                                .instance
                                                .hasConnection
                                                .value
                                            ? CColors.rBrown
                                            : CColors.darkGrey,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                          ],
                        );
                      },
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
                CContactItem(
                  space: 'all',
                ),
                // CContactsExpansionPanelView(
                //   space: 'all',
                // ),
                // CContactsExpansionPanelView(
                //   space: 'suppliers',
                // ),
                CContactItem(
                  space: 'suppliers',
                ),
                CContactItem(
                  space: 'customers',
                ),
                // CContactsExpansionPanelView(
                //   space: 'customers',
                // ),
                CContactItem(
                  space: 'friends',
                ),

                // CContactsExpansionPanelView(
                //   space: 'friends',
                // ),
                CContactItem(
                  space: 'trashed',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
