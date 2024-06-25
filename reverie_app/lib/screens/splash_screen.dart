import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDDBD3),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Spacer for top
          SizedBox(height: 50),
          // Center logo
          Center(
            child: Image.asset(
              'assets/reverie-logo.png',
              height: 100,
            ),
          ),
          // Spacer for center
          SizedBox(height: 50),
          // Powered by section
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'powered by',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 12,
                    color: Color(0xFF69734E),
                  ),
                ),
                SizedBox(height: 5),
                Image.asset(
                  'assets/mm-logo.png',
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}