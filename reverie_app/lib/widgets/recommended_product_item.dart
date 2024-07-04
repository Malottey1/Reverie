import 'package:flutter/material.dart';

class RecommendedProductItem extends StatelessWidget {
  final Map<String, dynamic> product;

  RecommendedProductItem({required this.product});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              product['image_url'] ?? 'https://via.placeholder.com/180x250',
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
            '\$${product['price'] ?? 'N/A'}',
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
}