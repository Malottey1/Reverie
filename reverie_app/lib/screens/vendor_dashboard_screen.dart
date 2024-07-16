import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../widgets/dashboard_stats.dart';
import '../widgets/performance_chart.dart';
import '../widgets/section_header.dart';
import 'vendor_orders_screen.dart'; // Make sure this import is correct

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

   Future<void> _fetchVendorStats(int vendorId) async {
     try {
       final response = await http.post(
         Uri.parse('http://192.168.100.100/api/reverie/fetch_vendor_stats.php'),
         headers: {'Content-Type': 'application/json'},
         body: json.encode({'vendor_id': vendorId}),
       );

       if (response.statusCode == 200) {
         setState(() {
           _stats = json.decode(response.body);
           _chartData = [
             {
               'title': 'Revenue',
               'value': '\$${_stats['earnings']}',
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
 }