class GsheetsContactModel {
  static const String contactId = 'contactId';
  static const String productId = 'productId';
  static const String addedBy = 'addedBy';
  static const String contactName = 'contactName';
  static const String contactCountryCode = 'contactCountryCode';
  static const String contactDialCode = 'contactDialCode';
  static const String contactPhone = 'contactPhone';
  static const String contactEmail = 'contactEmail';
  static const String contactCategory = 'contactCategory';
  static const String lastModified = 'lastModified';
  static const String createdAt = 'createdAt';
  static const String isSynced = 'isSynced';
  static const String syncAction = 'syncAction';
  static const String isTrashed = 'isTrashed';

  static List<String> getContactsSheetHeaders() {
    return [
      contactId,
      productId,
      addedBy,
      contactName,
      contactCountryCode,
      contactDialCode,
      contactPhone,
      contactEmail,
      contactCategory,
      lastModified,
      createdAt,
      isSynced,
      syncAction,
      isTrashed,
    ];
  }
}
