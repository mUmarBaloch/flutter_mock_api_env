import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../model/transaction_model.dart';

class SalesScreen extends StatefulWidget {
  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  bool isLoading = true;
  List<Transaction> transactions = [];
  List<Transaction> filteredTransactions = [];
  DateTime? startDate;
  DateTime? endDate;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      // Retrieve the auth token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('auth_token');

      if (authToken == null) {
        throw Exception("Authorization token not found");
      }

      // API URL
      const url = "https://7756-39-34-143-142.ngrok-free.app/shop/api/sales/";

      // Make the GET request
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Token $authToken',
        },
      );

      if (response.statusCode == 200) {
        // Parse the JSON response
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          transactions = data
              .map((transactionJson) => Transaction.fromJson(transactionJson))
              .toList();
          filteredTransactions = List.from(transactions); // Initial full list
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load transactions");
      }
    } catch (error) {
      print("Error fetching transactions: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterTransactions() {
    setState(() {
      if (startDate != null && endDate != null) {
        filteredTransactions = transactions.where((transaction) {
          final saleDate = transaction.saleDate;
          return saleDate.isAfter(startDate!.subtract(Duration(days: 1))) &&
              saleDate.isBefore(endDate!.add(Duration(days: 1)));
        }).toList();
      } else {
        filteredTransactions = List.from(transactions); // Reset to full list
      }
    });
  }

  Future<void> selectStartDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selected != null) {
      setState(() {
        startDate = selected;
      });
      filterTransactions();
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (selected != null) {
      setState(() {
        endDate = selected;
      });
      filterTransactions();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Sales Analytics",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 10),
              // Summary Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SummaryCard(
                    title: "Total Transactions",
                    value: "${filteredTransactions.length} ",
                    icon: Icons.receipt,
                  ),
                  SummaryCard(
                    title: "Total Income",
                    value: "\$${getTotalIncome().toStringAsFixed(2)}",
                    icon: Icons.attach_money,
                  ),
                  SummaryCard(
                    title: "Profit",
                    value: "\$${getTotalProfit().toStringAsFixed(2)}",
                    icon: Icons.trending_up,
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Date Pickers
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => selectStartDate(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          startDate == null
                              ? "Select Start Date"
                              : "Start: ${startDate!.toLocal()}".split(' ')[0],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => selectEndDate(context),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Text(
                          endDate == null
                              ? "Select End Date"
                              : "End: ${endDate!.toLocal()}".split(' ')[0],
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey[800]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              // Transactions List Title
              Text(
                "Transactions",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              SizedBox(height: 10),
              // Transactions List
              Expanded(
                child: isLoading
                    ? Center(child: CircularProgressIndicator())
                    : filteredTransactions.isEmpty
                        ? Center(child: Text("No transactions available"))
                        : ListView.builder(
                            itemCount: filteredTransactions.length,
                            itemBuilder: (context, index) {
                              final transaction = filteredTransactions[index];
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 5),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.1),
                                      blurRadius: 8,
                                      offset: Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: ListTile(
                                  leading: CircleAvatar(
                                    backgroundColor: Colors.blueAccent,
                                    child: Icon(Icons.receipt, color: Colors.white),
                                  ),
                                  title: Text(transaction.receiptNumber, style: TextStyle(fontWeight: FontWeight.bold)),
                                  subtitle: Text(
                                   "Date: ${transaction.saleDate.toLocal().toString().split(' ')[0].replaceAll('-', '/')}"
,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                  trailing: Text(
                                    "\$${transaction.totalSales.toStringAsFixed(2)}",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              );
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Calculate Total Income
  double getTotalIncome() {
    return filteredTransactions.fold(0, (sum, transaction) => sum + transaction.totalSales);
  }

  // Assuming no profit data is available in the current API response
  double getTotalProfit() {
    return 0;
  }
}

// Summary Card Widget
class SummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  SummaryCard({required this.title, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28, color: Colors.blueAccent),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
