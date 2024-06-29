import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  int? _userId;
  int? _vendorId;

  int? get userId => _userId;
  int? get vendorId => _vendorId;

  void setUserId(int userId) {
    _userId = userId;
    notifyListeners();
  }

  void setVendorId(int vendorId) {
    _vendorId = vendorId;
    notifyListeners();
  }

  void clear() {
    _userId = null;
    _vendorId = null;
    notifyListeners();
  }
}