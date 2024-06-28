import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import '/services/api_connection.dart'; // Assuming the path to ApiConnection class
import 'package:art_sweetalert/art_sweetalert.dart';

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
      _showErrorDialog(context, 'Passwords do not match');
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
        _showSuccessDialog(context);
      } else {
        _showErrorDialog(context, 'Registration failed: ${response['message']}');
      }
    } catch (e) {
      _showErrorDialog(context, 'Registration failed: $e');
    }
  }

  void _showSuccessDialog(BuildContext context) {
    ArtSweetAlert.show(
      context: context,
      artDialogArgs: ArtDialogArgs(
        type: ArtSweetAlertType.success,
        title: "Registration Successful",
        text: "Welcome to Reverie!",
        confirmButtonText: "Okay",
        onConfirm: () {
          Navigator.pushReplacementNamed(context, '/login');
        },
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    ArtSweetAlert.show(
      context: context,
      artDialogArgs: ArtDialogArgs(
        type: ArtSweetAlertType.danger,
        title: "Error",
        text: message,
        confirmButtonText: "Okay",
      ),
    );
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