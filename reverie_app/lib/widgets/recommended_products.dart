import 'package:flutter/material.dart';
import 'package:reverie_app/screens/product_details_screen.dart';
import 'package:reverie_app/widgets/recommended_product_item.dart';

class RecommendedProducts extends StatelessWidget {
  final Future<List<dynamic>> future;

  RecommendedProducts({required this.future});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: future,
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
                      child: RecommendedProductItem(product: recommendedProduct),
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
}