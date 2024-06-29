
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../services/product_service.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:art_sweetalert/art_sweetalert.dart';

class AddProductController with ChangeNotifier {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController brandController = TextEditingController();
  final TextEditingController colorController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  int? categoryId;
  int? sizeId;
  int? conditionId;
  int? targetGroupId;
  String? imagePath;

  final ProductService _productService = ProductService();

  void setCategory(String categoryName) {
    switch (categoryName) {
      case 'Tops':
        categoryId = 1;
        break;
      case 'Bottoms':
        categoryId = 2;
        break;
      case 'Dresses':
        categoryId = 3;
        break;
      case 'Outerwear':
        categoryId = 4;
        break;
      case 'Accessories':
        categoryId = 5;
        break;
      default:
        categoryId = null;
    }
    notifyListeners();
  }

  void setSize(String sizeName) {
    switch (sizeName) {
      case 'XS':
        sizeId = 1;
        break;
      case 'S':
        sizeId = 2;
        break;
      case 'M':
        sizeId = 3;
        break;
      case 'L':
        sizeId = 4;
        break;
      case 'XL':
        sizeId = 5;
        break;
      case 'XXL':
        sizeId = 6;
        break;
      default:
        sizeId = null;
    }
    notifyListeners();
  }

  void setCondition(String conditionName) {
    switch (conditionName) {
      case 'New with Tags':
        conditionId = 1;
        break;
      case 'Excellent':
        conditionId = 2;
        break;
      case 'Very Good':
        conditionId = 3;
        break;
      case 'Good':
        conditionId = 4;
        break;
      case 'Fair':
        conditionId = 5;
        break;
      default:
        conditionId = null;
    }
    notifyListeners();
  }

  void setTargetGroup(String targetGroupName) {
    switch (targetGroupName) {
      case 'Men':
        targetGroupId = 1;
        break;
      case 'Women':
        targetGroupId = 2;
        break;
      case 'Kids':
        targetGroupId = 3;
        break;
      default:
        targetGroupId = null;
    }
    notifyListeners();
  }

  void setImagePath(String path) {
    imagePath = path;
    notifyListeners();
  }

  Future<void> saveAndPublish(BuildContext context) async {
    if (imagePath == null ||
        titleController.text.isEmpty ||
        descriptionController.text.isEmpty ||
        categoryId == null ||
        sizeId == null ||
        colorController.text.isEmpty ||
        conditionId == null ||
        targetGroupId == null ||
        priceController.text.isEmpty) {
      _showErrorDialog(context, 'Please fill in all fields and upload an image');
      return;
    }

    final directory = await getApplicationDocumentsDirectory();
    final File localImage = await File(imagePath!).copy('${directory.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final int? userId = userProvider.userId;

    if (userId == null) {
      _showErrorDialog(context, 'User ID not found. Please log in again.');
      return;
    }

    final Map<String, dynamic> productData = {
      'user_id': userId,
      'title': titleController.text,
      'description': descriptionController.text,
      'category_id': categoryId,
      'brand': brandController.text,
      'size_id': sizeId,
      'color': colorController.text,
      'condition_id': conditionId,
      'target_group_id': targetGroupId,
      'price': priceController.text,
      'image_path': localImage.path,
    };

    try {
      final response = await _productService.addProduct(productData);
      if (response['message'] == 'Product added successfully') {
        _showSuccessDialog(context);
      } else {
        _showErrorDialog(context, 'Failed to add product: ${response['error']}');
      }
    } catch (e) {
      _showErrorDialog(context, 'Server error: ${e.toString()}');
    }
  }

  void _showSuccessDialog(BuildContext context) {
    ArtSweetAlert.show(
      context: context,
      artDialogArgs: ArtDialogArgs(
        type: ArtSweetAlertType.success,
        title: "Product Published",
        text: "Product published successfully",
        confirmButtonText: "Okay",
        onConfirm: () {
          Navigator.pushReplacementNamed(context, '/vendor-store');
        },
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    ArtSweetAlert.show(
      context: context,
      artDialogArgs: ArtDialogArgs(
        type: ArtSweetAlertType.danger,
        title: "Error",
        text: message,
        confirmButtonText: "Okay",
      ),
    );
  }
}