import 'package:flutter/material.dart';
import 'order_tracking_screen.dart';  // Import the OrderTrackingScreen

class OrderHistoryScreen extends StatelessWidget {
  final List<Map<String, String>> orders = [
    {
      'id': '1',
      'title': 'Order #12345',
      'status': 'Delivered',
      'date': 'June 25, 2023',
      'image': 'https://via.placeholder.com/100',
      'price': '\$56.99'
    },
    {
      'id': '2',
      'title': 'Order #12346',
      'status': 'Out for delivery',
      'date': 'June 26, 2023',
      'image': 'https://via.placeholder.com/100',
      'price': '\$74.50'
    },
    {
      'id': '3',
      'title': 'Order #12347',
      'status': 'Processing',
      'date': 'June 27, 2023',
      'image': 'https://via.placeholder.com/100',
      'price': '\$120.00'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDBD3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Order History',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: orders.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildOrderItem(context, orders[index]);
        },
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, Map<String, String> order) {
    return GestureDetector(
      onTap: () {
        if (order['status'] == 'Out for delivery') {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OrderTrackingScreen(
                orderId: order['id']!,
                items: [
                  {'name': 'A-line Mini Dress', 'imageUrl': 'https://via.placeholder.com/100x150', 'price': '\$24.99'},
                  {'name': 'Fitted T-shirt', 'imageUrl': 'https://via.placeholder.com/100x150', 'price': '\$6.99'},
                  {'name': 'Draped One-shoulder Top', 'imageUrl': 'https://via.placeholder.com/100x150', 'price': '\$19.99'},
                  {'name': 'Regular Fit Cotton Shorts', 'imageUrl': 'https://via.placeholder.com/100x150', 'price': '\$4.99'},
                ],
                pickupStatus: 'Out for delivery',
                estimatedDeliveryDate: 'Within 3-5 business days',
              ),
            ),
          );
        }
      },
      child: Card(
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
                  order['image']!,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order['title']!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF69734E),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      order['status']!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: order['status'] == 'Delivered'
                            ? Color(0xFF69734E)
                            : Color.fromARGB(255, 78, 118, 137),
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      order['date']!,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                order['price']!,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF69734E),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: OrderHistoryScreen(),
  ));
}