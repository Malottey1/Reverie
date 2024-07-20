import 'package:flutter/material.dart';



class OrderDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDBD3),
      appBar: AppBar(
        title: Text(
          'Order Details',
          style: TextStyle(
            fontFamily: 'Poppins',
            color: Color(0xFF69734E),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Package',
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF69734E),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              '6 items',
              style: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
            SizedBox(height: 10),
            _buildOrderItem(
              'A-line Mini Dress',
              'https://via.placeholder.com/100x150',
              '\GHS 24.99',
              '1246943003',
              'Red',
              'XS',
              '1',
              '\GHS 24.99',
            ),
            _buildOrderItem(
              'Fitted T-shirt',
              'https://via.placeholder.com/100x150',
              '\GHS 6.99',
              '1228404002',
              'White',
              'XS',
              '1',
              '\GHS 6.99',
            ),
            _buildOrderItem(
              'Draped One-shoulder Top',
              'https://via.placeholder.com/100x150',
              '\GHS 19.99',
              '1235421001',
              'Light beige',
              'XS',
              '1',
              '\GHS 19.99',
            ),
            _buildOrderItem(
              'Regular Fit Cotton Shorts',
              'https://via.placeholder.com/100x150',
              '\GHS 4.99',
              '1037593001',
              'Black',
              'XS',
              '1',
              '\GHS 4.99',
            ),
            // Add more items as needed
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(String name, String imageUrl, String price, String artNo, String color, String size, String quantity, String total) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Color(0xFF69734E)),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
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
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      price,
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Art.no. $artNo',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      'Color: $color',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      'Size: $size',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      'Quantity: $quantity',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      'Total: $total',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.delete, color: Color.fromARGB(255, 78, 118, 137)),
                onPressed: () {
                  // Handle delete item action
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
