import 'package:flutter/material.dart';

class SizeOption extends StatelessWidget {
  final String size;

  SizeOption({required this.size});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Size: ${size ?? 'M'}',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}