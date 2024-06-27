import 'package:flutter/material.dart';
import 'vendor_order_details_screen.dart'; // Import the order details screen
import 'vendor_pending_tracking_screen.dart'; // Import the pending tracking screen
import 'vendor_orders_delivered.dart'; // Import the delivered orders screen

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
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
          _buildIncomingOrderList(),
          _buildDeliveredOrderList(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFDDDBD3),
        selectedItemColor: Color(0xFF69734E),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
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

  Widget _buildIncomingOrderList() {
    List<Map<String, String>> incomingOrders = [
      {
        'title': 'Gucci loafers, size 7.5',
        'orderId': '12345',
        'status': 'Waiting For Pickup'
      },
      {
        'title': 'Prada sunglasses',
        'orderId': '12346',
        'status': 'Waiting For Pickup'
      },
      {
        'title': 'Chanel handbag',
        'orderId': '12347',
        'status': 'Waiting For Pickup'
      },
      {
        'title': 'Rolex watch',
        'orderId': '12348',
        'status': 'Waiting For Pickup'
      },
    ];

    List<Map<String, String>> pendingOrders = [
      {
        'title': 'Order number 12349',
        'orderId': '12349',
        'status': 'Waiting For Pickup'
      },
      {
        'title': 'Order number 12350',
        'orderId': '12350',
        'status': 'Waiting For Pickup'
      },
      {
        'title': 'Order number 12351',
        'orderId': '12351',
        'status': 'Waiting For Pickup'
      },
    ];

    return ListView(
      padding: EdgeInsets.all(16.0),
      children: [
        ...incomingOrders.map((order) => _buildOrderItem(order, false)).toList(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Text(
            'Pending Delivery Pickup',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        ...pendingOrders.map((order) => _buildOrderItem(order, true)).toList(),
      ],
    );
  }

  Widget _buildDeliveredOrderList() {
    List<Map<String, String>> orders = [
      {
        'title': 'Nike Running Shoes, Size 10',
        'orderId': '12345',
        'status': 'Delivered'
      },
      {
        'title': 'Ray-Ban Aviator Sunglasses',
        'orderId': '12346',
        'status': 'Delivered'
      },
      {
        'title': 'Lululemon Yoga Pants, Size 6',
        'orderId': '12347',
        'status': 'Delivered'
      },
      {
        'title': 'Rolex watch',
        'orderId': '12348',
        'status': 'Delivered'
      },
      {
        'title': 'Kindle Paperwhite E-reader',
        'orderId': '12347',
        'status': 'Delivered'
      },
      {
        'title': 'Herman Miller Aeron Chair',
        'orderId': '12347',
        'status': 'Delivered'
      },
      {
        'title': 'Canon EOS Camera',
        'orderId': '12347',
        'status': 'Delivered'
      },
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        return _buildOrderItem(orders[index], false);
      },
    );
  }

  Widget _buildOrderItem(Map<String, String> order, bool isPending) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
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
                    order['title'] ?? 'No Title',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.black,
                    ),
                    softWrap: true,
                  ),
                  if (order['orderId']!.isNotEmpty)
                    SizedBox(height: 4),
                  if (order['orderId']!.isNotEmpty)
                    Text(
                      'Order ID: ${order['orderId']}',
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
          if (!isPending)
            SizedBox(width: 8),
          if (!isPending)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF69734E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
              ),
              onPressed: () {
                if (order['status'] == 'Delivered') {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VendorOrdersDeliveredScreen()),
                  );
                } else {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => VendorOrderDetailsScreen()),
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
          if (isPending)
            SizedBox(width: 8),
          if (isPending)
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF69734E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 12),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VendorPendingTrackingScreen(
                    orderId: order['orderId']!,
                    items: order['title']!,
                    pickupStatus: order['status']!,
                    estimatedDeliveryDate: '1 Day 2 Hours', // Add appropriate value here
                  )),
                );
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
),
);
}
}