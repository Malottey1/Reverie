import 'package:flutter/material.dart';

class StyledProductItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String oldPrice;
  final bool isOnSale;

  StyledProductItem({
    required this.imageUrl,
    required this.title,
    required this.price,
    required this.oldPrice,
    required this.isOnSale,
  });

  @override
  Widget build(BuildContext context) {
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
                  imageUrl,
                  width: double.infinity,
                  height: 172,
                  fit: BoxFit.cover,
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
          if (isOnSale)
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