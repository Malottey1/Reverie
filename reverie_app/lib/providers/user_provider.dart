import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserProvider with ChangeNotifier {
  int? _userId;
  int? _vendorId;

  int? get userId => _userId;
  int? get vendorId => _vendorId;

  bool get isVendor => _vendorId != null;

  void setUserId(int userId) {
    _userId = userId;
    notifyListeners();
    checkIfVendor(userId); // Check if the user is a vendor when setting the user ID
  }

  void setVendorId(int vendorId) {
    _vendorId = vendorId;
    notifyListeners();
  }

  void signOut() {
    _userId = null;
    _vendorId = null;
    notifyListeners();
  }

  Future<void> checkIfVendor(int userId) async {
    try {
      final response = await http.post(
        Uri.parse('http://192.168.100.195/api/reverie/check_vendor.php'),
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