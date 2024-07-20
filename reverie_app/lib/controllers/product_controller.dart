import 'package:flutter/material.dart';
import 'package:reverie_app/services/api_connection.dart';

class ProductController extends ChangeNotifier {
  final ApiConnection _apiConnection = ApiConnection();
  List<dynamic> _recommendedProducts = [];
  bool _isLoading = false;
  String? _error;

  List<dynamic> get recommendedProducts => _recommendedProducts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchRecommendedProducts(int productId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _recommendedProducts = await _apiConnection.fetchRecommendedProducts(productId);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}