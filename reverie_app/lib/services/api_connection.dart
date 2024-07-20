import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import '../models/cart_item.dart';
import '../models/checkout_info.dart';

class ApiConnection {
  final String baseUrl = "https://reverie.newschateau.com/api/reverie/";

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
        print('Checkout Info Response: $jsonResponse');
        if (jsonResponse is Map<String, dynamic>) {
          return CheckoutInfo.fromJson(jsonResponse);
        } else {
          print('Unexpected response format: $jsonResponse');
          throw Exception('Unexpected response format');
        }
      } else {
        print('Failed to load checkout information. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load checkout information');
      }
    } catch (e) {
      print('Failed to load checkout information: $e');
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

  Future<Map<String, dynamic>> fetchVendorDetails(int vendorId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/fetch_vendor_details.php'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"vendor_id": vendorId}),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load vendor details');
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

  Future<Map<String, dynamic>> fetchVendorTracking(String orderId) async {
    final String url = baseUrl + 'fetch_vendor_tracking.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'order_id': orderId}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load vendor tracking data');
      }
    } catch (e) {
      throw Exception('Failed to load vendor tracking data: $e');
    }
  }

  Future<Map<String, dynamic>> initializePayment(String email, int amount) async {
    final String url = 'https://api.paystack.co/transaction/initialize';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer sk_test_c276989ec344e7fa1eafa1bfcf19bbb4e4b7d459',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'email': email,
        'amount': amount,
      }),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to initialize payment');
    }
  }

  Future<void> verifyPayment(String reference) async {
    final String url = 'https://api.paystack.co/transaction/verify/$reference';
    final response = await http.get(Uri.parse(url), headers: {
      'Authorization': 'Bearer sk_test_c276989ec344e7fa1eafa1bfcf19bbb4e4b7d459',
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == true) {
        // Payment successful
        print('Payment successful');
      } else {
        // Payment failed
        print('Payment failed');
      }
    } else {
      // Handle error
      print('Failed to verify payment');
    }
  }

  Future<void> recordPayment(int orderId, double amount) async {
    final url = Uri.parse('$baseUrl/record_payment.php');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'order_id': orderId,
        'amount': amount,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to record payment');
    } else {
      final jsonResponse = json.decode(response.body);
      if (!jsonResponse.containsKey('success') || !jsonResponse['success']) {
        throw Exception('Failed to record payment: ${jsonResponse['error']}');
      }
    }
  }

  Future<Map<String, dynamic>> createOrder(int userId, double totalAmount, String orderStatus) async {
    final url = Uri.parse('$baseUrl/create_order.php');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'total_amount': totalAmount,
        'order_status': orderStatus,
      }),
    );

    // Debugging statement to print the response body
    print('Create Order Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      if (jsonResponse.containsKey('order_id')) {
        return jsonResponse;
      } else {
        throw Exception('Failed to create order: ${jsonResponse['error']}');
      }
    } else {
      throw Exception('Failed to create order');
    }
  }

  Future<Map<String, dynamic>> createOrderDetail(int orderId, int productId, double price) async {
    final String url = baseUrl + 'create_order_detail.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'order_id': orderId,
          'product_id': productId,
          'price': price,
        }),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print('Create Order Detail Response Body: ${response.body}');
        throw Exception('Failed to create order detail: ${response.body}');
      }
    } catch (e) {
      throw Exception('Failed to create order detail: $e');
    }
  }

  Future<void> createOrderTracking(int orderId, String status, String estimatedDeliveryDate) async {
    final String url = baseUrl + 'create_order_tracking.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'order_id': orderId,
          'status': status,
          'estimated_delivery_date': estimatedDeliveryDate,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create order tracking');
      }
    } catch (e) {
      throw Exception('Failed to create order tracking: $e');
    }
  }

  Future<Map<String, dynamic>> fetchBuyerTracking(String orderId) async {
    final String url = baseUrl + 'fetch_buyer_tracking.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'order_id': orderId}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load buyer tracking data');
      }
    } catch (e) {
            throw Exception('Failed to load buyer tracking data: $e');
    }
  }

  Future<List<dynamic>> fetchOrders(int userId) async {
    final String url = baseUrl + 'fetch_orders.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId}),
      );

      print('Response body: ${response.body}'); // Log the response body

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData is List) {
          return responseData;
        } else if (responseData is Map && responseData.containsKey('orders')) {
          return responseData['orders'];
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to load orders');
      }
    } catch (e) {
      throw Exception('Failed to load orders: $e');
    }
  }

  Future<Map<String, dynamic>> fetchVendorStats(int vendorId) async {
    final String url = '$baseUrl/fetch_vendor_stats.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'vendor_id': vendorId}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        return responseBody;
      } else {
        print('Failed to load vendor stats. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
        throw Exception('Failed to load vendor stats');
      }
    } catch (e) {
      print('Failed to load vendor stats: $e');
      throw Exception('Failed to load vendor stats: $e');
    }
  }



  Future<List<dynamic>> fetchPendingDeliveries(int vendorId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/fetch_pending_deliveries.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'vendor_id': vendorId}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        return data;
      } else {
        throw Exception('Unexpected response format');
      }
    } else {
      throw Exception('Failed to load pending deliveries');
    }
  }

