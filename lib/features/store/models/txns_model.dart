// ignore_for_file: unnecessary_getters_setters

import 'dart:convert';

import 'package:cri_v3/features/store/models/gsheet_models/txns_sheet_fields.dart';
import 'package:cri_v3/utils/popups/snackbars.dart';
import 'package:flutter/foundation.dart';

class CTxnsModel {
  int? _soldItemId;
  int _txnId = 0;
  String _userId = "";
  String _userEmail = "";
  String _userName = "";

  int _productId = 0;
  String _productCode = "";
  String _productName = "";

  String _itemMetrics = '';
  double _quantity = 0;
  double _qtyRefunded = 0;
  String _refundReason = "";

  double _totalAmount = 0.0;
  double _amountIssued = 0.0;
  double _customerBalance = 0.0;
  double _unitBP = 0.0;
  double _unitSellingPrice = 0.0;
  double _deposit = 0.0;

  String _paymentMethod = "";
  String _customerName = "";
  String _customerContacts = "";
  String _txnAddress = "";
  String _txnAddressCoordinates = "";
  String _lastModified = "";
  int _isSynced = 0;

  String _syncAction = "";
  String _txnStatus = "";

  CTxnsModel(
    this._txnId,
    this._userId,
    this._userEmail,
    this._userName,
    this._productId,
    this._productCode,
    this._productName,
    this._itemMetrics,
    this._quantity,
    this._qtyRefunded,
    this._refundReason,
    this._totalAmount,
    this._amountIssued,
    this._customerBalance,
    this._unitBP,
    this._unitSellingPrice,

    this._deposit,
    this._paymentMethod,
    this._customerName,
    this._customerContacts,
    this._txnAddress,
    this._txnAddressCoordinates,
    this._lastModified,
    this._isSynced,
    this._syncAction,
    this._txnStatus,
  );

  CTxnsModel.monthlySales(this._lastModified);

  CTxnsModel.withId(
    this._soldItemId,
    this._txnId,
    this._userId,
    this._userEmail,
    this._userName,
    this._productId,
    this._productCode,
    this._productName,
    this._itemMetrics,
    this._quantity,
    this._qtyRefunded,
    this._refundReason,
    this._totalAmount,
    this._amountIssued,
    this._customerBalance,
    this._unitBP,
    this._unitSellingPrice,
    this._deposit,
    this._paymentMethod,
    this._customerName,
    this._customerContacts,
    this._txnAddress,
    this._txnAddressCoordinates,
    this._lastModified,
    this._isSynced,
    this._syncAction,
    this._txnStatus,
  );

  static List<String> getHeaders() {
    return [
      'soldItemId',
      'txnId',
      'userId',
      'userEmail',
      'userName',
      'productId',
      'productCode',
      'productName',
      'itemMetrics',
      'quantity',
      'qtyRefunded',
      'refundReason',
      'totalAmount',
      'amountIssued',
      'customerBalance',
      'unitBP',
      'unitSellingPrice',
      'deposit',
      'paymentMethod',
      'customerName',
      'customerContacts',
      'txnAddress',
      'txnAddressCoordinates',
      'lastModified',
      'isSynced',
      'syncAction',
      'txnStatus',
    ];
  }

  int? get soldItemId => _soldItemId;
  int get txnId => _txnId;

  String get userId => _userId;
  String get userEmail => _userEmail;
  String get userName => _userName;
  int get productId => _productId;
  String get productCode => _productCode;
  String get productName => _productName;

  String get itemMetrics => _itemMetrics;
  double get quantity => _quantity;

  double get qtyRefunded => _qtyRefunded;
  String get refundReason => _refundReason;

  double get totalAmount => _totalAmount;
  double get amountIssued => _amountIssued;
  double get customerBalance => _customerBalance;
  double get unitBP => _unitBP;
  double get unitSellingPrice => _unitSellingPrice;

