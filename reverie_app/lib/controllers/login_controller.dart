import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../screens/home_screen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginController {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> login(BuildContext context) async {
    final String email = emailController.text;
    final String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog(context, 'Please fill in all fields');
      return;
    }

    try {
      final response = await http.post(
        Uri.parse('http://192.168.102.56/api/reverie/login.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      print('Request URL: http://192.168.102.56/api/reverie/login.php');
      print('Request Body: ${json.encode({'email': email, 'password': password})}');
      print('Response Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['message'] == 'Login successful') {
          // Store the user ID in the UserProvider
          final userId = responseData['user_id'];
          Provider.of<UserProvider>(context, listen: false).setUserId(userId);

          // Handle successful login
          print('Login successful');
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        } else {
          print('Login failed: ${responseData['message']}');
          _showErrorDialog(context, 'Login failed: ${responseData['message']}');
        }
      } else {
        print('Server error: ${response.statusCode}');
        _showErrorDialog(context, 'Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Login failed: $e');
      _showErrorDialog(context, 'Login failed: $e');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(
          'Try Again',
          style: TextStyle(fontFamily: 'Poppins'), // Set Poppins font for the title
        ),
        content: Text(
          message,
          style: TextStyle(fontFamily: 'Poppins'), // Set Poppins font for the content
        ),
        actions: <Widget>[
          TextButton(
            child: Text(
              'Okay',
              style: TextStyle(fontFamily: 'Poppins'), // Set Poppins font for the button
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          ),
        ],
      ),
    );
  }

  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}