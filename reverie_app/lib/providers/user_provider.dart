import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider with ChangeNotifier {
  int? _userId;
  int? _vendorId;
  String? _firstName;
  String? _lastName;
  String? _email;

  int? get userId => _userId;
  int? get vendorId => _vendorId;
  String? get firstName => _firstName;
  String? get lastName => _lastName;
  String? get email => _email;

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
    notifyListeners();
  }

  Future<void> fetchUserInfo(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.162.65/api/reverie/get_user_info.php'),
        body: {'user_id': userId.toString()},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setUserInfo(data['first_name'], data['last_name'], data['email']);
      } else {
        print('Failed to fetch user info');
      }
    } catch (e) {
      print('Error fetching user info: $e');
    }
  }

  Future<void> checkIfVendor(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.162.65/api/reverie/check_vendor.php'),
        body: {'user_id': userId.toString()},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['is_vendor']) {
          setVendorId(data['vendor_id']);
        }
      } else {
        print('Failed to check vendor status');
      }
    } catch (e) {
      print('Error checking vendor status: $e');
    }
  }
}