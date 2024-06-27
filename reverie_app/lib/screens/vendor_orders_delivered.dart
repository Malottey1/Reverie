import 'package:flutter/material.dart';

class VendorOrdersDeliveredScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDBD3),
      appBar: AppBar(
        backgroundColor: Color(0xFFDDDBD3),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Order Details',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildOrderInfo(),
            SizedBox(height: 20),
            _buildOrderItems(),
            SizedBox(height: 20),
            _buildTransactionInfo(),
            SizedBox(height: 20),
            _buildCommissionInfo(),
            SizedBox(height: 8), // Reduced space
            _buildTotalInfo(),
            Spacer(),
            Center(child: _buildDeliveredText()), // Center the delivered text with a tick icon
          ],
        ),
      ),
    );
  }

  Widget _buildOrderInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Order number:', '8DIU0K'),
        _buildInfoRow('Date:', '22/07/22'),
        _buildInfoRow('Items:', '2'),
        _buildInfoRow('Total:', '\$970'),
      ],
    );
  }

  Widget _buildOrderItems() {
    return Column(
      children: [
        _buildOrderItem(
          'Michelle French',
          'Silk dress for a cocktail party',
          '928.02',
          'assets/dress.jpg',
        ),
        _buildOrderItem(
          'John Galliano',
          'Leather boots',
          '41.98',
          'assets/boots.jpg',
        ),
      ],
    );
  }

  Widget _buildOrderItem(
      String name, String description, String price, String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  '\$$price',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Transaction Date:', '23/07/22'),
        _buildFlexibleInfoRow('Delivery Address:', '600 Montgomery St, San Francisco'),
      ],
    );
  }

  Widget _buildCommissionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Subtotal:', '\$970'),
        _buildInfoRow('Delivery:', '\$0'),
        _buildInfoRow('Taxes:', '\$73.92'),
        _buildInfoRow('Commission:', '\$30'),
      ],
    );
  }

  Widget _buildTotalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Total:', '\$930.92'),
      ],
    );
  }

  Widget _buildInfoRow(String leftText, String rightText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            leftText,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          Text(
            rightText,
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

  Widget _buildFlexibleInfoRow(String leftText, String rightText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            leftText,
            style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 16,
              color: Colors.black,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              rightText,
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 16,
                color: Colors.black,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveredText() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.check_circle,
          color: Color(0xFF69734E),
        ),
        SizedBox(width: 8),
        Text(
          'Delivered',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFF69734E),
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}