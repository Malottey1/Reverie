import 'package:flutter/material.dart';
import 'product_results_screen.dart'; // Import the product results screen

class SearchScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDBD3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFF69734E)),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: 'Search...',
            border: InputBorder.none,
            hintStyle: TextStyle(
              fontFamily: 'Poppins',
              color: Colors.black54,
            ),
          ),
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 16,
            color: Colors.black,
          ),
          cursorColor: Color(0xFF69734E),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildCategoryItem(context, 'Men'),
            _buildCategoryItem(context, 'Women'),
            _buildCategoryItem(context, 'Kids'),
            _buildCategoryItem(context, 'Shoes'),
            _buildCategoryItem(context, 'Bags'),
            _buildCategoryItem(context, 'Watches'),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String category) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductResultsScreen(category: category),
          ),
        );
      },
      child: Container(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              category,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black,
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Color(0xFF69734E),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}