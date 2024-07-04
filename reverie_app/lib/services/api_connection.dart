import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cart_item.dart';
import '../models/checkout_info.dart';

class ApiConnection {
  final String baseUrl = "http://192.168.162.65/api/reverie/";

  Future<Map<String, dynamic>> registerUser(Map<String, dynamic> user) async {
    final String url = baseUrl + 'register.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(user),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to register user');
      }
    } catch (e) {
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

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to login user');
      }
    } catch (e) {
      throw Exception('Failed to login user: $e');
    }
  }

  Future<List<dynamic>> fetchProducts() async {
    final String url = baseUrl + 'products.php';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load products');
      }
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<List<dynamic>> fetchRecommendedProducts(int productId) async {
    final String url = baseUrl + 'get_recommended_products.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'product_id': productId.toString()},
      );

      if (response.statusCode == 200) {
        List<dynamic> products = json.decode(response.body);
        return products;
      } else {
        throw Exception('Failed to load recommended products');
      }
    } catch (e) {
      throw Exception('Failed to load recommended products: $e');
    }
  }

  Future<Map<String, dynamic>> addToCart(int userId, int productId) async {
    final String url = baseUrl + 'add_to_cart.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'user_id': userId.toString(), 'product_id': productId.toString()},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to add to cart');
      }
    } catch (e) {
      throw Exception('Failed to add to cart: $e');
    }
  }

  Future<List<CartItem>> fetchCartItems(int userId) async {
    final String url = '$baseUrl/cart_items.php?user_id=$userId';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse is List) {
          return jsonResponse.map((item) => CartItem.fromJson(item)).toList();
        } else if (jsonResponse is Map && jsonResponse.containsKey('message')) {
          throw Exception(jsonResponse['message']);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load cart items');
      }
    } catch (e) {
      throw Exception('Failed to load cart items: $e');
    }
  }

  Future<Map<String, dynamic>> removeCartItem(int cartId) async {
    final String url = baseUrl + 'remove_cart_item.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/x-www-form-urlencoded'},
        body: {'cart_id': cartId.toString()},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to remove cart item');
      }
    } catch (e) {
      throw Exception('Failed to remove cart item: $e');
    }
  }

  Future<CheckoutInfo> fetchCheckoutInfo(int userId) async {
    final String url = '$baseUrl/checkout_info.php?user_id=$userId';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var jsonResponse = json.decode(response.body);
        if (jsonResponse is Map<String, dynamic>) {
          return CheckoutInfo.fromJson(jsonResponse);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load checkout information');
      }
    } catch (e) {
      throw Exception('Failed to load checkout information: $e');
    }
  }

  Future<http.Response> updateShippingAddress(Map<String, dynamic> addressData) async {
    final String url = baseUrl + 'update_shipping_address.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(addressData),
      );

      return response;
    } catch (e) {
      throw Exception('Failed to update shipping address: $e');
    }
  }

  Future<List<dynamic>> searchProducts(String query) async {
    final String url = baseUrl + 'search_products.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'query': query}),
      );

      if (response.statusCode == 200) {
        List<dynamic> products = json.decode(response.body);
        return products;
      } else {
        throw Exception('Failed to search products');
      }
    } catch (e) {
      throw Exception('Failed to search products: $e');
    }
  }

  Future<List<dynamic>> fetchProductsByVendor(int vendorId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/fetch_products_by_vendor.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"vendor_id": vendorId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load products');
    }
  }

  Future<void> updateProduct({
    required int productId,
    required String title,
    required double price,
    required int isActive,
  }) async {
    final url = Uri.parse('$baseUrl/update_product.php');
    final response = await http.post(
      url,
      body: jsonEncode({
        'product_id': productId,
        'title': title,
        'price': price,
        'is_active': isActive,
      }),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update product');
    }
  }

  Future<void> deleteProduct(int productId) async {
    final url = Uri.parse('$baseUrl/delete_product.php');
    final response = await http.post(
      url,
      body: jsonEncode({'product_id': productId}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to delete product');
    }
  }

  Future<List<dynamic>> fetchStores() async {
    final response = await http.get(Uri.parse('$baseUrl/fetch_stores.php'));

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load stores');
    }
  }
}