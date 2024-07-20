import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:reverie_app/screens/login_screen.dart';
import '../providers/user_provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, TextEditingController> controllers = {};
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    controllers['Email'] = TextEditingController(text: userProvider.email);
    controllers['First name'] = TextEditingController(text: userProvider.firstName);
    controllers['Last name'] = TextEditingController(text: userProvider.lastName);
    // Add more controllers if needed
  }

  @override
  void dispose() {
    controllers.forEach((key, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  void toggleEditing() {
    setState(() {
      isEditing = !isEditing;
    });
  }

  void saveChanges() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    setState(() {
      userProvider.setUserInfo(
        controllers['First name']!.text,
        controllers['Last name']!.text,
        controllers['Email']!.text,
      );
      // Save additional user info if needed
      isEditing = false;
    });
  }

  Future<void> _deleteAccount(BuildContext context, int userId) async {
    final url = 'https://reverie.newschateau.com/api/reverie/delete_account.php';
    try {
      print('Sending delete request for user ID: $userId');
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId}),
      );

      final decodedResponse = json.decode(response.body);
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(decodedResponse['message'])),
        );
        if (decodedResponse['message'] == 'Account deleted successfully') {
          final userProvider = Provider.of<UserProvider>(context, listen: false);
          print('UserProvider state before sign out: ${userProvider.toString()}');
          userProvider.signOut();
          print('UserProvider state after sign out: ${userProvider.toString()}');
          print('Navigating to login screen...');
          Future.delayed(Duration.zero, () {
            Navigator.of(context, rootNavigator: true).pushReplacementNamed('/login');
            print('Navigation to login screen attempted.');
          });
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to delete account: ${decodedResponse['message']}')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  Future<void> _changePassword(int userId, String newPassword) async {
    final url = 'https://reverie.newschateau.com/api/reverie/change_password.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'user_id': userId, 'new_password': newPassword}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data['message'])),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to change password')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _handleChangePassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String newPassword = '';
        return AlertDialog(
          title: Text('Change Password'),
          content: TextField(
            onChanged: (value) {
              newPassword = value;
            },
            obscureText: true,
            decoration: InputDecoration(
              labelText: 'New Password',
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Change'),
              onPressed: () async {
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                if (userProvider.userId != null) {
                  await _changePassword(userProvider.userId!, newPassword);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _handleDeleteAccount() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Account'),
          content: Text('Are you sure you want to delete your account? This action cannot be undone.'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () async {
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                if (userProvider.userId != null) {
                  await _deleteAccount(context, userProvider.userId!);
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    print('Building SettingsScreen with userProvider state: ${userProvider.toString()}');

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
          'My Settings',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          if (isEditing)
            IconButton(
              icon: Icon(Icons.save, color: Colors.black),
              onPressed: saveChanges,
            )
          else
            IconButton(
              icon: Icon(Icons.edit, color: Colors.black),
              onPressed: toggleEditing,
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildSectionHeader(context, 'Personal Details'),
            _buildEditableInfo('Email', userProvider.email),
            _buildEditableInfo('First name', userProvider.firstName),
            _buildEditableInfo('Last name', userProvider.lastName),
            // Add more fields if needed
            SizedBox(height: 20),
            _buildSectionHeader(context, 'Privacy'),
            _buildPrivacyOptions(),
          ],
        ),
      ),
    );   
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

  Widget _buildEditableInfo(String label, String? value) {
    return ListTile(
      title: Text(
        label,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 14,
          color: Colors.black54,
        ),
      ),
      subtitle: isEditing
          ? TextField(
              controller: controllers[label],
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black,
              ),
            )
          : Text(
              value ?? '',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black,
              ),
            ),
    );
  }

  Widget _buildPrivacyOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: _handleChangePassword,
          child: Text(
            'Change password',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Color(0xFF69734E),
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        SizedBox(height: 10),
        GestureDetector(
          onTap: _handleDeleteAccount,
          child: Text(
            'Delete Account',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Color(0xFF69734E),
                           decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        home: SettingsScreen(),
        routes: {
          '/login': (context) => LoginScreen(), // Ensure this route is defined
        },
      ),
    ),
  );
}