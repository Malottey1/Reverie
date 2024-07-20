import 'package:flutter/material.dart';
import 'product_details_screen.dart';
import '../services/api_connection.dart';

class ProductResultsScreen extends StatelessWidget {
  final String searchQuery;

  ProductResultsScreen({required this.searchQuery});

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
        title: Text(
          searchQuery,
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFF69734E),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<dynamic>>(
          future: ApiConnection().searchProducts(searchQuery),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Failed to load search results: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text('No results found.'));
            } else {
              return _buildProductGrid(context, snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildProductGrid(BuildContext context, List<dynamic> products) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: products.length,
      itemBuilder: (BuildContext context, int index) {
        final product = products[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailsScreen(
                  product: {
                    'product_id': product['product_id'],
                    'title': product['title'],
                    'price': product['price'],
                    'old_price': product['old_price'],
                    'image_url': 'https://reverie.newschateau.com/api/reverie/product-images/' + product['image_path'],
                    'description': product['description'],
                    'size_name': product['size_name'],
                    'brand': product['brand'],
                    'condition_name': product['condition_name'],
                  },
                ),
              ),
            );
          },
          child: _buildProductItem(product),
        );
      },
    );
  }

  Widget _buildProductItem(dynamic product) {
    String imageUrl = product['image_path'];
    if (!imageUrl.startsWith('http') && !imageUrl.startsWith('https')) {
      imageUrl = 'https://reverie.newschateau.com/api/reverie/product-images/' + imageUrl; 
    }

    return Container(
      decoration: BoxDecoration(
        color: Color(0xFFDDDBD3),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 4,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              imageUrl,
              width: double.infinity,
              height: 150, // Reduced height
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: double.infinity,
                  height: 150, // Reduced height
                  color: Colors.grey,
                  child: Center(
                    child: Icon(Icons.image, color: Colors.white),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product['title'],
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1, // Reduced maxLines
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '\GHS ${product['price']}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Color(0xFF69734E),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          if (product['original_price'] != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                '\GHS ${product['original_price']}',
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