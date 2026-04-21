import 'package:cri_v3/data/countries.dart';
import 'package:cri_v3/features/store/controllers/inv_controller.dart';
import 'package:cri_v3/features/store/controllers/txns_controller.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CFormatter {
  static String formatDate(DateTime? date) {
    date ??= DateTime.now();
    final onlyDate = DateFormat('dd/MM/yyyy').format(date);
    final onlyTime = DateFormat('hh:mm a').format(date);
    return '$onlyDate at $onlyTime';
  }

  /// -- format time range and return result toString() --
  static int computeTimeRangeFromNow(String end) {
    final startTime = DateTime.now();
    final endTime = DateTime.parse(end);

    var differenceInDays = endTime.difference(startTime).inDays;

    return differenceInDays;
  }

  /// -- format time range and return result toString() --
  static String formatTimeRangeFromNow(String end) {
    final startTime = DateTime.now();
    final endTime = DateTime.parse(end);

    var differenceInDays = endTime.difference(startTime).inDays;
    var differenceInHours = endTime.difference(startTime).inHours;
    var differenceInMinutes = endTime.difference(startTime).inMinutes % 60;
    var formattedRange = '';

    switch (differenceInDays) {
      case < 0 && <= -1:
        differenceInDays = endTime.difference(startTime).inDays.abs();

        formattedRange = differenceInDays == 1
            ? '$differenceInDays day ago'
            : '$differenceInDays days ago';
        break;
      case < 0 && > -1:
        differenceInHours = endTime.difference(startTime).inHours.abs();

        // formattedRange =
        //     '$differenceInHours hour(s) $differenceInMinutes minute(s) ago';

        formattedRange = differenceInHours == 1
            ? '$differenceInHours hour ago'
            : '$differenceInHours hours ago';

        break;
      case >= 0 && < 1:
        differenceInHours = endTime.difference(startTime).inHours.abs();
        differenceInMinutes = endTime.difference(startTime).inMinutes.abs();
        if (differenceInMinutes < 1) {
          formattedRange = 'just now';
          break;
        }
        if (differenceInHours < 1) {
          formattedRange = differenceInMinutes == 1
              ? '$differenceInMinutes minute ago'
              : '$differenceInMinutes minutes ago';
          break;
        }
        if (differenceInHours >= 1) {
          formattedRange = differenceInHours == 1
              ? '$differenceInHours hour ago'
              : '$differenceInHours hours ago';
          break;
        }
        // formattedRange =
        //     '$differenceInHours hour(s) $differenceInMinutes minute(s) ago';

        break;
      case >= 1:
        differenceInDays = endTime.difference(startTime).inDays;
        differenceInHours = endTime.difference(startTime).inHours % 24;
        // formattedRange =
        //     'in $differenceInDays day(s) $differenceInHours hour(s)';
        formattedRange = differenceInDays == 1
            ? 'in $differenceInDays day'
            : 'in $differenceInDays days';
        break;
      default:
        differenceInDays = 0;
        formattedRange = endTime.toString();
    }

    return formattedRange;
  }

  /// -- display values greater than 1000 with a 'K' suffix --
  static String kSuffixFormatter(double amount) {
    final formatter = NumberFormat.compact(locale: 'en_US');
    return formatter.format(amount);
  }

  /// -- extract time from dateTime string --
  static String extractTime(String dateTimeString) {
    final DateTime dateTime = DateTime.parse(dateTimeString);
    return DateFormat('hh:mm:ss').format(dateTime);
  }

  static String formatInventoryMetrics(int productId) {
    final invController = Get.put(CInventoryController());
    final txnsController = Get.put(CTxnsController());

    try {
      var itemInvIndex = invController.inventoryItems.indexWhere(
        (item) => item.productId == productId,
      );

      var soldItemIndex = txnsController.sales.indexWhere(
        (item) => item.productId == productId,
      );
      if (itemInvIndex != -1) {
        var thisItem = invController.inventoryItems.firstWhereOrNull(
          (invItem) => invItem.productId == productId,
        );

        var formattedOutput = thisItem!.calibration == 'units'
            ? thisItem.calibration.substring(0, thisItem.calibration.length - 1)
            : thisItem.calibration;

        return formattedOutput;
      } else if (soldItemIndex != -1) {
        var thisItem = txnsController.sales.firstWhereOrNull(
          (soldItem) => soldItem.productId == productId,
        );

        var formattedOutput =
            thisItem!.itemMetrics == 'units' && thisItem.quantity == 1
            ? thisItem.itemMetrics.substring(0, thisItem.itemMetrics.length - 1)
            : thisItem.itemMetrics;

        return formattedOutput;
      } else {
        CPopupSnackBar.customToast(
          message: 'item is not listed in your inventory list',
          forInternetConnectivityStatus: false,
        );
        return '';
      }
    } catch (e) {
      if (kDebugMode) {
        print('error formatting item metrics: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'error formatting item metrics: $e',
          title: 'item metrics format error!',
        );
      } else {
        CPopupSnackBar.errorSnackBar(
          message: 'error formatting item metrics!',
          title: 'item metrics format error!',
        );
      }
      rethrow;
    }
  }

  static String formatItemMetrics(String metrics, double? qty) {
    try {
      var formattedOutput = metrics == 'units' && qty == 1
          ? metrics.substring(0, metrics.length - 1)
          : metrics != 'units'
          ? '${metrics}s'
          : metrics;

      return formattedOutput;
    } catch (e) {
      if (kDebugMode) {
        print('metrics format error: $e');
        CPopupSnackBar.errorSnackBar(
          message: 'metrics format error: $e',
          title: 'metrics format error!',
        );
      }
      rethrow;
    }
  }

  static String formatItemQtyDisplays(double qty, String itemMetrics) {
    try {
      var output = '';
      switch (itemMetrics) {
        case 'units':
          output = qty.toInt().toString();
          break;
        case 'litre' || 'kg':
          output = qty.toStringAsFixed(2);
          break;
        default:
          output = '';
      }

      return output;
    } catch (e) {
      if (kDebugMode) {
        print('error formatting qty: $e');
        CPopupSnackBar.errorSnackBar(
          message: e.toString(),
          title: 'format error',
        );
      }
      rethrow;
    }
  }

  static bool phoneNumberHasDialCode(String phoneNumber) {
    Map<String, String> foundedCountry = {};

    for (var country in CCountries.allCountries) {
      String dialCode = country["dial_code"].toString();

      if (phoneNumber.contains(dialCode)) {
        foundedCountry = country;
      }
    }

    if (foundedCountry.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  static (String, String) seperatePhoneAndDialCode(String phoneNumber) {
    Map<String, String> foundedCountry = {};
    var newPhoneNumber = '';
    var dialCode = '';

    for (var country in CCountries.allCountries) {
      var countryDialCode = country["dial_code"].toString();

      if (phoneNumber.contains(countryDialCode)) {
        foundedCountry = country;
      }
    }

    if (foundedCountry.isNotEmpty) {
      dialCode = phoneNumber.substring(
        0,
        foundedCountry["dial_code"]!.length,
      );
      newPhoneNumber = phoneNumber.substring(
        foundedCountry["dial_code"]!.length,
      );
    } else {
      dialCode = '';
    }
    return (dialCode, newPhoneNumber);
  }

  // seperatePhoneAndDialCode() {
  //   Map<String, String> foundedCountry = {};
  //   for (var country in Countries.allCountries) {
  //     String dialCode = country["dial_code"].toString();
  //     if (phoneWithDialCode.value.contains(dialCode)) {
  //       foundedCountry = country;
  //     }
  //   }

  //   if (foundedCountry.isNotEmpty) {
  //     var dialCode = phoneWithDialCode.value.substring(
  //       0,
  //       foundedCountry["dial_code"]!.length,
  //     );
  //     var newPhoneNumber = phoneWithDialCode.value.substring(
  //       foundedCountry["dial_code"]!.length,
  //     );
  //     print({dialCode, newPhoneNumber});
  //   }
  // }
}
