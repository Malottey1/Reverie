import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Map<String, String> userInfo = {
    'Email': 'clatteymolcolm4@gmail.com',
    'First name': 'Malcolm',
    'Last name': 'Clottey',
    'Date of birth': '03/09/2003',
    'Phone number': '+13014589407',
    'Gender': 'Male',
    'Zip Code': '22407-9264',
  };

  Map<String, TextEditingController> controllers = {};

  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    userInfo.forEach((key, value) {
      controllers[key] = TextEditingController(text: value);
    });
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
    setState(() {
      userInfo.forEach((key, value) {
        userInfo[key] = controllers[key]!.text;
      });
      isEditing = false;
    });
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
              onPressed: () {
                // Handle password change logic here
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
              onPressed: () {
                // Handle account deletion logic here
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
            ...userInfo.keys.map((key) => _buildEditableInfo(key)).toList(),
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

  Widget _buildEditableInfo(String label) {
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
              userInfo[label]!,
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
  runApp(MaterialApp(
    home: SettingsScreen(),
  ));
}