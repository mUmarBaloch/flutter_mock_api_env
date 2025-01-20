import 'package:flutter/material.dart';
import 'package:smart_shop_admin/screens/dashboard.dart';
import 'package:smart_shop_admin/screens/sales_dart.dart';
import 'package:smart_shop_admin/screens/stock/stock_screen.dart';
import 'package:smart_shop_admin/theme.dart';



class BottomNavWrapper extends StatefulWidget {
  const BottomNavWrapper({super.key});

  @override
  State<BottomNavWrapper> createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {
  int _selectedIndex = 1;

  final List<Widget> _widgetOptions =  [
  const  SalesScreen(),
  const  Dashboard(),
   StockScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: backgroundColor,
        selectedLabelStyle: TextStyle(color: backgroundColor),
        unselectedItemColor: Colors.black,
        unselectedLabelStyle:  TextStyle(color: Colors.black),
        onTap:_onItemTapped,items: const [
        BottomNavigationBarItem(label: 'Sales', icon: Icon(Icons.attach_money)),
        BottomNavigationBarItem(
            label: 'Dashboard', icon: Icon(Icons.dashboard)),
        BottomNavigationBarItem(
            label: 'Stocks', icon: Icon(Icons.shopping_cart)),
      ]),
    );
  }
}
