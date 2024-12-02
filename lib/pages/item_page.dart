import 'dart:io'; // File 클래스를 사용하기 위해 추가
import 'package:flutter/material.dart';
import '../models/product.dart';
import 'detail_page.dart';
import 'add_product_page.dart';
import '../data/product_data.dart';

class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => _ItemPageState();
}
class _ItemPageState extends State<ItemPage> {
  String _sortOption = 'price_asc';

  List<Product> get sortedProducts {
    List<Product> products = List.from(ProductData.products);
    if (_sortOption == 'price_asc') {
      products.sort((a, b) => a.price.compareTo(b.price));
    } else {
      products.sort((a, b) => b.price.compareTo(a.price));
    }
    return products;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('상품 목록'),
        actions: [
          // 정렬 옵션 드롭다운 버튼
          DropdownButton<String>(
            value: _sortOption,
            icon: Icon(Icons.sort, color: Colors.white),
            dropdownColor: Colors.blue,
            underline: Container(),
            onChanged: (String? newValue) {
              setState(() {
                _sortOption = newValue!;
              });
            },
            items: <DropdownMenuItem<String>>[
              DropdownMenuItem(
                value: 'price_asc',
                child: Text('가격 오름차순', style: TextStyle(color: Colors.white)),
              ),
              DropdownMenuItem(
                value: 'price_desc',
                child: Text('가격 내림차순', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () async {
              // AddProductPage로 이동하고, 완료 후 목록 갱신
              await Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddProductPage()),
              );
              setState(() {});
            },
          ),
        ],
      ),
      body: GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, // 한 행에 표시할 카드 수
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          childAspectRatio: 0.75,
        ),
        itemCount: sortedProducts.length,
        itemBuilder: (context, index) {
          Product product = sortedProducts[index];
          return Card(
            elevation: 5,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: product.imagePath.isNotEmpty
                      ? Image.file(
                          File(product.imagePath),
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/images/default_image.png',
                          fit: BoxFit.cover,
                        ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      // Detail 페이지로 이동
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailPage(productId: product.id),
                        ),
                      ).then((_) => setState(() {}));
                    },
                    child: Text('더 보기'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
