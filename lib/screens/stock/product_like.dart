
import 'package:flutter/material.dart';
import 'package:smart_shop_admin/screens/stock/stock_screen.dart';

class ProductTile extends StatelessWidget {
  final Product product;

  const ProductTile({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              'Qty: ${product.quantity}',
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.description, color: Colors.green),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        product.description,
                        style: const TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.qr_code, color: Colors.orange),
                    const SizedBox(width: 8),
                    Text(
                      'Barcode: ${product.barcode}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.category, color: Colors.red),
                    const SizedBox(width: 8),
                    Text(
                      'Category: ${product.category}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.attach_money, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'MRP: \$${product.mrp.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.price_check, color: Colors.purple),
                    const SizedBox(width: 8),
                    Text(
                      'Price: \$${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Viewing ${product.name}'),
                        ),
                      );
                    },
                    icon: const Icon(Icons.visibility),
                    label: const Text('View'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}