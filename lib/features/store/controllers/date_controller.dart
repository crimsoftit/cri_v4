import 'package:cri_v3/common/widgets/custom_shapes/containers/rounded_container.dart';
import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/utils/helpers/helper_functions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CDateController extends GetxController {
  // Initialize as null-friendly reactive variable
  final Rxn<DateTimeRange> selectedDateRange = Rxn<DateTimeRange>();

  // Optional: with default dates
  // final Rx<DateTimeRange> selectedDateRange = DateTimeRange(
  //   start: DateTime.now(),
  //   end: DateTime.now().add(const Duration(days: 7)),
  // ).obs;

  @override
  void onInit() {
    selectedDateRange.value = null;
    super.onInit();
  }

  Future<void> pickDateRange(BuildContext context) async {
    final DateTimeRange? result = await showDateRangePicker(
      context: context,
      cancelText: 'cancel',
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      saveText: "select",
    );

    if (result != null) {
      final txnsController = Get.put(CTxnsController());
      selectedDateRange.value = result; // Update reactive value

      final rawDateRange = selectedDateRange.value;

      final formattedDateRange =
          "${rawDateRange!.start.toLocal().toString().split(' ')[0]} to "
          "${rawDateRange.end.toLocal().toString().split(' ')[0]}";
      txnsController.dateRangeFieldController.text = formattedDateRange;

      txnsController.summarizeSalesData();
    }
  }

  /// -- use cupertino date picker to pick dates --

  void triggerCupertinoDatePicker(BuildContext context) {
    final firstDate = DateTime(2010, 1);
    final invController = Get.put(CInventoryController());
    final lastDate = DateTime(2100, 1);
    showCupertinoModalPopup(
      context: context,
      builder: (_) => CRoundedContainer(
        bgColor: CupertinoColors.systemBackground.resolveFrom(context),
        height: CHelperFunctions.screenHeight() * .38,
        width: CHelperFunctions.screenWidth() * .8,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // -- action buttons --
            Padding(
              padding: const EdgeInsets.only(
                left: 10.0,
                right: 10.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.cancel,
                    ),
                    onPressed: () {
                      invController.txtExpiryDatePicker.text = '';
                      Navigator.of(context).pop();
                    },
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.check,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: CHelperFunctions.screenHeight() * .3,
              child: CupertinoDatePicker(
                initialDateTime: invController.txtExpiryDatePicker.text != ''
                    ? DateTime.parse(
                        invController.txtExpiryDatePicker.text.replaceAll(
                          '@ ',
                          '',
                        ),
                      )
                    : DateTime.now(),
                maximumDate: lastDate,
                minimumDate: firstDate,
                mode: CupertinoDatePickerMode.date,
                onDateTimeChanged: (DateTime pickedDate) {
                  String formattedDate = DateFormat(
                    "yyyy-MM-dd @ kk:mm",
                  ).format(pickedDate);
                  invController.txtExpiryDatePicker.text = formattedDate;
                },
                showDayOfWeek: true,
                use24hFormat: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
