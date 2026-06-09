class CPaymentMethodModel {
  CPaymentMethodModel({
    required this.platformLogo,
    required this.platformName,
    this.receivingAccount,
  });

  String platformLogo, platformName;
  String? receivingAccount;

  static CPaymentMethodModel empty() {
    return CPaymentMethodModel(
      platformLogo: '',
      platformName: '',
      receivingAccount: '',
    );
  }
}
