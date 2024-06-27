import 'package:flutter/material.dart';
import 'vendor_orders_screen.dart';
import 'quick_stock_up.dart';


class VendorDashboardScreen extends StatefulWidget {
  @override
  _VendorDashboardScreenState createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  int _selectedIndex = 2;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        // Navigate to Home Screen
        break;
      case 1:
        // Navigate to Categories Screen
        break;
      case 2:
        // Already on Dashboard Screen
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VendorOrdersScreen()),
        );
        break;
      case 4:
        // Navigate to Me Screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDBD3),
      appBar: AppBar(
        backgroundColor: Color(0xFFDDDBD3),
        elevation: 0,
        title: Text(
          'Dashboard',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFF69734E),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.notifications, color: Colors.black),
            onPressed: () {
              // Handle notifications
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDashboardStats(),
            SizedBox(height: 20),
            _buildSectionHeader('Inventory', context),
            _buildInventoryList(),
            SizedBox(height: 20),
            _buildSectionHeader('Store performance', context),
            _buildPerformanceCharts(),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFDDDBD3),
        selectedItemColor: Color(0xFF69734E),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
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

  Widget _buildDashboardStats() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatCard('\$1,234', 'Earnings this month'),
            _buildStatCard('5', 'Total orders'),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildStatCard('15', 'Active listings'),
            _buildStatCard('30', 'New orders'),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(String value, String label) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: Color(0xFF69734E),
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          IconButton(
            icon: Icon(Icons.arrow_forward, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuickStockUpScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInventoryList() {
    return Column(
      children: [
        _buildInventoryItem('Palm leaf print dress', '\$120', '3 items', 'assets/dress.jpg', 3),
        _buildInventoryItem('Black leather jacket', '\$140', '2 items', 'assets/jacket.jpg', 2),
      ],
    );
  }

  Widget _buildInventoryItem(String title, String price, String quantity, String imageUrl, int itemCount) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFF69734E),
          width: 2,
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
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
                ),
                Text(
                  price,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  quantity,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: Icon(Icons.remove_circle, color: Color(0xFF69734E)),
                onPressed: () {
                  // Handle decrease quantity
                },
              ),
              Text(
                '$itemCount',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              IconButton(
                icon: Icon(Icons.add_circle, color: Color(0xFF69734E)),
                onPressed: () {
                  // Handle increase quantity
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceCharts() {
    return Column(
      children: [
        _buildPerformanceChart('Revenue', '\$4,500', '+12%', 'assets/images/revenue_chart.png'),
        SizedBox(height: 16),
        _buildPerformanceChart('Orders', '56', '+8%', 'assets/images/orders_chart.png'),
      ],
    );
  }

  Widget _buildPerformanceChart(String title, String value, String change, String chartImageUrl) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFF69734E),
          width: 2,
        ),
      ),
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
          ),
          Text(
            value,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            'This Month $change',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              color: change.startsWith('+') ? Colors.green : Colors.red,
            ),
          ),
          SizedBox(height: 16),
          Container(
            width: double.infinity,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Color(0xFF69734E),
                width: 1,
              ),
            ),
            child: Center(
                        child: Text(
            'Chart Placeholder',
            style: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black54,
            ),
          ),
        ),
      ),
    ],
  ),
);
  }
}