// ignore_for_file: unnecessary_getters_setters

class CContactsModel {
  int? _contactId;
  int? _productId;

  String _addedBy = '';
  String _contactName = '';
  String _contactCountryCode = '';
  String _contactIsoCode = '';
  String _contactPhone = '';
  String _contactEmail = '';
  String _contactCategory = '';
  String _lastModified = '';
  String _createdAt = '';
  int _isSynced = 0;
  String _syncAction = '';

  CContactsModel(
    this._addedBy,
    this._productId,
    this._contactName,
    this._contactCountryCode,
    this._contactIsoCode,
    this._contactPhone,
    this._contactEmail,
    this._contactCategory,
    this._lastModified,
    this._createdAt,
    this._isSynced,
    this._syncAction,
  );

  CContactsModel.withId(
    this._addedBy,
    this._productId,
    this._contactId,
    this._contactName,
    this._contactCountryCode,
    this._contactIsoCode,
    this._contactPhone,
    this._contactEmail,
    this._contactCategory,
    this._lastModified,
    this._createdAt,
    this._isSynced,
    this._syncAction,
  );

  CContactsModel empty() {
    return CContactsModel.withId(
      '',
      0,
      0,
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      '',
      0,
      '',
    );
  }

  int? get contactId => _contactId;
  int? get productId => _productId;
  String get addedBy => _addedBy;
  String get contactName => _contactName;
  String get contactCountryCode => _contactCountryCode;
  String get contactIsoCode => _contactIsoCode;
  String get contactPhone => _contactPhone;
  String get contactEmail => _contactEmail;
  String get contactCategory => _contactCategory;
  String get lastModified => _lastModified;
  String get createdAt => _createdAt;
  int get isSynced => _isSynced;
  String get syncAction => _syncAction;

  set contactId(int? newContactId) {
    _contactId = newContactId;
  }

  set productId(int? newProductId) {
    _contactId = newProductId;
  }

  set addedBy(String deviceUser) {
    _addedBy = deviceUser;
  }

  set contactName(String newContactName) {
    _contactName = newContactName;
  }

  set contactCountryCode(String newCountryCode) {
    _contactCountryCode = newCountryCode;
  }

  set contactIsoCode(String newIsoCode) {
    _contactIsoCode = newIsoCode;
  }

  set contactPhone(String newContactPhone) {
    _contactPhone = newContactPhone;
  }

  set contactEmail(String newContactEmail) {
    _contactEmail = newContactEmail;
  }

  set contactCategory(String newContactCategory) {
    _contactCategory = newContactCategory;
  }

  set lastModified(String newLastModified) {
    _lastModified = newLastModified;
  }

  set createdAt(String newCreatedAt) {
    _createdAt = newCreatedAt;
  }

  set isSynced(int newIsSynced) {
    _isSynced = newIsSynced;
  }

  set syncAction(String newSyncAction) {
    _syncAction = newSyncAction;
  }

  /// -- convert a Contact object into a Map object --
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'addedBy': _addedBy,
      'contactName': _contactName,
      'contactCountryCode': _contactCountryCode,
      'contactIsoCode': _contactIsoCode,
      'contactPhone': _contactPhone,
      'contactEmail': _contactEmail,
      'contactCategory': _contactCategory,
      'lastModified': _lastModified,
      'createdAt': _createdAt,
      'isSynced': _isSynced,
      'syncAction': _syncAction,
    };
    if (contactId != null) {
      map['contactId'] = _contactId;
    }
    if (productId != null) {
      map['productId'] = _productId;
    }
    return map;
  }

  /// -- extract a Contact object from a Map object --
  CContactsModel.fromMapObject(Map<String, dynamic> map) {
    _contactId = map['contactId'];
    _productId = map['productId'];
    _addedBy = map['addedBy'];
    _contactName = map['contactName'];
    _contactCountryCode = map['contactCountryCode'];
    _contactIsoCode = map['contactIsoCode'];
    _contactPhone = map['contactPhone'];
    _contactEmail = map['contactEmail'];
    _contactCategory = map['contactCategory'];
    _lastModified = map['lastModified'];
    _createdAt = map['createdAt'];
    _isSynced = map['isSynced'];
    _syncAction = map['syncAction'];
  }
}
