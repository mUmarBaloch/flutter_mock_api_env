import 'package:flutter/material.dart';

import 'product_like.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: StockScreen(),
    );
  }
}

class Product {
  final String name;
  final String description;
  final String barcode;
  final int quantity;
  final double mrp;
  final double price;
  final String category;

  Product({
    required this.name,
    required this.description,
    required this.barcode,
    required this.quantity,
    required this.mrp,
    required this.price,
    required this.category,
  });
}

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  final List<Product> products = [
    Product(name: 'Laptop', description: 'Dell XPS 13', barcode: '123456789', quantity: 5, mrp: 1500, price: 1450, category: 'Electronics'),
    Product(name: 'Phone', description: 'iPhone 14', barcode: '987654321', quantity: 10, mrp: 1100, price: 1050, category: 'Electronics'),
    Product(name: 'Headphones', description: 'Sony WH-1000XM4', barcode: '456789123', quantity: 15, mrp: 350, price: 320, category: 'Audio'),
    Product(name: 'Mouse', description: 'Logitech MX Master 3', barcode: '789123456', quantity: 20, mrp: 120, price: 100, category: 'Accessories'),
    Product(name: 'Keyboard', description: 'Keychron K2', barcode: '321654987', quantity: 8, mrp: 80, price: 70, category: 'Accessories'),
    Product(name: 'Monitor', description: 'LG UltraFine 5K', barcode: '654987321', quantity: 12, mrp: 900, price: 850, category: 'Electronics'),
    Product(name: 'Tablet', description: 'Samsung Galaxy Tab S8', barcode: '147258369', quantity: 7, mrp: 750, price: 720, category: 'Electronics'),
    Product(name: 'Smartwatch', description: 'Apple Watch Series 8', barcode: '369258147', quantity: 13, mrp: 500, price: 470, category: 'Wearables'),
    Product(name: 'Speaker', description: 'JBL Charge 5', barcode: '951753852', quantity: 6, mrp: 200, price: 190, category: 'Audio'),
    Product(name: 'Camera', description: 'Canon EOS R6', barcode: '852456159', quantity: 4, mrp: 2500, price: 2400, category: 'Photography'),
  ];

  List<Product> filteredProducts = [];
  final TextEditingController searchController = TextEditingController();
  String selectedFilter = 'None';

  @override
  void initState() {
    super.initState();
    filteredProducts = products;
  }

  void searchProducts(String query) {
    if (query.isEmpty) {
      setState(() {
        filteredProducts = products;
      });
    } else {
      setState(() {
        filteredProducts = products.where((product) {
          final nameLower = product.name.toLowerCase();
          final queryLower = query.toLowerCase();
          return nameLower.contains(queryLower);
        }).toList();
      });
    }
  }

  void filterProductsByQuantity(String filter) {
    setState(() {
      selectedFilter = filter;
      if (filter == 'Max Quantity') {
        filteredProducts = List.from(products)..sort((a, b) => b.quantity.compareTo(a.quantity));
      } else if (filter == 'Low Quantity') {
        filteredProducts = List.from(products)..sort((a, b) => a.quantity.compareTo(b.quantity));
      } else {
        filteredProducts = products;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock Management'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: searchProducts,
              decoration: const InputDecoration(
                labelText: 'Search Products',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
          Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    DropdownButtonHideUnderline(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: DropdownButton<String>(
          value: selectedFilter,
          isExpanded: true,
          items: const [
            DropdownMenuItem(
              value: 'None',
              child: Row(
                children: [
                  Icon(Icons.filter_alt_outlined, size: 16),
                  SizedBox(width: 4),
                  Text('Sort', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'Max Quantity',
              child: Row(
                children: [
                  Icon(Icons.arrow_downward, size: 16),
                  SizedBox(width: 4),
                  Text('Max Quantity', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'Low Quantity',
              child: Row(
                children: [
                  Icon(Icons.arrow_upward, size: 16),
                  SizedBox(width: 4),
                  Text('Low Quantity', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'Top Price',
              child: Row(
                children: [
                  Icon(Icons.price_check, size: 16),
                  SizedBox(width: 4),
                  Text('Top Price', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
            DropdownMenuItem(
              value: 'Low Price',
              child: Row(
                children: [
                  Icon(Icons.price_change, size: 16),
                  SizedBox(width: 4),
                  Text('Low Price', style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
          onChanged: (value) {
            if (value != null) {
              filterProductsByQuantity(value);
            }
          },
        ),
      ),
    ),
    DropdownButtonHideUnderline(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.45,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey, width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: DropdownButton<String>(
          value: 'Filter by Category',
          isExpanded: true,
          items: const [
            DropdownMenuItem(
              value: 'Filter by Category',
              child: Text('Filter by Category', style: TextStyle(fontSize: 14)),
            ),
            DropdownMenuItem(
              value: 'Dairy',
              child: Text('Dairy', style: TextStyle(fontSize: 14)),
            ),
            DropdownMenuItem(
              value: 'Stationary',
              child: Text('Stationary', style: TextStyle(fontSize: 14)),
            ),
            DropdownMenuItem(
              value: 'Electronics',
              child: Text('Electronics', style: TextStyle(fontSize: 14)),
            ),
            DropdownMenuItem(
              value: 'Accessories',
              child: Text('Accessories', style: TextStyle(fontSize: 14)),
            ),
          ],
          onChanged: (value) {
            // Add functionality here if needed in the future
          },
        ),
      ),
    ),
  ],
),


            const SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: filteredProducts.length,
                itemBuilder: (context, index) {
                  final product = filteredProducts[index];
                  return ProductTile(product: product);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
