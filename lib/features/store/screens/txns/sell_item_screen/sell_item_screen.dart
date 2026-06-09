import 'package:cri_v3/common/widgets/appbar/other_screens_app_bar.dart';
import 'package:cri_v3/features/personalization/controllers/user_controller.dart';
import 'package:cri_v3/features/personalization/screens/profile/widgets/c_profile_menu.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/constants/sizes.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:cri_v3/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class CSellItemScreen extends StatelessWidget {
  const CSellItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final txnsController = Get.put(CTxnsController());
    final userController = Get.put(CUserController());

    final currency = CHelperFunctions.formatCurrency(
      userController.user.value.currencyCode,
    );

    return Obx(() {
      return Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              OtherScreensAppBar(
                showScanner: false,
                title: '#${txnsController.sellItemId.value}',
                trailingIconLeftPadding: CHelperFunctions.screenWidth() * 0.25,
                //trailingIconLeftPadding: 70,
                showBackActionIcon: true,
                showTrailingIcon: true,
                showSubTitle: false,
                subTitle: 'code:',
              ),

              /// -- 4 sale item form fields --
              Padding(
                padding: const EdgeInsets.all(CSizes.defaultSpace),
                child: Form(
                  key: txnsController.txnsFormKey,
                  child: Column(
                    children: [
                      CProfileMenu(
                        titleFlex: 4,
                        secondRowWidgetFlex: 4,
                        title: 'code',
                        value: txnsController.saleItemCode.value,
                        verticalPadding: 7.0,
                        showTrailingIcon: false,
                        onTap: () {},
                      ),
                      CProfileMenu(
                        title: 'name',
                        value: txnsController.saleItemName.value,
                        verticalPadding: 7.0,
                        showTrailingIcon: false,
                        titleFlex: 4,
                        secondRowWidgetFlex: 4,
                        onTap: () {},
                      ),
                      CProfileMenu(
                        title: 'usp',
                        value:
                            '$currency.${(txnsController.saleItemUsp.value)}',
                        verticalPadding: 7.0,
                        showTrailingIcon: false,
                        titleFlex: 4,
                        secondRowWidgetFlex: 4,
                        onTap: () {},
                      ),
                      CProfileMenu(
                        title: 'total amount',
                        value:
                            '$currency.${(txnsController.totalAmount.value)}',
                        verticalPadding: 7.0,
                        titleFlex: 4,
                        secondRowWidgetFlex: 4,
                        showTrailingIcon: false,
                        onTap: () {},
                      ),
                      Visibility(
                        visible: txnsController.showAmountIssuedField.value,
                        child: CProfileMenu(
                          title: 'customer balance',
                          value:
                              '$currency.${(txnsController.customerBal.value)}',
                          verticalPadding: 7.0,
                          showTrailingIcon: false,
                          titleFlex: 4,
                          secondRowWidgetFlex: 4,
                          onTap: () {},
                        ),
                      ),
                      CProfileMenu(
                        title: 'include customer details?',
                        value:
                            '$currency.${(txnsController.totalAmount.value)}',
                        verticalPadding: 7.0,
                        showTrailingIcon: false,
                        titleFlex: 4,
                        secondRowWidgetFlex: 4,
                        valueIsWidget: true,
                        valueWidget: Transform.scale(
                          scale: 0.8,
                          alignment: Alignment.topLeft,
                          child: Switch(
                            value: txnsController.includeCustomerDetails.value,
                            activeThumbColor: CColors.rBrown,
                            onChanged: (value) {
                              txnsController.includeCustomerDetails.value =
                                  value;
                            },
                          ),
                        ),
                        onTap: () {},
                      ),

                      CProfileMenu(
                        title: 'pay via:',
                        valueIsWidget: true,
                        titleFlex: 2,
                        secondRowWidgetFlex: 6,
                        valueWidget: DropdownButtonFormField(
                          hint: Text(
                            txnsController.selectedPaymentMethod.value,
                          ),
                          decoration: const InputDecoration(
                            prefixIcon: Icon(Iconsax.sort),
                          ),
                          //padding: EdgeInsets.only(left: 2),
                          items: ['Cash', 'Mpesa', 'on the house']
                              .map(
                                (option) => DropdownMenuItem(
                                  value: option,
                                  enabled: true,
                                  child: Text(option),
                                ),
                              )
                              .toList(),
                          //value: 'Cash',
                          initialValue:
                              txnsController.selectedPaymentMethod.value,
                          //style: TextStyle(height: 7.0),
                          onChanged: (value) {
                            txnsController.setPaymentMethod(value!);
                          },
                        ),
                        verticalPadding: 15.0,
                        showTrailingIcon: false,
                        onTap: () {},
                      ),
                      // if (salesController.showAmountIssuedField.value)
                      //   const SizedBox(
                      //     height: CSizes.spaceBtnInputFields,
                      //   ),
                      Visibility(
                        visible: txnsController.showAmountIssuedField.value,
                        child: Column(
                          children: [
                            TextFormField(
                              autofocus: false,
                              controller: txnsController.txtAmountIssued,
                              style: TextStyle(
                                height: 0.7,
                                fontWeight: FontWeight.normal,
                                color:
                                    txnsController.customerBalErrorMsg.value ==
                                        'the amount issued is not enough!!'
                                    ? Colors.red
                                    : CColors.rBrown,
                              ),
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: false,
                                  ),
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Iconsax.money,
                                  color:
                                      txnsController
                                              .customerBalErrorMsg
                                              .value ==
                                          'the amount issued is not enough!!'
                                      ? Colors.red
                                      : CColors.rBrown,
                                ),
                                labelText: 'amount issued by customer',
                                // enabledBorder: OutlineInputBorder(
                                //   borderSide: BorderSide(
                                //     color: txnsController
                                //                 .amtIssuedFieldError.value !=
                                //             ''
                                //         ? Colors.red
                                //         : CColors.rBrown,
                                //   ),
                                // ),
                                errorBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                ),
                              ),
                              validator: (value) {
                                if (value!.isEmpty &&
                                    txnsController
                                        .showAmountIssuedField
                                        .value) {
                                  txnsController.amtIssuedFieldError.value ==
                                      'this field is required';
                                  return txnsController
                                      .amtIssuedFieldError
                                      .value;
                                } else {
                                  return CValidator.validateCustomerBal(
                                    'amount issued',
                                    value,
                                    txnsController.totalAmount.value,
                                  );
                                }
                              },
                              onChanged: (value) {
                                txnsController.computeCustomerBal(
                                  double.parse(value),
                                  txnsController.totalAmount.value,
                                );
                              },
                            ),
                            Text(
                              //'${txnsController.customerBalErrorMsg.value} ${txnsController.amtIssuedFieldError.value}',
                              txnsController.amtIssuedFieldError.value,
                              style: Theme.of(context).textTheme.labelMedium!
                                  .apply(
                                    color: Colors.red,
                                    fontStyle: FontStyle.italic,
                                  ),
                            ),
                            const SizedBox(height: CSizes.spaceBtnInputFields),
                          ],
                        ),
                      ),

                      TextFormField(
                        autofocus: true,
                        controller: txnsController.txtSaleItemQty,
                        style: TextStyle(
                          height: 0.7,
                          fontWeight: FontWeight.normal,
                          color:
                              txnsController.stockUnavailableErrorMsg.value ==
                                  'insufficient stock!!'
                              ? Colors.red
                              : CColors.rBrown,
                        ),
                        decoration: InputDecoration(
                          prefixIcon: Icon(
                            Iconsax.quote_up_square,
                            color:
                                txnsController.stockUnavailableErrorMsg.value ==
                                    'insufficient stock!!'
                                ? Colors.red
                                : CColors.grey,
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          hintStyle: TextStyle(
                            color:
                                txnsController.stockUnavailableErrorMsg.value ==
                                    'insufficient stock!!'
                                ? Colors.red
                                : CColors.rBrown,
                          ),
                          labelText:
                              'qty/no.of units (${txnsController.qtyAvailable.value} in stock)',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: false,
                          signed: false,
                        ),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        onChanged: (value) {
                          var usp = txnsController.saleItemUsp.value;
                          txnsController.computeTotals(value, usp);

                          if (txnsController.txtAmountIssued.text != '') {
                            txnsController.computeCustomerBal(
                              double.parse(txnsController.txtAmountIssued.text),
                              txnsController.totalAmount.value,
                            );
                          }
                        },
                      ),

                      /// -- stock insufficient error message
                      Visibility(
                        visible:
                            txnsController.stockUnavailableErrorMsg.value ==
                                'insufficient stock!!'
                            ? true
                            : false,
                        child: Text(
                          txnsController.stockUnavailableErrorMsg.value,
                          style: Theme.of(context).textTheme.labelSmall!.apply(
                            color: Colors.red,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),

                      Visibility(
                        visible: txnsController.includeCustomerDetails.value,
                        child: Column(
                          children: [
                            const SizedBox(
                              height: CSizes.spaceBtnInputFields / 2,
                            ),
                            TextFormField(
                              controller: txnsController.txtCustomerName,
                              style: const TextStyle(
                                height: 0.7,
                                fontWeight: FontWeight.normal,
                              ),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Iconsax.user,
                                  color: CColors.grey,
                                ),
                                labelText: 'customer name(optional)',
                                // labelStyle: TextStyle(
                                //   fontWeight: FontWeight.normal,
                                //   fontStyle: FontStyle.italic,
                                // ),
                              ),
                            ),
                            const SizedBox(
                              height: CSizes.spaceBtnInputFields / 2,
                            ),
                            TextFormField(
                              controller: txnsController.txtCustomerContacts,
                              style: const TextStyle(
                                height: 0.7,
                                fontWeight: FontWeight.normal,
                              ),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Iconsax.mobile,
                                  color: CColors.grey,
                                ),
                                labelText: 'customer contacts(optional)',
                                // labelStyle: TextStyle(
                                //   fontWeight: FontWeight.normal,
                                //   fontStyle: FontStyle.italic,
                                // ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Visibility(
                        visible: false,
                        child: Column(
                          children: [
                            const SizedBox(height: CSizes.spaceBtnInputFields),
                            TextFormField(
                              controller: txnsController.txtTxnAddress,
                              style: const TextStyle(
                                height: 0.7,
                                fontWeight: FontWeight.normal,
                              ),
                              decoration: const InputDecoration(
                                prefixIcon: Icon(
                                  Iconsax.location,
                                  color: CColors.grey,
                                ),
                                labelText: 'txn address',
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: CSizes.spaceBtnInputFields),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              txnsController.stockUnavailableErrorMsg.value ==
                                  'insufficient stock!!'
                              ? null
                              : () async {
                                  if (txnsController.customerBal.value < 0) {
                                    txnsController.customerBalErrorMsg.value ==
                                        'the amount issued is not enough!!';
                                    CPopupSnackBar.errorSnackBar(
                                      title: 'customer still owes you!!',
                                      message:
                                          'the amount issued is not enough',
                                    );
                                    //return;
                                  } else {
                                    if (txnsController.txtAmountIssued.text ==
                                            '' &&
                                        txnsController
                                            .showAmountIssuedField
                                            .value) {
                                      txnsController
                                              .amtIssuedFieldError
                                              .value ==
                                          'please enter the amount issued by customer!!';
                                      CPopupSnackBar.errorSnackBar(
                                        title:
                                            'invalid value for amount issued',
                                        message:
                                            'please enter the amount issued by customer!!',
                                      );
                                    } else {
                                      //txnsController.processTransaction();
                                    }
                                  }
                                },
                          child: Text(
                            txnsController.stockUnavailableErrorMsg.value ==
                                    'insufficient stock!!'
                                ? 'insufficient stock!!'
                                : 'confirm sale',
                            style: Theme.of(context).textTheme.labelMedium!
                                .apply(
                                  fontWeightDelta: 1,
                                  color:
                                      txnsController
                                              .stockUnavailableErrorMsg
                                              .value ==
                                          'insufficient stock!!'
                                      ? Colors.red
                                      : CColors.white,
                                ),
                          ),
                        ),
                      ),
                      Text(txnsController.saleItemCode.value),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
