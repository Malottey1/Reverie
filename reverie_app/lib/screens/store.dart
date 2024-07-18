import 'package:flutter/material.dart';
import '../services/api_connection.dart';
import 'product_details_screen.dart'; // Import ProductDetailsScreen

class StoreScreen extends StatefulWidget {
  final int vendorId;

  StoreScreen({required this.vendorId});

  @override
  _StoreScreenState createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  List<Map<String, dynamic>> _products = [];
  Map<String, dynamic>? _vendorDetails;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchVendorDetailsAndProducts();
  }

  Future<void> _fetchVendorDetailsAndProducts() async {
    try {
      final vendorDetails = await ApiConnection().fetchVendorDetails(widget.vendorId);
      final products = await ApiConnection().fetchProductsByVendor(widget.vendorId);
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
        SnackBar(content: Text('Failed to load vendor details and products: $e')),
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
            icon: Icon(Icons.star_border, color: Color(0xFF69734E)),
            onPressed: () {
              // Implement add product functionality here
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
                                ? NetworkImage('http://192.168.102.56/api/reverie/profile-photos/' + _vendorDetails!['profile_photo'])
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
                              // Add navigation to edit profile screen if needed
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
        itemCount: _products.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16.0,
          mainAxisSpacing: 16.0,
          childAspectRatio: 0.7,
        ),
        itemBuilder: (BuildContext context, int index) {
          final product = _products[index];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailsScreen(product: {
                    ...product,
                    'image_url': 'http://192.168.102.56/api/reverie/product-images/' + (product['image_path'] ?? ''),
                  }),
                ),
              );
            },
            child: _buildProductItem(
              context,
              product['title'],
              '\$${product['price']}',
              product['old_price'] != null ? '\$${product['old_price']}' : '',
              product['is_on_sale'] == 1,
              product['image_path'],
            ),
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
                  'http://192.168.102.56/api/reverie/product-images/' + imagePath,
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
          if (oldPrice.isNotEmpty)
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