Future<Map<String, dynamic>> fetchOrderDetails(String orderId) async {
  final String url = baseUrl + 'fetch_order_details.php';
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'order_id': orderId}),
    );

    print('Response status: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // Check if data is of expected type
      if (data is Map<String, dynamic>) {
        return data;
      } else {
        throw Exception('Unexpected response format: ${data.runtimeType}');
      }
    } else {
      throw Exception('Failed to load order details: ${response.statusCode} - ${response.reasonPhrase}');
    }
  } catch (e) {
    print('Failed to load order details: $e');
    throw Exception('Failed to load order details: $e');
  }
}

   Future<List<dynamic>> fetchVendorOrders(int vendorId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/fetch_vendor_orders.php'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'vendor_id': vendorId}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load orders');
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    final String url = baseUrl + 'update_order_ready_status.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'order_id': orderId, 'status': status}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message'] == 'Order status updated successfully') {
          return;
        } else {
          throw Exception('Failed to update order status');
        }
      } else {
        throw Exception('Failed to update order status');
      }
    } catch (e) {
      print('Failed to update order status: $e');
      throw Exception('Failed to update order status: $e');
    }
  }

  Future<Map<String, dynamic>> fetchVendorTrackingDetails(String orderId) async {
    final String url = baseUrl + 'fetch_vendor_tracking.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'order_id': orderId}),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load vendor tracking data');
      }
    } catch (e) {
      throw Exception('Failed to load vendor tracking data: $e');
    }
  }


Future<Map<String, dynamic>> deleteVendor(int vendorId) async {
  final url = Uri.parse('$baseUrl/delete_vendor.php');
  final response = await http.post(
    url,
    body: jsonEncode({'vendor_id': vendorId}),
    headers: {'Content-Type': 'application/json'},
  );

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to delete vendor: ${response.body}');
  }
}

  Future<void> updateVendorProfile(Map<String, dynamic> profileData) async {
    final url = Uri.parse('${baseUrl}edit_profile.php');

    log('Starting profile update...');
    log('Profile data: $profileData');

    var request = http.MultipartRequest('POST', url);

    profileData.forEach((key, value) {
      if (value != null) {
        log('Adding field: $key = $value');
        request.fields[key] = value.toString();
      }
    });

    if (profileData['profile_photo'] != null && profileData['profile_photo'] is String) {
      log('Adding profile photo...');
      request.files.add(await http.MultipartFile.fromPath('profile_photo', profileData['profile_photo']));
    }

    log('Sending request...');
    var response = await request.send();

    log('Response status: ${response.statusCode}');
    if (response.statusCode == 200) {
      var responseData = await response.stream.bytesToString();
      log('Response data: $responseData');
      try {
        var decodedResponse = json.decode(responseData);
        log('Decoded response: $decodedResponse');
        if (decodedResponse['message'] != 'Profile updated successfully') {
          throw Exception('Failed to update profile: ${decodedResponse['message']}');
        }
      } catch (e) {
        log('Error decoding response: $e');
        throw Exception('Failed to update profile');
      }
    } else {
      throw Exception('Failed to update profile');
    }
  }

}