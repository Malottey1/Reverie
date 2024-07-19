import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../providers/user_provider.dart';

class BillingAddressScreen extends StatefulWidget {
  @override
  _BillingAddressScreenState createState() => _BillingAddressScreenState();
}

class _BillingAddressScreenState extends State<BillingAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;
  late TextEditingController _stateController;
  late TextEditingController _countryController;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    // Fetch initial billing address data if available
    _nameController = TextEditingController(text: userProvider.firstName ?? '');
    _addressController = TextEditingController(text: ''); // Fetch from user data if available
    _cityController = TextEditingController(text: ''); // Fetch from user data if available
    _postalCodeController = TextEditingController(text: ''); // Fetch from user data if available
    _stateController = TextEditingController(text: ''); // Fetch from user data if available
    _countryController = TextEditingController(text: ''); // Fetch from user data if available
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _cityController.dispose();
    _postalCodeController.dispose();
    _stateController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  Future<void> _saveBillingAddress() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('http://192.168.104.167/api/reverie/update_billing_address.php'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, dynamic>{
          'user_id': userProvider.userId,
          'name': _nameController.text,
          'address': _addressController.text,
          'city': _cityController.text,
          'postal_code': _postalCodeController.text,
          'state': _stateController.text,
          'country': _countryController.text,
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(result['message'])),
        );
        if (result['message'] == 'Billing address updated successfully') {
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update billing address')),
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
          'Billing Address',
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
              _buildTextField('Name', _nameController),
              _buildTextField('Address', _addressController),
              _buildTextField('City', _cityController),
              _buildTextField('Postal Code', _postalCodeController),
              _buildTextField('State', _stateController),
              _buildTextField('Country', _countryController),
              SizedBox(height: 20),
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            fontFamily: 'Poppins',
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '$label cannot be empty';
          }
          return null;
        },
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
      onPressed: _saveBillingAddress,
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