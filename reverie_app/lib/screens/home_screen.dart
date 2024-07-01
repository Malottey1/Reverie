import 'package:flutter/material.dart';
import 'package:reverie_app/screens/order_history_screen.dart';
import '../widgets/category_item.dart';
import '../widgets/product_item.dart';
import 'terms_and_conditions.dart';  // Import the Terms and Conditions screen
import 'search_screen.dart'; // Import the Search Screen
import 'product_details_screen.dart'; // Import the Product Details Screen
import 'cart_screen.dart';
import 'store_list_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 1) {  // Index for the Market button
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StoreListScreen()),
      );
    } else if (index == 2) {  // Index for the Sell button
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => TermsConditionsScreen()),
      );
    } else if (index == 3) {  // Index for the Sell button
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrderHistoryScreen()),
      );
    } else if (index == 4) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => SettingsScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 6,
      child: Scaffold(
        backgroundColor: Color(0xFFDDDBD3),
        appBar: AppBar(
          backgroundColor: Color(0xFFDDDBD3),
          elevation: 0,
          title: Image.asset(
            'assets/reverie-logo.png',
            height: 25,
          ),
          centerTitle: true,
          leading: IconButton(
            icon: Icon(Icons.search),
            color: Color(0xFF69734E),
            onPressed: () {
              Navigator.push(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) => SearchScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    const begin = Offset(-1.0, 0.0);  // Slide from the left
                    const end = Offset.zero;
                    const curve = Curves.ease;

                    var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

                    return SlideTransition(
                      position: animation.drive(tween),
                      child: child,
                    );
                  },
                ),
              );
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Color(0xFF69734E),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CartScreen()),
                );
              },
            ),
          ],
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Color(0xFF69734E),
            labelColor: Color(0xFF69734E),
            unselectedLabelColor: Colors.black,
            tabs: [
              Tab(text: 'Women'),
              Tab(text: 'Men'),
              Tab(text: 'Kids'),
              Tab(text: 'Shoes'),
              Tab(text: 'Bags'),
              Tab(text: 'Watches'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            buildTabContent('assets/women.png', 'New In: Women’s'),
            buildTabContent('assets/men.png', 'New In: Men’s'),
            buildTabContent('assets/kids.png', 'New In: Kids'),
            buildTabContent('assets/shoes.png', 'New In: Shoes'),
            buildTabContent('assets/bags.png', 'New In: Bags'),
            buildTabContent('assets/watches.png', 'New In: Watches'),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.white,
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
              icon: Icon(Icons.business),
              label: 'Market',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add_box),
              label: 'Sell',
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
      ),
    );
  }

  Widget buildTabContent(String imagePath, String title) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ProductItem(
                    imagePath: imagePath,
                    title: title,
                    onBuyNow: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductDetailsScreen()),
                      );
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ProductItem(
                    imagePath: imagePath,
                    title: title,
                    onBuyNow: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductDetailsScreen()),
                      );
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Top Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryItem(title: 'Sneakers', imagePath: 'assets/sneakers.png'),
                CategoryItem(title: 'Handbags', imagePath: 'assets/handbags.png'),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CategoryItem(title: 'Jackets', imagePath: 'assets/jackets.png'),
                CategoryItem(title: 'Sweaters', imagePath: 'assets/sweaters.png'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}