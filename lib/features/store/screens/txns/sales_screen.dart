import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CSalesScreen extends StatelessWidget {
  const CSalesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //final invController = Get.put(CInventoryController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final txnsController = Get.put(CTxnsController());

    Get.put(CInventoryController());
    Get.put(CTxnsController());
    txnsController.fetchTxns();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: CColors.rBrown.withValues(alpha: 0.2),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.menu, size: 30.0, color: CColors.rBrown),
                        Expanded(child: Container()),
                        Container(
                          width: 30.0,
                          height: 30.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8.0),
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 25.0),
                    Container(
                      padding: const EdgeInsets.only(left: 2.0),
                      child: Text(
                        'Sales',
                        style: Theme.of(context).textTheme.labelLarge!.apply(
                          color: CColors.rBrown,
                          fontSizeFactor: 2.5,
                          fontWeightDelta: -2,
                        ),
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Column(
                      children: [
                        SizedBox(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TabBar(
                              isScrollable: true,
                              labelColor: CColors.rBrown,
                              labelPadding: const EdgeInsets.only(
                                left: 10.0,
                                right: 10.0,
                              ),
                              unselectedLabelColor: CColors.grey,
                              tabs: [
                                Tab(text: 'all'),
                                Tab(text: 'refunds'),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: CHelperFunctions.screenHeight() * 0.7,
                          child: Obx(() {
                            return TabBarView(
                              children: [
                                ListView.builder(
                                  padding: const EdgeInsets.all(0.0),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: txnsController.foundSales.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: isDarkTheme
                                          ? CColors.rBrown.withValues(
                                              alpha: 0.3,
                                            )
                                          : CColors.lightGrey,
                                      elevation: 0.3,
                                      child: ListTile(
                                        horizontalTitleGap: 10,
                                        contentPadding: const EdgeInsets.all(
                                          5.0,
                                        ),
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.brown[300],
                                          radius: 16.0,
                                          child: Text(
                                            txnsController
                                                .foundSales[index]
                                                .productName[0]
                                                .toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .apply(color: CColors.white),
                                          ),
                                        ),
                                        title: Text(
                                          '${txnsController.foundSales[index].productName.toUpperCase()} ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .apply(
                                                color: isDarkTheme
                                                    ? CColors.white
                                                    : CColors.rBrown,
                                              ),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: txnsController.refunds.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: CColors.lightGrey,
                                      elevation: 0.3,
                                      child: ListTile(
                                        horizontalTitleGap: 10,
                                        contentPadding: const EdgeInsets.all(
                                          5.0,
                                        ),
                                        leading: CircleAvatar(
                                          backgroundColor: Colors.brown[300],
                                          radius: 16.0,
                                          child: Text(
                                            txnsController
                                                .refunds[index]
                                                .productName[0]
                                                .toUpperCase(),
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelLarge!
                                                .apply(color: CColors.white),
                                          ),
                                        ),
                                        title: Text(
                                          '${txnsController.refunds[index].productName.toUpperCase()} ',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelMedium!
                                              .apply(color: CColors.rBrown),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            );
                          }),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
