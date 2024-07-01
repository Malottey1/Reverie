import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductService {
  final String host = "http://192.168.100.195/api/reverie/";

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> product) async {
    final response = await http.post(
      Uri.parse(host + 'add_product.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(product),
    );

    // Print the request and response for debugging
    print('Request URL: ${host + 'add_product.php'}');
    print('Request Body: ${json.encode(product)}');
    print('Response Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to add product. Status code: ${response.statusCode}');
    }
  }
}