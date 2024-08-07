import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reverie_app/screens/login_screen.dart';
import 'package:reverie_app/services/api_connection.dart';
import '../providers/user_provider.dart';
import 'vendor_order_details_screen.dart';
import 'vendor_pending_tracking_screen.dart';
import 'vendor_orders_delivered.dart';
import 'home_screen.dart';
import 'inventory_management_screen.dart';
import 'vendor_dashboard_screen.dart';

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
      await _fetchUserAndVendorData();
    });
  }

  Future<void> _fetchUserAndVendorData() async {
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
        print('Error in _fetchUserAndVendorData: $e');
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => InventoryManagementScreen()), // Navigate to the inventory management screen
        );
        break;
      case 2:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => VendorDashboardScreen()),
        );
        break;
      case 3:
        // Already on Orders Screen
        break;
      case 4:
        _showSignOutDialog(context);
        break;
    }
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
        currentIndex: 3, // Set current index to Orders
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/inventory.png')), // Custom inventory icon
            label: 'Inventory',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/trend_11902027.png')),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: ImageIcon(AssetImage('assets/package.png')),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.delete_forever),
            label: 'Delete',
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

    return RefreshIndicator(
      onRefresh: _fetchUserAndVendorData,
      child: ListView(
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
      ),
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

   void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Store'),
          content: Text('Are you sure you want to delete this store? This action cannot be undone.'),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete Store'),
              onPressed: () async {
                final userProvider = Provider.of<UserProvider>(context, listen: false);
                final vendorId = userProvider.vendorId;

                Navigator.of(context).pop(); // Close the dialog first

                if (vendorId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete: vendor ID is required')),
                  );
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                  return;
                }

                try {
                  final response = await ApiConnection().deleteVendor(vendorId);
                  if (response['success'] == true) {
                    userProvider.signOut();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => LoginScreen()),
                    );
                  } else {
                    if (response['message'].contains('a foreign key constraint fails')) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete store: Please delete all products associated with this vendor first.')),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to delete vendor: ${response['message']}')),
                      );
                    }
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to delete vendor: $e')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }
}