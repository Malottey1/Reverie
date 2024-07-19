import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reverie_app/screens/order_confirmation_screen.dart';
import 'package:reverie_app/screens/payment_page.dart';
import 'package:reverie_app/services/notification_helper.dart';
import '../providers/user_provider.dart';
import '../services/api_connection.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class CheckoutButton extends StatelessWidget {
  final double totalAmount;

  const CheckoutButton({Key? key, required this.totalAmount}) : super(key: key);

  Future<void> createOrderTracking(int orderId, String status, String estimatedDeliveryDate) async {
    final String url = 'http://192.168.104.167/api/reverie/create_order_tracking.php';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'order_id': orderId,
          'status': status,
          'estimated_delivery_date': estimatedDeliveryDate,
        }),
      );

      if (response.statusCode != 200) {
        print('Failed to create order tracking. Response: ${response.body}');
        throw Exception('Failed to create order tracking');
      }
    } catch (e) {
      print('Exception occurred while creating order tracking: $e');
      throw Exception('Failed to create order tracking: $e');
    }
  }

  String calculateEstimatedDeliveryDate() {
    final now = DateTime.now();
    final estimatedDate = now.add(Duration(days: 5)); // Assuming delivery in 3-5 business days
    return DateFormat('yyyy-MM-dd').format(estimatedDate);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF69734E),
          padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          try {
            final userId = Provider.of<UserProvider>(context, listen: false).userId;
            final info = await ApiConnection().fetchCheckoutInfo(userId!);
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => PaymentPage(amount: totalAmount, email: info.email),
              ),
            );

            if (result != null) {
              await ApiConnection().verifyPayment(result);
              final createOrderResponse = await ApiConnection().createOrder(userId, totalAmount, 'Processing');
              final orderId = int.parse(createOrderResponse['order_id'].toString());

              final cartItems = await ApiConnection().fetchCartItems(userId);
              for (var item in cartItems) {
                try {
                  await ApiConnection().createOrderDetail(orderId, item.productId, item.price);
                } catch (e) {
                  print('Failed to create order detail for item ${item.productId}: $e');
                  throw Exception('Failed to create order detail: $e');
                }
              }

              await ApiConnection().recordPayment(orderId, totalAmount);

              // Create the tracking record with the calculated delivery date
              final estimatedDeliveryDate = calculateEstimatedDeliveryDate();
              await createOrderTracking(orderId, 'Ready', estimatedDeliveryDate);

              // Show order placed notification
              await showNotification('Order Placed', 'Your order has been placed successfully!');
              print('Notification should have been shown.');

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => OrderConfirmationScreen(orderId: orderId.toString(), totalAmount: totalAmount.toString()),
                ),
              );
            }
          } catch (e) {
            print('Payment failed: $e');
          }
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