import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reverie_app/screens/order_history_screen.dart';
import '../widgets/category_item.dart';
import '../widgets/product_item.dart';
import 'terms_and_conditions.dart';
import 'search_screen.dart';
import 'product_details_screen.dart';
import 'cart_screen.dart';
import 'store_list_screen.dart';
import 'settings_screen.dart';
import 'vendor_store_screen.dart'; // Import VendorStoreScreen
import 'package:reverie_app/services/api_connection.dart';
import '../providers/user_provider.dart'; // Import UserProvider

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Future<List<dynamic>> _productsFuture;
  final ApiConnection _apiConnection = ApiConnection();

  @override
  void initState() {
    super.initState();
    _productsFuture = _apiConnection.fetchProducts();
  }
  
  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => StoreListScreen()),
      );
    } else if (index == 2) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.isVendor) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => VendorStoreScreen()),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TermsConditionsScreen()),
        );
      }
    } else if (index == 3) {
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
                    const begin = Offset(-1.0, 0.0);
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
              Tab(text: 'Tops'),
              Tab(text: 'Bottoms'),
              Tab(text: 'Dresses'),
            ],
          ),
        ),
        body: FutureBuilder<List<dynamic>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No products available'));
            } else {
              final products = snapshot.data!;
              return TabBarView(
                children: [
                  buildTabContent(products, 'Women', null),
                  buildTabContent(products, 'Men', null),
                  buildTabContent(products, 'Kids', null),
                  buildTabContent(products, null, 'Tops'),
                  buildTabContent(products, null, 'Bottoms'),
                  buildTabContent(products, null, 'Dresses'),
                ],
              );
            }
          },
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

  Widget buildTabContent(List<dynamic> products, String? targetGroup, String? category) {
    final filteredProducts = products.where((product) {
      final matchesTargetGroup = targetGroup == null || product['target_group_name'] == targetGroup;
      final matchesCategory = category == null || product['category_name'] == category;
      return matchesTargetGroup && matchesCategory;
    }).toList();

    if (filteredProducts.isEmpty) {
      return Center(child: Text('No products available'));
    }

    // Log image URLs
    filteredProducts.forEach((product) {
      print('Product title: ${product['title']} - Image URL: ${product['image_url']}');
    });

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (filteredProducts.isNotEmpty)
                  Expanded(
                    child: ProductItem(
                      imagePath: filteredProducts[0]['image_url'] ?? '',
                      title: filteredProducts[0]['title'] ?? 'No Title',
                      onBuyNow: () {
                                                Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: filteredProducts[0])),
                        );
                      },
                    ),
                  ),
                SizedBox(width: 10),
                if (filteredProducts.length > 1)
                  Expanded(
                    child: ProductItem(
                      imagePath: filteredProducts[1]['image_url'] ?? '',
                      title: filteredProducts[1]['title'] ?? 'No Title',
                      onBuyNow: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ProductDetailsScreen(product: filteredProducts[1])),
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
                CategoryItem(title: 'Watches', imagePath: 'assets/sneakers.png'),
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
                         