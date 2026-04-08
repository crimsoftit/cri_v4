import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CTxnsScreen extends StatelessWidget {
  const CTxnsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final txnsController = Get.put(CTxnsController());
    final userController = Get.put(CUserController());
    final userCurrency = CHelperFunctions.formatCurrency(
      userController.user.value.currencyCode,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('txns')),
      body: SingleChildScrollView(
        child: Obx(() {
          if (!txnsController.isLoading.value &&
              txnsController.receipts.isEmpty) {
            txnsController.fetchTxns();
          }
          return ExpansionPanelList.radio(
            animationDuration: const Duration(milliseconds: 600),
            elevation: 3,
            expansionCallback: (panelIndex, isExpanded) {
              if (isExpanded) {
                txnsController.transactionItems.clear();
                if (txnsController.transactionItems.isEmpty) {
                  txnsController.fetchTxnItems(
                    txnsController.receipts[panelIndex].txnId,
                  );
                }
                // Perform an action when the panel is expanded
                if (kDebugMode) {
                  print('Panel at index $panelIndex is now expanded');
                  CPopupSnackBar.customToast(
                    message: '${txnsController.receipts[panelIndex].txnId}',
                    forInternetConnectivityStatus: false,
                  );
                }
                // Add your custom logic here
              } else {
                // Perform an action when the panel is collapsed
                if (kDebugMode) {
                  print('Panel at index $panelIndex is now collapsed');
                }
                // Add your custom logic here
              }
            },
            children: txnsController.receipts
                .map(
                  (item) => ExpansionPanelRadio(
                    value: item.txnId,
                    canTapOnHeader: true,
                    headerBuilder: (_, isExpanded) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 15,
                          horizontal: 30,
                        ),
                        child: Text(
                          'txn #${item.txnId}',
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    },
                    body: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 15,
                        horizontal: 30,
                      ),
                      child: ListView.separated(
                        // Ensures state persistence,
                        itemBuilder: (context, index) {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${txnsController.transactionItems[index].productName.toUpperCase()} (${txnsController.transactionItems[index].quantity} item(s) @ $userCurrency.${txnsController.transactionItems[index].unitSellingPrice})',
                                style: Theme.of(context).textTheme.labelMedium!
                                    .apply(color: CColors.rBrown),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ],
                          );
                        },
                        itemCount: txnsController.transactionItems.length,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        separatorBuilder: (_, __) {
                          return SizedBox(height: CSizes.spaceBtnItems / 4);
                        },
                        shrinkWrap: true,
                      ),
                    ),
                  ),
                )
                .toList(),
          );
        }),
      ),
    );
  }
}
