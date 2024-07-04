import 'package:flutter/material.dart';
import 'enter_credit_card_info.dart';
import 'enter_mobile_money_info.dart';

class PaymentSelectionScreen extends StatelessWidget {
  final double totalAmount;

  PaymentSelectionScreen({required this.totalAmount});

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
          'Select Payment',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _buildPaymentOption(context, 'Mobile Money', Icons.phone_android_rounded, true),
          _buildPaymentOption(context, 'Credit/Debit Card', Icons.credit_card, false),
        ],
      ),
    );
  }

  Widget _buildPaymentOption(BuildContext context, String title, IconData icon, bool isMobileMoney) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: Colors.black,
        ),
      ),
      trailing: Icon(Icons.arrow_forward_ios, color: Colors.black),
      leading: Icon(icon, color: Colors.black),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => isMobileMoney
                ? EnterMobileMoneyInfoScreen(totalAmount: totalAmount.toString())
                : EnterCreditCardInfoScreen(),
          ),
        );
      },
    );
  }
}