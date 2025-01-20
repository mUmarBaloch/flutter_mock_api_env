import 'package:flutter/material.dart';
import 'package:smart_shop_admin/screens/sales_dart.dart';
import 'package:smart_shop_admin/screens/stock/stock_screen.dart';
import '../charts/line_chart.dart';
import '../theme.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
            const SizedBox(
              height: 18,
            ),
            Align(
              alignment: Alignment.center,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
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
                child: const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Ahmed Super Store',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'rafsar town, mirpur khas',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 25,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildInfoCard('Total saved', '\$ 673.50'),
                _buildInfoCard('Incomes', '\$ 24.50'),
                _buildInfoCard('Saving rate', '23.50 %'),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
            const Align(
              alignment: Alignment.center,
              child: Text(
                'Sales last three Months',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const LineChartSample2(),
          ],
        ),
      ),
     
    );
  }
}

Widget _buildInfoCard(String title, String value) {
  return Container(
    width: 100,
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
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    ),
  );
}
