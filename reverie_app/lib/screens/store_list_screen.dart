import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_connection.dart';
import '../providers/user_provider.dart';
import 'store.dart'; // Import the Store screen

class StoreListScreen extends StatefulWidget {
  @override
  _StoreListScreenState createState() => _StoreListScreenState();
}

class _StoreListScreenState extends State<StoreListScreen> {
  List<Map<String, dynamic>> _stores = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchStores();
  }

  Future<void> _fetchStores() async {
    try {
      List<dynamic> results = await ApiConnection().fetchStores();
      setState(() {
        _stores = results.cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load stores: $e')),
      );
    }
  }

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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _stores.length,
              itemBuilder: (context, index) {
                final store = _stores[index];
                return _buildStoreItem(
                  context,
                  store['profile_photo'] ?? '',
                  store['business_name'] ?? 'Store Name',
                  store['business_description'] ?? 'Store Description',
                );
              },
            ),
    );
  }

  Widget _buildStoreItem(BuildContext context, String imagePath, String title, String subtitle) {
    return ListTile(
      leading: CircleAvatar(
        radius: 30,
        backgroundImage: imagePath.isNotEmpty
            ? NetworkImage(imagePath) as ImageProvider<Object> // Cast to ImageProvider<Object>
            : AssetImage('assets/placeholder.png') as ImageProvider<Object>, // Cast to ImageProvider<Object>
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