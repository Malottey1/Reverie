import 'package:flutter/material.dart';

class VendorProvider extends ChangeNotifier {
  int? vendorId;

  void setVendorId(int id) {
    vendorId = id;
    notifyListeners();
  }
}