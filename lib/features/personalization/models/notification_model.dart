// ignore_for_file: unnecessary_getters_setters

class CNotificationsModel {
  int? _notificationId;

  int _alertCreated = 0;
  String _notificationTitle = '';
  String _notificationBody = '';
  int _notificationIsRead = 0;
  int? _productId;
  String _userEmail = '';
  String _date = '';

  CNotificationsModel(
    this._alertCreated,
    this._notificationTitle,
    this._notificationBody,
    this._notificationIsRead,
    this._productId,
    this._userEmail,
    this._date,
  );

  CNotificationsModel.withId(
    this._notificationId,
    this._alertCreated,
    this._notificationTitle,
    this._notificationBody,
    this._notificationIsRead,
    this._productId,
    this._userEmail,
    this._date,
  );

  CNotificationsModel empty() {
    return CNotificationsModel(0, '', '', 0, 0, '', '');
  }

  int? get notificationId => _notificationId;
  int get alertCreated => _alertCreated;
  String get notificationTitle => _notificationTitle;
  String get notificationBody => _notificationBody;
  int get notificationIsRead => _notificationIsRead;
  int? get productId => _productId;
  String get userEmail => _userEmail;
  String get date => _date;

  set notificationId(int? newId) {
    _notificationId = newId;
  }

  set alertCreated(int newAlertCreated) {
    _alertCreated = newAlertCreated;
  }

  set notificationTitle(String newTitle) {
    _notificationTitle = newTitle;
  }

  set notificationBody(String newBody) {
    _notificationBody = newBody;
  }

  set notificationIsRead(int isRead) {
    _notificationIsRead = isRead;
  }

  set productId(int? newProductId) {
    _productId = newProductId;
  }

  set userEmail(String newUserEmail) {
    _userEmail = newUserEmail;
  }

  set date(String newDate) {
    _date = newDate;
  }

  /// -- convert a CNotificationsModel object into a Map object --
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    if (notificationId != null) {
      map['notificationId'] = _notificationId;
    }
    map['alertCreated'] = _alertCreated;
    map['notificationTitle'] = _notificationTitle;
    map['notificationBody'] = _notificationBody;
    map['notificationIsRead'] = _notificationIsRead;
    if (productId != null) {
      map['productId'] = _productId;
    }
    map['userEmail'] = _userEmail;
    map['date'] = _date;

    return map;
  }

  /// -- extract a CNotificationsModel object from a Map object
  CNotificationsModel.fromMapObject(Map<String, dynamic> map) {
    _notificationId = map['notificationId'];
    _alertCreated = map['alertCreated'];
    _notificationTitle = map['notificationTitle'];
    _notificationBody = map['notificationBody'];
    _notificationIsRead = map['notificationIsRead'];
    _productId = map['productId'];
    _userEmail = map['userEmail'];
    _date = map['date'];
  }
}
