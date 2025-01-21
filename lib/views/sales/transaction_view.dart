import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:smart_shop_admin/provider/api.dart';
import '../../model/product_model.dart';
import '../../model/transaction_model.dart';

class TransactionViewScreen extends StatefulWidget {
  final Transaction transaction;

  const TransactionViewScreen({Key? key, required this.transaction})
      : super(key: key);

  @override
  State<TransactionViewScreen> createState() => _TransactionViewScreenState();
}

class _TransactionViewScreenState extends State<TransactionViewScreen> {
  bool isLoading = true;
  List<Map<String, dynamic>> salesItems = [];
  List<Product> products = [];

  @override
  void initState() {
    super.initState();
    fetchTransactionDetails();
  }

  Future<void> fetchTransactionDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('auth_token') ?? '';

      // Fetch sales items
      final salesItemsResponse = await http.get(
        Uri.parse('$baseUrl/shop/api/sale-items/'),
        headers: {'Authorization': 'Token $authToken'},
      );

      if (salesItemsResponse.statusCode == 200) {
        final salesItemsData = jsonDecode(salesItemsResponse.body) as List;
  salesItems = salesItemsData
      .where((item) => item['sale'] == widget.transaction.id)
      .toList()
      .cast<Map<String, dynamic>>(); // Explicit cast

        // Fetch products
        final productsResponse = await http.get(
          Uri.parse('$baseUrl/shop/api/products/'),
          headers: {'Authorization': 'Token $authToken'},
        );

        if (productsResponse.statusCode == 200) {
          final productsData = jsonDecode(productsResponse.body) as List;
          products = productsData
              .map((json) => Product.fromJson(json))
              .toList();

          // Map sales items to include product details
          salesItems = salesItems.map((item) {
            final product = products.firstWhere((prod) => prod.id == item['product'], orElse: () => Product(id: 0, name: "Unknown", categoryName: "", description: "", price: 0.0, inventory: 0));
            return {...item, 'productDetails': product};
          }).toList();
        }
      }
    } catch (error) {
      debugPrint('Error fetching transaction details: $error');
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Invoice: ${widget.transaction.receiptNumber}'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Invoice Details',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text('Receipt Number: ${widget.transaction.receiptNumber}'),
                  Text(
                    'Date: ${widget.transaction.saleDate.toLocal().toString().split(' ')[0].replaceAll('-', '/')}',
                  ),
                  const Divider(height: 20, thickness: 2),
                  Expanded(
                    child: ListView.builder(
                      itemCount: salesItems.length,
                      itemBuilder: (context, index) {
                        final item = salesItems[index];
                        final product = item['productDetails'] as Product;
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Product: ${product.name}',
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text('Category: ${product.categoryName}'),
                              Text(
                                  'Price: \$${double.parse(item['product_price']).toStringAsFixed(2)}'),
                              Text('Quantity: ${item['quantity']}'),
                              Text(
                                  'Subtotal: \$${(item['quantity'] * double.parse(item['product_price'])).toStringAsFixed(2)}'),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  const Divider(height: 20, thickness: 2),
                  Text(
                    'Total: \$${salesItems.fold<double>(0.0, (sum, item) => sum + (item['quantity'] * double.parse(item['product_price']))).toStringAsFixed(2)}',
                    style: Theme.of(context)
                        .textTheme.headlineSmall
                       
                        ?.copyWith(color: Colors.green),
                  ),
                ],
              ),
            ),
    );
  }
}
