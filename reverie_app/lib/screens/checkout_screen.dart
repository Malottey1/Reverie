import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'my_information_screen.dart';
import 'billing_address_screen.dart';
import 'shipping_address_screen.dart';
import 'payment_selection_screen.dart';
import 'cart_screen.dart';
import 'order_confirmation_screen.dart';
import '../models/checkout_info.dart';
import '../models/cart_item.dart';
import '../providers/user_provider.dart';
import '../services/api_connection.dart';

class CheckoutScreen extends StatefulWidget {
  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  late Future<CheckoutInfo> _checkoutInfoFuture;
  late Future<List<CartItem>> _cartItemsFuture;

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
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData) {
              return Center(child: Text('No data available'));
            } else {
              final info = snapshot.data!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInformationTile(
                    context,
                    'My Information',
                    '${info.firstName} ${info.lastName}',
                    info.email,
                    MyInformationScreen(),
                  ),
                  _buildInformationTile(
                    context,
                    'Billing Address',
                    '${info.billingName}',
                    '${info.billingAddress}\n${info.billingCity}\n${info.billingState}\n${info.billingCountry}',
                    BillingAddressScreen(),
                  ),
                  _buildInformationTile(
                    context,
                    'Shipping',
                    '${info.shippingFirstName} ${info.shippingLastName}',
                    '${info.shippingAddress}\n${info.shippingCity}\n${info.shippingState}\n${info.shippingCountry}',
                    ShippingAddressScreen(),
                  ),
                  FutureBuilder<List<CartItem>>(
                    future: _cartItemsFuture,
                    builder: (context, cartSnapshot) {
                      if (cartSnapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (cartSnapshot.hasError) {
                        return Center(child: Text('Error: ${cartSnapshot.error}'));
                      } else if (!cartSnapshot.hasData || cartSnapshot.data!.isEmpty) {
                        return Center(child: Text('Your cart is empty'));
                      } else {
                        final cartItems = cartSnapshot.data!;
                        final double orderValue = cartItems.fold(0.0, (sum, item) => sum + item.price);
                        final double deliveryFee = 5.99;
                        final double estimatedTaxes = orderValue * 0.1;
                        final double totalAmount = orderValue + deliveryFee + estimatedTaxes;
                        return Column(
                          children: [
                            _buildPackageDetails(context, cartItems),
                            _buildSummary(orderValue, deliveryFee, estimatedTaxes),
                            _buildPaymentTile(context, totalAmount),
                            _buildTotal(totalAmount),
                            _buildCheckoutButton(context, totalAmount),
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

  Widget _buildInformationTile(BuildContext context, String title, String name, String details, Widget screen) {
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

  Widget _buildPackageDetails(BuildContext context, List<CartItem> cartItems) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Color(0xFF69734E)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Package',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.info_outline, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CartScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Column(
              children: cartItems.map((item) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          item.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.title,
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                '\$${item.price.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Text(
                        'Size: ${item.size}',
                        style: TextStyle(
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary(double orderValue, double deliveryFee, double estimatedTaxes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order value',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$${orderValue.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Delivery fee',
              style: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              '\$${deliveryFee.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Est. taxes',
              style: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              '\$${estimatedTaxes.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }

  Widget _buildPaymentTile(BuildContext context, double totalAmount) {
    return ListTile(
      title: Text(
        'Payment',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => PaymentSelectionScreen(totalAmount: totalAmount)),
        );
      },
    );
  }

  Widget _buildTotal(double totalAmount) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '\$${totalAmount.toStringAsFixed(2)}',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCheckoutButton(BuildContext context, double totalAmount) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF69734E),
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderConfirmationScreen(totalAmount: totalAmount.toString()),
            ),
          );
        },
        child: Text(
          'Place Order',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child: MaterialApp(
        home: CheckoutScreen(),
      ),
    ),
  );
}