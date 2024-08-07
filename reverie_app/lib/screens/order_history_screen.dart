import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/services/api_connection.dart';
import 'order_tracking_screen.dart';
import '/providers/user_provider.dart';

class OrderHistoryScreen extends StatefulWidget {
  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  Future<List<Map<String, dynamic>>>? futureOrders;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final userId = Provider.of<UserProvider>(context, listen: false).userId;
      if (userId != null) {
        setState(() {
          futureOrders = fetchOrders(userId);
        });
      } else {
        setState(() {
          futureOrders = Future.error("User ID not found");
        });
      }
    });
  }

  Future<List<Map<String, dynamic>>> fetchOrders(int userId) async {
    final api = ApiConnection();
    final orders = await api.fetchOrders(userId);
    return orders.map<Map<String, dynamic>>((order) {
      return {
        'id': order['id'].toString(),
        'status': order['status'],
        'date': order['date'],
        'products': (order['products'] as List<dynamic>? ?? []).map<Map<String, dynamic>>((product) {
          return {
            'title': product['title'],
            'image': product['image'],
            'price': product['price'].toString(),
          };
        }).toList(),
      };
    }).toList();
  }

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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: futureOrders,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error fetching orders: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No orders found'));
          }

          final orders = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int index) {
              return _buildOrderItem(context, orders[index]);
            },
          );
        },
      ),
    );
  }

  Widget _buildOrderItem(BuildContext context, Map<String, dynamic> order) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderTrackingScreen(
              orderId: order['id']!,
            ),
          ),
        );
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Order ID: ${order['id']}',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF69734E),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Status: ${order['status']}',
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
                'Date: ${order['date']}',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.black54,
                  fontSize: 14,
                ),
              ),
              SizedBox(height: 16),
              if (order['products'] != null && order['products'].isNotEmpty)
                ...order['products'].map<Widget>((product) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            product['image'],
                            width: 80,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(Icons.error),
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product['title'],
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Color(0xFF69734E),
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Price: GHS ${product['price']}',
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
                }).toList(),
            ],
          ),
        ),
      ),
    );
  }
}