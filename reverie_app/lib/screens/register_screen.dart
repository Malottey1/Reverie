import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../routes/slide_left_route.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/custom_dropdown.dart';
import '../controllers/register_controller.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController _controller = RegisterController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        _controller.birthdayController.text = picked.toLocal().toString().split(' ')[0]; // Format the date as YYYY-MM-DD
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDBD3),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/reverie-logo.png',
                    height: 40,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 20,
                      fontFamily: 'Poppins',
                      color: Color(0xFF69734E),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Create Your Account',
                    style: TextStyle(
                      fontSize: 16,
                      fontFamily: 'Poppins',
                      color: Color(0xFF69734E),
                    ),
                  ),
                  SizedBox(height: 24),
                  CustomTextField(
                    hintText: 'First Name',
                    controller: _controller.firstNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your first name';
                      }
                      if (value.length < 2) {
                        return 'First name must be at least 2 characters long';
                      }
                      if (value.length > 30) {
                        return 'First name must be less than 30 characters long';
                      }
                      if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                        return 'First name can only contain letters and spaces';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'Last Name',
                    controller: _controller.lastNameController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your last name';
                      }
                      if (value.length < 2) {
                        return 'Last name must be at least 2 characters long';
                      }
                      if (value.length > 30) {
                        return 'Last name must be less than 30 characters long';
                      }
                      if (!RegExp(r'^[a-zA-Z ]+$').hasMatch(value)) {
                        return 'Last name can only contain letters and spaces';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'Email',
                    controller: _controller.emailController,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                        return 'Please enter a valid email address';
                      }
                      // Additional unique email validation should be done server-side
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'Password',
                    controller: _controller.passwordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      if (value.length < 8) {
                        return 'Password must be at least 8 characters long';
                      }
                      if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]').hasMatch(value)) {
                        return 'Password must include an uppercase letter, lowercase letter, number, and special character';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    hintText: 'Confirm Password',
                    controller: _controller.confirmPasswordController,
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please confirm your password';
                      }
                      if (value != _controller.passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  CustomDropdown(
                    hintText: 'Gender',
                    items: ['Male', 'Female', 'Other'],
                    onChanged: (value) {
                      setState(() {
                        _controller.gender = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your gender';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: CustomTextField(
                        hintText: 'Birthday (YYYY-MM-DD)',
                        controller: _controller.birthdayController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please select your birthday';
                          }
                          final date = DateTime.tryParse(value);
                          if (date == null) {
                            return 'Invalid date format';
                          }
                          final age = DateTime.now().difference(date).inDays ~/ 365;
                          if (age < 18) {
                            return 'You must be at least 18 years old';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Color(0xFF69734E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 130, vertical: 10),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          // Log the data being sent
                          print('Registering user with data:');
                          print('First Name: ${_controller.firstNameController.text}');
                          print('Last Name: ${_controller.lastNameController.text}');
                          print('Email: ${_controller.emailController.text}');
                          print('Gender: ${_controller.gender}');
                          print('Birthday: ${_controller.birthdayController.text}');

                          await _controller.register(context);
                        } catch (e) {
                          print('Exception occurred while registering user: $e');
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Failed to register user: $e')),
                          );
                        }
                      }
                    },
                    child: Text(
                      'Register',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        SlideLeftRoute(page: LoginScreen()),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(top: 25.0),
                      child: Text(
                        'Already Have An Account? Sign In here',
                        style: const TextStyle(
                          fontSize: 14,
                          fontFamily: 'Poppins',
                          color: Color(0xFF69734E),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}