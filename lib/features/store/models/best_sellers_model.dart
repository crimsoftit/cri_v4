// ignore_for_file: unnecessary_getters_setters

class CBestSellersModel {
  int _productId = 0;
  double _totalSales = 0;
  String _productName = "";
  String _itemMetrics = '';
  double _unitSellingPrice = 0.0;
  double _quantity = 0.0;

  CBestSellersModel(
    this._productId,
    this._productName,
    this._itemMetrics,
    this._totalSales,
    this._unitSellingPrice,
    this._quantity,
  );

  //CBestSellersModel.withId(this._productName, this._quantity);

  static List<String> getHeaders() {
    return [
      'productId',
      'productName',
      'itemMetrics',
      'totalSales',
      'unitSellingPrice',
      'quantity',
    ];
  }

  int get productId => _productId;
  String get productName => _productName;
  String get itemMetrics => _itemMetrics;
  double get totalSales => _totalSales;
  double get unitSellingPrice => _unitSellingPrice;
  double get quantity => _quantity;

  set productId(int newPid) {
    _productId = newPid;
  }

  set productName(String newPname) {
    _productName = newPname;
  }

  set itemMetrics(String newMetrics) {
    _itemMetrics = newMetrics;
  }

  set totalSales(double newTotalSales) {
    if (newTotalSales >= 0) {
      _totalSales = newTotalSales;
    }
  }

  set unitSellingPrice(double newUnitSP) {
    _unitSellingPrice = newUnitSP;
  }

  set quantity(double newQty) {
    _quantity = newQty;
  }

  // convert a SoldItemsModel Object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    map['productId'] = _productId;
    map['productName'] = _productName;
    map['itemMetrics'] = _itemMetrics;
    map['totalSales'] = _totalSales;
    map['unitSellingPrice'] = _unitSellingPrice;
    map['quantity'] = _quantity;

    return map;
  }

  // extract a SoldItemsModel object from a Map object
  CBestSellersModel.fromMapObject(Map<String, dynamic> map) {
    _productId = map['productId'];
    _productName = map['productName'];
    _itemMetrics = map['itemMetrics'];
    _totalSales = map['totalSales'];
    _unitSellingPrice = map['unitSellingPrice'];
    _quantity = map['quantity'];
  }
}
