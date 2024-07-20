import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/api_connection.dart';

class VendorEditProfileScreen extends StatefulWidget {
  @override
  _VendorEditProfileScreenState createState() => _VendorEditProfileScreenState();
}

class _VendorEditProfileScreenState extends State<VendorEditProfileScreen> {
  Map<String, TextEditingController> controllers = {};
  bool _isLoading = true;
  int _selectedPaymentMethod = 0;
  File? _profileImage;

  @override
  void initState() {
    super.initState();
    _fetchVendorDetails();
  }

  Future<void> _fetchVendorDetails() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final vendorId = userProvider.vendorId;

    try {
      final vendorDetails = await ApiConnection().fetchVendorDetails(vendorId!);
      setState(() {
        controllers['Profile Photo'] = TextEditingController(text: vendorDetails['profile_photo']);
        controllers['Business Description'] = TextEditingController(text: vendorDetails['business_description']);
        controllers['Business name'] = TextEditingController(text: vendorDetails['business_name']);
        controllers['Business number registration'] = TextEditingController(text: vendorDetails['business_registration_number']);
        controllers['Business Address/ Postal Code'] = TextEditingController(text: vendorDetails['business_address']);
        controllers['City'] = TextEditingController(text: vendorDetails['city']);
        controllers['State/Province'] = TextEditingController(text: vendorDetails['state']);
        controllers['Country'] = TextEditingController(text: vendorDetails['country']);
        // Payment method fields
        if (vendorDetails['payment_method'] == 'credit_card') {
          _selectedPaymentMethod = 0;
          controllers['Name on card'] = TextEditingController(text: vendorDetails['card_name']);
          controllers['Card number'] = TextEditingController(text: vendorDetails['card_number']);
          controllers['Expiry Date'] = TextEditingController(text: vendorDetails['card_expiry_date']);
          controllers['CVV'] = TextEditingController(text: vendorDetails['card_cvv']);
        } else if (vendorDetails['payment_method'] == 'mobile_money') {
          _selectedPaymentMethod = 1;
          controllers['Mobile Network'] = TextEditingController(text: vendorDetails['mobile_network']);
          controllers['Phone Number'] = TextEditingController(text: vendorDetails['phone_number']);
        } else if (vendorDetails['payment_method'] == 'bank_account') {
          _selectedPaymentMethod = 2;
          controllers['Account Holder\'s Name'] = TextEditingController(text: vendorDetails['account_holder_name']);
          controllers['Bank Name'] = TextEditingController(text: vendorDetails['bank_name']);
          controllers['Account Number'] = TextEditingController(text: vendorDetails['account_number']);
          controllers['Routing Number'] = TextEditingController(text: vendorDetails['routing_number']);
        }
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load vendor details: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final vendorId = userProvider.vendorId;

    final profileData = {
      'vendor_id': vendorId,
      'profile_photo': _profileImage != null ? _profileImage!.path : controllers['Profile Photo']?.text,
      'business_description': controllers['Business Description']?.text,
      'business_name': controllers['Business name']?.text,
      'business_registration_number': controllers['Business number registration']?.text,
      'business_address': controllers['Business Address/ Postal Code']?.text,
      'city': controllers['City']?.text,
      'state': controllers['State/Province']?.text,
      'country': controllers['Country']?.text,
      'payment_method': _selectedPaymentMethod == 0 ? 'credit_card' : _selectedPaymentMethod == 1 ? 'mobile_money' : 'bank_account',
      'card_name': controllers['Name on card']?.text,
      'card_number': controllers['Card number']?.text,
      'card_expiry_date': controllers['Expiry Date']?.text,
      'card_cvv': controllers['CVV']?.text,
      'mobile_network': controllers['Mobile Network']?.text,
      'phone_number': controllers['Phone Number']?.text,
      'account_holder_name': controllers['Account Holder\'s Name']?.text,
      'bank_name': controllers['Bank Name']?.text,
      'account_number': controllers['Account Number']?.text,
      'routing_number': controllers['Routing Number']?.text,
    };

    try {
      await ApiConnection().updateVendorProfile(profileData);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    }
  }

  Future<void> _pickImage() async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _profileImage = File(image.path);
        controllers['Profile Photo']?.text = image.path;
      });
    }
  }

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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView(
                children: [
                  _buildTextField('Profile Photo', icon: Icons.camera_alt, onTapIcon: _pickImage),
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
                      onPressed: _saveProfile,
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

  Widget _buildTextField(String hint, {IconData? icon, bool isMultiline = false, Function()? onTapIcon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controllers[hint],
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
          suffixIcon: icon != null
              ? IconButton(
                  icon: Icon(icon, color: Color(0xFF69734E)),
                  onPressed: onTapIcon,
                )
              : null,
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