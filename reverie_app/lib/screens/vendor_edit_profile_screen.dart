import 'package:flutter/material.dart';

class VendorEditProfileScreen extends StatefulWidget {
  @override
  _VendorEditProfileScreenState createState() => _VendorEditProfileScreenState();
}

class _VendorEditProfileScreenState extends State<VendorEditProfileScreen> {
  int _selectedPaymentMethod = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDDBD3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDDBD3),
        elevation: 0,
        title: Text(
          'Edit Profile',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 20,
            color: Color(0xFF69734E),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF69734E)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildTextField('Profile Photo', icon: Icons.camera_alt),
            _buildTextField('Business Description', isMultiline: true),
            SizedBox(height: 20),
            Text(
              "Business Information",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                color: Color(0xFF69734E),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildTextField('Business name'),
            _buildTextField('Business number registration'),
            _buildTextField('Business Address/ Postal Code'),
            _buildTextField('City'),
            _buildTextField('State/Province'),
            _buildTextField('Country'),
            SizedBox(height: 20),
            Text(
              "Payment Information",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                color: Color(0xFF69734E),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            _buildPaymentMethodOption('Credit Card', 0),
            _buildPaymentMethodOption('Mobile Money', 1),
            _buildPaymentMethodOption('Bank Account', 2),
            SizedBox(height: 20),
            if (_selectedPaymentMethod == 0) ...[
              _buildTextField('Name on card'),
              _buildTextField('Card number'),
              _buildTextField('Expiry Date'),
              _buildTextField('CVV'),
            ],
            if (_selectedPaymentMethod == 1) ...[
              _buildTextField('Mobile Network'),
              _buildTextField('Phone Number'),
            ],
            if (_selectedPaymentMethod == 2) ...[
              _buildTextField('Account Holder\'s Name'),
              _buildTextField('Bank Name'),
              _buildTextField('Account Number'),
              _buildTextField('Routing Number'),
              _buildTextField('IBAN'),
              _buildTextField('SWIFT/BIC Code'),
            ],
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF69734E),
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {
                  // Handle save profile action
                },
                child: Text(
                  'Save Changes',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {IconData? icon, bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        maxLines: isMultiline ? null : 1,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
          ),
          filled: true,
          fillColor: Color(0xFFB0BEC5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: icon != null ? Icon(icon, color: Color(0xFF69734E)) : null,
        ),
      ),
    );
  }

  Widget _buildPaymentMethodOption(String title, int value) {
    return RadioListTile(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: Color(0xFF69734E),
        ),
      ),
      value: value,
      groupValue: _selectedPaymentMethod,
      onChanged: (int? value) {
        setState(() {
          _selectedPaymentMethod = value!;
        });
      },
    );
  }
}