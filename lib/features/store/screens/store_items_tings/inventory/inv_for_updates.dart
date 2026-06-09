import 'package:cri_v3/features/personalization/screens/no_data/no_data_screen.dart';
import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class InvForUpdates extends StatelessWidget {
  const InvForUpdates({super.key});

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    invController.fetchInvUpdates();
    return Scaffold(
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Obx(() {
            // -- no data widget --
            if (invController.pendingUpdates.isEmpty) {
              return const Center(
                child: NoDataScreen(
                  lottieImage: CImages.noDataLottie,
                  txt: 'No data found!',
                ),
              );
            }

            invController.fetchInvUpdates();
            return SizedBox(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: invController.pendingUpdates.length,
                itemBuilder: (context, index) {
                  return Card(
                    color: CColors.lightGrey,
                    elevation: 1,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: CColors.rBrown[300],
                        radius: 16,
                        child: invController.pendingUpdates[index].isSynced == 1
                            ? const Icon(Iconsax.cloud_add)
                            : const Icon(Iconsax.cloud_cross),
                      ),
                      title: Text(invController.pendingUpdates[index].itemName),
                      subtitle: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            invController.pendingUpdates[index].itemCategory,
                          ),
                          Text(
                            invController.pendingUpdates[index].itemId
                                .toString(),
                          ),
                          Row(
                            children: [
                              Text(
                                invController.pendingUpdates[index].isSynced
                                    .toString(),
                              ),
                              const SizedBox(width: 10),
                              Text(
                                invController.pendingUpdates[index].syncAction,
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
