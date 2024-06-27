import 'package:flutter/material.dart';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;
  final List<Map<String, String>> items;
  final String pickupStatus;
  final String estimatedDeliveryDate;

  OrderTrackingScreen({
    required this.orderId,
    required this.items,
    required this.pickupStatus,
    required this.estimatedDeliveryDate,
  });

  @override
  Widget build(BuildContext context) {
    int statusIndex;
    if (pickupStatus == 'Ready') {
      statusIndex = 0;
    } else if (pickupStatus == 'Picked Up') {
      statusIndex = 1;
    } else if (pickupStatus == 'Delivered') {
      statusIndex = 2;
    } else {
      statusIndex = -1; // Default case
    }

    return Scaffold(
      backgroundColor: Color(0xFFDDDBD3),
      appBar: AppBar(
        backgroundColor: Color(0xFF69734E),
        title: Text(
          'Tracking Details',
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
            _buildOrderSummary(),
            SizedBox(height: 20),
            _buildOrderInfo(orderId),
            SizedBox(height: 20),
            _buildItemsInfo(items),
            SizedBox(height: 20),
            _buildPickupStatus(statusIndex),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              'assets/men.png', // Replace with the image asset for the item
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            'Men Graphic Tee',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            'To Ahmed',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Colors.black54,
            ),
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: Text(
            'Estimated day of delivery: $estimatedDeliveryDate',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: Color(0xFF69734E),
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderInfo(String orderId) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order ID: $orderId',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
      ],
    );
  }

  Widget _buildItemsInfo(List<Map<String, String>> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Item(s):',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Colors.black,
          ),
        ),
        ...items.map((item) => _buildOrderItem(item['name']!, item['imageUrl']!, item['price']!)).toList(),
      ],
    );
  }

  Widget _buildPickupStatus(int statusIndex) {
    List<String> statuses = ['Ready', 'Picked Up', 'Delivered'];
    List<String> descriptions = [
      'Your item is ready for pickup.',
      'Your item has been picked up.',
      'Your item has been delivered.'
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Text(
          'Delivery Status:',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Color(0xFF69734E),
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 30),
        Column(
          children: List.generate(statuses.length, (index) {
            return Row(
              children: [
                Column(
                  children: [
                    CircleAvatar(
                      radius: 5,
                      backgroundColor: statusIndex >= index ? Color(0xFF69734E) : Colors.grey,
                    ),
                    if (index != statuses.length - 1)
                      Container(
                        width: 1,
                        height: 50,
                        color: statusIndex > index ? Color(0xFF69734E) : Colors.grey,
                      ),
                  ],
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statuses[index],
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      descriptions[index],
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
        ),
      ],
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

void main() {
  runApp(MaterialApp(
    home: OrderTrackingScreen(
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
  ));
}