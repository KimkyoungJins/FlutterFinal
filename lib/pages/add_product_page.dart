import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';
import 'package:path/path.dart' as path;

class AddProductPage extends StatefulWidget {
  const AddProductPage({Key? key}) : super(key: key);

  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  double _price = 0.0;
  File? _imageFile;
  bool _isUploading = false;

  final ImagePicker _picker = ImagePicker();

  // 기본 이미지 URL
  String _defaultImageUrl = 'http://handong.edu/site/handong/res/img/logo.png';

  // 이미지 선택 함수
  Future<void> _pickImage() async {
    final pickedFile =
        await _picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  // 이미지 업로드 함수
  Future<String> _uploadImage(File file) async {
    String fileName = path.basename(file.path);
    Reference storageRef =
        FirebaseStorage.instance.ref().child('products').child(fileName);
    UploadTask uploadTask = storageRef.putFile(file);
    TaskSnapshot snapshot = await uploadTask;
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  // 상품 추가 함수
  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() {
      _isUploading = true;
    });

    try {
      String imageUrl;
      if (_imageFile != null) {
        imageUrl = await _uploadImage(_imageFile!);
      } else {
        imageUrl = _defaultImageUrl;
      }

      Product newProduct = Product(
        name: _name,
        price: _price,
        imageUrl: imageUrl,
      );

      await FirebaseFirestore.instance
          .collection('products')
          .add(newProduct.toMap());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('상품이 성공적으로 추가되었습니다!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('상품 추가 중 에러가 발생했습니다: $e')),
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('상품 추가'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: _isUploading
              ? Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // 이미지 표시 및 선택 버튼
                      GestureDetector(
                        onTap: _pickImage,
                        child: CircleAvatar(
                          radius: 60,
                          backgroundImage: _imageFile != null
                              ? FileImage(_imageFile!)
                              : NetworkImage(_defaultImageUrl)
                                  as ImageProvider,
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton.icon(
                        onPressed: _pickImage,
                        icon: Icon(Icons.photo),
                        label: Text('이미지 선택'),
                      ),
                      SizedBox(height: 20),
                      // 상품 이름 입력
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: '상품 이름',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '상품 이름을 입력해주세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _name = value!;
                        },
                      ),
                      SizedBox(height: 20),
                      // 상품 가격 입력
                      TextFormField(
                        decoration: InputDecoration(
                          labelText: '가격',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType:
                            TextInputType.numberWithOptions(decimal: true),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '가격을 입력해주세요.';
                          }
                          if (double.tryParse(value) == null) {
                            return '유효한 숫자를 입력해주세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _price = double.parse(value!);
                        },
                      ),
                      SizedBox(height: 30),
                      // 상품 추가 버튼
                      ElevatedButton(
                        onPressed: _addProduct,
                        child: Text('상품 추가'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
                        ),
                      ),
                    ],
                  ),
                ),
        ));
  }
}
