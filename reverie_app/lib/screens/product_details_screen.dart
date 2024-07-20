import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:reverie_app/screens/cart_screen.dart';
import 'package:reverie_app/services/api_connection.dart';
import '/providers/user_provider.dart';
import 'package:art_sweetalert/art_sweetalert.dart'; // import ArtSweetAlert

class ProductDetailsScreen extends StatefulWidget {
  final Map<String, dynamic> product;

  ProductDetailsScreen({required this.product});

  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  late Future<List<dynamic>> _recommendedProductsFuture;
  final ApiConnection _apiConnection = ApiConnection();

  @override
  void initState() {
    super.initState();

    int? productId;
    try {
      productId = int.parse(widget.product['product_id'].toString());
      if (productId == null) {
        throw Exception('Product ID is null or not an int');
      }
    } catch (e) {
      print('Error casting product_id: $e');
    }
    print('Product ID type: ${productId.runtimeType}, value: $productId');

    if (productId != null) {
      _recommendedProductsFuture = _apiConnection.fetchRecommendedProducts(productId);
    }
  }

  Future<void> _handleAddToCart(int userId) async {
    try {
      final response = await _apiConnection.addToCart(userId, int.parse(widget.product['product_id'].toString()));
      _showSuccessDialog(context, response['message']);
    } catch (e) {
      print('Error adding to cart: $e');
      _showErrorDialog(context, 'Failed to add to cart');
    }
  }

  void _showSuccessDialog(BuildContext context, String message) {
    ArtSweetAlert.show(
      context: context,
      artDialogArgs: ArtDialogArgs(
        type: ArtSweetAlertType.success,
        title: "Success",
        text: message,
        confirmButtonText: "Okay",
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    ArtSweetAlert.show(
      context: context,
      artDialogArgs: ArtDialogArgs(
        type: ArtSweetAlertType.danger,
        title: "Error",
        text: message,
        confirmButtonText: "Okay",
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);
    final userId = userProvider.userId;

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
        actions: [
          IconButton(
          icon: Icon(Icons.shopping_cart, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CartScreen()),
            );
          },
        ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            _buildProductTitleAndPrice(),
            _buildSizeOption(),
            _buildExpandableSections(),
            _buildRecommendedProducts(context),
            _buildActionButtons(context, userId),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    print('Image URL: ${widget.product['image_url']}');
    return Container(
      height: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          widget.product['image_url'] ?? 'https://via.placeholder.com/400x250',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProductTitleAndPrice() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.product['title'] ?? 'Product Title',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          Text(
            '\GHS ${widget.product['price'].toString()}',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeOption() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'Size: ${widget.product['size_name'] ?? 'M'}',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 20,
              color: Colors.black,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpandableSections() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildExpandableSection('The Details', widget.product['description'] ?? 'Description not available'),
        _buildExpandableSection('Size & Fit', widget.product['size_name'] ?? 'Size information not available'),
        _buildExpandableSection('Brand', widget.product['brand'] ?? 'Brand information not available'),
        _buildExpandableSection('Condition', widget.product['condition_name'] ?? 'Condition information not available'),
      ],
    );
  }

  Widget _buildExpandableSection(String title, String content) {
    return ExpansionTile(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            content,
            style: TextStyle(
              fontFamily: 'Poppins',
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecommendedProducts(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: _recommendedProductsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('No recommended products available'));
        } else {
          final recommendedProducts = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Recommended for you',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: recommendedProducts.map((recommendedProduct) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ProductDetailsScreen(product: recommendedProduct),
                          ),
                        );
                      },
                      child: _buildRecommendedProduct(recommendedProduct),
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildRecommendedProduct(Map<String, dynamic> product) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              product['image_url'],
              width: 180,
              height: 250,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5),
          Text(
            product['title'] ?? 'No title',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '\GHS ${product['price'] ?? 'N/A'}',
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, int? userId) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromARGB(255, 78, 118, 137),
              padding: EdgeInsets.symmetric(horizontal: 100, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: userId != null
                ? () async {
                    await _handleAddToCart(userId);
                  }
                : null,
            child: Text(
              'Add to Cart',
              style: TextStyle(
                fontFamily: 'Poppins',
                color: Colors.white,
                fontSize: 16,
              ),
            ),
                   ),
        ],
      ),
    );
  }
}