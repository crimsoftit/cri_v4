import 'package:cri_v3/common/widgets/products/cart/add_remove_btns.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/store/controllers/cart_controller.dart';
import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/features/store/controllers/search_bar_controller.dart';
import 'package:cri_v3/features/store/models/inv_model.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CTypeAheadSearchField extends StatelessWidget {
  const CTypeAheadSearchField({super.key});

  @override
  Widget build(BuildContext context) {
    final invController = Get.put(CInventoryController());
    final searchBarController = Get.put(CSearchBarController());
    final cartController = Get.put(CCartController());

    final screenWidth = CHelperFunctions.screenWidth();
    final userController = Get.put(CUserController());
    final currencySymbol = CHelperFunctions.formatCurrency(
      userController.user.value.currencyCode,
    );

    return Container(
      //color: Colors.yellow,
      height: 40.0,
      width: screenWidth,
      padding: const EdgeInsets.only(top: 4.0),
      child: TypeAheadField<CInventoryModel>(
        builder: (context, controller, focusNode) {
          return TextFormField(
            autofocus: true,
            controller: controller,
            decoration: InputDecoration(
              border: InputBorder.none,
              prefixIcon: Padding(
                padding: const EdgeInsets.only(
                  bottom: 3.0,
                ),
                child: Icon(
                  Iconsax.search_normal,
                  size: CSizes.iconMd - 5.0,
                ),
              ),
              prefixIconColor: CColors.rBrown.withValues(
                alpha: 0.4,
              ),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(
                  bottom: 4.0,
                ),
                child: InkWell(
                  onTap: () {
                    searchBarController.onTypeAheadSearchIconTap();
                  },
                  child: Icon(
                    Iconsax.close_circle,
                  ),
                ),
              ),
              suffixIconColor: CColors.rBrown.withValues(
                alpha: 0.4,
              ),
              contentPadding: EdgeInsets.all(
                1.0,
              ),
              disabledBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              focusedBorder: InputBorder.none,
              hintStyle: TextStyle(
                color: CColors.rBrown.withValues(alpha: 0.6),
                fontStyle: FontStyle.normal,
              ),
              hintText: 'search store (inventory, txns, dates, etc.)',
              labelStyle: TextStyle(
                color: CColors.rBrown.withValues(alpha: 0.6),
                fontStyle: FontStyle.italic,
              ),
            ),
            focusNode: focusNode,
            style: TextStyle(
              color: CColors.rBrown,
              fontSize: 13.0,
              fontStyle: FontStyle.normal,
              fontWeight: FontWeight.normal,
              //height: 1.1,
            ),
            textAlign: TextAlign.start,
            textAlignVertical: TextAlignVertical.top,
            onFieldSubmitted: (value) {
              searchBarController.onTypeAheadSearchIconTap();
            },
          );
        },
        offset: Offset(0, 14),
        constraints: BoxConstraints(
          maxWidth: screenWidth,
        ),
        suggestionsCallback: (pattern) {
          var matches = invController.inventoryItems;

          return matches
              .where(
                (item) =>
                    item.name.toLowerCase().contains(pattern.toLowerCase()) ||
                    item.productId.toString().toLowerCase().contains(
                      pattern.toLowerCase(),
                    ) ||
                    item.pCode.toLowerCase().contains(pattern.toLowerCase()) ||
                    item.dateAdded.toLowerCase().contains(
                      pattern.toLowerCase(),
                    ) ||
                    item.lastModified.toLowerCase().contains(
                      pattern.toLowerCase(),
                    ),
              )
              .toList();
        },
        itemBuilder: (context, suggestion) {
          return ExpansionTile(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            backgroundColor: CColors.white,
            //collapsedBackgroundColor: CColors.rBrown.withValues(alpha: 0.08),
            collapsedBackgroundColor: CColors.grey,
            expandedCrossAxisAlignment: CrossAxisAlignment.start,
            tilePadding: const EdgeInsets.all(5.0),
            title: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  suggestion.lastModified,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall!.apply(color: CColors.darkGrey),
                ),
                Text(
                  '${suggestion.name.toUpperCase()} (@ $currencySymbol.${suggestion.unitSellingPrice})',
                  style: Theme.of(context).textTheme.labelMedium!.apply(
                    color: CColors.rBrown,
                    fontWeightDelta: 2,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                Text(
                  '#${suggestion.productId}; code: ${suggestion.pCode}; (${suggestion.quantity} stocked)',
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall!.apply(color: CColors.rBrown),
                ),
              ],
            ),
            children: [
              Column(
                children: [
                  Obx(() {
                    return Row(
                      children: [
                        TextButton.icon(
                          onPressed: () async {
                            searchBarController.onTypeAheadSearchIconTap();
                            Navigator.of(context).pop();
                            //Get.back();
                            cartController.initializeItemCountInCart(
                              suggestion,
                            );
                            Get.toNamed(
                              '/inventory/item_details/',
                              arguments: suggestion.productId,
                            );
                          },
                          label: Text(
                            'info',
                            style: Theme.of(context).textTheme.labelMedium!
                                .apply(color: CColors.rBrown),
                          ),
                          icon: const Icon(
                            Iconsax.information,
                            size: CSizes.iconSm,
                            color: CColors.rBrown,
                          ),
                        ),
                        SizedBox(
                          width: CSizes.defaultSpace / 3,
                        ),

                        // -- buttons to increment, decrement qty --
                        CItemQtyWithAddRemoveBtns(
                          displayBorder: false,
                          includeAddToCartActionBtn: true,
                          useSmallIcons: true,
                          useTxtFieldForQty: false,
                          horizontalSpacing: CSizes.spaceBtnItems / 2.0,
                          btnsLeftPadding: 0,
                          btnsRightPadding: 0,
                          iconWidth: 32.0,
                          iconHeight: 32.0,
                          add2CartActionBtnTxt:
                              cartController.itemQtyInCart.value >= 1
                              ? 'added'
                              : 'add',
                          add2CartBtnTxtColor:
                              cartController.itemQtyInCart.value < 1
                              ? CColors.grey
                              : CColors.rBrown,
                          add2CartIconColor:
                              cartController.itemQtyInCart.value < 1
                              ? CColors.grey
                              : CColors.rBrown,
                          // addToCartBtnAction:
                          //     cartController.itemQtyInCart.value < 1
                          //         ? null
                          //         : () {
                          //             // cartController.addToCart(suggestion);
                          //             // cartController.fetchCartItems();
                          //           },
                          addToCartBtnAction: null,

                          removeItemBtnAction: () {
                            invController.fetchUserInventoryItems();
                            cartController.fetchCartItems();
                            int cartItemIndex = cartController.cartItems
                                .indexWhere(
                                  (cartItem) =>
                                      cartItem.productId ==
                                      suggestion.productId,
                                );
                            if (cartItemIndex >= 0) {
                              if (cartController
                                  .getItemQtyInCart(suggestion.productId!)
                                  .isGreaterThan(0)) {
                                final thisCartItem = cartController
                                    .convertInvToCartItem(
                                      suggestion,
                                      suggestion.calibration == 'units'
                                          ? 1
                                          : .25,
                                    );
                                cartController.removeSingleItemFromCart(
                                  thisCartItem,
                                  false,
                                );
                                cartController.fetchCartItems();

                                cartController
                                    .qtyFieldControllers[cartItemIndex]
                                    .text = cartController
                                    .cartItems[cartItemIndex]
                                    .quantity
                                    .toString();
                              }
                            }
                          },
                          qtyWidget: Text(
                            suggestion.calibration == 'units'
                                ? cartController
                                      .getItemQtyInCart(suggestion.productId!)
                                      .toInt()
                                      .toString()
                                : cartController
                                      .getItemQtyInCart(suggestion.productId!)
                                      .toString(),
                            style: Theme.of(context).textTheme.labelMedium!
                                .apply(
                                  color: CColors.rBrown,
                                  fontSizeDelta: 1.5,
                                ),
                          ),

                          // button to increment item qty in the cart
                          addItemBtnAction: () {
                            if (suggestion.quantity > 0) {
                              invController.fetchUserInventoryItems();
                              cartController.fetchCartItems();

                              final thisCartItem = cartController
                                  .convertInvToCartItem(
                                    suggestion,
                                    suggestion.calibration == 'units' ? 1 : .25,
                                  );
                              cartController.addSingleItemToCart(
                                thisCartItem,
                                false,
                                null,
                              );
                            } else {
                              CPopupSnackBar.warningSnackBar(
                                title: 'item is out of stock',
                                message: '${suggestion.name} is out of stock!!',
                              );
                            }
                          },
                          qtyField: null,
                        ),

                        SizedBox(width: CSizes.defaultSpace / 3),
                      ],
                    );
                  }),
                ],
              ),
            ],
          );
        },
        onSelected: (suggestion) {
          // Handle when a suggestion is selected.
          searchBarController.txtTypeAheadFieldController.text =
              suggestion.name;

          //print('Selected item: ${suggestion.name}');
        },
      ),
    );
  }
}
