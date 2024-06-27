import 'package:flutter/material.dart';
import 'order_tracking_screen.dart';

class OrderConfirmationScreen extends StatelessWidget {
  final String totalAmount;

  OrderConfirmationScreen({required this.totalAmount});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDBD3),
      appBar: AppBar(
        backgroundColor: Color(0xFF69734E),
        title: Text(
          'Order Confirmation',
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
            Center(
              child: Text(
                'Thanks for your order!',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                  color: Color(0xFF69734E),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Order ID: 1234567890',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Items Purchased:',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF69734E),
              ),
            ),
            SizedBox(height: 10),
            _buildOrderItem(
              'A-line Mini Dress',
              'https://via.placeholder.com/100x150',
              '\$24.99',
            ),
            _buildOrderItem(
              'Fitted T-shirt',
              'https://via.placeholder.com/100x150',
              '\$6.99',
            ),
            _buildOrderItem(
              'Draped One-shoulder Top',
              'https://via.placeholder.com/100x150',
              '\$19.99',
            ),
            _buildOrderItem(
              'Regular Fit Cotton Shorts',
              'https://via.placeholder.com/100x150',
              '\$4.99',
            ),
            SizedBox(height: 20),
            Text(
              'Total: $totalAmount',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Estimated Delivery: Within 3-5 business days',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
              ),
            ),
            SizedBox(height: 30),
            Center(
              child: Column(
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF69734E),
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderTrackingScreen(
                            orderId: '1234567890',
                            items: [
                              {'name': 'A-line Mini Dress', 'imageUrl': 'https://via.placeholder.com/100x150', 'price': '\$24.99'},
                              {'name': 'Fitted T-shirt', 'imageUrl': 'https://via.placeholder.com/100x150', 'price': '\$6.99'},
                              {'name': 'Draped One-shoulder Top', 'imageUrl': 'https://via.placeholder.com/100x150', 'price': '\$19.99'},
                              {'name': 'Regular Fit Cotton Shorts', 'imageUrl': 'https://via.placeholder.com/100x150', 'price': '\$4.99'},
                            ],
                            pickupStatus: 'Picked Up',
                            estimatedDeliveryDate: 'Within 3-5 business days',
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Track Order',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Color(0xFF69734E), 
                      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      side: BorderSide(color: Color(0xFF69734E)),
                    ),
                    onPressed: () {
                      // Navigate back to the home screen
                    },
                    child: Text(
                      'Continue Shopping',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Color(0xFF69734E),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(String name, String imageUrl, String price) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      color: Color(0xFFDDDBD3),
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Color(0xFF69734E)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF69734E),
                ),
              ),
            ),
            Text(
              price,
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Color(0xFF69734E),
              ),
            ),
          ],
        ),
      ),
    );
  }
}