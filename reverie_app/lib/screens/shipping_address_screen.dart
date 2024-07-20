import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/user_provider.dart';
import 'checkout_screen.dart'; // Import the checkout screen

class ShippingAddressScreen extends StatefulWidget {
  @override
  _ShippingAddressScreenState createState() => _ShippingAddressScreenState();
}

class _ShippingAddressScreenState extends State<ShippingAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _addressController;
  late TextEditingController _addressLine2Controller;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;
  late TextEditingController _stateController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _firstNameController = TextEditingController(text: userProvider.firstName);
    _lastNameController = TextEditingController(text: userProvider.lastName);
    _addressController = TextEditingController(text: '');
    _addressLine2Controller = TextEditingController(text: '');
    _cityController = TextEditingController(text: '');
    _postalCodeController = TextEditingController(text: '');
    _stateController = TextEditingController(text: '');
    _countryController = TextEditingController(text: 'Ghana'); // Pre-fill country as Ghana
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _addressController.dispose();
    _addressLine2Controller.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _saveShippingAddress() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    print("Saving shipping address for user_id: ${userProvider.userId}");
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://reverie.newschateau.com/api/reverie/update_shipping_address.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': userProvider.userId,
          'first_name': _firstNameController.text,
          'last_name': _lastNameController.text,
          'address': _addressController.text,
          'address_line2': _addressLine2Controller.text,
          'city': _cityController.text,
          'postal_code': _postalCodeController.text,
          'state': _stateController.text,
          'country': _countryController.text,
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        print("Response from server: ${result['message']}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
        if (result['message'] == 'Shipping address updated successfully') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => CheckoutScreen()),
          );
        }
      } else {
        print("Failed to update shipping address. Status code: ${response.statusCode}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update shipping address: ${response.statusCode}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDBD3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Shipping Address',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTextField('First Name', _firstNameController),
              _buildTextField('Last Name', _lastNameController),
              _buildTextField('Address', _addressController),
              _buildTextField('Address Line 2', _addressLine2Controller, required: false),
              _buildTextField('City', _cityController),
              _buildTextField('Postal Code', _postalCodeController, required: false),
              _buildTextField('State', _stateController, required: false),
              _buildTextField('Country', _countryController, readOnly: true),
              SizedBox(height: 20),
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool required = true, bool readOnly = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        validator: required
            ? (value) {
                if (value == null || value.isEmpty) {
                  return '$label cannot be empty';
                }
                return null;
              }
            : null,
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: _saveShippingAddress,
      child: Text(
        'Save',
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }
}