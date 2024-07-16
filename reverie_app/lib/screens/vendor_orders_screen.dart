import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'vendor_order_details_screen.dart';
import 'vendor_pending_tracking_screen.dart';
import 'vendor_orders_delivered.dart';

class VendorOrdersScreen extends StatefulWidget {
  @override
  _VendorOrdersScreenState createState() => _VendorOrdersScreenState();
}

class _VendorOrdersScreenState extends State<VendorOrdersScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.userId != null) {
        try {
          await userProvider.fetchUserInfo(userProvider.userId!);
          await userProvider.checkIfVendor(userProvider.userId!);
          if (userProvider.vendorId != null) {
            await userProvider.fetchVendorOrders(userProvider.vendorId!);
            await userProvider.fetchVendorDeliveredOrders(userProvider.vendorId!); // Fetch delivered orders
          }
        } catch (e) {
          print('Error in initState: $e');
        }
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

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
          'Orders',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Color(0xFF69734E),
          unselectedLabelColor: Colors.black,
          indicatorColor: Color(0xFF69734E),
          tabs: [
            Tab(text: 'Incoming'),
            Tab(text: 'Delivered'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOrderList(userProvider.incomingOrders, userProvider.pendingOrders, 'Pending Delivery Pickup', false),
          _buildOrderList(userProvider.deliveredOrders, [], null, true),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFDDDBD3),
        selectedItemColor: Color(0xFF69734E),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: 2,
        onTap: (index) {
          // Handle navigation
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.category),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/trend_11902027.png',
              height: 24,
              width: 24,
            ),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Image.asset(
              'assets/package.png',
              height: 24,
              width: 24,
            ),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Me',
          ),
        ],
      ),
    );
  }

  Widget _buildOrderList(List<Map<String, dynamic>> orders, List<Map<String, dynamic>> pendingOrders, String? pendingHeader, bool isDeliveredTab) {
    if (orders.isEmpty && pendingOrders.isEmpty) {
      return Center(
        child: Text(
          'No Orders Found',
          style: TextStyle(fontFamily: 'Poppins', fontSize: 18, color: Colors.black),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        ...orders.map((order) => _buildOrderItem(order, false, isDeliveredTab)).toList(),
        if (pendingHeader != null && pendingOrders.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              pendingHeader,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          ...pendingOrders.map((order) => _buildOrderItem(order, true, isDeliveredTab)).toList(),
        ],
      ],
    );
  }

  Widget _buildOrderItem(Map<String, dynamic> order, bool isPending, bool isDeliveredTab) {
    final String title = order['title'] ?? order['items']?.join(', ') ?? 'No Title'; // Ensure title is retrieved from the order map
    final String orderId = order['order_id'].toString(); // Convert order_id to string
    final String status = order['order_status'] ?? 'Unknown';

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Color(0xFFDDDBD3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isPending ? Colors.transparent : Color(0xFF69734E),
          width: 2,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    softWrap: true,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Order ID: $orderId',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    softWrap: true,
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Status: $status',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                    softWrap: true,
                  ),
                ],
              ),
            ),
          ),
          if (isDeliveredTab) ...[
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 4),
                Text(
                  'Delivered',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    color: Colors.green,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ] else ...[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF69734E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
              ),
              onPressed: () {
                if (isPending) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VendorPendingTrackingScreen(
                        orderId: orderId,
                        items: title,
                        pickupStatus: status,
                        estimatedDeliveryDate: '1 Day 2 Hours', // Add appropriate value here
                      ),
                    ),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VendorOrderDetailsScreen(
                        orderId: orderId,
                        title: title,
                      ),
                    ),
                  );
                }
              },
              child: Text(
                'View details',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}