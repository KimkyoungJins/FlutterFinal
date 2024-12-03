import 'package:flutter/material.dart';
import 'pages/item_list_page.dart';
import 'pages/add_product_page.dart';
import 'pages/profile_page.dart';

void main() {
  runApp(ProductApp());
}

class ProductApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Product App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ItemListPage(),
      routes: {
        '/add': (context) => AddProductPage(),
        '/profile': (context) => ProfilePage(),
      },
    );
  }
}
