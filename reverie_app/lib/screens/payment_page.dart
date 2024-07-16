import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';

class PaymentPage extends StatefulWidget {
  final double amount;
  final String email;

  const PaymentPage({super.key, required this.amount, required this.email});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final plugin = PaystackPlugin();
  String publicKey = 'pk_test_79878c9dc401ab5dc178c9a4dc1c7fca4038ca32';

  @override
  void initState() {
    super.initState();
    plugin.initialize(publicKey: publicKey);
  }

  void makePayment() async {
    int price = (widget.amount * 100).toInt();
    Charge charge = Charge()
      ..amount = price
      ..reference = 'ref_${DateTime.now()}'
      ..email = widget.email
      ..currency = 'GHS';

    CheckoutResponse response = await plugin.checkout(
      context,
      method: CheckoutMethod.card,
      charge: charge,
    );

    if (response.status) {
      Navigator.pop(context, response.reference);
    } else {
      Navigator.pop(context, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: makePayment,
          child: const Text('Make Payment'),
        ),
      ),
    );
  }
}