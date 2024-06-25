import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFDDDBD3),
      body: Center(
        child: Image.asset('assets/reverie-logo.png'),
      ),
    );
  }
}