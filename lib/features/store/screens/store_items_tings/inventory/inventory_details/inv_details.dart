import 'package:cri_v3/common/widgets/dividers/custom_divider.dart';
import 'package:cri_v3/common/widgets/list_tiles/menu_tile.dart';
import 'package:cri_v3/common/widgets/txt_widgets/c_section_headings.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/features/store/models/inv_model.dart';
import 'package:cri_v3/features/store/screens/store_items_tings/inventory/inventory_details/widgets/add_to_cart_bottom_nav_bar.dart';
import 'package:cri_v3/features/store/screens/store_items_tings/inventory/widgets/inv_dialog.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/formatter.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CInvDetails extends StatelessWidget {
  const CInvDetails({super.key});

  /// TODO: include txn status (invoiced, complete)

  @override
  Widget build(BuildContext context) {
    AddUpdateItemDialog dialog = AddUpdateItemDialog();
    final invController = Get.put(CInventoryController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    final userController = Get.put(CUserController());

    return Container(
      color: isDarkTheme ? CColors.transparent : CColors.white,
      child: Obx(() {
        final currency = CHelperFunctions.formatCurrency(
          userController.user.value.currencyCode,
        );
        var itemId = Get.arguments;

        var invItem = invController.inventoryItems.firstWhere(
          (item) => item.productId == itemId,
        );

        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: true,
            elevation: 1.0,
            shadowColor: CColors.rBrown.withValues(alpha: 0.1),
            iconTheme: IconThemeData(
              color: isDarkTheme ? CColors.white : CColors.rBrown,
            ),
            title: Text(
              '#${invItem.productId}',
              style: Theme.of(context).textTheme.labelMedium!.apply(
                color: isDarkTheme ? CColors.grey : CColors.rBrown,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  Get.back();
                },
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
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.brown[300],
                    child: Text(
                      invItem.name[0].toUpperCase(),
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge!.apply(color: CColors.white),
                    ),
                  ),
                  title: Text(
                    invItem.name.toUpperCase(),
                    style: Theme.of(context).textTheme.labelMedium!.apply(
                      color: isDarkTheme ? CColors.grey : CColors.rBrown,
                      fontSizeDelta: 2.0,
                    ),
                  ),
                  subtitle: Text(
                    invItem.lastModified,
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
                      // const CSectionHeading(
                      //   showActionBtn: false,
                      //   title: 'details',
                      //   btnTitle: '',
                      //   editFontSize: false,
                      // ),
                      CMenuTile(
                        icon: Iconsax.user,
                        title: invItem.userName,
                        // subTitle: invItem.userEmail,
                        subTitle: 'added by',
                        onTap: () {},
                      ),

                      CMenuTile(
                        icon: Iconsax.hashtag5,
                        title: invItem.productId.toString(),
                        subTitle: 'product/item id',
                        onTap: () {},
                      ),

                      CMenuTile(
                        icon: Iconsax.barcode,
                        title: invItem.pCode,
                        subTitle: 'sku/code',
                        onTap: () {},
                      ),

                      CMenuTile(
                        icon: Iconsax.calendar,
                        title: invItem.dateAdded,
                        subTitle: 'Date added',
                        onTap: () {},
                      ),

                      // TODO: ability to update expiry date
                      CMenuTile(
                        icon: Iconsax.calendar,
                        title: invItem.expiryDate != ''
                            ? '${CFormatter.formatTimeRangeFromNow(invItem.expiryDate.replaceAll('@ ', ''))} (${invItem.expiryDate})'
                            : 'N/A',
                        subTitle: 'Expiry date/Shelflife',
                        onTap: () {},
                      ),

                      CMenuTile(
                        icon: Iconsax.shopping_cart,
                        title:
                            '${invItem.calibration == 'units' ? invItem.quantity.toInt() : invItem.quantity} (${invItem.calibration == 'units' ? invItem.qtyRefunded.toInt() : invItem.qtyRefunded} ${CFormatter.formatInventoryMetrics(invItem.productId!)}(s) refunded)',
                        subTitle: 'in stock',
                        onTap: () {},
                      ),

                      // CMenuTile(
                      //   icon: Iconsax.shopping_cart,
                      //   title: '${(invItem.qtyRefunded)}',
                      //   subTitle: 'Qty/units refunded',
                      //   onTap: () {},
                      // ),
                      CMenuTile(
                        icon: Iconsax.bitcoin_card,
                        title:
                            '$currency.${(invItem.qtySold * invItem.unitSellingPrice).toStringAsFixed(2)} (${(invItem.qtySold)} units)',
                        subTitle: 'total sales',
                        onTap: () {},
                      ),

                      CMenuTile(
                        icon: Iconsax.bitcoin_card,
                        //title: '',
                        title: '$currency.${(invItem.buyingPrice)}',
                        subTitle: 'buying price',
                        onTap: () {
                          //Get.to(() => const UserAddressesScreen());
                        },
                      ),

                      CMenuTile(
                        icon: Iconsax.card_pos,
                        //title: '',
                        title: '$currency. ${(invItem.unitSellingPrice)}',
                        subTitle: 'unit selling price',
                        onTap: () {
                          //Get.to(() => const OrdersScreen());
                        },
                      ),

                      CMenuTile(
                        icon: Iconsax.card_pos,
                        //title: '',
                        title: '$currency.${(invItem.unitBp)}',
                        subTitle: '~ unit buying price',
                        onTap: () {
                          //Get.to(() => const OrdersScreen());
                        },
                      ),

                      CMenuTile(
                        icon: Iconsax.calendar,
                        title: invItem.lastModified,
                        subTitle: 'last modified',
                        onTap: () {},
                      ),
                      CMenuTile(
                        icon: Iconsax.card_tick,
                        title: invItem.qtySold.toString(),
                        subTitle: 'total units sold',
                        onTap: () {},
                      ),

                      CMenuTile(
                        icon: Icons.contact_mail,
                        onTap: () {
                          if (kDebugMode) {
                            CPopupSnackBar.customToast(
                              message: 'tap iko sawa',
                              forInternetConnectivityStatus: false,
                            );
                          }
                        },
                        subTitle: 'supplier name, contacts',
                        title: invItem.supplierName.isNotEmpty
                            ? '${invItem.supplierName} (${invItem.supplierContacts})'
                            : 'N/A',
                        trailing: Icon(Iconsax.pen_add, color: CColors.rBrown),
                      ),
                      CMenuTile(
                        icon: Iconsax.notification,
                        title: 'notifications',
                        subTitle: 'customize notification messages',
                        onTap: () {},
                      ),

                      const SizedBox(height: CSizes.spaceBtnSections),

                      // -- app settings
                      const CSectionHeading(
                        showActionBtn: false,
                        title: 'app settings',
                        btnTitle: '',
                        editFontSize: false,
                      ),
                      const SizedBox(height: CSizes.spaceBtnItems),
                      CMenuTile(
                        icon: Iconsax.document_upload,
                        title: 'upload data',
                        subTitle: 'upload data to your cloud firebase',
                        trailing: IconButton(
                          onPressed: () {},
                          icon: const Icon(Iconsax.arrow_right),
                        ),
                        onTap: () {},
                      ),
                      CMenuTile(
                        icon: Iconsax.location,
                        title: 'geolocation',
                        subTitle: 'set recommendation based on location',
                        trailing: Switch(
                          value: true,
                          activeThumbColor: CColors.rBrown,
                          onChanged: (value) {},
                        ),
                      ),
                      CMenuTile(
                        icon: Iconsax.security_user,
                        title: 'safe mode',
                        subTitle:
                            'search result is safe for people of all ages',
                        trailing: Switch(
                          value: false,
                          activeThumbColor: CColors.rBrown,
                          onChanged: (value) {},
                        ),
                      ),

                      const Divider(),
                      const SizedBox(height: CSizes.spaceBtnItems),
                    ],
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Obx(() {
            if (!invController.isLoading.value &&
                invController.inventoryItems.isEmpty) {
              invController.fetchUserInventoryItems();
            }
            var thisItem = invController.inventoryItems.firstWhere(
              (item) => item.productId == itemId,
            );
            return CAddToCartBottomNavBar(inventoryItem: thisItem);
          }),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                onPressed: () {
                  invController.itemExists.value = true;

                  showDialog(
                    context: context,
                    useRootNavigator: false,
                    builder: (BuildContext context) {
                      invController.currentItemId.value = itemId;
                      invController.txtSupplierName.text = invItem.supplierName;
                      invController.txtSupplierContacts.text =
                          invItem.supplierContacts;

                      invController.includeSupplierDetails.value =
                          invItem.supplierName != '' ||
                          invItem.supplierContacts != '';
                      invController.includeExpiryDate.value =
                          invItem.expiryDate != '';

                      return dialog.buildDialog(
                        context,
                        CInventoryModel.withID(
                          itemId,
                          userController.user.value.id,
                          userController.user.value.email,
                          userController.user.value.fullName,
                          invItem.pCode,
                          invItem.name,
                          invItem.markedAsFavorite,
                          invItem.calibration,
                          invItem.quantity,
                          invItem.qtySold,
                          invItem.qtyRefunded,
                          invItem.buyingPrice,
                          invItem.unitBp,
                          invItem.unitSellingPrice,
                          invItem.lowStockNotifierLimit,
                          invItem.supplierName,
                          invItem.supplierContacts,
                          invItem.dateAdded,
                          invItem.lastModified,
                          invItem.expiryDate,
                          invItem.isSynced,
                          invItem.syncAction,
                        ),
                        false,
                        false,
                      );
                    },
                  );
                  invController.txtId.text = (invItem.productId).toString();
                },
                backgroundColor: Colors.brown,
                foregroundColor: Colors.white,
                child: const Icon(Iconsax.edit, color: CColors.white),
              ),
            ],
          ),
        );
      }),
    );
  }
}
