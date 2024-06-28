import 'package:flutter/material.dart';

void main() {
  runApp(SupportScreenApp());
}

class SupportScreenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Support Screen',
      theme: ThemeData(
        // Define your color scheme here
        primaryColor: Colors.grey[300],
        appBarTheme: AppBarTheme(
          color: Colors.grey[300],
          iconTheme: IconThemeData(color: Colors.black),
          textTheme: TextTheme(
            headline6: TextStyle(
              color: Colors.black,
              fontSize: 20.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      home: SupportScreen(),
    );
  }
}

class SupportScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Add your back navigation code here
          },
        ),
        title: Text('Support'),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
        children: [
          SupportListTile(
            title: 'Help Center',
            subtitle: 'Find answers to common questions about our products and services',
            onTap: () {
              // Add your onTap code here
            },
          ),
          SupportListTile(
            title: 'Send us a message',
            onTap: () {
              // Add your onTap code here
            },
          ),
          SupportListTile(
            title: 'Chat with us',
            onTap: () {
              // Add your onTap code here
            },
          ),
          SupportListTile(
            title: 'Call us',
            onTap: () {
              // Add your onTap code here
            },
          ),
          SupportListTile(
            title: 'Check your order status',
            onTap: () {
              // Add your onTap code here
            },
          ),
        ],
      ),
    );
  }
}

class SupportListTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const SupportListTile({
    Key? key,
    required this.title,
    this.subtitle = '',
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          title: Text(title),
          subtitle: subtitle.isNotEmpty ? Text(subtitle) : null,
          trailing: Icon(Icons.arrow_forward),
          onTap: onTap,
        ),
        Divider(),
      ],
    );
  }
}
