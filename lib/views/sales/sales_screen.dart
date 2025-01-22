import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:smart_shop_admin/provider/core/api.dart';
import 'package:smart_shop_admin/provider/transactions_api.dart';
import 'package:smart_shop_admin/theme.dart';
import 'package:smart_shop_admin/views/sales/transaction_view.dart';
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

     
       List<Transaction> data =await TransactionsApiService().fetchTransactions();
        setState(() {
          transactions = data;
          filteredTransactions = List.from(transactions); // Initial full list
          isLoading = false;
        });
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
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                "Sales Analytics",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
              ),
              SizedBox(height: 10),
              // Summary Cards
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SummaryCard(
                    title: "Sales",
                    value: "${filteredTransactions.length} ",
                    icon: Icons.receipt,
                  ),
                  SummaryCard(
                    title: "Total Income",
                    value: "\$${getTotalIncome().toStringAsFixed(0)}",
                    icon: Icons.attach_money,
                  ),
                  SummaryCard(
                    title: "Profit",
                    value: "\$${getTotalProfit().toStringAsFixed(0)}",
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
                              : "Start: ${startDate!.toLocal()}".split(' ')[1],
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
                              : "End: ${endDate!.toLocal()}".split(' ')[1],
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
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
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
                                  color: lightBg,
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
                                  onTap: (){Navigator.push(context, MaterialPageRoute(builder: (context)=>TransactionViewScreen(transaction: transaction)));},
                                  leading: CircleAvatar(
                                    backgroundColor:  const Color.fromARGB(255, 70, 134, 244),
                                    child: Icon(Icons.receipt, color: Colors.white),
                                  ),
                                  title: Text(transaction.receiptNumber, style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
                                  subtitle: Text(
                                   "Date: ${transaction.saleDate.toLocal().toString().split(' ')[0].replaceAll('-', '/')}"
                                   
,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  trailing: Text(
                                    "\$${transaction.totalSales.toStringAsFixed(2)}",
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold,color: Colors.black),
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
    return filteredTransactions.fold(0, (sum, transaction) => sum + transaction.totalProfit);
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
        color: darkBg,
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
          Icon(icon, size: 28, color: const Color.fromARGB(255, 37, 117, 255)),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
          ),
        ],
      ),
    );
  }
}
