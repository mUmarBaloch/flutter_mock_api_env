import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_shop_admin/model/product_model.dart';
import 'package:smart_shop_admin/provider/core/api.dart';
import 'package:smart_shop_admin/theme.dart';
import 'product_tile.dart';
import 'package:http/http.dart' as http;

class StockScreen extends StatefulWidget {
  @override
  _StockScreenState createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {
  List<Product> allProducts = [];
  List<Product> displayedProducts = [];
  List<String> categories = [];
  String? selectedCategory = 'All';
  String? selectedSort;
  TextEditingController _searchController = TextEditingController();
  bool isLoading = true;  // To track the loading state

  @override
  void initState() {
    super.initState();
    fetchCategories();
    fetchProducts();
  }

  Future<void> fetchCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/shop/api/product-categories/'),
        headers: {'Authorization': 'Token $authToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          categories = (data as List).map((e) => e['name'] as String).toList();
        });
      } else {
        throw Exception('Failed to fetch categories');
      }
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
  }

  Future<void> fetchProducts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final authToken = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse('$baseUrl/shop/api/products/'),
        headers: {'Authorization': 'Token $authToken'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<Product> fetchedProducts =
            (data as List).map((e) => Product.fromJson(e)).toList();

        setState(() {
          allProducts = fetchedProducts;
          displayedProducts = List.from(allProducts);
          isLoading = false; // Set loading to false once data is fetched
        });
      } else {
        throw Exception('Failed to fetch products');
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
    }
  }

  void applyFilters() {
    List<Product> filteredProducts = List.from(allProducts);

    // Filter by category
    if (selectedCategory != null && selectedCategory != 'All') {
      filteredProducts = filteredProducts
          .where((product) => product.categoryName == selectedCategory)
          .toList();
    }

    // Sort by selected criteria
    if (selectedSort != null) {
      switch (selectedSort) {
        case 'Max Inventory':
          filteredProducts.sort((a, b) => b.inventory.compareTo(a.inventory));
          break;
        case 'Low Inventory':
          filteredProducts.sort((a, b) => a.inventory.compareTo(b.inventory));
          break;
        case 'Max Price':
          filteredProducts.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'Low Price':
          filteredProducts.sort((a, b) => a.price.compareTo(b.price));
          break;
      }
    }

    // Filter by search title
    String searchQuery = _searchController.text.toLowerCase();
    if (searchQuery.isNotEmpty) {
      filteredProducts = filteredProducts
          .where((product) =>
              product.name.toLowerCase().contains(searchQuery))
          .toList();
    }

    setState(() {
      displayedProducts = filteredProducts;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        title: Text('Total Stocks: ${displayedProducts.length}',style: TextStyle(color: Colors.white),),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:TextField(
  controller: _searchController,
  onChanged: (value) => applyFilters(),
  decoration: InputDecoration(
    labelText: 'Search by Title',
    labelStyle: TextStyle(color: Colors.white),
    prefixIcon: Icon(Icons.search,color: Colors.white,),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(color: darkBg), // Default border color
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: darkBg), // Focused border color
    ),
  ),
),
          ),
          // Filter and Sort Options
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Filter by Category Dropdown
                DropdownButton<String>(
                  value: selectedCategory,
                  
                  hint: Text('Select Category'),
                 
                  
                  items: ['All', ...categories].map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedCategory = value;
                    });
                    applyFilters();
                  },
                ),
                // Sort Dropdown
                DropdownButton<String>(
                  value: selectedSort,
                  hint: Text('Sort By'),
                  items: [
                    'Max Inventory',
                    'Low Inventory',
                    'Max Price',
                    'Low Price'
                  ].map((sort) {
                    return DropdownMenuItem(
                      value: sort,
                      child: Text(sort),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSort = value;
                    });
                    applyFilters();
                  },
                ),
              ],
            ),
          ),
          // Loading Indicator or Product List
          isLoading
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: ListView.builder(
                    itemCount: displayedProducts.length,
                    itemBuilder: (context, index) {
                      return ProductTile(product: displayedProducts[index]);
                    },
                  ),
                ),
        ],
      ),
    );
  }
}
