import 'package:cri_v3/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TxnsForAppends extends StatelessWidget {
  const TxnsForAppends({super.key});

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
            if (txnsController.unsyncedTxnAppends.isEmpty) {
              return const Center(
                child: NoDataScreen(
                  lottieImage: CImages.noDataLottie,
                  txt: 'No data found!',
                ),
              );
            }

            txnsController.fetchSoldItems();
            return SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: txnsController.unsyncedTxnAppends.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: CColors.lightGrey,
                    elevation: 1,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: CColors.rBrown[300],
                        radius: 16,
                        child:
                            txnsController.unsyncedTxnAppends[index].isSynced ==
                                1
                            ? const Icon(Iconsax.cloud_add)
                            : const Icon(Iconsax.cloud_cross),
                      ),
                      title: Text(
                        txnsController.unsyncedTxnAppends[index].productName,
                      ),
                      subtitle: const Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'txnsController.unsyncedTxnAppends[index].itemCategory',
                          ),
                          Text('invController.pendingUpdates[index].itemId'),
                          Row(
                            children: [
                              Text(
                                'invController.pendingUpdates[index].isSynced',
                              ),
                              SizedBox(width: 10),
                              Text(
                                'invController.pendingUpdates[index].syncAction',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }),
        ),
      ),
    );
  }
}
