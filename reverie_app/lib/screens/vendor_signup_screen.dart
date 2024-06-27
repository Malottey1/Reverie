import 'package:flutter/material.dart';

class VendorSignupScreen extends StatefulWidget {
  @override
  _VendorSignupScreenState createState() => _VendorSignupScreenState();
}

class _VendorSignupScreenState extends State<VendorSignupScreen> {
  int _currentStep = 0;
  int _selectedPaymentMethod = 0;

  List<Step> _getSteps() {
    return [
      Step(
        title: Text('Step 1'),
        isActive: _currentStep >= 0,
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
            _buildTextField('Profile Photo', icon: Icons.camera_alt),
            _buildTextField('Business Description', isMultiline: true),
          ],
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
            _buildTextField('Business name'),
            _buildTextField('Business number registration'),
            _buildTextField('Business Address/ Postal Code'),
            _buildTextField('City'),
            _buildTextField('State/Province'),
            _buildTextField('Country'),
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
          ],
        ),
      ),
    ];
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
          if (_currentStep < _getSteps().length - 1) {
            setState(() {
              _currentStep++;
            });
          } else {
            // Handle form submission
            Navigator.pushReplacementNamed(context, '/vendor-store');
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