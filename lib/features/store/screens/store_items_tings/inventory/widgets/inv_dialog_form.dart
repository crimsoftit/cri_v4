import 'package:cri_v3/common/widgets/buttons/custom_dropdown_btn.dart';
import 'package:cri_v3/common/widgets/login_signup/form_divider.dart';
import 'package:cri_v3/common/widgets/txt_fields/custom_typeahed_field.dart';
import 'package:cri_v3/features/personalization/controllers/contacts_controller.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/store/controllers/date_controller.dart';
import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/features/store/controllers/nav_menu_controller.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/features/store/models/inv_model.dart';
import 'package:cri_v3/nav_menu.dart' show NavMenu;
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/formatter.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:cri_v3/utils/validators/validation.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class AddUpdateInventoryForm extends StatelessWidget {
  const AddUpdateInventoryForm({
    super.key,
    required this.textStyle,
    required this.inventoryItem,
    required this.fromHomeScreen,
  });

  final bool fromHomeScreen;
  final CInventoryModel inventoryItem;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final contactsController = Get.put(CContactsController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final invController = Get.put(CInventoryController());
    final navController = Get.put(CNavMenuController());
    final txnsController = Get.put(CTxnsController());
    final userController = Get.put(CUserController());
    final currency = CHelperFunctions.formatCurrency(
      userController.user.value.currencyCode,
    );

    return Column(
      children: <Widget>[
        const SizedBox(
          height: CSizes.spaceBtnInputFields / 2,
        ),
        // form to handle input data
        Form(
          key: invController.addInvItemFormKey,
          child: Obx(
            () {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    maintainState: true,
                    visible: false,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: invController.txtId,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Product id',
                            labelStyle: Theme.of(
                              context,
                            ).textTheme.labelSmall,
                          ),
                        ),
                        TextFormField(
                          controller: invController.txtSyncAction,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Sync action',
                            labelStyle: Theme.of(
                              context,
                            ).textTheme.labelSmall,
                          ),
                        ),
                      ],
                    ),
                  ),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: invController.txtCode,
                    //readOnly: true,
                    decoration: InputDecoration(
                      constraints: BoxConstraints(
                        maxHeight: 60.0,
                      ),
                      filled: true,
                      fillColor: isDarkTheme
                          ? CColors.transparent
                          : CColors.lightGrey,
                      labelText: 'Barcode/Sku',
                      labelStyle: Theme.of(
                        context,
                      ).textTheme.labelSmall,
                      prefixIcon: invController.txtCode.text.isNotEmpty
                          ? Icon(
                              Iconsax.barcode,
                              color: CColors.darkGrey,
                              size: CSizes.iconXs,
                            )
                          : TextButton.icon(
                              onPressed: () {
                                invController.txtCode.text =
                                    invController.txtCode.text.isNotEmpty
                                    ? invController.txtCode.text = ''
                                    : CHelperFunctions.generateProductCode()
                                          .toString();
                              },
                              icon: Icon(
                                Iconsax.flash,
                                size: CSizes.iconXs,
                                color: isDarkTheme
                                    ? CColors.darkGrey
                                    : CColors.rBrown,
                              ),
                              label: Text(
                                invController.txtCode.text.isEmpty
                                    ? 'Auto'
                                    : 'Clear',
                                style: Theme.of(context).textTheme.labelSmall!
                                    .apply(
                                      color: isDarkTheme
                                          ? CColors.darkGrey
                                          : CColors.rBrown,
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                            ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Iconsax.scan,
                          size: CSizes.iconSm,
                        ),
                        color: isDarkTheme ? CColors.darkGrey : CColors.rBrown,
                        onPressed: () {
                          invController.scanBarcodeNormal();
                        },
                      ),
                    ),
                    onChanged: (barcodeValue) {
                      invController.fetchItemByCodeAndEmail(barcodeValue);
                    },
                    style: const TextStyle(fontWeight: FontWeight.normal),
                    validator: (value) {
                      return CValidator.validateBarcode('Barcode value', value);
                    },
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields / 1.5,
                  ),

                  // -- product name field --
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: invController.txtNameController,
                    decoration: InputDecoration(
                      constraints: BoxConstraints(
                        maxHeight: 60.0,
                      ),
                      filled: true,
                      fillColor: isDarkTheme
                          ? CColors.transparent
                          : CColors.lightGrey,
                      labelText: 'Product name',
                      labelStyle: Theme.of(
                        context,
                      ).textTheme.labelSmall,
                      prefixIcon: Icon(
                        Iconsax.tag,
                        color: CColors.darkGrey,
                        size: CSizes.iconXs,
                      ),
                    ),
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    validator: (value) {
                      return CValidator.validateEmptyText(
                        'Product name',
                        value,
                      );
                    },
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields / 1.5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // -- item metrics dropdown button --
                      SizedBox(
                        width: CHelperFunctions.screenWidth() * .41,
                        height: 60.0,
                        child: CCustomDropdownBtn(
                          dropdownItems: invController.demMetrics,
                          // defaultItemColor: isDarkTheme
                          //     ? CColors.white
                          //     : CColors.rBrown,
                          // iconColor: isDarkTheme
                          //     ? CColors.white
                          //     : CColors.rBrown,
                          defaultItemColor: CColors.white,
                          defaultItemFontSizeFactor: 1.3,
                          iconColor: CColors.white,
                          onValueChanged: (value) {
                            if (value != '') {
                              invController.itemMetrics.value = value!;
                            }
                          },
                          padding: EdgeInsets.only(
                            bottom: 5.0,
                            left: 5.0,
                            right: 5.0,
                            top: 10.0,
                          ),
                          selectedValue: invController.setItemMetrics(),
                        ),
                      ),

                      // -- inventory qty field --
                      SizedBox(
                        width: CHelperFunctions.screenWidth() * .41,
                        height: 60.0,
                        child: TextFormField(
                          controller: invController.txtQty,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d*\.?\d{0,2}$'),
                            ),
                          ],
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                          decoration: InputDecoration(
                            constraints: BoxConstraints(
                              minHeight: 60.0,
                            ),
                            contentPadding: const EdgeInsets.only(
                              left: 2.0,
                            ),
                            filled: true,
                            fillColor: isDarkTheme
                                ? CColors.transparent
                                : CColors.lightGrey,
                            labelStyle: Theme.of(
                              context,
                            ).textTheme.labelSmall,
                            //labelText:  'qty (units, kg, litre)',
                            labelText:
                                'Qty in ${CFormatter.formatItemMetrics(invController.itemMetrics.value, null)}:',
                            maintainHintSize: true,
                            prefixIcon: Padding(
                              padding: const EdgeInsets.only(left: 2.0),
                              child: Icon(
                                Iconsax.quote_up,
                                color: CColors.darkGrey,
                                size: CSizes.iconXs,
                              ),
                            ),
                          ),
                          validator: (value) {
                            return CValidator.validateNumber(
                              'Qty/No. of units',
                              value,
                            );
                          },
                          onChanged: (value) {
                            if (invController.txtBP.text.isNotEmpty &&
                                value.isNotEmpty) {
                              invController.computeUnitBP(
                                double.parse(
                                  invController.txtBP.text.trim(),
                                ),
                                double.parse(value.trim()),
                              );
                            }

                            if (value.isNotEmpty) {
                              invController.computeLowStockThreshold(
                                double.parse(value.trim()),
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      // -- buying price textfield --
                      SizedBox(
                        width: CHelperFunctions.screenWidth() * .42,
                        height: 60.0,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: invController.txtBP,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+(\.\d*)?'),
                            ),
                          ],
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 1.0,
                            ),
                            constraints: BoxConstraints(
                              minHeight: 60.0,
                            ),
                            filled: true,
                            fillColor: isDarkTheme
                                ? CColors.transparent
                                : CColors.lightGrey,
                            labelStyle: Theme.of(
                              context,
                            ).textTheme.labelSmall,
                            labelText: 'Buying price($currency):',
                            prefixIcon: Icon(
                              // Iconsax.card_pos,
                              Iconsax.bitcoin_card,
                              color: CColors.darkGrey,
                              size: CSizes.iconXs,
                            ),
                          ),
                          onChanged: (value) {
                            if (invController.txtQty.text.isNotEmpty &&
                                value.isNotEmpty) {
                              invController.computeUnitBP(
                                double.parse(value),
                                double.parse(invController.txtQty.text),
                              );
                            }
                          },
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                          validator: (value) {
                            return CValidator.validateNumber(
                              'Buying price',
                              value,
                            );
                          },
                        ),
                      ),

                      SizedBox(
                        width: CSizes.spaceBtnInputFields / 4.0,
                      ),

                      // -- unit selling price field --
                      SizedBox(
                        width: CHelperFunctions.screenWidth() * .42,
                        height: 60.0,
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: invController.txtUnitSP,
                          decoration: InputDecoration(
                            constraints: BoxConstraints(
                              minHeight: 60.0,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 0.0,
                            ),
                            filled: true,
                            fillColor: isDarkTheme
                                ? CColors.transparent
                                : CColors.lightGrey,
                            labelStyle: Theme.of(
                              context,
                            ).textTheme.labelSmall,
                            labelText:
                                invController.itemMetrics.value == '' ||
                                    (invController.itemMetrics.value != '' &&
                                        invController.itemMetrics.value ==
                                            'units')
                                ? 'Unit Selling Price($currency):'
                                : 'Selling price per ${invController.itemMetrics.value}($currency):',
                            maintainHintSize: true,
                            prefixIcon: Icon(
                              Iconsax.bitcoin_card,
                              color: CColors.darkGrey,
                              size: CSizes.iconXs,
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                            signed: false,
                          ),
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(
                              RegExp(r'^\d+(\.\d*)?'),
                            ),
                          ],
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            height: 1.5,
                          ),
                          validator: (value) {
                            return CValidator.validateNumber(
                              'Unit selling price',
                              value,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible:
                        invController.txtBP.text.isEmpty &&
                            invController.txtQty.text.isEmpty
                        ? false
                        : true,
                    replacement: SizedBox.shrink(),
                    child: Container(
                      padding: const EdgeInsets.all(0.0),
                      width: CHelperFunctions.screenWidth() * .95,
                      height:
                          invController.txtBP.text.isEmpty &&
                              invController.txtQty.text.isEmpty
                          ? 0
                          : 14.0,
                      alignment: Alignment.topRight,
                      child: Text(
                        'Unit BP: ~$currency.${invController.unitBP.value.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.labelSmall!.apply(
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ),
                  TextFormField(
                    // autovalidateMode: AutovalidateMode.onUserInteraction,
                    autovalidateMode: AutovalidateMode.onUnfocus,
                    controller: invController.txtStockNotifierLimit,
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(
                        RegExp(r'^\d+(\.\d*)?'),
                      ),
                      // FilteringTextInputFormatter.digitsOnly,
                    ],
                    decoration: InputDecoration(
                      constraints: BoxConstraints(
                        minHeight: 70.0,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 0.0,
                      ),
                      filled: true,
                      fillColor: isDarkTheme
                          ? CColors.transparent
                          : CColors.lightGrey,
                      labelStyle: Theme.of(
                        context,
                      ).textTheme.labelSmall,
                      labelText: 'Notify when qty falls below:',
                      prefixIcon: Icon(
                        // Iconsax.card_pos,
                        Iconsax.quote_down,
                        color: CColors.darkGrey,
                        size: CSizes.iconXs,
                      ),
                    ),
                    onChanged: (value) {},
                    style: const TextStyle(
                      fontWeight: FontWeight.normal,
                    ),
                    validator: (value) {
                      return CValidator.validateNumber(
                        'Alert threshold',
                        value,
                      );
                    },
                  ),

                  Column(
                    children: [
                      Visibility(
                        visible: invController.includeSupplierDetails.value,
                        replacement: SizedBox.shrink(),
                        child: Column(
                          children: [
                            CFormDivider(
                              dividerColor: isDarkTheme
                                  ? CColors.white
                                  : CColors.rBrown,
                              dividerText: 'Supplier\'s details',
                              dividerTxtColor: isDarkTheme
                                  ? CColors.white
                                  : CColors.rBrown,
                              dividerTxtFontSizeFactor: .85,
                            ),

                            const SizedBox(
                              height: CSizes.spaceBtnInputFields / 2.0,
                            ),
                            CCustomTypeahedField(
                              focusedBorderColor: isDarkTheme
                                  ? CColors.grey
                                  : CColors.rBrown,
                              includePrefixIcon: true,
                              labelTxt: 'Supplier\'s name:',
                              onItemSelected: (suggestion) {
                                invController.txtSupplierName.text =
                                    suggestion.contactName;
                                invController.txtSupplierContacts.text =
                                    suggestion.contactPhone != ''
                                    ? suggestion.contactPhone
                                    : suggestion.contactEmail;
                              },
                              prefixIcon: Icon(
                                Iconsax.user_add,
                                color: CColors.darkGrey,
                                size: CSizes.iconXs,
                              ),
                              typeAheadFieldController:
                                  invController.txtSupplierName,
                              fieldValidator: (value) {
                                return fieldValidator(value);
                              },
                            ),

                            const SizedBox(
                              height: CSizes.spaceBtnInputFields / 4.0,
                            ),

                            CCustomTypeahedField(
                              focusedBorderColor: isDarkTheme
                                  ? CColors.grey
                                  : CColors.rBrown,
                              includePrefixIcon: true,
                              labelTxt: 'Supplier\'s phone no. or e-mail:',
                              onItemSelected: (suggestion) {
                                invController.txtSupplierName.text =
                                    suggestion.contactName;
                                invController.txtSupplierContacts.text =
                                    suggestion.contactPhone != ''
                                    ? suggestion.contactPhone
                                    : suggestion.contactEmail;
                              },
                              prefixIcon: Icon(
                                Icons.contact_mail,
                                color: CColors.darkGrey,
                                size: CSizes.iconXs,
                              ),
                              typeAheadFieldController:
                                  invController.txtSupplierContacts,
                              fieldValidator: (value) {
                                if (value == null ||
                                    value == '' ||
                                    (!CValidator.isValidEmail(value.trim()) &&
                                        !CValidator.isValidPhoneNumber(
                                          value.trim(),
                                        ))) {
                                  return 'Please enter a valid phone no. or e-mail address!';
                                }
                                return null;
                              },
                            ),

                            const SizedBox(
                              height: CSizes.spaceBtnInputFields / 2,
                            ),
                          ],
                        ),
                      ),
                      // -- expiry date field --
                      Visibility(
                        replacement: const SizedBox.shrink(),
                        visible: invController.includeExpiryDate.value,

                        child: TextFormField(
                          //autovalidateMode: AutovalidateMode.onUserInteraction,
                          controller: invController.txtExpiryDatePicker,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: isDarkTheme
                                ? CColors.transparent
                                : CColors.lightGrey,
                            labelText: 'Pick expiry date:',
                            labelStyle: Theme.of(
                              context,
                            ).textTheme.labelSmall,
                            prefixIcon: Icon(
                              Iconsax.calendar,
                              color: CColors.darkGrey,
                              size: CSizes.iconXs,
                            ),
                            suffixIcon: InkWell(
                              onTap: () {
                                invController.removeExpiry();
                              },
                              child: IconButton(
                                onPressed: () {
                                  invController.removeExpiry();
                                },
                                icon: Icon(
                                  Iconsax.pen_close,
                                  color: CColors.darkGrey,
                                  size: CSizes.iconSm,
                                ),
                              ),
                            ),
                          ),
                          onTap: () async {
                            final dateController = Get.put(
                              CDateController(),
                            );
                            dateController.triggerCupertinoDatePicker(
                              Get.overlayContext!,
                            );
                          },
                          readOnly: true,
                          style: const TextStyle(
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: CSizes.spaceBtnInputFields,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 4,
                        child: TextButton.icon(
                          icon: Icon(
                            Iconsax.save_add,
                            size: CSizes.iconSm,
                            color: isDarkTheme ? CColors.rBrown : CColors.white,
                          ),
                          label: Text(
                            invController.itemExists.value ? 'Update' : 'Add',
                            style: Theme.of(context).textTheme.labelMedium!
                                .apply(
                                  color: isDarkTheme
                                      ? CColors.rBrown
                                      : CColors.white,
                                ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                CColors.white, // foreground (text) color
                            backgroundColor: isDarkTheme
                                ? CColors.white
                                : CColors.rBrown, // background color
                          ),
                          onPressed: () async {
                            // -- form validation
                            if (!invController.addInvItemFormKey.currentState!
                                .validate()) {
                              return;
                            }

                            if (invController.unitBP.value >
                                double.parse(
                                  invController.txtUnitSP.text.trim(),
                                )) {
                              invController.confirmInvalidUspModal(context);
                              return;
                            }

                            if (!invController.itemExists.value) {
                              inventoryItem.productId =
                                  CHelperFunctions.generateInvId();
                            }

                            // -- check if the inventory item's name has changed --
                            var relatedSoldItems = txnsController.txns
                                .where(
                                  (soldItem) =>
                                      soldItem.productName
                                          .trim()
                                          .toLowerCase() ==
                                      invController.txtNameController.text
                                          .trim()
                                          .toLowerCase(),
                                )
                                .toList();

                            if (relatedSoldItems.isEmpty &&
                                invController.itemExists.value) {
                              // -- update product name in sales db --
                              txnsController.updateRelatedSoldItemsName(
                                inventoryItem,
                                invController.txtNameController.text.trim(),
                              );
                            }

                            if (relatedSoldItems.isNotEmpty &&
                                invController.itemExists.value) {
                              if (kDebugMode) {
                                print(
                                  'product name remains intact!',
                                );
                                // CPopupSnackBar.customToast(
                                //   message: 'product name remains intact',
                                //   forInternetConnectivityStatus: false,
                                // );
                              }
                            }

                            if (await contactsController.contactActionIsAdd(
                                  invController.txtSupplierName.text.trim(),
                                  invController.txtSupplierContacts.text.trim(),
                                ) &&
                                (invController.includeSupplierDetails.value)) {
                            
                              contactsController.addContact(
                                true,
                                null,
                                inventoryItem.productId!,
                              );
                            }

                            if (await invController.addOrUpdateInventoryItem(
                              inventoryItem,
                            )) {
                              // -- check if contact already exists and add if it does not --

                              switch (fromHomeScreen) {
                                case true:
                                  navController.selectedIndex.value = 1;
                                  Navigator.pop(Get.overlayContext!, true);

                                  Get.to(const NavMenu());

                                  break;
                                default:
                                  Navigator.pop(Get.overlayContext!, true);
                                  break;
                              }
                            } else {
                              CPopupSnackBar.errorSnackBar(
                                title: 'Error adding/updating inventory item ',
                              );
                              return;
                            }
                          },
                        ),
                      ),
                      const SizedBox(
                        width: CSizes.spaceBtnSections / 4,
                      ),
                      Expanded(
                        flex: 4,
                        child: TextButton.icon(
                          icon: const Icon(
                            Iconsax.undo,
                            size: CSizes.iconSm,
                            color: CColors.rBrown,
                          ),
                          label: Text(
                            'Back',
                            style:
                                Theme.of(
                                  context,
                                ).textTheme.labelMedium!.apply(
                                  color: CColors.rBrown,
                                ),
                          ),
                          style: ElevatedButton.styleFrom(
                            foregroundColor:
                                CColors.rBrown, // foreground (text) color
                            backgroundColor: CColors.white, // background color
                          ),
                          onPressed: () {
                            //Navigator.pop(context, true);

                            invController.resetInvFields();
                            Navigator.pop(Get.overlayContext!, true);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  String? fieldValidator(value) {
    return CValidator.validateEmptyText(
      'supplier name',
      value,
    );
  }
}
