import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_information_screen.dart';
import 'billing_address_screen.dart';
import 'shipping_address_screen.dart';
import 'order_confirmation_screen.dart';
import 'payment_page.dart';
import '../models/checkout_info.dart';
import '../models/cart_item.dart';
import '../providers/user_provider.dart';
import '../services/api_connection.dart';
import '/widgets/information_tile.dart';
import '/widgets/package_details.dart';
import '/widgets/summary.dart';
import '/widgets/total.dart';
import '/widgets/checkout_button.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late Future<CheckoutInfo> _checkoutInfoFuture;
  late Future<List<CartItem>> _cartItemsFuture;
  double _totalAmount = 0.0;

  @override
  void initState() {
    super.initState();
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId != null) {
      _checkoutInfoFuture = ApiConnection().fetchCheckoutInfo(userId);
      _cartItemsFuture = ApiConnection().fetchCartItems(userId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDBD3),
      appBar: AppBar(
        backgroundColor: Color(0xFF69734E),
        title: Text(
          'Checkout',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<CheckoutInfo>(
          future: _checkoutInfoFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              print('Error loading checkout info: ${snapshot.error}');
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            } else {
              final info = snapshot.data!;
              print('Checkout Info loaded: $info');
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InformationTile(
                    title: 'My Information',
                    name: '${info.firstName} ${info.lastName}',
                    details: info.email,
                    screen: MyInformationScreen(),
                  ),
                  InformationTile(
                    title: 'Billing Address',
                    name: '${info.billingName}',
                    details: '${info.billingAddress}\n${info.billingCity}\n${info.billingState}\n${info.billingCountry}',
                    screen: BillingAddressScreen(),
                  ),
                  InformationTile(
                    title: 'Shipping',
                    name: '${info.shippingFirstName} ${info.shippingLastName}',
                    details: '${info.shippingAddress}\n${info.shippingCity}\n${info.shippingState}\n${info.shippingCountry}',
                    screen: ShippingAddressScreen(),
                  ),
                  FutureBuilder<List<CartItem>>(
                    future: _cartItemsFuture,
                    builder: (context, cartSnapshot) {
                      if (cartSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (cartSnapshot.hasError) {
                        print('Error loading cart items: ${cartSnapshot.error}');
                        return Center(child: Text('Error: ${cartSnapshot.error}'));
                      } else if (!cartSnapshot.hasData || cartSnapshot.data!.isEmpty) {
                        return Center(child: Text('Your cart is empty'));
                      } else {
                        final cartItems = cartSnapshot.data!;
                        print('Cart Items loaded: $cartItems');
                        final double orderValue = cartItems.fold(0.0, (sum, item) => sum + item.price);
                        final double deliveryFee = 5.99;
                        final double estimatedTaxes = orderValue * 0.1;
                        final double totalAmount = orderValue + deliveryFee + estimatedTaxes;
                        _totalAmount = totalAmount;
                        return Column(
                          children: [
                            PackageDetails(cartItems: cartItems),
                            Summary(orderValue: orderValue, deliveryFee: deliveryFee, estimatedTaxes: estimatedTaxes),
                            Total(totalAmount: totalAmount),
                            CheckoutButton(totalAmount: totalAmount),
                          ],
                        );
                      }
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}