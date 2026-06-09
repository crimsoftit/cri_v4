// ignore_for_file: unnecessary_getters_setters

class CContactsDelModel {
  int? _id;
  int _contactId = 0;
  String _contactEmail = '';
  String _contactName = '';
  String _contactPhone = '';

  String _deletedBy = '';
  String _deleteDate = '';
  int _isSynced = 0;
  String _syncAction = '';

  /// -- constructor without id --
  CContactsDelModel(
    this._contactId,
    this._contactEmail,
    this._contactName,
    this._contactPhone,
    this._deletedBy,
    this._deleteDate,
    this._isSynced,
    this._syncAction,
  );

  /// -- constructor without id --
  CContactsDelModel.withID(
    this._id,
    this._contactId,
    this._contactEmail,
    this._contactName,
    this._contactPhone,
    this._deletedBy,
    this._deleteDate,
    this._isSynced,
    this._syncAction,
  );

  int? get id => _id;
  int get contactId => _contactId;
  String get contactEmail => _contactEmail;
  String get contactName => _contactName;
  String get contactPhone => _contactPhone;

  String get deletedBy => _deletedBy;
  String get deleteDate => _deleteDate;
  int get isSynced => _isSynced;
  String get syncAction => _syncAction;

  set id(int? newId) {
    _id = newId;
  }

  set contactId(int newContactId) {
    _contactId = newContactId;
  }

  set contactEmail(String newContactEmail) {
    _contactEmail = newContactEmail;
  }

  set contactName(String newContactName) {
    _contactName = newContactName;
  }

  set contactPhone(String newContactPhone) {
    _contactPhone = newContactPhone;
  }

  set deletedBy(String deviceUser) {
    _deletedBy = deviceUser;
  }

  set deleteDate(String newDeleteDate) {
    _deleteDate = newDeleteDate;
  }

  set isSynced(int newIsSynced) {
    _isSynced = newIsSynced;
  }

  set syncAction(String newSyncAction) {
    _syncAction = newSyncAction;
  }

  /// -- convert a CContactsDelModel object into a Map object --
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'contactId': _contactId,
      'contactEmail': _contactEmail,
      'contactName': _contactName,
      'contactPhone': _contactPhone,
      'deletedBy': _deletedBy,
      'deleteDate': _deleteDate,
      'isSynced': _isSynced,
      'syncAction': _syncAction,
    };

    if (id != null) {
      map['id'] = _id;
    }

    return map;
  }

  /// -- extract a CContactsDelModel object from a Map object --
  CContactsDelModel.fromMapObject(Map<String, dynamic> map) {
    _id = map['id'];
    _contactId = map['contactId'];
    _contactEmail = map['contactEmail'];
    _contactName = map['contactName'];
    _contactPhone = map['contactPhone'];
    _deletedBy = map['deletedBy'];
    _deleteDate = map['deleteDate'];
    _isSynced = map['isSynced'];
    _syncAction = map['syncAction'];
  }
}
