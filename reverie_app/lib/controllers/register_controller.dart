import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import '/services/api_connection.dart'; // Assuming the path to ApiConnection class

class RegisterController {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController birthdayController = TextEditingController();
  String? gender;

  final ApiConnection api = ApiConnection();

  Future<void> register(BuildContext context) async {
    final String firstName = firstNameController.text;
    final String lastName = lastNameController.text;
    final String email = emailController.text;
    final String password = passwordController.text;
    final String confirmPassword = confirmPasswordController.text;
    final String birthday = birthdayController.text;

    if (password != confirmPassword) {
      // Handle password mismatch
      print('Passwords do not match');
      return;
    }

    final user = User(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
      gender: gender ?? '',
      birthday: birthday,
    );

    print('Sending registration data: ${user.toJson()}'); // Log the data being sent

    try {
      final response = await api.registerUser(user.toJson());
      if (response['message'] == 'Registration successful') {
        // Handle successful registration
        print('Registration successful');
        Navigator.pushReplacementNamed(context, '/login');
      } else {
        // Handle registration error
        print('Registration failed: ${response['message']}');
      }
    } catch (e) {
      // Handle network or other errors
      print('Registration failed: $e');
    }
  }

  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    birthdayController.dispose();
  }
}