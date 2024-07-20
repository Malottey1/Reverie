import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../controllers/add_product_controller.dart';

class AddProductScreen extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _image;

  @override
  Widget build(BuildContext context) {
    final AddProductController _controller = Provider.of<AddProductController>(context);

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
          'New Item',
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () async {
                  final pickedFile = await _pickImage();
                  if (pickedFile != null) {
                    setState(() {
                      _image = pickedFile;
                    });
                    _controller.setImagePath(pickedFile.path);
                  }
                },
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Color(0xFFB0BEC5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.all(8),
                      child: Icon(
                        Icons.image,
                        color: Color(0xFF69734E),
                        size: 30,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Upload Image',
                      style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 16,
                        color: Colors.black,
                      ),
                    ),
                    Spacer(),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.black,
                      size: 16,
                    ),
                  ],
                ),
              ),
              if (_image != null)
                Padding(
                  padding: const EdgeInsets.only(top: 16.0),
                  child: Image.file(
                    File(_image!.path),
                    width: double.infinity,
                    height: 150,
                    fit: BoxFit.cover,
                  ),
                ),
              SizedBox(height: 20),
              _buildTextField('Title', _controller.titleController),
              _buildTextField('Description', _controller.descriptionController, isMultiline: true),
              _buildDropdown('Category', ['Tops', 'Bottoms', 'Dresses', 'Outerwear', 'Accessories'], (String? newValue) {
                _controller.setCategory(newValue!);
              }),
              _buildTextField('Brand (Optional)', _controller.brandController),
              _buildDropdown('Size', ['XS', 'S', 'M', 'L', 'XL', 'XXL'], (String? newValue) {
                _controller.setSize(newValue!);
              }),
              _buildTextField('Color', _controller.colorController),
              _buildDropdown('Condition', ['New with Tags', 'Excellent', 'Very Good', 'Good', 'Fair'], (String? newValue) {
                _controller.setCondition(newValue!);
              }),
              _buildDropdown('Target Group', ['Men', 'Women', 'Kids'], (String? newValue) {
                _controller.setTargetGroup(newValue!);
              }),
              _buildTextField('Price', _controller.priceController),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () => _controller.saveAndPublish(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF69734E),
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    'Save and Publish',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<XFile?> _pickImage() async {
    return await showModalBottomSheet<XFile>(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text('Take a Photo'),
                onTap: () async {
                  final pickedFile = await _picker.pickImage(source: ImageSource.camera);
                  Navigator.pop(context, pickedFile);
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text('Choose from Gallery'),
                onTap: () async {
                  final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
                  Navigator.pop(context, pickedFile);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildTextField(String hint, TextEditingController controller, {bool isMultiline = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        maxLines: isMultiline ? null : 1,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
          ),
          filled: true,
          fillColor: Color(0xFFB0BEC5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDropdown(String hint, List<String> items, void Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            fontFamily: 'Poppins',
          ),
          filled: true,
          fillColor: Color(0xFFB0BEC5),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(
                fontFamily: 'Poppins',
              ),
            ),
          );
        }).toList(),
        onChanged: onChanged,
      ),
    );
  }
}