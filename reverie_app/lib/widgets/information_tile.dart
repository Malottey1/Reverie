import 'package:flutter/material.dart';


class InformationTile extends StatelessWidget {
  final String title;
  final String name;
  final String details;
  final Widget screen;

  InformationTile({required this.title, required this.name, required this.details, required this.screen});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text('$name\n$details'),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }
}