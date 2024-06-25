import 'package:flutter/material.dart';
import 'screens/onboarding_screen.dart';
import 'screens/splash_screen.dart'; // Import the splash_screen.dart file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
      },
    );
  }
}