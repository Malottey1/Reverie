import 'package:flutter/material.dart';
import 'store.dart'; // Import the Store screen

class StoreListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDBD3),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Stores',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildStoreItem(
            context,
            'assets/store1.png',
            'The RealReal',
            'Dresses, Tops, Accessories',
          ),
          _buildStoreItem(
            context,
            'assets/store2.png',
            'Nike',
            'Sneakers, Sandals, Boots',
          ),
          _buildStoreItem(
            context,
            'assets/store3.png',
            'Reformation',
            'Dresses, Tops, Bottoms',
          ),
          _buildStoreItem(
            context,
            'assets/store4.png',
            'Levi\'s',
            'Dresses, Tops, Jeans',
          ),
          _buildStoreItem(
            context,
            'assets/store5.png',
            'Everlane',
            'Tops, Dresses, Skirts',
          ),
        ],
      ),
    );
  }

  Widget _buildStoreItem(BuildContext context, String imagePath, String title, String subtitle) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: AssetImage(imagePath),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontFamily: 'Poppins',
          color: Colors.black54,
        ),
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StoreScreen(
              storeName: title,
              storeDescription: subtitle,
            ),
          ),
        );
      },
    );
  }
}