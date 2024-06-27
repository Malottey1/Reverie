import 'package:flutter/material.dart';
import 'my_information_screen.dart'; // Import your screen files accordingly
import 'billing_address_screen.dart';
import 'shipping_address_screen.dart';
import 'payment_selection_screen.dart';
import 'order_details.dart';
import 'order_confirmation_screen.dart';

class CheckoutScreen extends StatelessWidget {
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInformationTile(context, 'My Information', 'Malcolm Clottey', 'clatteymolcolm4@gmail.com', MyInformationScreen()),
            _buildInformationTile(context, 'Billing address', 'Malcolm Clottey', '9516 Fall Haven Rd\nFredericksburg Virginia\n22407-9264\nUSA', BillingAddressScreen()),
            _buildInformationTile(context, 'Shipping', 'Malcolm Clottey', '+1 5714614899', ShippingAddressScreen()),
            _buildPackageDetails(context),
            _buildSummary(),
            _buildPaymentTile(context),
            _buildTotal(),
            _buildCheckoutButton(context),
          ],
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

  Widget _buildPackageDetails(BuildContext context) {
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
                Text(
                  'Order ID: 1234567890',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Color(0xFF69734E),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://via.placeholder.com/100x150',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://via.placeholder.com/100x150',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    'https://via.placeholder.com/100x150',
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.info_outline, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => OrderDetailsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Malcolm Clottey\n9516 Fall Haven Rd\nFredericksburg Virginia\n22407-9264\nUSA',
              style: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('\$5.99', style: TextStyle(fontFamily: 'Poppins')),
                Text('Standard Delivery', style: TextStyle(fontFamily: 'Poppins')),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
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
              '\$24.99',
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
              '\$5.99',
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
              '\$1.64',
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

  Widget _buildPaymentTile(BuildContext context) {
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
          MaterialPageRoute(builder: (context) => PaymentScreen(totalAmount: '\$32.62')),
        );
      },
    );
  }

  Widget _buildTotal() {
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
            '\$32.62',
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

  Widget _buildCheckoutButton(BuildContext context) {
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
              builder: (context) => OrderConfirmationScreen(totalAmount: '\$32.62'),
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
  runApp(MaterialApp(
    home: CheckoutScreen(),
  ));
}