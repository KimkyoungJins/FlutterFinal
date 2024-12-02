import 'package:flutter/material.dart';
import '../helpers/database_helper.dart';
import '../models/product.dart';
import 'detail_page.dart';
import 'add_product_page.dart';

class ItemPage extends StatefulWidget {
  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  late Future<List<Product>> _productList;

  @override
  void initState() {
    super.initState();
    _refreshProductList();
  }

  void _refreshProductList() {
    setState(() {
      _productList = DatabaseHelper.instance.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: Text('상품 목록'), actions: [buildAddButton(), SizedBox(width: 10)]),
      body: FutureBuilder<List<Product>>(
        future: _productList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<Product> products = snapshot.data!;
            return GridView.builder(
              padding: EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // 한 행에 표시할 카드 수
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                Product product = products[index];
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
                                builder: (context) => DetailPage(productId: product.id!),
                              ),
                            );
                          },
                          child: Text('더 보기'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Widget buildAddButton() {
    return IconButton(
      icon: Icon(Icons.add),
      onPressed: () async {
        // AddProductPage로 이동하고, 완료 후 목록 갱신
        await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => AddProductPage()),
        );
        _refreshProductList();
      },
    );
  }
}
