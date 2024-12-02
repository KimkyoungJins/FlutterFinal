import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/product_data.dart';

class EditProductPage extends StatefulWidget {
  final Product product;

  const EditProductPage({Key? key, required this.product}) : super(key: key);

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();

  late String _name;
  late double _price;
  late String _description;
  bool _isUpdating = false;

  @override
  void initState() {
    super.initState();
    _name = widget.product.name;
    _price = widget.product.price;
    _description = widget.product.description;
  }

  void _updateProduct() {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();

    setState(() {
      _isUpdating = true;
    });

    try {
      Product updatedProduct = Product(
        id: widget.product.id,
        name: _name,
        price: _price,
        imagePath: widget.product.imagePath,
        description: _description,
        likeCount: widget.product.likeCount,
        isLiked: widget.product.isLiked,
      );

      ProductData.updateProduct(updatedProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('상품이 성공적으로 수정되었습니다!')),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('상품 수정 중 에러가 발생했습니다: $e')),
      );
    } finally {
      setState(() {
        _isUpdating = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('상품 수정'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: _isUpdating
              ? Center(child: CircularProgressIndicator())
              : Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // 상품 이름 입력
                      TextFormField(
                        initialValue: _name,
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
                        initialValue: _price.toString(),
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
                      SizedBox(height: 20),
                      // 상품 설명 입력
                      TextFormField(
                        initialValue: _description,
                        decoration: InputDecoration(
                          labelText: '상품 설명',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return '상품 설명을 입력해주세요.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _description = value!;
                        },
                      ),
                      SizedBox(height: 30),
                      // 상품 수정 버튼
                      ElevatedButton(
                        onPressed: _updateProduct,
                        child: Text('상품 수정'),
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
