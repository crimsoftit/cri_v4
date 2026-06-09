class InvSheetFields {
  static const String productId = 'productId';
  static const String userId = 'userId';
  static const String userEmail = 'userEmail';
  static const String userName = 'userName';
  static const String pCode = 'pCode';
  static const String name = 'name';
  static const String markedAsFavorite = 'markedAsFavorite';
  static const String calibration = 'calibration';
  static const String quantity = 'quantity';
  static const String qtySold = 'qtySold';
  static const String qtyRefunded = 'qtyRefunded';
  static const String buyingPrice = 'buyingPrice';
  static const String unitBp = 'unitBp';
  static const String unitSellingPrice = 'unitSellingPrice';
  static const String lowStockNotifierLimit = 'lowStockNotifierLimit';
  static const String supplierName = 'supplierName';
  static const String supplierContacts = 'supplierContacts';
  static const String dateAdded = 'dateAdded';
  static const String lastModified = 'lastModified';
  static const String expiryDate = 'expiryDate';
  static const String isSynced = 'isSynced';
  static const String syncAction = 'syncAction';

  static List<String> getInvSheetHeaders() {
    return [
      productId,
      userId,
      userEmail,
      userName,
      pCode,
      name,
      markedAsFavorite,
      calibration,
      quantity,
      qtySold,
      qtyRefunded,
      buyingPrice,
      unitBp,
      unitSellingPrice,
      lowStockNotifierLimit,
      supplierName,
      supplierContacts,
      dateAdded,
      lastModified,
      expiryDate,
      isSynced,
      syncAction,
    ];
  }
}
