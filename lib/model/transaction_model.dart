class Transaction {
  final int id;
  final String receiptNumber;
  final DateTime saleDate;
  final double totalSales;
  final double totalProfit;
  Transaction({
    required this.id,
    required this.receiptNumber,
    required this.saleDate,
    required this.totalSales,
    required this.totalProfit,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      receiptNumber: json['receipt_number'],
      saleDate: DateTime.parse(json['sale_date']),
      totalSales: json['total_sales'] != null
          ? double.tryParse(json['total_sales'].toString()) ?? 0.0
          : 0.0, 
      totalProfit: json['total_profit'] != null
          ? double.tryParse(json['total_profit'].toString()) ?? 0.0
          : 0.0, 

    );
  }
}
