import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiConnection {
  final String baseUrl = "http://192.168.100.195/api/reverie/";

  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> user) async {
    final String url = baseUrl + 'register.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user),
      );

      print('Request URL: $url');
      print('Request Body: ${json.encode(user)}');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
      print('Error during registerUser: $e');
      throw Exception('Failed to register user: $e');
    }
  }

  Future<Map<String, dynamic>> loginUser(Map<String, String> credentials) async {
    final String url = baseUrl + 'login.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(credentials),
      );

      print('Request URL: $url');
      print('Request Body: ${json.encode(credentials)}');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to login user');
      }
    } catch (e) {
      print('Error during loginUser: $e');
      throw Exception('Failed to login user: $e');
    }
  }

  Future<List<dynamic>> fetchProducts() async {
    final String url = baseUrl + 'products.php';
    try {
      final response = await http.get(Uri.parse(url));

      print('Request URL: $url');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      print('Error during fetchProducts: $e');
      throw Exception('Failed to load products: $e');
    }
  }
}