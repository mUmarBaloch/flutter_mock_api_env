import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_shop_admin/provider/core/api.dart';

import '../model/shop_model.dart';

class ShopApiService {
  static final String _baseUrl = "$baseUrl/shop/api/shops/";

  // Method to get the authorization token from SharedPreferences
  static Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("auth_token"); // Retrieve the token from SharedPreferences
  }

  // Method to get shop data with authorization header
  static Future<ShopModel> getShopData() async {
    try {
      final token = await _getAuthToken();

      if (token == null) {
        throw Exception('Authorization token not found.');
      }

      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Token $token', // Pass the token in the headers
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return ShopModel.fromJson(data[0]); // Assuming the response is a list and we want the first shop
      } else {
        throw Exception('Failed to load shop data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