  double get deposit => _deposit;

  String get paymentMethod => _paymentMethod;
  String get customerName => _customerName;
  String get customerContacts => _customerContacts;
  String get txnAddress => _txnAddress;
  String get txnAddressCoordinates => _txnAddressCoordinates;
  String get lastModified => _lastModified;
  int get isSynced => _isSynced;
  String get syncAction => _syncAction;
  String get txnStatus => _txnStatus;

  set soldItemId(int? newsoldItemId) {
    _soldItemId = newsoldItemId;
  }

  set txnId(int newTxnId) {
    if (newTxnId > 1000) {
      _txnId = newTxnId;
    } else {
      if (kDebugMode) {
        print('invalid value for txn ID!!!');
        CPopupSnackBar.errorSnackBar(
          title: 'invalid value',
          message: 'invalid value for txn ID!!!',
        );
      }
    }
  }

  set userId(String newUid) {
    _userId = newUid;
  }

  set userEmail(String newUEmail) {
    _userEmail = newUEmail;
  }

  set userName(String newUName) {
    _userName = newUName;
  }

  set productId(int newPId) {
    productId = newPId;
  }

  set productCode(String newPcode) {
    _productCode = newPcode;
  }

  set productName(String newPname) {
    _productName = newPname;
  }

  set itemMetrics(String newItemMetrics) {
    _itemMetrics = newItemMetrics;
  }

  set quantity(double newQty) {
    if (newQty >= 0.0) {
      _quantity = newQty;
    }
  }

  set qtyRefunded(double newQtyRefunded) {
    _qtyRefunded = newQtyRefunded;
  }

  set refundReason(String newRefundReason) {
    _refundReason = newRefundReason;
  }

  set totalAmount(double newtotalAmount) {
    if (newtotalAmount >= 0) {
      _totalAmount = newtotalAmount;
    }
  }

  set amountIssued(double newAmountIssued) {
    if (newAmountIssued >= 0) {
      _amountIssued = newAmountIssued;
    }
  }

  set customerBalance(double newCustomerBal) {
    _customerBalance = newCustomerBal;
  }

  set unitBP(double newUbp) {
    if (newUbp >= 0.0) {
      _unitBP = newUbp;
    }
  }

  set unitSellingPrice(double newUsp) {
    if (newUsp >= 0.0) {
      _unitSellingPrice = newUsp;
    }
  }

  set deposit(double newDeposit) {
    if (newDeposit >= 0) {
      _deposit = newDeposit;
    }
  }

  set paymentMethod(String newPaymentMethod) {
    if (newPaymentMethod != '') {
      _paymentMethod = newPaymentMethod;
    }
  }

  set customerName(String newCustomerName) {
    _customerName = newCustomerName;
  }

  set customerContacts(String newCustomerContacts) {
    _customerContacts = newCustomerContacts;
  }

  set txnAddress(String newTxnAddress) {
    _txnAddress = newTxnAddress;
  }

  set txnAddressCoordinates(String newTxnAddressCoordinates) {
    _txnAddressCoordinates = newTxnAddressCoordinates;
  }

  set lastModified(String newLastModified) {
    _lastModified = newLastModified;
  }

  set isSynced(int syncStatus) {
    _isSynced = syncStatus;
  }

  set syncAction(String newSyncAction) {
    _syncAction = newSyncAction;
  }

  set txnStatus(String newTxnStatus) {
    _txnStatus = newTxnStatus;
  }

  // convert a SoldItemsModel Object into a Map object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};

    if (soldItemId != null) {
      map['soldItemId'] = _soldItemId;
    }
    map['txnId'] = _txnId;
    map['userId'] = _userId;
    map['userEmail'] = _userEmail;
    map['userName'] = _userName;

    map['productId'] = _productId;
    map['productCode'] = _productCode;
    map['productName'] = _productName;

    map['itemMetrics'] = _itemMetrics;
    map['quantity'] = _quantity;

