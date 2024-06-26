import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/terms_and_conditions.dart';
import 'screens/vendor_signup_screen.dart';
import 'screens/vendor_store_screen.dart';
import 'screens/add_product_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xFF69734E), // This will affect the active step color
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF69734E), // Active step color
          secondary: Colors.grey, // Inactive step color
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
          ),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/onboarding': (context) => OnboardingScreen(),
        '/terms': (context) => TermsConditionsScreen(),
        '/vendor-signup': (context) => VendorSignupScreen(),
        '/vendor-store': (context) => VendorStoreScreen(),
        '/add-product': (context) => AddProductScreen(),
      },
    );
  }
}