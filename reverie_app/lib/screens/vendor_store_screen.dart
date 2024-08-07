import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reverie_app/screens/home_screen.dart';
import 'package:reverie_app/screens/login_screen.dart';
import 'package:reverie_app/screens/vendor_orders_screen.dart';
import 'add_product_screen.dart';
import 'vendor_dashboard_screen.dart';
import 'inventory_management_screen.dart';
import 'vendor_edit_profile_screen.dart';
import '../providers/user_provider.dart';
import '../services/api_connection.dart';

class VendorStoreScreen extends StatefulWidget {
  @override
  _VendorStoreScreenState createState() => _VendorStoreScreenState();
}

class _VendorStoreScreenState extends State<VendorStoreScreen> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;
  Map<String, dynamic>? _vendorDetails;

  @override
  void initState() {
    super.initState();
    _fetchVendorDetailsAndProducts();
  }

  Future<void> _fetchVendorDetailsAndProducts() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final vendorId = userProvider.vendorId;

    try {
      final vendorDetails = await ApiConnection().fetchVendorDetails(vendorId!);
      final products = await ApiConnection().fetchProductsByVendor(vendorId);
      setState(() {
        _vendorDetails = vendorDetails;
        _products = products.cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load products: $e')),
      );
    }
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
        title: Image.asset(
          'assets/reverie-logo.png',
          height: 20,
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductScreen()),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            backgroundColor: Colors.grey,
                            backgroundImage: _vendorDetails?['profile_photo'] != null
                                ? NetworkImage('https://reverie.newschateau.com/api/reverie/profile-photos/' + _vendorDetails!['profile_photo'])
                                : null,
                            child: _vendorDetails?['profile_photo'] == null
                                ? CircleAvatar(
                                    radius: 38,
                                    backgroundColor: Colors.white,
                                    child: Text(
                                      _vendorDetails?['business_name']?.substring(0, 1) ?? '',
                                      style: TextStyle(
                                        fontFamily: 'Poppins',
                                        color: Colors.black,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                          SizedBox(height: 10),
                          Text(
                            _vendorDetails?['business_name'] ?? 'Store',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            'Verified official store',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF69734E),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => VendorEditProfileScreen()),
                              );
                            },
                            child: Text(
                              'Edit Profile',
                              style: TextStyle(
                                fontFamily: 'Poppins',
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _buildTabButton(context, 'Overview'),
                        _buildTabButton(context, 'Collection'),
                        _buildTabButton(context, 'Blog'),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildSectionHeader(context, 'Peak of our new collection'),
                  SizedBox(height: 10),
                  _buildProductGrid(context),
                  SizedBox(height: 10),
                ],
              ),
            ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xFFDDDBD3),
        selectedItemColor: Color(0xFF69734E),
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        onTap: (index) {
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
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => VendorDashboardScreen()),
              );
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
        },
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

  Widget _buildTabButton(BuildContext context, String title) {
    return TextButton(
      onPressed: () {
        // Handle tab switch action
      },
      child: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: Color(0xFF69734E          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
        ],
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: _products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (BuildContext context, int index) {
          final product = _products[index];
          return _buildProductItem(
            context,
            product['title'],
            '\GHS ${product['price']}',
            product['old_price'] != null ? '\GHS ${product['old_price']}' : '',
            product['is_on_sale'] == 1,
            product['image_path'],
          );
        },
      ),
    );
  }

  Widget _buildProductItem(BuildContext context, String title, String price, String oldPrice, bool isOnSale, String imagePath) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFDDDBD3), // Background color as specified
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
                child: Image.network(
                  'https://reverie.newschateau.com/api/reverie/product-images/' + imagePath,
                  width: double.infinity,
                  height: 172,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 172,
                      color: Colors.grey,
                      child: Center(
                        child: Icon(Icons.image, color: Colors.white),
                      ),
                    );
                  },
                ),
              ),
              if (isOnSale)
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    color: Colors.red,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: Text(
                      '-72%', // Discount percentage placeholder
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 12,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              price,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF69734E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (isOnSale)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                oldPrice,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: Colors.grey,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: VendorStoreScreen(),
));