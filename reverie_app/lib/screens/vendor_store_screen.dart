import 'package:flutter/material.dart';
import 'add_product_screen.dart';
import 'vendor_dashboard_screen.dart';
import 'inventory_management_screen.dart'; // Import the inventory management screen
import 'vendor_edit_profile_screen.dart';

class VendorStoreScreen extends StatelessWidget {
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
      body: SingleChildScrollView(
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
                      child: CircleAvatar(
                        radius: 38,
                        backgroundColor: Colors.white,
                        child: Text(
                          'Bershka',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Bershka',
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
              Navigator.pushReplacementNamed(context, '/orders');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/me');
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
            icon: Icon(Icons.dashboard),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
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
          color: Color(0xFF69734E),
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
          IconButton(
            icon: Icon(Icons.arrow_forward, color: Colors.black),
            onPressed: () {
              // Handle navigation to collection
            },
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
        itemCount: 4,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (BuildContext context, int index) {
          return _buildProductItem(
            context,
            'Bershka Platform Sandals with Buckle',
            '\$29',
            index % 2 == 0 ? '\$49' : '',
            index % 2 == 0,
          );
        },
      ),
    );
  }

  
Widget _buildProductItem(BuildContext context, String title, String price, String oldPrice, bool isOnSale) {
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
              child: Image.asset(
                'assets/men.png',
                width: double.infinity,
                height: 172,
                fit: BoxFit.cover,
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