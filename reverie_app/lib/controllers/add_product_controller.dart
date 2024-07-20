import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../services/product_service.dart';
import '../providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

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

    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final int? userId = userProvider.userId;

    if (userId == null) {
      _showErrorDialog(context, 'User ID not found. Please log in again.');
      return;
    }

    try {
      print('Getting application documents directory...');
      final directory = await getApplicationDocumentsDirectory();
      print('Application documents directory: ${directory.path}');
      
      final String fileName = path.basename(imagePath!);
      final String fullPath = path.join(directory.path, fileName);
      print('Copying image to: $fullPath');
      final File localImage = await File(imagePath!).copy(fullPath);

      final request = http.MultipartRequest('POST', Uri.parse('https://reverie.newschateau.com/api/reverie/add_product.php'));
      request.fields['user_id'] = userId.toString();
      request.fields['title'] = titleController.text;
      request.fields['description'] = descriptionController.text;
      request.fields['category_id'] = categoryId.toString();
      request.fields['brand'] = brandController.text;
      request.fields['size_id'] = sizeId.toString();
      request.fields['color'] = colorController.text;
      request.fields['condition_id'] = conditionId.toString();
      request.fields['target_group_id'] = targetGroupId.toString();
      request.fields['price'] = priceController.text;

      print('Adding image to multipart request...');
      request.files.add(await http.MultipartFile.fromPath('image', localImage.path));

      print('Sending request...');
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Response status code: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200) {
        final responseData = json.decode(responseBody);
        if (responseData['message'] == 'Product added successfully') {
          _showSuccessDialog(context);
        } else {
          _showErrorDialog(context, 'Failed to add product: ${responseData['error']}');
        }
      } else {
        _showErrorDialog(context, 'Server error: ${response.reasonPhrase}');
      }
    } catch (e) {
      _showErrorDialog(context, 'Server error: ${e.toString()}');
      print('Error: ${e.toString()}');
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