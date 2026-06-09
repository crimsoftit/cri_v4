// ignore_for_file: unnecessary_getters_setters

class CInvDelsModel {
  int? _itemId;
  String _itemName = "";
  String _itemCategory = "";
  int _isSynced = 0;
  String _syncAction = '';

  CInvDelsModel(
    this._itemId,
    this._itemName,
    this._itemCategory,
    this._isSynced,
    this._syncAction,
  );

  int? get itemId => _itemId;
  String get itemName => _itemName;
  String get itemCategory => _itemCategory;
  int get isSynced => _isSynced;
  String get syncAction => _syncAction;

  set itemId(int? newId) {
    _itemId = newId;
  }

  set itemName(String newItemName) {
    itemName = newItemName;
  }

  set itemCategory(String newCategory) {
    _itemCategory = newCategory;
  }

  set isSynced(int syncStatus) {
    _isSynced = syncStatus;
  }

  set syncAction(String newSyncAction) {
    _syncAction = newSyncAction;
  }

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{};
    map['itemId'] = _itemId;
    map['itemName'] = _itemName;
    map['itemCategory'] = _itemCategory;
    map['isSynced'] = _isSynced;
    map['syncAction'] = _syncAction;

    return map;
  }

  CInvDelsModel.fromMapObject(Map<String, dynamic> map) {
    _itemId = map['itemId'];
    _itemName = map['itemName'];
    _itemCategory = map['itemCategory'];
    _isSynced = map['isSynced'];
    _syncAction = map['syncAction'];
  }
}
