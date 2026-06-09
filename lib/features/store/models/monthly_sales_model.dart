class CMonthlySalesModel {
  String? month;
  final double totalSales;

  CMonthlySalesModel({
    required this.totalSales,
  });

  CMonthlySalesModel.withMonth({
    this.month,
    required this.totalSales,
  });

  @override
  String toString() {
    return month == null ? '$totalSales' : '$month: $totalSales';
  }
}
