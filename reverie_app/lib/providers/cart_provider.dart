import 'package:flutter/material.dart';
import '../models/order_detail.dart';

class CartProvider with ChangeNotifier {
  List<OrderDetail> _cartItems = [];

  List<OrderDetail> get cartItems => _cartItems;

  void addItem(OrderDetail item) {
    _cartItems.add(item);
    notifyListeners();
  }

  void removeItem(OrderDetail item) {
    _cartItems.remove(item);
    notifyListeners();
  }
}