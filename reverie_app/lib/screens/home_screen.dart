import 'package:flutter/material.dart';
import '../widgets/category_item.dart';
import '../widgets/product_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
              // Handle search action
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Color(0xFF69734E),
              onPressed: () {
                // Handle cart action
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
          backgroundColor: Color.fromARGB(0, 255, 255, 255),
          selectedItemColor: Color(0xFF69734E),
          unselectedItemColor: Colors.grey,
          showUnselectedLabels: true,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.category),
              label: 'Categories',
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
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ProductItem(imagePath: imagePath, title: title),
                  ProductItem(imagePath: imagePath, title: title),
                  ProductItem(imagePath: imagePath, title: title),
                  ProductItem(imagePath: imagePath, title: title),
                  ProductItem(imagePath: imagePath, title: title),
                  ProductItem(imagePath: imagePath, title: title),
                  ProductItem(imagePath: imagePath, title: title),
                  ProductItem(imagePath: imagePath, title: title),
                ],
              ),
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