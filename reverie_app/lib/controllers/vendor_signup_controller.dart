import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import '../services/vendor_signup_service.dart';
import '../providers/user_provider.dart';

class VendorSignupController {
  final TextEditingController profilePhotoController = TextEditingController();
  final TextEditingController businessDescriptionController = TextEditingController();
  final TextEditingController businessNameController = TextEditingController();
  final TextEditingController businessRegistrationNumberController = TextEditingController();
  final TextEditingController businessAddressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final TextEditingController cardNameController = TextEditingController();
  final TextEditingController cardNumberController = TextEditingController();
  final TextEditingController cardExpiryDateController = TextEditingController();
  final TextEditingController cardCvvController = TextEditingController();
  final TextEditingController mobileNetworkController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController accountHolderNameController = TextEditingController();
  final TextEditingController bankNameController = TextEditingController();
  final TextEditingController accountNumberController = TextEditingController();
  final TextEditingController routingNumberController = TextEditingController();

  final VendorSignupService _service = VendorSignupService();

  Future<void> pickProfilePhoto() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final appDir = await getApplicationDocumentsDirectory();
      final folderPath = path.join(appDir.path, 'vendor_profile_photos');
      await Directory(folderPath).create(recursive: true);
      final fileName = path.basename(pickedFile.path);
      final savedImage = await File(pickedFile.path).copy(path.join(folderPath, fileName));

      profilePhotoController.text = savedImage.path;
    }
  }

  Future<void> registerVendor(BuildContext context, int selectedPaymentMethod) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final int? userId = userProvider.userId;

    if (userId == null) {
      print('User ID not found in user provider');
      _showErrorDialog(context, 'User ID not found. Please log in again.');
      return;
    }

    final Map<String, dynamic> vendorData = {
      'user_id': userId,
      'profile_photo': profilePhotoController.text,
      'business_description': businessDescriptionController.text,
      'business_name': businessNameController.text,
      'business_registration_number': businessRegistrationNumberController.text,
      'business_address': businessAddressController.text,
      'city': cityController.text,
      'state': stateController.text,
      'country': countryController.text,
      'payment_method': selectedPaymentMethod == 0
          ? 'credit_card'
          : selectedPaymentMethod == 1
              ? 'mobile_money'
              : 'bank_account',
      'card_name': selectedPaymentMethod == 0 ? cardNameController.text : null,
      'card_number': selectedPaymentMethod == 0 ? cardNumberController.text : null,
      'card_expiry_date': selectedPaymentMethod == 0 ? cardExpiryDateController.text : null,
      'card_cvv': selectedPaymentMethod == 0 ? cardCvvController.text : null,
      'mobile_network': selectedPaymentMethod == 1 ? mobileNetworkController.text : null,
      'phone_number': selectedPaymentMethod == 1 ? phoneNumberController.text : null,
      'account_holder_name': selectedPaymentMethod == 2 ? accountHolderNameController.text : null,
      'bank_name': selectedPaymentMethod == 2 ? bankNameController.text : null,
      'account_number': selectedPaymentMethod == 2 ? accountNumberController.text : null,
      'routing_number': selectedPaymentMethod == 2 ? routingNumberController.text : null,
    };

    if (!_validateInputs(vendorData)) {
      _showErrorDialog(context, 'Please fill in all required fields.');
      return;
    }

    print('Sending vendor registration data: $vendorData'); // Log the data being sent

    try {
      final response = await _service.registerVendor(vendorData);
      print('Response: $response'); // Log the response

      if (response['message'] == 'Registration successful') {
        print('Registration successful');
        Navigator.pushReplacementNamed(context, '/vendor-store');
      } else {
        print('Registration failed: ${response['message']}');
        _showErrorDialog(context, 'Registration failed: ${response['message']}');
      }
    } catch (e) {
      print('Registration failed: $e');
      _showErrorDialog(context, 'Registration failed: $e');
    }
  }

  bool _validateInputs(Map<String, dynamic> data) {
    // Add validation logic as needed
    if (data['profile_photo'] == null || data['profile_photo'].isEmpty) return false;
    if (data['business_description'] == null || data['business_description'].isEmpty) return false;
    if (data['business_name'] == null || data['business_name'].isEmpty) return false;
    if (data['business_registration_number'] == null || data['business_registration_number'].isEmpty) return false;
    if (data['business_address'] == null || data['business_address'].isEmpty) return false;
    if (data['city'] == null || data['city'].isEmpty) return false;
    if (data['state'] == null || data['state'].isEmpty) return false;
    if (data['country'] == null || data['country'].isEmpty) return false;

    // Add more validation if necessary for payment details based on selectedPaymentMethod

    return true;
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text('Okay'),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void dispose() {
    profilePhotoController.dispose();
    businessDescriptionController.dispose();
    businessNameController.dispose();
    businessRegistrationNumberController.dispose();
    businessAddressController.dispose();
    cityController.dispose();
    stateController.dispose();
    countryController.dispose();
    cardNameController.dispose();
    cardNumberController.dispose();
    cardExpiryDateController.dispose();
    cardCvvController.dispose();
    mobileNetworkController.dispose();
    phoneNumberController.dispose();
    accountHolderNameController.dispose();
    bankNameController.dispose();
    accountNumberController.dispose();
    routingNumberController.dispose();
  }
}