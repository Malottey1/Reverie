import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class UserProvider with ChangeNotifier {
  int? _userId;
  int? _vendorId;
  String? _firstName;
  String? _lastName;
  String? _email;

  List<Map<String, dynamic>> _incomingOrders = [];
  List<Map<String, dynamic>> _pendingOrders = [];
  List<Map<String, dynamic>> _deliveredOrders = [];

  int? get userId => _userId;
  int? get vendorId => _vendorId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;

  List<Map<String, dynamic>> get incomingOrders => _incomingOrders;
  List<Map<String, dynamic>> get pendingOrders => _pendingOrders;
  List<Map<String, dynamic>> get deliveredOrders => _deliveredOrders;

  bool get isVendor => _vendorId != null;

  void setUserId(int userId) {
    _userId = userId;
    notifyListeners();
    fetchUserInfo(userId); // Fetch user information when setting the user ID
    checkIfVendor(userId); // Check if the user is a vendor when setting the user ID
  }

  void setVendorId(int vendorId) {
    _vendorId = vendorId;
    notifyListeners();
  }

  void setUserInfo(String firstName, String lastName, String email) {
    _firstName = firstName;
    _lastName = lastName;
    _email = email;
    notifyListeners();
  }

  void signOut() {
    _userId = null;
    _vendorId = null;
    _firstName = null;
    _lastName = null;
    _email = null;
    _incomingOrders = [];
    _pendingOrders = [];
    _deliveredOrders = [];
    notifyListeners();
  }

  Future<void> fetchUserInfo(int userId) async {
    final url = 'http://192.168.100.100/api/reverie/get_user_info.php';
    print('Fetching user info from: $url');

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'user_id': userId.toString()},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setUserInfo(data['first_name'], data['last_name'], data['email']);
        print('User info fetched successfully: $data');
      } else {
        print('Failed to fetch user info: ${response.body}');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> checkIfVendor(int userId) async {
    final url = 'http://192.168.100.100/api/reverie/check_vendor.php';
    print('Checking if user is a vendor from: $url');

    try {
      final response = await http.post(
        Uri.parse(url),
        body: {'user_id': userId.toString()},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['is_vendor']) {
          setVendorId(data['vendor_id']);
          print('Vendor ID set successfully: ${data['vendor_id']}');
          await fetchVendorOrders(data['vendor_id']);
          await fetchVendorDeliveredOrders(data['vendor_id']); // Fetch delivered orders
        }
      } else {
        print('Failed to check vendor status: ${response.body}');
      }
    } catch (e) {
      print('Error checking vendor status: $e');
    }
  }

  Future<void> fetchVendorOrders(int vendorId) async {
    final url = 'http://192.168.100.100/api/reverie/fetch_vendor_orders.php';
    print('Fetching vendor orders from: $url');

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'vendor_id': vendorId}),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        print('Fetched Orders: $data'); // Log the response data

        _incomingOrders = [];
        _pendingOrders = [];

        for (var order in data) {
          Map<String, dynamic> orderMap = Map<String, dynamic>.from(order);
          if (orderMap['order_status'] == 'Shipped') {
            _pendingOrders.add(orderMap);
          } else if (orderMap['order_status'] == 'Processing') {
            _incomingOrders.add(orderMap);
          }
        }

        notifyListeners();
      } else {
        print('Failed to fetch vendor orders: ${response.body}');
      }
    } catch (e) {
      print('Error fetching vendor orders: $e');
    }
  }

Future<void> fetchVendorDeliveredOrders(int vendorId) async {
  try {
    final response = await http.post(
      Uri.parse('http://192.168.100.100/api/reverie/fetch_vendor_delivered_orders.php'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'vendor_id': vendorId}),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      print('Fetched Delivered Orders: $data'); // Log the response data

      _deliveredOrders = [];

      for (var order in data) {
        Map<String, dynamic> orderMap = Map<String, dynamic>.from(order);
        _deliveredOrders.add(orderMap);
      }

      notifyListeners();
    } else {
      print('Failed to fetch delivered orders: ${response.body}');
    }
  } catch (e) {
    print('Error fetching delivered orders: $e');
  }
}
}