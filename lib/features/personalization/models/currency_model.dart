class CurrencyModel {
  final String country, countryCode;
  final String curCode;

  CurrencyModel({
    required this.country,
    required this.countryCode,
    required this.curCode,
  });

  @override
  toString() => curCode;
}
