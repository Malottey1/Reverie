import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderTrackingScreen extends StatelessWidget {
  final String orderId;

  OrderTrackingScreen({required this.orderId});

  Future<Map<String, dynamic>> fetchTrackingDetails(String orderId) async {
    final String url = 'https://reverie.newschateau.com/api/reverie/fetch_buyer_tracking.php';
    try {
      print('Fetching tracking details for order ID: $orderId');  // Log the start of the fetch
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'order_id': orderId}),
      );

      print('Response status code: ${response.statusCode}');  // Log response status code
      print('Response body: ${response.body}');  // Log response body

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load tracking details');
      }
    } catch (e) {
      print('Exception caught: $e');  // Log any exception that occurs
      throw Exception('Failed to load tracking details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: fetchTrackingDetails(orderId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
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
            body: Center(child: CircularProgressIndicator()),
          );
        } else if (snapshot.hasError) {
          print('Error in snapshot: ${snapshot.error}');  // Log the error in the snapshot
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
            body: Center(child: Text('Error fetching tracking details')),
          );
        } else {
          final trackingDetails = snapshot.data!;
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
                  _buildOrderSummary(trackingDetails),
                  SizedBox(height: 20),
                  _buildOrderInfo(orderId),
                  SizedBox(height: 20),
                  _buildItemsInfo(trackingDetails['items']),
                  SizedBox(height: 20),
                  _buildPickupStatus(trackingDetails['status'], trackingDetails['estimated_delivery_date']),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildOrderSummary(Map<String, dynamic> trackingDetails) {
    return Column(
      children: [
        Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              trackingDetails['items'][0]['imageUrl'],
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 10),
        Center(
          child: Text(
            trackingDetails['items'][0]['name'],
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
            'To Ahmed', // This should be dynamic based on your data
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
            'Estimated day of delivery: ${trackingDetails['estimated_delivery_date']}',
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

  Widget _buildItemsInfo(List<dynamic> items) {
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
        ...items.map((item) => _buildOrderItem(item['name'], item['imageUrl'], item['price'])).toList(),
      ],
    );
  }

    Widget _buildPickupStatus(String status, String estimatedDeliveryDate) {
    List<String> statuses = ['Ready', 'Picked Up', 'Delivered'];
    List<String> descriptions = [
      'Your item is ready for pickup.',
      'Your item has been picked up.',
      'Your item has been delivered.'
    ];

    int statusIndex;
    if (status == 'Ready') {
      statusIndex = 0;
    } else if (status == 'Picked Up') {
      statusIndex = 1;
    } else if (status == 'Delivered') {
      statusIndex = 2;
    } else {
      statusIndex = -1; // Default case
    }

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