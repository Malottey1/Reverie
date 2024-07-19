import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../services/api_connection.dart';

class VendorOrderDetailsScreen extends StatelessWidget {
  final String orderId;
  final String title;

  VendorOrderDetailsScreen({required this.orderId, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDBD3),
      appBar: AppBar(
        backgroundColor: Color(0xFFDDDBD3),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Order Details',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _fetchOrderDetails(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final orderDetails = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildOrderInfo(orderDetails),
                  SizedBox(height: 20),
                  _buildOrderItems(orderDetails['items']),
                  SizedBox(height: 20),
                  _buildTransactionInfo(orderDetails),
                  SizedBox(height: 20),
                  _buildCommissionInfo(orderDetails),
                  SizedBox(height: 8),
                  _buildTotalInfo(orderDetails),
                  Spacer(),
                  Center(child: _buildMarkAsReadyButton(context)),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _fetchOrderDetails(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final response = await ApiConnection().fetchOrderDetails(orderId);
      return response;
    } catch (e) {
      throw Exception('Failed to load order details: $e');
    }
  }

  Widget _buildOrderInfo(Map<String, dynamic> orderDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Order number:', orderDetails['order_id']?.toString() ?? 'N/A'),
        _buildInfoRow('Date:', orderDetails['transactionDate'] ?? 'N/A'),
        _buildInfoRow('Items:', (orderDetails['items']?.length ?? 0).toString()),
        _buildInfoRow('Total:', '\$${orderDetails['total'] ?? 'N/A'}'),
      ],
    );
  }

  Widget _buildOrderItems(List<dynamic> items) {
    return Column(
      children: items.map((item) {
        return _buildOrderItem(
          item['name'] ?? 'N/A',
          item['description'] ?? 'N/A',
          item['price']?.toString() ?? 'N/A',
          item['imageUrl'] ?? '',
        );
      }).toList(),
    );
  }

  Widget _buildOrderItem(String name, String description, String price, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: imageUrl.isNotEmpty
                ? Image.network(
                    imageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey,
                  ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  '\$$price',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionInfo(Map<String, dynamic> orderDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Transaction Date:', orderDetails['transactionDate'] ?? 'N/A'),
        _buildFlexibleInfoRow('Delivery Address:', orderDetails['deliveryAddress'] ?? 'N/A'),
      ],
    );
  }

  Widget _buildCommissionInfo(Map<String, dynamic> orderDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Subtotal:', '\$${orderDetails['subtotal'] ?? 'N/A'}'),
        _buildInfoRow('Delivery:', '\$${orderDetails['delivery'] ?? 'N/A'}'),
        _buildInfoRow('Taxes:', '\$${orderDetails['taxes'] ?? 'N/A'}'),
        _buildInfoRow('Commission:', '\$${orderDetails['commission'] ?? 'N/A'}'),
      ],
    );
  }

  Widget _buildTotalInfo(Map<String, dynamic> orderDetails) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Total:', '\$${orderDetails['total'] ?? 'N/A'}'),
      ],
    );
  }

  Widget _buildInfoRow(String leftText, String rightText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Text(
            rightText,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlexibleInfoRow(String leftText, String rightText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            leftText,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              rightText,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMarkAsReadyButton(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF69734E),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      ),
      onPressed: () {
        _markAsReady(context);
      },
      child: Text(
        'Mark as Ready for Pickup',
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  void _markAsReady(BuildContext context) async {
    final url = 'http://192.168.104.167/api/reverie/update_order_ready_status.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'order_id': orderId, 'status': 'Shipped'}),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['message'] == 'Order status updated successfully') {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order marked as Ready for Pickup')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to update order status: ${data['message']}')),
          );
        }
      } else {
        print('Error response: ${response.body}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update order status: ${response.statusCode}')),
        );
      }
    } catch (e) {
      print('Exception: $e');
            ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update order status: $e')),
      );
    }
  }
}