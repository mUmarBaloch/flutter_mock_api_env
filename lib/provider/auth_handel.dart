import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_shop_admin/provider/core/api.dart';
class Auth {
  static final String _baseUrl = "$baseUrl/auth";
  static const String _authTokenKey = "auth_token";

  // Login
  static Future<bool> login(String username, String password) async {
    try {
      final url = Uri.parse("$_baseUrl$loginEndpoint");
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"username": username, "password": password}),
      );
     
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data["auth_token"];
        if (token != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString(_authTokenKey, token);
          return true;
        }
      }
      print(response);
      return false;
    } 
    on SocketException {
      throw 'internet error';
    }
    catch (e) {

      print("Login Error: $e");
      return false;
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_authTokenKey); // Get the token from preferences

      if (token != null) {
        final url = Uri.parse("$_baseUrl$logoutEndpoint");
        await http.post(
          url,
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Token $token", // Pass token directly in headers
          },
        );
        await prefs.remove(_authTokenKey); // Remove token after logout
      }
    } catch (e) {
      print("Logout Error: $e");
    }
  }

  // Check Authentication Status
  static Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_authTokenKey);
  }

  // Get Authentication Token
  static Future<String> getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_authTokenKey) ?? ''; // Return the stored token, or null if not found
  }
}
