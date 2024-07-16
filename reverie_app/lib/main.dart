import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/user_provider.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/terms_and_conditions.dart';
import 'screens/vendor_signup_screen.dart';
import 'screens/vendor_store_screen.dart';
import 'screens/add_product_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'controllers/add_product_controller.dart';
import 'providers/vendor_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/payment_page.dart'; // Updated to use the new PaymentPage

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => AddProductController()),
        ChangeNotifierProvider(create: (_) => VendorProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF69734E),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF69734E),
          secondary: Colors.grey,
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
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
        '/payment': (context) => PaymentPage(amount: 0, email: ''), // Default values for now
      },
    );
  }
}