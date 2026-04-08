import 'package:cri_v3/features/store/models/cart_item_model.dart';

class CPriceCalculator {
  CPriceCalculator.init();

  static CPriceCalculator instance = CPriceCalculator.init();

  /// -- variables --
  // final cartController = Get.put(CCartController());

  String computeCartItemsSubTotal(List<CCartItemModel> cartItems) {
    return cartItems
        .fold(
          0.0,
          (double prev, element) => prev + (element.price * element.quantity),
        )
        .toStringAsFixed(2);
  }

  String computeVatTotals(List<CCartItemModel> items) {
    return items
        .fold(
          0.0,
          (double prevValue, nextValue) =>
              prevValue + ((nextValue.price * .19) * nextValue.quantity),
        )
        .toStringAsFixed(2);
  }
}
