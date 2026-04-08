import 'package:cri_v3/common/widgets/appbar/app_bar.dart';
import 'package:cri_v3/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CTxnsForUpdates extends StatelessWidget {
  const CTxnsForUpdates({super.key});

  @override
  Widget build(BuildContext context) {
    final txnsController = Get.put(CTxnsController());

    txnsController.fetchSoldItems();
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Obx(() {
            // -- no data widget --
            if (txnsController.unsyncedTxnUpdates.isEmpty) {
              return const Center(
                child: NoDataScreen(
                  lottieImage: CImages.noDataLottie,
                  txt: 'No data found!',
                ),
              );
            }

            txnsController.fetchSoldItems();
            return SingleChildScrollView(
              child: Column(
                children: [
                  CAppBar(
                    title: IconButton(
                      onPressed: () {},
                      icon: const Icon(Iconsax.cloud_change),
                    ),
                    backIconAction: () {},
                  ),
                  SizedBox(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: txnsController.unsyncedTxnUpdates.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: CColors.lightGrey,
                          elevation: 1,
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: CColors.rBrown[300],
                              radius: 16,
                              child:
                                  txnsController
                                          .unsyncedTxnUpdates[index]
                                          .isSynced ==
                                      1
                                  ? const Icon(Iconsax.cloud_add)
                                  : const Icon(Iconsax.cloud_cross),
                            ),
                            title: Text(
                              txnsController
                                  .unsyncedTxnUpdates[index]
                                  .productName,
                            ),
                            subtitle: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  txnsController
                                      .unsyncedTxnUpdates[index]
                                      .productCode,
                                ),
                                Text(
                                  txnsController
                                      .unsyncedTxnUpdates[index]
                                      .lastModified,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        'txnStatus ${txnsController.unsyncedTxnUpdates[index].txnStatus}',
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'isSynced: ${txnsController.unsyncedTxnUpdates[index].isSynced}',
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'syncAction: ${txnsController.unsyncedTxnUpdates[index].syncAction}',
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
