import 'package:flutter/material.dart';

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDBD3),
      appBar: AppBar(
        backgroundColor: Color(0xFF69734E),
        title: Text(
          'Support',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop(); // Navigate back when back button is pressed
          },
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          _buildSupportListTile(
            title: 'Help Center',
            subtitle: 'Find answers to common questions about our products and services',
            onTap: () {
              _handleSupportOptionSelected(context, 'Help Center');
            },
          ),
          _buildSupportListTile(
            title: 'Send us a message',
            onTap: () {
              _handleSupportOptionSelected(context, 'Send us a message');
            },
          ),
          _buildSupportListTile(
            title: 'Chat with us',
            onTap: () {
              _handleSupportOptionSelected(context, 'Chat with us');
            },
          ),
          _buildSupportListTile(
            title: 'Call us',
            onTap: () {
              _handleSupportOptionSelected(context, 'Call us');
            },
          ),
          _buildSupportListTile(
            title: 'Check your order status',
            onTap: () {
              _handleSupportOptionSelected(context, 'Check your order status');
            },
          ),
        ],
      ),
    );
  }

  void _handleSupportOptionSelected(BuildContext context, String option) {
    switch (option) {
      case 'Help Center':
        break;
      case 'Send us a message':
        break;
      case 'Chat with us':
        break;
      case 'Call us':
        break;
      case 'Check your order status':
        break;
      default:
        break;
    }
  }

  Widget _buildSupportListTile({
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black,
            ),
          ),
          subtitle: subtitle != null
              ? Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.black54,
                  ),
                )
              : null,
          trailing: Icon(
            Icons.arrow_forward,
            color: Colors.black,
          ),
          onTap: onTap,
        ),
        Divider(),
      ],
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: SupportScreen(),
  ));
}
