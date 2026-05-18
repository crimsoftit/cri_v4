import 'package:cri_v3/common/widgets/buttons/icon_buttons/circular_icon_btn.dart';
import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/common/widgets/dividers/custom_divider.dart';
import 'package:cri_v3/common/widgets/loaders/animated_loader.dart';
import 'package:cri_v3/common/widgets/products/store_item.dart';
import 'package:cri_v3/common/widgets/search_bar/animated_typeahead_field.dart';
import 'package:cri_v3/common/widgets/shimmers/vert_items_shimmer.dart';
import 'package:cri_v3/common/widgets/txt_fields/custom_intl_phone_input_field.dart';
import 'package:cri_v3/common/widgets/txt_widgets/product_price_txt.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/store/controllers/cart_controller.dart';
import 'package:cri_v3/features/store/controllers/checkout_controller.dart';
import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/features/store/controllers/nav_menu_controller.dart';
import 'package:cri_v3/features/store/controllers/search_bar_controller.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/features/store/screens/store_items_tings/checkout/widgets/amt_issued_field.dart';
import 'package:cri_v3/features/store/screens/store_items_tings/checkout/widgets/billing_amount_section.dart';
import 'package:cri_v3/features/store/screens/store_items_tings/checkout/widgets/checkout_scan_fab.dart';
import 'package:cri_v3/features/store/screens/store_items_tings/checkout/widgets/customer_details_screen.dart';
import 'package:cri_v3/features/store/screens/store_items_tings/checkout/widgets/payment_methods/payment_method_section.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/img_strings.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/helpers/network_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CCheckoutScreen extends StatelessWidget {
  const CCheckoutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartController = Get.put(CCartController());
    final checkoutController = Get.put(CCheckoutController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final invController = Get.put(CInventoryController());

    final navController = Get.put(CNavMenuController());
    final scrollController = ScrollController();
    final searchBarController = Get.put(CSearchBarController());
    final txnsController = Get.put(CTxnsController());
    final userController = Get.put(CUserController());

    final currencySymbol = CHelperFunctions.formatCurrency(
      userController.user.value.currencyCode,
    );

    return Container(
      color: isDarkTheme ? CColors.transparent : CColors.white,
      child: Scaffold(
        /// -- app bar --
        appBar: AppBar(
          automaticallyImplyLeading: true,
          iconTheme: IconThemeData(color: CColors.rBrown),
          leading: IconButton(
            icon: Icon(
              Iconsax.arrow_left,
              size: CSizes.iconMd,
              color: CColors.rBrown,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          leadingWidth: 20.0,
          title: Padding(
            padding: const EdgeInsets.only(top: 1.0, left: 0),
            child: Obx(() {
              return searchBarController.showAnimatedTypeAheadField.value
                  ? CAnimatedTypeaheadField(
                      boxColor: CColors.white,
                      searchBarWidth: CHelperFunctions.screenWidth() * .87,
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: CHelperFunctions.screenWidth() * 0.72,
                        ),
                        CAnimatedTypeaheadField(
                          boxColor: CColors.transparent,
                          searchBarWidth: 30.0,
                        ),
                      ],
                    );
            }),
          ),
        ),
        backgroundColor: CColors.rBrown.withValues(alpha: 0.2),
        body: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.only(
              top: CSizes.defaultSpace / 4,
              left: CSizes.defaultSpace / 1.8,
              right: CSizes.defaultSpace / 4,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Chekout',
                        style: Theme.of(context).textTheme.labelLarge!.apply(
                          color: CNetworkManager.instance.hasConnection.value
                              ? CColors.rBrown
                              : CColors.darkGrey,
                          fontSizeFactor: 2.5,
                          fontWeightDelta: -7,
                        ),
                      ),
                      CCheckoutScanFAB(
                        bgColor: CColors.transparent,
                        elevation: 0, // -- remove shadow --
                        foregroundColor:
                            CNetworkManager.instance.hasConnection.value
                            ? CColors.rBrown
                            : CColors.darkGrey,
                      ),
                    ],
                  );
                }),

                /// -- custom divider --
                CCustomDivider(
                  leftPadding: 2.0,
                ),
                const SizedBox(
                  height: CSizes.defaultSpace,
                ),
                Obx(() {
                  /// -- empty data widget --
                  final noDataWidget = CAnimatedLoaderWidget(
                    showActionBtn: true,
                    text: 'Whoops! cart is EMPTY!',
                    actionBtnText: 'Let\'s fill it',
                    animation: CImages.emptyCartLottie,
                    onActionBtnPressed: () {
                      navController.selectedIndex.value = 1;
                      Get.back();
                    },
                  );

                  if (txnsController.isLoading.value ||
                      invController.isLoading.value ||
                      invController.syncIsLoading.value) {
                    return const CVerticalProductShimmer(itemCount: 7);
                  }

                  if (cartController.cartItems.isEmpty &&
                      !cartController.cartItemsLoading.value) {
                    return noDataWidget;
                  }
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                          top: CSizes.defaultSpace / 4,
                          right: CSizes.defaultSpace / 4,
                        ),
                        child: Column(
                          children: [
                            // -- list of items in the cart --
                            SizedBox(
                              height: cartController.cartItems.length <= 2
                                  ? CHelperFunctions.screenHeight() * 0.30
                                  : CHelperFunctions.screenHeight() * 0.38,
                              child: CRoundedContainer(
                                padding: EdgeInsets.all(
                                  CSizes.defaultSpace / 12.0,
                                ),
                                // bgColor: CColors.rBrown.withValues(
                                //   alpha: 0.2,
                                // ),
                                bgColor: CColors.transparent,
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  controller: scrollController,
                                  child: ListView.separated(
                                    shrinkWrap: true,
                                    controller: scrollController,
                                    itemCount: cartController.cartItems.length,
                                    separatorBuilder: (_, __) {
                                      return SizedBox(
                                        height: CSizes.spaceBtnSections / 4,
                                      );
                                    },
                                    itemBuilder: (_, index) {
                                      cartController.qtyFieldControllers.add(
                                        TextEditingController(
                                          text:
                                              cartController
                                                      .cartItems[index]
                                                      .itemMetrics ==
                                                  'units'
                                              ? cartController
                                                    .getItemQtyInCart(
                                                      cartController
                                                          .cartItems[index]
                                                          .productId,
                                                    )
                                                    .toStringAsFixed(0)
                                              : cartController
                                                    .getItemQtyInCart(
                                                      cartController
                                                          .cartItems[index]
                                                          .productId,
                                                    )
                                                    .toStringAsFixed(2),
                                        ),
                                      );

                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CStoreItemWidget(
                                            cartItem:
                                                cartController.cartItems[index],
                                            includeDate: false,
                                          ),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                //mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  // -- some extra space --
                                                  SizedBox(
                                                    //height: 10.0,
                                                    width: 45.0,
                                                  ),
                                                  // -- buttons to increment, decrement qty --
                                                  CRoundedContainer(
                                                    bgColor: isDarkTheme
                                                        ? CColors.dark
                                                        : CColors.white,
                                                    margin:
                                                        const EdgeInsets.only(
                                                          bottom: 13.0,
                                                          top: 5.0,
                                                        ),
                                                    padding:
                                                        const EdgeInsets.only(
                                                          top: 0,
                                                          bottom: 0,
                                                          left: 3.0,
                                                          right:
                                                              3.0, //CSizes.sm,
                                                        ),
                                                    showBorder: isDarkTheme
                                                        ? false
                                                        : true,
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        CCircularIconBtn(
                                                          icon: Iconsax.minus,
                                                          width: 32.0,
                                                          height: 32.0,
                                                          iconBorderRadius: 100,
                                                          iconSize: CSizes.md,
                                                          iconColor: isDarkTheme
                                                              ? CColors.white
                                                              : (cartController.cartItems[index].quantity ==
                                                                            1 &&
                                                                        cartController.cartItems[index].itemMetrics ==
                                                                            'units') ||
                                                                    cartController.cartItems[index].quantity ==
                                                                            .1 &&
                                                                        cartController.cartItems[index].itemMetrics !=
                                                                            'units'
                                                              ? CColors.white
                                                              : CColors.rBrown,
                                                          bgColor:
                                                              (cartController
                                                                              .cartItems[index]
                                                                              .quantity ==
                                                                          1 &&
                                                                      cartController
                                                                              .cartItems[index]
                                                                              .itemMetrics ==
                                                                          'units') ||
                                                                  cartController
                                                                              .cartItems[index]
                                                                              .quantity ==
                                                                          .1 &&
                                                                      cartController
                                                                              .cartItems[index]
                                                                              .itemMetrics !=
                                                                          'units'
                                                              ? CColors.error
                                                              : isDarkTheme
                                                              ? CColors
                                                                    .darkerGrey
                                                              : CColors.light,
                                                          onPressed: () {
                                                            if (cartController
                                                                    .qtyFieldControllers[index]
                                                                    .text !=
                                                                '') {
                                                              invController
                                                                  .fetchUserInventoryItems();
                                                              cartController
                                                                  .fetchCartItems();
                                                              var invItem = invController.inventoryItems.firstWhere(
                                                                (item) =>
                                                                    item.productId
                                                                        .toString() ==
                                                                    cartController
                                                                        .cartItems[index]
                                                                        .productId
                                                                        .toString()
                                                                        .toLowerCase(),
                                                              );
                                                              final thisCartItem =
                                                                  cartController.convertInvToCartItem(
                                                                    invItem,
                                                                    double.parse(
                                                                      cartController
                                                                          .qtyFieldControllers[index]
                                                                          .text
                                                                          .trim(),
                                                                    ),
                                                                  );
                                                              cartController
                                                                  .removeSingleItemFromCart(
                                                                    thisCartItem,
                                                                    true,
                                                                  );
                                                              cartController
                                                                  .fetchCartItems();

                                                              cartController
                                                                      .qtyFieldControllers[index]
                                                                      .text =
                                                                  cartController
                                                                          .cartItems[index]
                                                                          .itemMetrics ==
                                                                      'units'
                                                                  ? cartController
                                                                        .cartItems[index]
                                                                        .quantity
                                                                        .toStringAsFixed(
                                                                          0,
                                                                        )
                                                                  : cartController
                                                                        .cartItems[index]
                                                                        .quantity
                                                                        .toStringAsFixed(
                                                                          2,
                                                                        );
                                                              if (checkoutController
                                                                      .amtIssuedFieldController
                                                                      .text !=
                                                                  '') {
                                                                checkoutController.computeCustomerBal(
                                                                  cartController
                                                                      .totalCartPrice
                                                                      .value,
                                                                  double.parse(
                                                                    checkoutController
                                                                        .amtIssuedFieldController
                                                                        .text
                                                                        .trim(),
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                          },
                                                        ),

                                                        // SizedBox(
                                                        //   width: CSizes
                                                        //       .spaceBtnItems,
                                                        // ),

                                                        // -- field to set quantity --
                                                        SizedBox(
                                                          width:
                                                              CHelperFunctions.screenWidth() *
                                                              .21,
                                                          child: TextFormField(
                                                            controller:
                                                                cartController
                                                                    .qtyFieldControllers[index],
                                                            //initialValue: qtyFieldInitialValue,
                                                            decoration: InputDecoration(
                                                              border: UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                              ),
                                                              contentPadding:
                                                                  EdgeInsets
                                                                      .zero,
                                                              disabledBorder: const UnderlineInputBorder(
                                                                borderSide: BorderSide(
                                                                  color: CColors
                                                                      .darkGrey,
                                                                  width: 1.0,
                                                                ),
                                                              ),
                                                              enabledBorder: const UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                              ),
                                                              errorBorder: UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                      color: CColors
                                                                          .error,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                              ),
                                                              focusedBorder: UnderlineInputBorder(
                                                                borderSide:
                                                                    BorderSide(
                                                                      color: Colors
                                                                          .grey,
                                                                      width:
                                                                          1.0,
                                                                    ),
                                                              ),
                                                              hintText: 'qty',
                                                            ),
                                                            keyboardType:
                                                                const TextInputType.numberWithOptions(
                                                                  decimal: true,
                                                                  signed: false,
                                                                ),
                                                            inputFormatters:
                                                                <
                                                                  TextInputFormatter
                                                                >[
                                                                  FilteringTextInputFormatter.allow(
                                                                    RegExp(
                                                                      r'^\d+(\.\d*)?',
                                                                    ),
                                                                  ),
                                                                ],
                                                            style: TextStyle(
                                                              color: isDarkTheme
                                                                  ? CColors
                                                                        .white
                                                                  : CColors
                                                                        .rBrown,
                                                            ),

                                                            onChanged: (value) {
                                                              // cartController
                                                              //         .displaySaveBtnOnCheckOutItems
                                                              //         .value =
                                                              //     true;
                                                              if (cartController
                                                                          .qtyFieldControllers[index]
                                                                          .text
                                                                          .trim() !=
                                                                      '' &&
                                                                  double.parse(
                                                                        cartController
                                                                            .qtyFieldControllers[index]
                                                                            .text
                                                                            .trim(),
                                                                      ) >
                                                                      0) {
                                                                var invItem = invController.inventoryItems.firstWhere(
                                                                  (item) =>
                                                                      item.productId
                                                                          .toString() ==
                                                                      cartController
                                                                          .cartItems[index]
                                                                          .productId
                                                                          .toString()
                                                                          .toLowerCase(),
                                                                );

                                                                final thisCartItem = cartController.convertInvToCartItem(
                                                                  invItem,
                                                                  double.parse(
                                                                    cartController
                                                                        .qtyFieldControllers[index]
                                                                        .text
                                                                        .trim(),
                                                                  ),
                                                                );

                                                                cartController.addSingleItemToCart(
                                                                  thisCartItem,
                                                                  true,
                                                                  cartController
                                                                      .qtyFieldControllers[index]
                                                                      .text
                                                                      .trim(),
                                                                );
                                                                if (checkoutController
                                                                        .amtIssuedFieldController
                                                                        .text !=
                                                                    '') {
                                                                  checkoutController.computeCustomerBal(
                                                                    cartController
                                                                        .totalCartPrice
                                                                        .value,
                                                                    double.parse(
                                                                      checkoutController
                                                                          .amtIssuedFieldController
                                                                          .text
                                                                          .trim(),
                                                                    ),
                                                                  );
                                                                }
                                                                cartController
                                                                        .displaySaveBtnOnCheckOutItems
                                                                        .value =
                                                                    false;
                                                              }
                                                            },
                                                            textAlign: TextAlign
                                                                .center,
                                                          ),
                                                        ),

                                                        // Padding(
                                                        //   padding:
                                                        //       const EdgeInsets.only(
                                                        //         top: 10.0,
                                                        //       ),
                                                        //   child: Text(
                                                        //     CFormatter.formatItemMetrics(
                                                        //       cartController
                                                        //           .cartItems[index]
                                                        //           .itemMetrics,
                                                        //       cartController
                                                        //           .cartItems[index]
                                                        //           .quantity,
                                                        //     ),
                                                        //   ),
                                                        // ),
                                                        CCircularIconBtn(
                                                          icon: Iconsax.add,
                                                          iconBorderRadius: 100,
                                                          width: 32.0,
                                                          height: 32.0,
                                                          iconSize: CSizes.md,
                                                          iconColor:
                                                              CColors.white,
                                                          bgColor:
                                                              CColors.rBrown,
                                                          onPressed: () {
                                                            if (cartController
                                                                        .qtyFieldControllers[index]
                                                                        .text
                                                                        .trim() !=
                                                                    '' &&
                                                                double.parse(
                                                                      cartController
                                                                          .qtyFieldControllers[index]
                                                                          .text
                                                                          .trim(),
                                                                    ) >
                                                                    0) {
                                                              // invController
                                                              //     .fetchUserInventoryItems();
                                                              // cartController
                                                              //     .fetchCartItems();
                                                              var invItem = invController.inventoryItems.firstWhere(
                                                                (item) =>
                                                                    item.productId
                                                                        .toString() ==
                                                                    cartController
                                                                        .cartItems[index]
                                                                        .productId
                                                                        .toString()
                                                                        .toLowerCase(),
                                                              );
                                                              final thisCartItem =
                                                                  cartController.convertInvToCartItem(
                                                                    invItem,
                                                                    double.parse(
                                                                      cartController
                                                                          .qtyFieldControllers[index]
                                                                          .text
                                                                          .trim(),
                                                                    ),
                                                                  );
                                                              cartController
                                                                  .addSingleItemToCart(
                                                                    thisCartItem,
                                                                    false,
                                                                    null,
                                                                  );
                                                              cartController
                                                                  .fetchCartItems();
                                                              cartController
                                                                      .qtyFieldControllers[index]
                                                                      .text =
                                                                  cartController
                                                                          .cartItems[index]
                                                                          .itemMetrics ==
                                                                      'units'
                                                                  ? cartController
                                                                        .cartItems[index]
                                                                        .quantity
                                                                        .toStringAsFixed(
                                                                          0,
                                                                        )
                                                                  : cartController
                                                                        .cartItems[index]
                                                                        .quantity
                                                                        .toStringAsFixed(
                                                                          2,
                                                                        );
                                                              if (checkoutController
                                                                      .amtIssuedFieldController
                                                                      .text !=
                                                                  '') {
                                                                checkoutController.computeCustomerBal(
                                                                  cartController
                                                                      .totalCartPrice
                                                                      .value,
                                                                  double.parse(
                                                                    checkoutController
                                                                        .amtIssuedFieldController
                                                                        .text,
                                                                  ),
                                                                );
                                                              }
                                                            }
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Visibility(
                                                    visible: cartController
                                                        .displaySaveBtnOnCheckOutItems
                                                        .value,
                                                    child: TextButton.icon(
                                                      icon: Icon(
                                                        Iconsax.save_add,
                                                        color: CColors.rBrown,
                                                      ),
                                                      label: Text(
                                                        'save',
                                                        style: Theme.of(
                                                          context,
                                                        ).textTheme.labelMedium,
                                                      ),
                                                      onPressed: () {
                                                        // invController
                                                        //     .fetchUserInventoryItems();
                                                        // cartController
                                                        //     .fetchCartItems();
                                                        if (cartController
                                                                .qtyFieldControllers[index]
                                                                .text !=
                                                            '') {
                                                          var invItem = invController
                                                              .inventoryItems
                                                              .firstWhere(
                                                                (item) =>
                                                                    item.productId
                                                                        .toString() ==
                                                                    cartController
                                                                        .cartItems[index]
                                                                        .productId
                                                                        .toString()
                                                                        .toLowerCase(),
                                                              );

                                                          final thisCartItem = cartController
                                                              .convertInvToCartItem(
                                                                invItem,
                                                                double.parse(
                                                                  cartController
                                                                      .qtyFieldControllers[index]
                                                                      .text
                                                                      .trim(),
                                                                ),
                                                              );

                                                          cartController
                                                              .addSingleItemToCart(
                                                                thisCartItem,
                                                                true,
                                                                cartController
                                                                    .qtyFieldControllers[index]
                                                                    .text
                                                                    .trim(),
                                                              );
                                                          if (checkoutController
                                                                  .amtIssuedFieldController
                                                                  .text !=
                                                              '') {
                                                            checkoutController
                                                                .computeCustomerBal(
                                                                  cartController
                                                                      .totalCartPrice
                                                                      .value,
                                                                  double.parse(
                                                                    checkoutController
                                                                        .amtIssuedFieldController
                                                                        .text
                                                                        .trim(),
                                                                  ),
                                                                );
                                                          }
                                                          cartController
                                                                  .displaySaveBtnOnCheckOutItems
                                                                  .value =
                                                              false;
                                                        }
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  right: 8.0,
                                                ),
                                                child: CProductPriceTxt(
                                                  price:
                                                      (cartController
                                                                  .cartItems[index]
                                                                  .price *
                                                              cartController
                                                                  .cartItems[index]
                                                                  .quantity)
                                                          .toStringAsFixed(2),
                                                  isLarge: true,
                                                  txtColor: isDarkTheme
                                                      ? CColors.white
                                                      : CColors.rBrown,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: CSizes.defaultSpace / 4,
                            ),

                            // -- billing section --
                            CRoundedContainer(
                              padding: const EdgeInsets.all(CSizes.md / 4),
                              showBorder: true,
                              bgColor: isDarkTheme
                                  ? CColors.black
                                  : CColors.white,
                              child: Column(
                                children: [
                                  // pricing
                                  if (cartController.cartItems.isNotEmpty)
                                    CBillingAmountSection(),
                                  //const SizedBox(height: CSizes.spaceBtnItems),

                                  // divider
                                  if (cartController.cartItems.isNotEmpty)
                                    Divider(),
                                  //const SizedBox(height: CSizes.spaceBtnItems),
                                  // payment methods
                                  if (cartController.cartItems.isNotEmpty)
                                    CPaymentMethodSection(
                                      platformName:
                                          checkoutController
                                                      .selectedPaymentMethod
                                                      .value
                                                      .platformName
                                                      .toLowerCase() ==
                                                  'cash'.toLowerCase() ||
                                              checkoutController
                                                      .selectedPaymentMethod
                                                      .value
                                                      .platformName
                                                      .toLowerCase() ==
                                                  'mPesa (offline)'
                                                      .toLowerCase() ||
                                              checkoutController
                                                      .selectedPaymentMethod
                                                      .value
                                                      .platformName
                                                      .toLowerCase() ==
                                                  'credit'.toLowerCase()
                                          ? checkoutController
                                                .selectedPaymentMethod
                                                .value
                                                .platformName
                                          : '',
                                      platformLogo: checkoutController
                                          .selectedPaymentMethod
                                          .value
                                          .platformLogo,
                                      txtFieldSpace:
                                          checkoutController
                                                  .selectedPaymentMethod
                                                  .value
                                                  .platformName
                                                  .toLowerCase() ==
                                              'cash'.toLowerCase()
                                          ? Row(
                                              children: [
                                                const SizedBox(
                                                  width: CSizes.spaceBtnItems,
                                                  height: 40.0,
                                                ),
                                                CAmountIssuedTxtField(
                                                  txtFieldWidth:
                                                      CHelperFunctions.screenWidth() *
                                                      0.69,
                                                ),
                                              ],
                                            )
                                          : Row(
                                              children: [
                                                const SizedBox(
                                                  width: CSizes.spaceBtnItems,
                                                  height: 40.0,
                                                ),
                                                CRoundedContainer(
                                                  bgColor: CColors.transparent,

                                                  // width:
                                                  //     checkoutController
                                                  //             .selectedPaymentMethod
                                                  //             .value
                                                  //             .platformName
                                                  //             .toLowerCase() ==
                                                  //         "mPesa online"
                                                  //             .toLowerCase()
                                                  //     ? CHelperFunctions.screenWidth() *
                                                  //           .75
                                                  //     : CHelperFunctions.screenWidth() *
                                                  //           0.56,
                                                  width:
                                                      CHelperFunctions.screenWidth() *
                                                      .69,

                                                  child:
                                                      checkoutController
                                                              .selectedPaymentMethod
                                                              .value
                                                              .platformName ==
                                                          'mPesa online'
                                                      ? CInternationalPhoneNumberInput(
                                                          controller:
                                                              checkoutController
                                                                  .customerContactsFieldController,
                                                        )
                                                      // CCustomIntlPhoneFormField(
                                                      //     btnTxt:
                                                      //         'request payment',
                                                      //     // formTitle:
                                                      //     //     'please enter customer phone no. below to send payment request',
                                                      //     fieldWidth: 100.0,
                                                      //     formTitle:
                                                      //         'lipa na mpesa express (online)',
                                                      //     intlPhoneFieldController:
                                                      //         checkoutController
                                                      //             .customerContactsFieldController,
                                                      //     onFormBtnPressed: () async {
                                                      //       final internetIsConnected =
                                                      //           await CNetworkManager
                                                      //               .instance
                                                      //               .isConnected();
                                                      //       if (internetIsConnected) {
                                                      //         checkoutController.initializeMpesaTxn(
                                                      //           cartController
                                                      //               .totalCartPrice
                                                      //               .value,
                                                      //           checkoutController
                                                      //               .customerMpesaNumber
                                                      //               .value,
                                                      //         );
                                                      //       } else {
                                                      //         CPopupSnackBar.warningSnackBar(
                                                      //           title:
                                                      //               'internet connection required',
                                                      //           message:
                                                      //               'internet connection is required to use lipa na mPesa express!',
                                                      //         );
                                                      //       }
                                                      //     },
                                                      //   )
                                                      : CustomerDetailsScreen(),
                                                ),
                                              ],
                                            ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: CSizes.spaceBtnSections),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),

        /// -- bottom navigation bar --
        bottomNavigationBar: Obx(() {
          if (cartController.cartItems.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child:
                  /// -- button to complete/suspend txn --
                  SizedBox(
                    width: CHelperFunctions.screenWidth() * 0.98,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        checkoutController.onCheckoutBtnPressed();
                      },
                      label: SizedBox(
                        height: 38.2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'CHECKOUT',
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .apply(
                                    color: CColors.white,
                                    fontSizeFactor: 0.88,
                                    fontWeightDelta: 1,
                                  ),
                            ),
                            Text(
                              '$currencySymbol.${cartController.totalCartPrice.value.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.bodyMedium!
                                  .apply(
                                    color: CColors.white,
                                    fontSizeFactor: 1.10,
                                    fontWeightDelta: 2,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      icon: Icon(Iconsax.wallet_check, color: CColors.white),
                    ),
                  ),
            );
          } else {
            return SizedBox.shrink();
          }
        }),
      ),
    );
  }
}
