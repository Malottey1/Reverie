import 'package:flutter/material.dart';

class VendorOrdersDeliveredScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  VendorOrdersDeliveredScreen({required this.order});

  @override
  Widget build(BuildContext context) {
    print("Order: $order"); // Debugging print statement
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
            SizedBox(height: 8),
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
        _buildInfoRow('Order number:', order['order_id'].toString()),
        _buildInfoRow('Date:', order['created_at']),
        _buildInfoRow('Items:', (order['items'] as List).length.toString()),
        _buildInfoRow('Total:', '\$${order['total_amount']}'),
      ],
    );
  }

  Widget _buildOrderItems() {
    print("Items: ${order['items']}"); // Debugging print statement
    return Column(
      children: (order['items'] as List).map<Widget>((item) {
        if (item is Map<String, dynamic>) {
          // Handle item as a map
          print("Item: $item"); // Debugging print statement
          String imageUrl = item.containsKey('image_path') && item['image_path'] != null
              ? item['image_path']
              : ''; // Use the full image URL directly
          return _buildOrderItem(
            item['title'],
            item['description'] ?? '', // Handle possible null description
            item['price'].toString(),
            imageUrl,
          );
        } else {
          // Handle unexpected item type
          print("Unexpected item type: $item");
          return _buildOrderItem('Unknown item', '', '', '');
        }
      }).toList(),
    );
  }

  Widget _buildOrderItem(String title, String description, String price, String imageUrl) {
    print("Building order item: $title, $description, $price, $imageUrl"); // Debugging print statement
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          if (imageUrl.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.network(
                imageUrl,
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  print("Failed to load image: $error"); // Debugging print statement
                  return Icon(Icons.error); // Fallback to an error icon if image fails to load
                },
              ),
            )
          else
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(Icons.image, color: Colors.grey[700]),
            ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                if (description.isNotEmpty)
                  Text(
                    description,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Colors.black54,
                    ),
                  ),
                if (price.isNotEmpty)
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
    // Fetch the delivery address from the order map
    String deliveryAddress = order.containsKey('delivery_address') && order['delivery_address'] != null
        ? order['delivery_address']
        : 'Address not available';
    print("Delivery address: $deliveryAddress"); // Debugging print statement

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Transaction Date:', order['created_at']),
        _buildFlexibleInfoRow('Delivery Address:', deliveryAddress),
      ],
    );
  }

  Widget _buildCommissionInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Subtotal:', '\$${order['total_amount']}'),
        _buildInfoRow('Delivery:', '\$0'), // Placeholder
        _buildInfoRow('Taxes:', '\$73.92'), // Placeholder
        _buildInfoRow('Commission:', '\$30'), // Placeholder
      ],
    );
  }

  Widget _buildTotalInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoRow('Total:', '\$930.92'), // Placeholder
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
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, color: Colors.green),
        SizedBox(width: 8),
        Text(
          'Delivered',
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 18,
            color: Colors.green,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}