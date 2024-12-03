import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../models/product.dart';

class AddProductPage extends StatefulWidget {
  final Product? product;
  final bool isEditing;

  AddProductPage({this.product, this.isEditing = false});

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();
  String id = '';
  String name = '';
  String description = '';
  double price = 0.0;
  String imagePath = 'assets/images/default.jpg'; // Default image path
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    if (widget.isEditing && widget.product != null) {
      id = widget.product!.id;
      name = widget.product!.name;
      description = widget.product!.description;
      price = widget.product!.price;
      imagePath = widget.product!.imagePath;
    }
  }

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Product newProduct = Product(
        id: widget.isEditing ? id : DateTime.now().toString(),
        name: name,
        description: description,
        price: price,
        imagePath: _imageFile != null ? _imageFile!.path : imagePath,
        isAuthor: true,
      );
      Navigator.pop(context, newProduct);
    }
  }

  void _pickImage() async {
    final picker = ImagePicker();
    final pickedImage =
        await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
        imagePath = pickedImage.path;
      });
    }
  }

  Widget _buildImage() {
    if (_imageFile != null) {
      return Image.file(_imageFile!);
    } else {
      return Image.asset(imagePath);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.isEditing ? 'Edit Product' : 'Add Product'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16.0),
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: Container(
                height: 200,
                color: Colors.grey[200],
                child: _buildImage(),
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              initialValue: name,
              decoration: InputDecoration(labelText: 'Product Name'),
              onSaved: (value) => name = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a product name' : null,
            ),
            TextFormField(
              initialValue: description,
              decoration: InputDecoration(labelText: 'Description'),
              onSaved: (value) => description = value!,
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a description' : null,
            ),
            TextFormField(
              initialValue: price != 0.0 ? price.toString() : '',
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType:
                  TextInputType.numberWithOptions(decimal: true, signed: false),
              onSaved: (value) => price = double.parse(value!),
              validator: (value) =>
                  value!.isEmpty ? 'Please enter a price' : null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveProduct,
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
