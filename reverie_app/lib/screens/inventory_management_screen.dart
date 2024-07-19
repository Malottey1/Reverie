import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_connection.dart';
import '../providers/user_provider.dart';

class InventoryManagementScreen extends StatefulWidget {
  @override
  _InventoryManagementScreenState createState() => _InventoryManagementScreenState();
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  List<Map<String, dynamic>> _products = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProducts();
  }

  Future<void> _fetchProducts() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final vendorId = userProvider.vendorId;

    try {
      List<dynamic> results = await ApiConnection().fetchProductsByVendor(vendorId!);
      setState(() {
        _products = results.cast<Map<String, dynamic>>();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load products: $e')),
      );
    }
  }

  Future<void> _updateProduct(int productId, String title, double price, bool isActive) async {
    try {
      await ApiConnection().updateProduct(
        productId: productId,
        title: title,
        price: price,
        isActive: isActive ? 1 : 0,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product updated successfully')),
      );
      _fetchProducts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update product: $e')),
      );
    }
  }

  Future<void> _deleteProduct(int productId) async {
    try {
      await ApiConnection().deleteProduct(productId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product deleted successfully')),
      );
      _fetchProducts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete product: $e')),
      );
    }
  }

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
            SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _products.isEmpty
                      ? Center(child: Text('No products found'))
                      : ListView.builder(
                          itemCount: _products.length,
                          itemBuilder: (context, index) {
                            return _buildInventoryItem(_products[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }



  Widget _buildInventoryItem(Map<String, dynamic> product) {
    String imageUrl = product['image_path'];
    if (!imageUrl.startsWith('http') && !imageUrl.startsWith('https')) {
      imageUrl = 'http://192.168.104.167/api/reverie/product-images/' + imageUrl;
    }

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
            child: Image.network(
              imageUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey,
                  child: Center(
                    child: Icon(Icons.image, color: Colors.white),
                  ),
                );
              },
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['title'],
                  style: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.black),
                  softWrap: true,
                ),
                Text(
                  '\$${product['price']}',
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
              _showEditItemDialog(context, product);
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

  Future<bool?> _showEditItemDialog(BuildContext context, Map<String, dynamic> product) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return EditItemDialog(
          product: product,
          onSave: (title, price, isActive) {
            _updateProduct(product['product_id'], title, price, isActive);
          },
          onDelete: () {
            _deleteProduct(product['product_id']);
          },
        );
      },
    );
  }
}

class EditItemDialog extends StatefulWidget {
  final Map<String, dynamic> product;
  final void Function(String title, double price, bool isActive) onSave;
  final VoidCallback onDelete;

  EditItemDialog({required this.product, required this.onSave, required this.onDelete});

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
    _titleController = TextEditingController(text: widget.product['title']);
    _priceController = TextEditingController(text: widget.product['price'].toString());
    _isActive = widget.product['is_active'] == 1;
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
                widget.onDelete();
                Navigator.of(context).pop();
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
                widget.onSave(
                  _titleController.text,
                  double.tryParse(_priceController.text) ?? 0.0,
                  _isActive,
                );
                Navigator.of(context).pop();
              },
              child: Text('Save Changes', style: TextStyle(fontFamily: 'Poppins', color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}