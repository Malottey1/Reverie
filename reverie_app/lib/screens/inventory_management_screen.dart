import 'package:flutter/material.dart';

class InventoryManagementScreen extends StatefulWidget {
  @override
  _InventoryManagementScreenState createState() => _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFDDDBD3),
      appBar: AppBar(
        title: Text('Inventory', style: TextStyle(fontFamily: 'Poppins', color: Colors.black)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Search inventory',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                filled: true,
                fillColor: Colors.transparent,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FilterChip(
                  label: Text('All'),
                  onSelected: (bool value) {},
                  backgroundColor: Color(0xFFDDDBD3),
                ),
                FilterChip(
                  label: Text('Category'),
                  onSelected: (bool value) {},
                  backgroundColor: Color(0xFFDDDBD3),
                ),
                FilterChip(
                  label: Text('Size'),
                  onSelected: (bool value) {},
                  backgroundColor: Color(0xFFDDDBD3),
                ),
                FilterChip(
                  label: Text('Color'),
                  onSelected: (bool value) {},
                  backgroundColor: Color(0xFFDDDBD3),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildInventoryItem('Nike Air Max 90 Hyper Grape', 'assets/shoes.png', '\$150'),
                  _buildInventoryItem('Adidas Yeezy Boost 350 V2', 'assets/shoes.png', '\$250'),
                  _buildInventoryItem('Gucci GG Marmont Matelasse Mini', 'assets/dress.jpg', '\$1300'),
                  _buildInventoryItem('Coach Signature Zip Tote', 'assets/bags.png', '\$200'),
                  _buildInventoryItem('Prada Saffiano Leather Wallet', 'assets/jacket.jpg', '\$300'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInventoryItem(String title, String imageUrl, String price) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Color(0xFF69734E),
          width: 2,
        ),
      ),
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
                  title,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.black),
                  softWrap: true,
                ),
                Text(
                  price,
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: Colors.black54),
                  softWrap: true,
                ),
              ],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF69734E),
              side: BorderSide(color: Color(0xFF69734E)),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
            ),
            onPressed: () {
              _showEditItemDialog(context, title, imageUrl, price);
            },
            child: Text(
              'Edit',
              style: TextStyle(fontFamily: 'Poppins', color: Colors.white, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, String title, String imageUrl, String price) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return EditItemDialog(title: title, imageUrl: imageUrl, price: price);
      },
    );
  }
}

class EditItemDialog extends StatefulWidget {
  final String title;
  final String imageUrl;
  final String price;

  EditItemDialog({required this.title, required this.imageUrl, required this.price});

  @override
  _EditItemDialogState createState() => _EditItemDialogState();
}

class _EditItemDialogState extends State<EditItemDialog> {
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _priceController = TextEditingController(text: widget.price);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _priceController,
              decoration: InputDecoration(
                labelText: 'Price',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Text('Active', style: TextStyle(fontFamily: 'Poppins', fontSize: 16)),
                Switch(
                  value: _isActive,
                  onChanged: (bool value) {
                    setState(() {
                      _isActive = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 78, 118, 137),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              ),
              onPressed: () {
                // Handle delete action
              },
              child: Text('Delete', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF69734E),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              ),
              onPressed: () {
                // Handle save changes action
              },
              child: Text('Save Changes', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: InventoryManagementScreen(),
));