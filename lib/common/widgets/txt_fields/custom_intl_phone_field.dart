import 'package:cri_v3/features/store/controllers/checkout_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class CCustomIntlPhoneFormField extends StatelessWidget {
  const CCustomIntlPhoneFormField({
    super.key,
    required this.btnTxt,
    required this.intlPhoneFieldController,
    this.fieldHeight = 40.0,

    this.fieldWidth,
    this.formTitle,
    this.onFormBtnPressed,
  });

  final double? fieldHeight, fieldWidth;
  final String? formTitle;
  final String btnTxt;
  final TextEditingController intlPhoneFieldController;

  final VoidCallback? onFormBtnPressed;

  @override
  Widget build(BuildContext context) {
    //final isDarkTheme = CHelperFunctions.isDarkMode(context);
    final checkoutController = Get.put(CCheckoutController());
    FocusNode focusNode = FocusNode();
    GlobalKey<FormState> formKey = GlobalKey<FormState>();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1.0),
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Align(
              alignment: Alignment.topRight,
              child: Text(
                formTitle!,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium!.apply(fontWeightDelta: 2),
              ),
            ),
            const SizedBox(
              height: 15.0,
            ),
            IntlPhoneField(
              controller: intlPhoneFieldController,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderSide: BorderSide()),
                labelText: 'customer phone no.',
                counterStyle: TextStyle(
                  fontSize: 8.0,
                ),
                //fillColor: isDarkTheme ? CColors.darkBg :
              ),
              enabled: true,
              focusNode: focusNode,
              initialCountryCode: 'KE',

              //initialValue: "0",
              languageCode: "en",
              onChanged: (phone) {
                var mpesaNumber = phone.completeNumber.substring(
                  1,
                ); //removes the leading '+');
                var legitMpesaNumber =
                    mpesaNumber.substring(0, 3) +
                    mpesaNumber.substring(
                      4,
                    ); //removes the extra 0 after country code
                if (kDebugMode) {
                  //print(phone.completeNumber);
                  print(legitMpesaNumber);
                }
                checkoutController.customerMpesaNumber.value = legitMpesaNumber;
              },
              onCountryChanged: (country) {
                if (kDebugMode) {
                  print('Country changed to: ${country.name}');
                }
              },
            ),
            const SizedBox(height: 3.0),
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                width: 150.0,
                child: ElevatedButton(
                  onPressed: onFormBtnPressed,
                  child: Text(
                    btnTxt,
                    style: Theme.of(
                      context,
                    ).textTheme.labelMedium!.apply(color: Colors.white),
                  ),
                ),
              ),

              // MaterialButton(
              //   color: Theme.of(context).primaryColor,
              //   textColor: Colors.white,
              //   onPressed: () {
              //     formKey.currentState?.validate();
              //   },
              //   child: const Text('request payment'),
              // ),
            ),
          ],
        ),
      ),
    );
  }
}
