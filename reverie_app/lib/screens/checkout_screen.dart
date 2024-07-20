import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'my_information_screen.dart';
import 'billing_address_screen.dart';
import 'shipping_address_screen.dart';
import 'order_confirmation_screen.dart';
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
    _loadData();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _showInfoDialog(context);
    });
  }

  void _loadData() {
    final userId = Provider.of<UserProvider>(context, listen: false).userId;
    if (userId != null) {
      setState(() {
        _checkoutInfoFuture = ApiConnection().fetchCheckoutInfo(userId);
        _cartItemsFuture = ApiConnection().fetchCartItems(userId);
      });
    }
  }

  Future<void> _refreshData() async {
    _loadData();
    await _checkoutInfoFuture;
    await _cartItemsFuture;
  }

  void _showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Important Information'),
        content: Text('Please make sure to fill out both billing and shipping addresses to ensure timely delivery.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  void _validateAndProceed(BuildContext context, CheckoutInfo info, List<CartItem> cartItems) {
    print('Validating checkout info...');
    print('First Name: ${info.firstName}');
    print('Last Name: ${info.lastName}');
    print('Email: ${info.email}');
    print('Billing Name: ${info.billingName}');
    print('Billing Address: ${info.billingAddress}');
    print('Billing City: ${info.billingCity}');
    print('Billing State: ${info.billingState}');
    print('Billing Country: ${info.billingCountry}');
    print('Shipping First Name: ${info.shippingFirstName}');
    print('Shipping Last Name: ${info.shippingLastName}');
    print('Shipping Address: ${info.shippingAddress}');
    print('Shipping City: ${info.shippingCity}');
    print('Shipping State: ${info.shippingState}');
    print('Shipping Country: ${info.shippingCountry}');
    print('Cart Items: ${cartItems.length}');

    if (info.firstName.isEmpty ||
        info.lastName.isEmpty ||
        info.email.isEmpty ||
        info.billingName == null ||
        info.billingAddress == null ||
        info.billingCity == null ||
        info.billingState == null ||
        info.billingCountry == null ||
        info.shippingFirstName == null ||
        info.shippingLastName == null ||
        info.shippingAddress == null ||
        info.shippingCity == null ||
        info.shippingState == null ||
        info.shippingCountry == null ||
        cartItems.isEmpty) {
      print('Validation failed: Missing required information.');
      _showMissingInfoDialog(context);
    } else {
      print('Validation succeeded: Proceeding to order confirmation.');
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => OrderConfirmationScreen(
            orderId: '12345', // Pass your actual order ID here
            totalAmount: _totalAmount.toStringAsFixed(2),
          ),
        ),
      );
    }
  }

  void _showMissingInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Missing Information'),
        content: Text('Please make sure all information is entered before proceeding.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
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
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
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
                      name: info.billingName ?? '',
                      details: '${info.billingAddress ?? ''}\n${info.billingCity ?? ''}\n${info.billingState ?? ''}\n${info.billingCountry ?? ''}',
                      screen: BillingAddressScreen(),
                    ),
                    InformationTile(
                      title: 'Shipping',
                      name: '${info.shippingFirstName ?? ''} ${info.shippingLastName ?? ''}',
                      details: '${info.shippingAddress ?? ''}\n${info.shippingCity ?? ''}\n${info.shippingState ?? ''}\n${info.shippingCountry ?? ''}',
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
                              CheckoutButton(
                                totalAmount: totalAmount,
                                onPressed: () => _validateAndProceed(context, info, cartItems),
                              ),
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
      ),
    );
  }
}