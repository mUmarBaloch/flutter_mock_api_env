
class Transaction {
  final int id;
  final String receiptNumber;
  final DateTime saleDate;
  final double totalSales;

  Transaction({
    required this.id,
    required this.receiptNumber,
    required this.saleDate,
    required this.totalSales,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      receiptNumber: json['receipt_number'],
      saleDate: DateTime.parse(json['sale_date']),
      totalSales: json['total_sales'],
    );
  }
}
