import 'package:cri_v3/common/widgets/txt_fields/custom_typeahed_field.dart';
import 'package:cri_v3/features/store/controllers/checkout_controller.dart';
import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/utils/constants/colors.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:cri_v3/utils/validators/validation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerDetailsScreen extends StatelessWidget {
  const CustomerDetailsScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final checkoutController = Get.put(CCheckoutController());
    final invController = Get.put(CInventoryController());
    final isDarkTheme = CHelperFunctions.isDarkMode(context);

    return Column(
      children: [
        CCustomTypeahedField(
          fieldHeight:
              checkoutController.customerContactsFieldController.text == ''
              ? 40.0
              : CValidator.isValidPhoneNumber(
                      checkoutController.customerContactsFieldController.text,
                    ) ||
                    CValidator.isValidEmail(
                      checkoutController.customerContactsFieldController.text,
                    )
              ? 40.0
              : 55.0,
          fillColor: isDarkTheme ? CColors.transparent : CColors.white,
          includePrefixIcon: false,
          labelTxt: 'Customer\'s name:',
          minHeight: 50.0,
          onItemSelected: (suggestion) {
            invController.txtSupplierName.text = suggestion.contactName;
            invController.txtSupplierContacts.text =
                suggestion.contactPhone != ''
                ? suggestion.contactPhone
                : suggestion.contactEmail;
          },
          prefixIcon: SizedBox.shrink(),
          typeAheadFieldController:
              checkoutController.customerNameFieldController,
        ),
        // CCustomTxtField(
        //   labelTxt: 'Customer name',
        //   // checkoutController
        //   //             .selectedPaymentMethod
        //   //             .value
        //   //             .platformName.toLowerCase() ==
        //   //         'mPesa (offline)'.toLowerCase() ||
        //   //     checkoutController
        //   //             .selectedPaymentMethod
        //   //             .value
        //   //             .platformName.toLowerCase() ==
        //   //         'credit'.toLowerCase()
        //   // ? 'customer name'
        //   // : 'customer name(optional)',
        //   txtFieldController: checkoutController.customerNameFieldController,
        // ),
        const SizedBox(
          height: 4.0,
        ),
        // -- contacts field --
        CCustomTypeahedField(
          fieldHeight:
              checkoutController.customerContactsFieldController.text == ''
              ? 40.0
              : CValidator.isValidPhoneNumber(
                      checkoutController.customerContactsFieldController.text,
                    ) ||
                    CValidator.isValidEmail(
                      checkoutController.customerContactsFieldController.text,
                    )
              ? 40.0
              : 55.0,
          fillColor: isDarkTheme ? CColors.transparent : CColors.white,
          includePrefixIcon: false,
          labelTxt: 'Phone no. or e-mail:',
          minHeight: 50.0,
          onItemSelected: (suggestion) {
            invController.txtSupplierName.text = suggestion.contactName;
            invController.txtSupplierContacts.text =
                suggestion.contactPhone != ''
                ? suggestion.contactPhone
                : suggestion.contactEmail;
          },
          prefixIcon: SizedBox.shrink(),
          typeAheadFieldController:
              checkoutController.customerContactsFieldController,
          fieldValidator: (value) {
            if (value == null ||
                value == '' ||
                (!CValidator.isValidEmail(
                      value.trim(),
                    ) &&
                    !CValidator.isValidPhoneNumber(
                      value.trim(),
                    ))) {
              return 'Please enter a valid phone no. e-mail address!';
            }
            return null;
          },
        ),
        // CCustomTxtField(
        //   txtFieldController:
        //       checkoutController
        //           .customerContactsFieldController,
        //   labelTxt:
        //       'contacts',
        //   // labelTxt:
        //   //     checkoutController
        //   //             .selectedPaymentMethod
        //   //             .value
        //   //             .platformName ==
        //   //         'mPesa (offline)'
        //   //     ? 'contacts (optional)'
        //   //     : 'contacts',
        // ),
      ],
    );
  }
}
