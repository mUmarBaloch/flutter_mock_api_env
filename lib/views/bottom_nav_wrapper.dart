import 'package:flutter/material.dart';
import 'package:smart_shop_admin/model/shop_model.dart';
import 'package:smart_shop_admin/provider/shop_api_service.dart';
import 'package:smart_shop_admin/views/dashboard.dart';
import 'package:smart_shop_admin/views/sales/sales_screen.dart';
import 'package:smart_shop_admin/views/stock/stock_screen.dart';
import 'package:smart_shop_admin/theme.dart';

import '../provider/auth_handel.dart';



class BottomNavWrapper extends StatefulWidget {

  const BottomNavWrapper({super.key});

  @override
  State<BottomNavWrapper> createState() => _BottomNavWrapperState();
}

class _BottomNavWrapperState extends State<BottomNavWrapper> {
  
  int _selectedIndex = 1;
  
  final List<Widget> _widgetOptions =  [
    SalesScreen(),
    // ignore: prefer_const_constructors
    Dashboard(),
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
