import 'dart:convert';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:smart_shop_admin/model/shop_model.dart';
import 'package:smart_shop_admin/views/sales/sales_screen.dart';
import 'package:smart_shop_admin/views/stock/stock_screen.dart';
import '../model/transaction_model.dart';
import '../provider/core/api.dart';
import '../provider/auth_handel.dart';
import '../provider/shop_api_service.dart';
import 'core/charts/chart_colors.dart';
import 'core/charts/line_chart.dart';
import '../theme.dart';
import 'wrapper.dart';
import 'package:http/http.dart' as http;

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<ShopModel> shopData;
  List<Transaction> transactions = [];
  double totalIncome = 0.0;
  double totalProfit = 0.0;
  double avgProfitRate = 0.0;
  bool isLoading = true;

  Future<void> fetchTransactions() async {
    try {
      // Retrieve the auth token from shared preferences
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('auth_token');

      if (authToken == null) {
        throw Exception("Authorization token not found");
      }

      final url = "$baseUrl/shop/api/sales/";

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

          // Calculate the statistics
          totalIncome = transactions.fold(0.0, (sum, t) => sum + t.totalSales);
          totalProfit = transactions.fold(0.0, (sum, t) => sum + t.totalProfit);
          avgProfitRate = transactions.isNotEmpty
              ? (totalProfit / totalIncome) * 100
              : 0.0;

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

  @override
  void initState() {
    super.initState();
    // Fetch shop data when the widget is first created
    shopData = ShopApiService.getShopData();
    fetchTransactions(); // Fetch the transactions as well
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () async {
              await Auth.logout();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => WrapperScreen()),
              );
            },
            icon: const Icon(Icons.logout),
          )
        ],
        backgroundColor: backgroundColor,
        title: const Padding(
          padding: EdgeInsets.all(10),
          child: Text(
            'Dashboard',
            style: TextStyle(color: Colors.white),
          ),
        ),
        centerTitle: true,
        toolbarHeight: kToolbarHeight + 20,
      ),
      backgroundColor: backgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 18),
            // Use FutureBuilder to load the shop data
          FutureBuilder<ShopModel>(
  future: shopData,
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      // Show shimmer effect when loading data
      return Align(
        alignment: Alignment.center,
        child: Shimmer.fromColors(
          baseColor: const Color.fromARGB(255, 74, 93, 125), // Shimmer color base
          highlightColor: const Color.fromARGB(255, 93, 114, 151),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            width: MediaQuery.of(context).size.width * .9,
            height: 100,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 171, 202, 255),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
          ),
        ),
      );
    } else if (snapshot.hasError) {
      return Center(child: Text('Error: ${snapshot.error}'));
    } else if (!snapshot.hasData) {
      return Center(child: Text('No shop data found'));
    } else {
      final shop = snapshot.data!;

      return Align(
        alignment: Alignment.center,
        child: AnimatedOpacity(
          opacity: snapshot.connectionState == ConnectionState.waiting ? 0.7 : 1.0,
          duration: const Duration(milliseconds: 700), // Duration for fade effect
          child: Container(
            width: MediaQuery.of(context).size.width * .9,
            height: 100,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 171, 202, 255),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  shop.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  shop.address,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  },
)
,
            const SizedBox(height: 25),
             Align(
              alignment: Alignment.center,
              child: Text(isLoading ? '':'Last 1 Month Metrics', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoCard('Total Income',  '\$ ${totalIncome.toStringAsFixed(0)}'),
                _buildInfoCard('Total profit','\$ ${totalProfit.toStringAsFixed(0)}'),
                _buildInfoCard('profit Rate', '${avgProfitRate.toStringAsFixed(3)} %'),
              ],
            ),
            const SizedBox(height: 30),
            const SizedBox(height: 10),
             LineChartSample2(),
          ],
        ),
      ),
    );
  }
  
  
  
  Widget _buildInfoCard(String title, String value) {
  return AnimatedOpacity(
    opacity: isLoading ? 0.7 : 1.0,
    duration: const Duration(milliseconds: 700), // Duration of the fade effect
    child: isLoading
        ? Shimmer.fromColors(
            baseColor: ShimmerbaseColor,
            highlightColor: ShimmerhighlightColor,
            child: Container(
              width: 100,
              height: 100,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white, // Background color during shimmer
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 50,
                    height: 10,
                    color: Colors.white,
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 30,
                    height: 10,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          )
        : Container(
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 40, 53, 85), // Background color
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,  // Adjust size as needed
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
  );
}
}


//chart code
