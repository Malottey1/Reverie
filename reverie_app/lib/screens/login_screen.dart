import 'package:flutter/material.dart';
import 'package:reverie_app/routes/slide_left_route.dart';
import 'package:reverie_app/screens/onboarding_screen.dart';
import '../routes/slide_right_route.dart';
import 'register_screen.dart';
import '../controllers/login_controller.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = LoginController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDBD3),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  'assets/reverie-logo.png',
                  height: 40,
                ),
                SizedBox(height: 8),
                Text(
                  'Sign in',
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: 'Poppins',
                    color: Color(0xFF69734E),
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Enter Your Account Details',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: 'Poppins',
                    color: Color(0xFF69734E),
                  ),
                ),
                SizedBox(height: 24),
                CustomTextField(
                  hintText: 'Email',
                  controller: _controller.emailController,
                ),
                SizedBox(height: 16),
                CustomTextField(
                  hintText: 'Password',
                  controller: _controller.passwordController,
                  obscureText: true,
                ),
                SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFF69734E),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 140, vertical: 10),
                  ),
                  onPressed: () {
                    _controller.login(context);
                  },
                  child: Text(
                    'Sign In',
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
                      SlideLeftRoute(page: OnboardingScreen()),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(top: 25.0),
                    child: Text(
                      "Don't have an Account? Register here",
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
    );
  }
}