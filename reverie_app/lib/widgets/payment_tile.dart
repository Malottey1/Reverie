import 'package:flutter/material.dart';

class PaymentTile extends StatelessWidget {
  final double totalAmount;
  final VoidCallback onPaymentSelect;

  const PaymentTile({
    Key? key,
    required this.totalAmount,
    required this.onPaymentSelect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        'Payment',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontWeight: FontWeight.bold,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
      onTap: onPaymentSelect,
    );
  }
}