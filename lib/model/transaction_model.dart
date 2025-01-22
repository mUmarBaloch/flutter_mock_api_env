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



List<Transaction> mockTransactions = [
  Transaction(
    id: 1,
    receiptNumber: "R1001",
    saleDate: DateTime.parse("2025-01-01"),
    totalSales: 250.00,
    totalProfit: 50.00,
  ),
  Transaction(
    id: 2,
    receiptNumber: "R1002",
    saleDate: DateTime.parse("2025-01-02"),
    totalSales: 300.00,
    totalProfit: 75.00,
  ),
  Transaction(
    id: 3,
    receiptNumber: "R1003",
    saleDate: DateTime.parse("2025-01-03"),
    totalSales: 150.00,
    totalProfit: 30.00,
  ),
  Transaction(
    id: 4,
    receiptNumber: "R1004",
    saleDate: DateTime.parse("2025-01-04"),
    totalSales: 400.00,
    totalProfit: 100.00,
  ),
  Transaction(
    id: 5,
    receiptNumber: "R1005",
    saleDate: DateTime.parse("2025-01-05"),
    totalSales: 500.00,
    totalProfit: 125.00,
  ),
  Transaction(
    id: 6,
    receiptNumber: "R1006",
    saleDate: DateTime.parse("2025-01-06"),
    totalSales: 600.00,
    totalProfit: 150.00,
  ),
  Transaction(
    id: 7,
    receiptNumber: "R1007",
    saleDate: DateTime.parse("2025-01-07"),
    totalSales: 700.00,
    totalProfit: 175.00,
  ),
  Transaction(
    id: 8,
    receiptNumber: "R1008",
    saleDate: DateTime.parse("2025-01-08"),
    totalSales: 800.00,
    totalProfit: 200.00,
  ),
  Transaction(
    id: 9,
    receiptNumber: "R1009",
    saleDate: DateTime.parse("2025-01-09"),
    totalSales: 900.00,
    totalProfit: 225.00,
  ),
  Transaction(
    id: 10,
    receiptNumber: "R1010",
    saleDate: DateTime.parse("2025-01-10"),
    totalSales: 1000.00,
    totalProfit: 250.00,
  ),
  Transaction(
    id: 11,
    receiptNumber: "R1011",
    saleDate: DateTime.parse("2025-01-11"),
    totalSales: 1100.00,
    totalProfit: 275.00,
  ),
  Transaction(
    id: 12,
    receiptNumber: "R1012",
    saleDate: DateTime.parse("2025-01-12"),
    totalSales: 1200.00,
    totalProfit: 300.00,
  ),
  Transaction(
    id: 13,
    receiptNumber: "R1013",
    saleDate: DateTime.parse("2025-01-13"),
    totalSales: 1300.00,
    totalProfit: 325.00,
  ),
  Transaction(
    id: 14,
    receiptNumber: "R1014",
    saleDate: DateTime.parse("2025-01-14"),
    totalSales: 1400.00,
    totalProfit: 350.00,
  ),
  Transaction(
    id: 15,
    receiptNumber: "R1015",
    saleDate: DateTime.parse("2025-01-15"),
    totalSales: 1500.00,
    totalProfit: 375.00,
  ),
  Transaction(
    id: 16,
    receiptNumber: "R1016",
    saleDate: DateTime.parse("2025-01-16"),
    totalSales: 1600.00,
    totalProfit: 400.00,
  ),
  Transaction(
    id: 17,
    receiptNumber: "R1017",
    saleDate: DateTime.parse("2025-01-17"),
    totalSales: 1700.00,
    totalProfit: 425.00,
  ),
  Transaction(
    id: 18,
    receiptNumber: "R1018",
    saleDate: DateTime.parse("2025-01-18"),
    totalSales: 1800.00,
    totalProfit: 450.00,
  ),
  Transaction(
    id: 19,
    receiptNumber: "R1019",
    saleDate: DateTime.parse("2025-01-19"),
    totalSales: 1900.00,
    totalProfit: 475.00,
  ),
  Transaction(
    id: 20,
    receiptNumber: "R1020",
    saleDate: DateTime.parse("2025-01-20"),
    totalSales: 2000.00,
    totalProfit: 500.00,
  ),
];
