import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../controllers/vendor_signup_controller.dart';

class VendorSignupScreen extends StatefulWidget {
  @override
  _VendorSignupScreenState createState() => _VendorSignupScreenState();
}

class _VendorSignupScreenState extends State<VendorSignupScreen> {
  final VendorSignupController _controller = VendorSignupController();
  int _currentStep = 0;
  int _selectedPaymentMethod = 0;
  File? _profileImage;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
        _controller.profilePhotoController.text = pickedFile.path;
      });
    }
  }

  List<Step> _getSteps() {
    return [
      Step(
        title: Text('Step 1'),
        isActive: _currentStep >= 0,
        content: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Wanna become a vendor? Let's get to know you.",
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  color: Color(0xFF69734E),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Color(0xFFB0BEC5),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Color(0xFF69734E)),
                  ),
                  child: _profileImage == null
                      ? Icon(Icons.camera_alt, color: Color(0xFF69734E), size: 50)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.file(
                            _profileImage!,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
              ),
              SizedBox(height: 20),
              _buildTextField(
                'Business Description',
                controller: _controller.businessDescriptionController,
                isMultiline: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Business Description is required';
                  }
                  if (value.length < 5) {
                    return 'Business Description must be at least 5 characters long';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
      Step(
        title: Text('Step 2'),
        isActive: _currentStep >= 1,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Wanna become a vendor? Let's get to know you.",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                color: Color(0xFF69734E),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildTextField(
              'Business name',
              controller: _controller.businessNameController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Business name is required';
                }
                if (value.length < 3) {
                  return 'Business name must be at least 3 characters long';
                }
                if (!RegExp(r'^[a-zA-Z0-9 ]+$').hasMatch(value)) {
                  return 'Business name can only contain letters, numbers, and spaces';
                }
                return null;
              },
            ),
            _buildTextField(
              'Business number registration',
              controller: _controller.businessRegistrationNumberController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Business number registration is required';
                }
                // Add specific format validation if needed
                return null;
              },
            ),
            _buildTextField(
              'Business Address/ Postal Code',
              controller: _controller.businessAddressController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Business Address/ Postal Code is required';
                }
                if (value.length < 5) {
                  return 'Business Address/ Postal Code must be at least 5 characters long';
                }
                return null;
              },
            ),
            _buildTextField(
              'City',
              controller: _controller.cityController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'City is required';
                }
                if (value.length < 3) {
                  return 'City must be at least 3 characters long';
                }
                if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                  return 'City can only contain letters and spaces';
                }
                return null;
              },
            ),
            _buildTextField(
              'State/Province',
              controller: _controller.stateController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'State/Province is required';
                }
                if (value.length < 3) {
                  return 'State/Province must be at least 3 characters long';
                }
                if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                  return 'State/Province can only contain letters and spaces';
                }
                return null;
              },
            ),
            _buildTextField(
              'Country',
              controller: _controller.countryController,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Country is required';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      Step(
        title: Text('Step 3'),
        isActive: _currentStep >= 2,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Receive payment with",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                color: Color(0xFF69734E),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            _buildPaymentMethodOption('Credit Card', 0),
            _buildPaymentMethodOption('Mobile Money', 1),
            _buildPaymentMethodOption('Bank Account', 2),
            SizedBox(height: 20),
            if (_selectedPaymentMethod == 0) ...[
              _buildTextField(
                'Name on card',
                controller: _controller.cardNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name on card is required';
                  }
                  if (value.length < 3) {
                    return 'Name on card must be at least 3 characters long';
                  }
                  if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                    return 'Name on card can only contain letters and spaces';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'Card number',
                controller: _controller.cardNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Card number is required';
                  }
                  if (!RegExp(r'^[0-9]{16}$').hasMatch(value)) {
                    return 'Card number must be 16 digits';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'Expiry Date',
                controller: _controller.cardExpiryDateController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Expiry Date is required';
                  }
                  if (!RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$').hasMatch(value)) {
                    return 'Expiry Date must be in MM/YY format';
                  }
                  // Additional future date validation can be added here
                  return null;
                },
              ),
              _buildTextField(
                'CVV',
                controller: _controller.cardCvvController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'CVV is required';
                  }
                  if (!RegExp(r'^[0-9]{3,4}$').hasMatch(value)) {
                    return 'CVV must be 3 or 4 digits';
                  }
                  return null;
                },
              ),
            ],
            if (_selectedPaymentMethod == 1) ...[
              DropdownButtonFormField<String>(
                hint: Text('Mobile Network'),
                items: ['Telecel', 'MTN', 'AirtelTigo', 'Glo Mobile']
                    .map((network) => DropdownMenuItem<String>(
                          value: network,
                          child: Text(network),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _controller.mobileNetworkController.text = value!;
                  });
                },
                validator: (value) {
                                    if (value == null || value.isEmpty) {
                    return 'Mobile Network is required';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'Phone Number',
                controller: _controller.phoneNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Phone Number is required';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Phone Number can only contain numbers';
                  }
                  return null;
                },
              ),
            ],
            if (_selectedPaymentMethod == 2) ...[
              _buildTextField(
                'Account Holder\'s Name',
                controller: _controller.accountHolderNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Account Holder\'s Name is required';
                  }
                  if (value.length < 3) {
                    return 'Account Holder\'s Name must be at least 3 characters long';
                  }
                  if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                    return 'Account Holder\'s Name can only contain letters and spaces';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'Bank Name',
                controller: _controller.bankNameController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Bank Name is required';
                  }
                  if (value.length < 3) {
                    return 'Bank Name must be at least 3 characters long';
                  }
                  if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                    return 'Bank Name can only contain letters and spaces';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'Account Number',
                controller: _controller.accountNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Account Number is required';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Account Number can only contain numbers';
                  }
                  return null;
                },
              ),
              _buildTextField(
                'Routing Number',
                controller: _controller.routingNumberController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Routing Number is required';
                  }
                  if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                    return 'Routing Number can only contain numbers';
                  }
                  return null;
                },
              ),
            ],
          ],
        ),
      ),
    ];
  }

  Widget _buildTextField(String hint, {required TextEditingController controller, IconData? icon, bool isMultiline = false, String? Function(String?)? validator}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        maxLines: isMultiline ? null : 1,
        validator: validator,
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDDBD3),
      appBar: AppBar(
        backgroundColor: const Color(0xFFDDDBD3),
        elevation: 0,
        title: Text(
          'Vendor Sign Up',
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
      body: Stepper(
        type: StepperType.vertical,
        currentStep: _currentStep,
        onStepContinue: () {
          if (_formKey.currentState!.validate()) {
            if (_currentStep < _getSteps().length - 1) {
              setState(() {
                _currentStep++;
              });
            } else {
              // Handle form submission
              _controller.registerVendor(context, _selectedPaymentMethod);
            }
          }
        },
        onStepCancel: () {
          if (_currentStep > 0) {
            setState(() {
              _currentStep--;
            });
          } else {
            Navigator.of(context).pop();
          }
        },
        steps: _getSteps(),
        controlsBuilder: (BuildContext context, ControlsDetails details) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              TextButton(
                onPressed: details.onStepCancel,
                child: Text(
                  'Back',
                  style: TextStyle(
                    color: Color(0xFF69734E),
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
              ElevatedButton(
                onPressed: details.onStepContinue,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF69734E),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  _currentStep == _getSteps().length - 1 ? 'Finish' : 'Next',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}