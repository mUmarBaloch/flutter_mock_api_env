import 'package:flutter/material.dart';
import 'package:smart_shop_admin/model/product_model.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  ProductTile({required this.product});

  double calculateProfit() {
    double price = double.tryParse(product.price.toString()) ?? 0.0;
    double mrp = double.tryParse(product.mrp.toString()) ?? 0.0;
    return price - mrp;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: ExpansionTile(
          title: Row(
            children: [
              // Product ID
              CircleAvatar(
                radius: 25,
                child: Text(
                  product.id.toString(),
                  style: TextStyle(fontSize: 14),
                ),
              ),
              SizedBox(width: 10),
              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Name (with ellipsis)
                    Text(
                      product.name,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis, // Truncate text
                      maxLines: 1, // Limit to one line
                    ),
                    SizedBox(height: 5),
                    // Product Category
                    Text(
                      'Category: ${product.categoryName}',
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                    ),
                    // Product Price
                    Text(
                      'Price: \$${product.price}',
                      style: TextStyle(fontSize: 14),
                    ),
                    // Inventory
                    Text(
                      'Inventory: ${product.inventory}',
                      style: TextStyle(fontSize: 14, color: Colors.green),
                    ),
                  ],
                ),
              ),
            ],
          ),
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category ID and Description
                  Row(
                    children: [
                      const Icon(Icons.category, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        'Category ID: ${product.category}',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.description, color: Colors.green),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Description: ${product.description}',
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.money_off, color: Colors.blue),
                      const SizedBox(width: 8),
                      Text(
                        'MRP: \$${product.mrp}',
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Profit Calculation
                  Row(
                    children: [
                      const Icon(Icons.attach_money, color: Colors.purple),
                      const SizedBox(width: 8),
                      Text(
                        'Profit: \$${calculateProfit().toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 14, color: Colors.green),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
