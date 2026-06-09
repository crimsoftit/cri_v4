// ignore_for_file: unnecessary_getters_setters, prefer_final_fields

class CInvoicesModel {
  int? _invoiceId;
  int _txnId = 0;

  String _userId = "";
  String _userEmail = "";
  String _userName = "";

  double _amountOwed = 0.0;
  double _amountPaid = 0.0;
  String _customerName = "";
  String _customerContacts = "";
  String _dateAdded = "";
  String _timeStamp = "";
  String _lastModified = "";

  int _isSynced = 0;
  String _syncAction = "";
  String _txnStatus = "";

  CInvoicesModel(
    //this._invoiceId,
    this._txnId,
    this._userId,
    this._userEmail,
    this._userName,
    this._amountOwed,
    this._amountPaid,
    this._customerName,
    this._customerContacts,
    this._dateAdded,
    this._timeStamp,
    this._lastModified,
    this._isSynced,
    this._syncAction,
    this._txnStatus,
  );

  CInvoicesModel.withId(
    this._invoiceId,
    this._txnId,
    this._userId,
    this._userEmail,
    this._userName,
    this._amountOwed,
    this._amountPaid,
    this._customerName,
    this._customerContacts,
    this._dateAdded,
    this._timeStamp,
    this._lastModified,
    this._isSynced,
    this._syncAction,
    this._txnStatus,
  );

  static List<String> getInvoiceHeaders() {
    return [
      'invoiceId',
      'txnId',
      'userId',
      'userEmail',
      'userName',
      'amountOwed',
      'amountPaid',
      'customerName',
      'customerContacts',
      'dateAdded',
      'timeStamp',
      'lastModified',
      'isSynced',
      'syncAction',
      'txnStatus',
    ];
  }

  int? get invoiceId => _invoiceId;
  int get txnId => _txnId;

  String get userId => _userId;
  String get userEmail => _userEmail;
  String get userName => _userName;

  double get amountOwed => _amountOwed;
  double get amountPaid => _amountPaid;

  String get customerName => _customerName;
  String get customerContacts => _customerContacts;

  String get dateAdded => _dateAdded;
  String get timeStamp => _timeStamp;
  String get lastModified => _lastModified;

  int get isSynced => _isSynced;
  String get syncAction => _syncAction;
  String get txnStatus => _txnStatus;

  set invoiceId(int? newInvoiceId) {
    _invoiceId = newInvoiceId;
  }

  set txnId(int newTxnId) {
    _txnId = newTxnId;
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

  set amountOwed(double newAmtOwed) {
    _amountOwed = newAmtOwed;
  }
}