    map['qtyRefunded'] = _qtyRefunded;
    map['refundReason'] = _refundReason;

    map['totalAmount'] = _totalAmount;
    map['amountIssued'] = _amountIssued;
    map['customerBalance'] = _customerBalance;
    map['unitBP'] = _unitBP;
    map['unitSellingPrice'] = _unitSellingPrice;
    map['deposit'] = _deposit;
    map['paymentMethod'] = _paymentMethod;
    map['customerName'] = _customerName;
    map['customerContacts'] = _customerContacts;
    map['txnAddress'] = _txnAddress;
    map['txnAddressCoordinates'] = _txnAddressCoordinates;
    map['lastModified'] = _lastModified;
    map['isSynced'] = _isSynced;
    map['syncAction'] = _syncAction;
    map['txnStatus'] = _txnStatus;

    return map;
  }

  // extract a SoldItemsModel object from a Map object
  CTxnsModel.fromMapObject(Map<String, dynamic> map) {
    _soldItemId = map['soldItemId'];
    _txnId = map['txnId'];
    _userId = map['userId'];
    _userEmail = map['userEmail'];
    _userName = map['userName'];
    _productId = map['productId'];
    _productCode = map['productCode'];
    _productName = map['productName'];
    _itemMetrics = map['itemMetrics'];
    _quantity = map['quantity'];
    _qtyRefunded = map['qtyRefunded'];
    _refundReason = map['refundReason'];
    _totalAmount = map['totalAmount'];
    _amountIssued = map['amountIssued'];
    _customerBalance = map['customerBalance'];
    _unitBP = map['unitBP'];
    _unitSellingPrice = map['unitSellingPrice'];
    _deposit = map['deposit'];
    _paymentMethod = map['paymentMethod'];
    _customerName = map['customerName'];
    _customerContacts = map['customerContacts'];
    _txnAddress = map['txnAddress'];
    _txnAddressCoordinates = map['txnAddressCoordinates'];
    _lastModified = map['lastModified'];
    _isSynced = map['isSynced'];
    _syncAction = map['syncAction'];
    _txnStatus = map['txnStatus'];
  }

  /// -- extract a CTxnsModel object from a GSheet Map object --
  static CTxnsModel gSheetFromJson(Map<String, dynamic> json) {
    return CTxnsModel.withId(
      jsonDecode(json[TxnsSheetFields.soldItemId]),
      jsonDecode(json[TxnsSheetFields.txnId]),
      json[TxnsSheetFields.userId],
      json[TxnsSheetFields.userEmail],
      json[TxnsSheetFields.userName],
      jsonDecode(json[TxnsSheetFields.productId]),
      json[TxnsSheetFields.productCode],
      json[TxnsSheetFields.productName],
      json[TxnsSheetFields.itemMetrics],
      double.parse(json[TxnsSheetFields.quantity]),
      double.parse(json[TxnsSheetFields.qtyRefunded]),
      json[TxnsSheetFields.refundReason],
      double.parse(json[TxnsSheetFields.totalAmount]),
      double.parse(json[TxnsSheetFields.amountIssued]),
      double.parse(json[TxnsSheetFields.customerBalance]),
      double.parse(json[TxnsSheetFields.unitBP]),
      double.parse(json[TxnsSheetFields.unitSellingPrice]),

      double.parse(json[TxnsSheetFields.deposit]),
      json[TxnsSheetFields.paymentMethod],
      json[TxnsSheetFields.customerName],
      json[TxnsSheetFields.customerContacts],
      json[TxnsSheetFields.txnAddress],
      json[TxnsSheetFields.txnAddressCoordinates],
      json[TxnsSheetFields.lastModified],
      jsonDecode(json[TxnsSheetFields.isSynced]),
      json[TxnsSheetFields.syncAction],
      json[TxnsSheetFields.txnStatus],
    );
  }
}
