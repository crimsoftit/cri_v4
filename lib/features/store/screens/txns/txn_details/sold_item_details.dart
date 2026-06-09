import 'package:cri_v3/common/widgets/dividers/custom_divider.dart';
import 'package:cri_v3/common/widgets/list_tiles/menu_tile.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/utils/constants/app_icons.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/formatter.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CSoldItemDetails extends StatelessWidget {
  const CSoldItemDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final txnsController = Get.put(CTxnsController());
    final userController = Get.put(CUserController());
    final userCurrency = CHelperFunctions.formatCurrency(
      userController.user.value.currencyCode,
    );

    var itemId = Get.arguments;

    Future.delayed(Duration.zero, () {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        txnsController.fetchSoldItems();
      });
    });

    return Container(
      color: isDarkTheme ? CColors.transparent : CColors.white,
      child: Obx(() {
        var saleItem = txnsController.sales.firstWhere(
          (item) => item.soldItemId == itemId,
        );
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            iconTheme: IconThemeData(
              color: isDarkTheme ? CColors.white : CColors.rBrown,
            ),
            elevation: 1.0,
            shadowColor: CColors.rBrown.withValues(alpha: 0.1),
            title: Text(
              'TXN/RECIEPT #${saleItem.txnId}',
              style: Theme.of(context).textTheme.labelMedium!.apply(
                color: saleItem.txnStatus == 'invoiced'
                    ? CColors.warning
                    : isDarkTheme
                    ? CColors.grey
                    : CColors.rBrown,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Iconsax.notification,
                  color: isDarkTheme ? CColors.white : CColors.rBrown,
                ),
              ),
            ],
          ),
          backgroundColor: CColors.rBrown.withValues(alpha: 0.2),
          body: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  // contentPadding: const EdgeInsets.only(
                  //   left: CSizes.defaultSpace / 3,
                  // ),
                  leading: CircleAvatar(
                    backgroundColor: saleItem.txnStatus == 'complete'
                        ? Colors.brown[300]
                        : CColors.warning,
                    child: Text(
                      saleItem.productName[0].toUpperCase(),
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge!.apply(color: CColors.white),
                    ),
                  ),
                  title: Text(
                    '${saleItem.productName.toUpperCase()} ${saleItem.txnStatus == 'invoiced' ? '(unpaid)' : ''}',
                    style: Theme.of(context).textTheme.labelMedium!.apply(
                      color: saleItem.txnStatus == 'invoiced'
                          ? CColors.warning
                          : isDarkTheme
                          ? CColors.grey
                          : CColors.rBrown,
                      fontSizeDelta: 2.0,
                    ),
                  ),
                  subtitle: Text(
                    saleItem.lastModified,
                    style: Theme.of(context).textTheme.headlineSmall!.apply(
                      color: CColors.darkGrey,
                      fontSizeFactor: 0.6,
                    ),
                  ),
                  // trailing: IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(
                  //     Iconsax.notification,
                  //     color: isDarkTheme ? CColors.white : CColors.rBrown,
                  //   ),
                  // ),
                ),

                /// -- custom divider --
                CCustomDivider(),

                Padding(
                  padding: const EdgeInsets.all(CSizes.defaultSpace / 3),
                  child: Column(
                    children: [
                      CMenuTile(
                        icon: Iconsax.user,
                        title: saleItem.userName.split(" ").elementAt(0),
                        // subTitle: invItem.userEmail,
                        subTitle: 'served by',
                        onTap: () {},
                      ),
                      CMenuTile(
                        icon: Iconsax.hashtag5,
                        title:
                            '${saleItem.productId} - #${saleItem.soldItemId}',
                        subTitle: 'product id - #',
                        onTap: () {},
                      ),
                      CMenuTile(
                        icon: Iconsax.barcode,
                        title: saleItem.productCode,
                        subTitle: 'sku/code',
                        onTap: () {},
                      ),
                      CMenuTile(
                        icon: Iconsax.bitcoin_card,
                        // title:
                        //     '$userCurrency.${(saleItem.quantity * saleItem.unitSellingPrice).toStringAsFixed(2)} (${saleItem.quantity} sold; ${saleItem.qtyRefunded} refunded)',
                        title:
                            '$userCurrency.${(saleItem.quantity * saleItem.unitSellingPrice).toStringAsFixed(2)} (${CFormatter.formatItemQtyDisplays(saleItem.quantity, saleItem.itemMetrics)} ${CFormatter.formatItemMetrics(saleItem.itemMetrics, saleItem.quantity)} sold; ${CFormatter.formatItemQtyDisplays(saleItem.qtyRefunded, saleItem.itemMetrics)} refunded)',
                        subTitle: 'total amount',
                        onTap: () {},
                      ),
                      CMenuTile(
                        icon: saleItem.txnStatus == 'complete'
                            ? Iconsax.money_tick
                            : Iconsax.money_time,
                        iconColor: saleItem.txnStatus == 'complete'
                            ? Colors.green
                            : CColors.warning,
                        onTap: () {},
                        subTitle: 'txn/payment status',
                        title: saleItem.txnStatus == 'complete'
                            ? saleItem.txnStatus
                            : 'deferred(${saleItem.txnStatus})',
                        titleColor: saleItem.txnStatus == 'complete'
                            ? Colors.green
                            : CColors.warning,
                      ),
                      CMenuTile(
                        icon: CAppIcons.contactDetails,
                        onTap: () {},
                        title: saleItem.customerName == ''
                            ? 'N/A'
                            : '${saleItem.customerName}(${saleItem.customerContacts == '' ? 'N/A' : saleItem.customerContacts})',
                        subTitle: 'customer details',
                        trailing: InkWell(
                          child: Icon(
                            saleItem.customerName == '' &&
                                    saleItem.customerContacts == ''
                                ? Iconsax.card_add
                                : Iconsax.card_edit,
                            color: CColors.darkGrey,
                            size: CSizes.iconMd,
                          ),
                          onTap: () {
                            CPopupSnackBar.customToast(
                              message: 'rada safi',
                              forInternetConnectivityStatus: false,
                            );
                          },
                        ),
                      ),
                      CMenuTile(
                        icon: Iconsax.money,
                        onTap: () {},
                        title: saleItem.paymentMethod,
                        subTitle: 'payment method',
                        // trailing: InkWell(
                        //   child: Icon(
                        //     saleItem.customerName == '' &&
                        //             saleItem.customerContacts == ''
                        //         ? Iconsax.card_add
                        //         : Iconsax.card_edit,
                        //     color: CColors.darkGrey,
                        //     size: CSizes.iconMd,
                        //   ),
                        //   onTap: () {
                        //     CPopupSnackBar.customToast(
                        //       message: 'rada safi',
                        //       forInternetConnectivityStatus: false,
                        //     );
                        //   },
                        // ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // bottomNavigationBar: SizedBox(
          //   width: CHelperFunctions.screenWidth() * .55,
          //   child: ElevatedButton.icon(
          //     onPressed: () {
          //       var soldItem = txnsController.sales
          //           .firstWhere((item) => item.soldItemId == itemId);
          //       txnsController.refundItemActionModal(context, soldItem);
          //     },
          //     style: ElevatedButton.styleFrom(
          //       padding: const EdgeInsets.all(
          //         CSizes.md,
          //       ),
          //       backgroundColor: CNetworkManager.instance.hasConnection.value
          //           ? CColors.rBrown
          //           : CColors.black,
          //       side: BorderSide(
          //         color: CColors.rBrown,
          //       ),
          //     ),
          //     label: Text(
          //       'refund'.toUpperCase(),
          //       style: Theme.of(context).textTheme.labelMedium?.apply(
          //             color: CColors.white,
          //           ),
          //     ),
          //     icon: Icon(
          //       CAppIcons.refundIcon,
          //       color: CColors.white,
          //     ),
          //   ),
          // ),
        );
      }),
    );
  }
}
