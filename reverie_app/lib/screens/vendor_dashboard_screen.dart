import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:reverie_app/screens/login_screen.dart';
import 'package:reverie_app/services/api_connection.dart';
import '../providers/user_provider.dart';
import '../widgets/dashboard_stats.dart';
import '../widgets/performance_chart.dart';
import '../widgets/section_header.dart';
import 'vendor_orders_screen.dart'; // Make sure this import is correct
import 'home_screen.dart';
import 'inventory_management_screen.dart';
import 'vendor_dashboard_screen.dart';

class VendorDashboardScreen extends StatefulWidget {
  @override
  _VendorDashboardScreenState createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  int _selectedIndex = 2;
  Map<String, dynamic> _stats = {
    'earnings': '0',
    'total_orders': '0',
    'active_listings': '0',
    'new_orders': '0',
  };
  List<Map<String, dynamic>> _chartData = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.userId != null) {
        try {
          await userProvider.fetchUserInfo(userProvider.userId!);
          await _fetchVendorStats(userProvider.vendorId!);
        } catch (e) {
          print('Error in initState: $e');
        }
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

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
        // Already on Dashboard Screen
        break;
      case 3:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VendorOrdersScreen()),
        );
        break;
      case 4:
        _showSignOutDialog(context);
        break;
    }
  }

  Future<void> _fetchVendorStats(int vendorId) async {
    try {
      final response = await http.post(
        Uri.parse('https://reverie.newschateau.com/api/reverie/fetch_vendor_stats.php'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'vendor_id': vendorId}),
      );

      if (response.statusCode == 200) {
        setState(() {
          _stats = json.decode(response.body);
          _chartData = [
            {
              'title': 'Revenue',
              'value': '\GHS ${_stats['earnings']}',
              'change': '+12%',
              'dataPoints': [
                FlSpot(0, 1),
                FlSpot(1, 3),
                FlSpot(2, 10),
                FlSpot(3, 7),
                FlSpot(4, 12),
                FlSpot(5, 13),
                FlSpot(6, 17),
              ],
            },
            {
              'title': 'Orders',
              'value': '${_stats['total_orders']}',
              'change': '+8%',
              'dataPoints': [
                FlSpot(0, 2),
                FlSpot(1, 2.5),
                FlSpot(2, 5),
                FlSpot(3, 4),
                FlSpot(4, 6),
                FlSpot(5, 7),
                FlSpot(6, 9),
              ],
            },
          ];
        });
      } else {
        print('Failed to fetch vendor stats. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (e) {
      print('Failed to fetch vendor stats: $e');
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
            DashboardStats(stats: _stats),
            SizedBox(height: 20),
            SectionHeader(title: 'Store performance'),
            PerformanceCharts(chartData: _chartData),
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