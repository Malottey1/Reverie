import 'package:flutter/material.dart';

class ProductImage extends StatelessWidget {
  final String imageUrl;

  ProductImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 250,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.network(
          imageUrl ?? 'https://via.placeholder.com/400x250',
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}