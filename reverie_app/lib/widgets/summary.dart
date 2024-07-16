import 'package:flutter/material.dart';

class Summary extends StatelessWidget {
  final double orderValue;
  final double deliveryFee;
  final double estimatedTaxes;

  Summary({required this.orderValue, required this.deliveryFee, required this.estimatedTaxes});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order value',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '\$${orderValue.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Delivery fee',
              style: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              '\$${deliveryFee.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Est. taxes',
              style: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
            Text(
              '\$${estimatedTaxes.toStringAsFixed(2)}',
              style: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
        Divider(),
      ],
    );
  }
}