import 'dart:io'; // 추가해야 합니다.
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../data/product_data.dart';
import 'edit_product_page.dart';

class DetailPage extends StatefulWidget {
  final int productId;

  const DetailPage({Key? key, required this.productId}) : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Product? _product;

  void _loadProduct() {
    setState(() {
      _product = ProductData.getProductById(widget.productId);
    });
  }

  void _toggleLike() {
    if (_product == null) return;

    if (_product!.isLiked) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('이미 좋아요를 눌렀습니다.')),
      );
    } else {
      setState(() {
        _product!.isLiked = true;
        _product!.likeCount += 1;
      });
      ProductData.updateProduct(_product!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('좋아요를 눌렀습니다!')),
      );
    }
  }

  void _deleteProduct() {
    ProductData.deleteProduct(widget.productId);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('상품이 삭제되었습니다.')),
    );
    Navigator.pop(context);
  }

  @override
  void initState() {
    super.initState();
    _loadProduct();
  }

  @override
  Widget build(BuildContext context) {
    if (_product == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('상세 정보'),
        ),
        body: Center(child: Text('상품을 찾을 수 없습니다.')),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: Text(_product!.name),
          actions: [
            IconButton(
              icon: Icon(Icons.create),
              onPressed: () async {
                // 상품 수정 페이지로 이동
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditProductPage(product: _product!),
                  ),
                );
                _loadProduct();
              },
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: _deleteProduct,
            ),
          ],
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
              // 상품 설명
              Text(
                _product!.description,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              // 좋아요 버튼
              ElevatedButton.icon(
                onPressed: _toggleLike,
                icon: Icon(Icons.thumb_up),
                label: Text('좋아요'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: _product!.isLiked ? Colors.grey : Colors.blue, // 수정된 부분
                ),
              ),
              SizedBox(height: 10),
              // 좋아요 수
              Text('좋아요 수: ${_product!.likeCount}'),
            ],
          ),
        ),
      );
    }
  }
}
