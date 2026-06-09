import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class CInternationalPhoneNumberInput extends StatelessWidget {
  const CInternationalPhoneNumberInput({
    super.key,
    required this.controller,
    this.autoFocus = false,
    this.initialValue,
  });

  final bool autoFocus;
  final PhoneNumber? initialValue;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return InternationalPhoneNumberInput(
      autoFocus: autoFocus,
      textAlign: TextAlign.start,
      onInputChanged:
          (
            PhoneNumber number,
          ) {
            if (kDebugMode) {
              print(
                number.phoneNumber,
              );
              print(
                number.isoCode,
              ); // e.g., US
              print(
                number.dialCode,
              );
            } // e.g., +15551234567
            // e.g., +1
          },
      onInputValidated: (bool value) {
        if (kDebugMode) {
          print(
            'Is valid: $value',
          );
        }
      },
      selectorConfig: SelectorConfig(
        leadingPadding: 10.0,

        selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
        setSelectorButtonAsPrefixIcon: true,
        useBottomSheetSafeArea: true,
        useEmoji: true,
      ),
      ignoreBlank: false,
      autoValidateMode: AutovalidateMode.onUserInteraction,
      // initialValue: PhoneNumber(
      //   isoCode: 'KE',
      // ),
      textFieldController: controller,
      formatInput: true,
      keyboardType: TextInputType.phone,
      inputDecoration: InputDecoration(
        labelText: 'Phone Number',
        border: OutlineInputBorder(),
      ),
    );
  }
}
