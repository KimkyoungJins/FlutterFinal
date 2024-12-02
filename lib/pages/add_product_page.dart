import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../helpers/database_helper.dart';
import '../models/product.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class AddProductPage extends StatefulWidget {
  @override
  _AddProductPageState createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  double _price = 0.0;
  File? _imageFile;
  bool _isSaving = false;

  final ImagePicker _picker = ImagePicker();

  // 기본 이미지 경로
  String _defaultImagePath = 'assets/images/default_image.png';

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

  // 이미지 저장 함수
  Future<String> _saveImage(File file) async {
    Directory appDir = await getApplicationDocumentsDirectory();
    String fileName = basename(file.path);
    String savedPath = join(appDir.path, fileName);
    return await file.copy(savedPath).then((File savedFile) => savedFile.path);
  }

  // 상품 추가 함수
  Future<void> _addProduct() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() {
      _isSaving = true;
    });

    try {
      String imagePath;
      if (_imageFile != null) {
        imagePath = await _saveImage(_imageFile!);
      } else {
        // 기본 이미지 사용
        imagePath = '';
      }

      Product newProduct = Product(
        name: _name,
        price: _price,
        imagePath: imagePath,
      );

      await DatabaseHelper.instance.insertProduct(newProduct);

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
        _isSaving = false;
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
          child: _isSaving
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
                              : AssetImage(_defaultImagePath) as ImageProvider,
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
