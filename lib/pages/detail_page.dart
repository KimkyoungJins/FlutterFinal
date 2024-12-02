import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/product.dart';
import 'dart:io';

class DetailPage extends StatefulWidget {
  final int productId;

  const DetailPage({Key? key, required this.productId}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Product? _product;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  Future<void> _loadProduct() async {
    Product? product = await DatabaseHelper.instance.getProduct(widget.productId);
    setState(() {
      _product = product;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading || _product == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('상세 정보'),
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(_product!.name),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              // 상품 이미지
              _product!.imagePath.isNotEmpty
                  ? Image.file(
                      File(_product!.imagePath),
                      height: 250,
                      fit: BoxFit.cover,
                    )
                  : Image.asset(
                      'assets/images/default_image.png',
                      height: 250,
                      fit: BoxFit.cover,
                    ),
              SizedBox(height: 20),
              // 상품 이름
              Text(
                _product!.name,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              // 상품 가격
              Text(
                '\$${_product!.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, color: Colors.grey[700]),
              ),
              SizedBox(height: 20),
              // 추가적인 상품 설명이나 정보
              Text(
                '이곳에 상품에 대한 추가 설명을 입력하세요.',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }
  }
}
