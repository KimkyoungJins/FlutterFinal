import 'package:flutter/material.dart';
import '../models/product.dart';
import 'detail_page.dart';
import 'add_product_page.dart';
import 'profile_page.dart';

class ItemListPage extends StatefulWidget {
  @override
  _ItemListPageState createState() => _ItemListPageState();
}

class _ItemListPageState extends State<ItemListPage> {
  List<Product> products = [
    Product(
      id: '1',
      name: 'Laptop',
      description: 'High performance laptop',
      price: 1500.0,
      imagePath: 'assets/images/laptop.jpg',
    ),
    Product(
      id: '2',
      name: 'Smartphone',
      description: 'Latest model smartphone',
      price: 999.0,
      imagePath: 'assets/images/smartphone.jpg',
    ),
    Product(
      id: '3',
      name: 'Headphones',
      description: 'Noise-cancelling headphones',
      price: 199.0,
      imagePath: 'assets/images/headphones.jpg',
    ),
    Product(
      id: '4',
      name: 'Smartwatch',
      description: 'Feature-rich smartwatch',
      price: 299.0,
      imagePath: 'assets/images/smartwatch.jpg',
    ),
    Product(
      id: '5',
      name: 'Camera',
      description: 'High-resolution camera',
      price: 1200.0,
      imagePath: 'assets/images/camera.jpg',
    ),
    Product(
      id: '6',
      name: 'Speaker',
      description: 'Bluetooth speaker',
      price: 150.0,
      imagePath: 'assets/images/speaker1.jpg',
    ),
  ];

  String dropdownValue = 'Price Ascending';

  @override
  Widget build(BuildContext context) {
    // Sort products based on dropdownValue
    if (dropdownValue == 'Price Ascending') {
      products.sort((a, b) => a.price.compareTo(b.price));
    } else {
      products.sort((a, b) => b.price.compareTo(a.price));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          // Dropdown for sorting
          DropdownButton<String>(
            value: dropdownValue,
            items: <String>['Price Ascending', 'Price Descending']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Colors.white)),
              );
            }).toList(),
            dropdownColor: Colors.blue,
            icon: Icon(Icons.sort, color: Colors.white),
            onChanged: (String? newValue) {
              setState(() {
                dropdownValue = newValue!;
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => ProfilePage()));
            },
          ),
        ],
      ),
      body: ListView(
        children: products.map((product) {
          return Card(
            child: ListTile(
              leading: Image.asset(product.imagePath, width: 50, height: 50),
              title: Text(product.name),
              subtitle: Text('\$${product.price}'),
              trailing: IconButton(
                icon: Icon(Icons.more_vert),
                onPressed: () async {
                  // Navigate to Detail Page and wait for potential updates
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        product: product,
                      ),
                    ),
                  );
                  setState(() {}); // Refresh the list after returning
                },
              ),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // Navigate to Add Product Page and wait for the new product
          var newProduct = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddProductPage()),
          );
          if (newProduct != null) {
            setState(() {
              products.add(newProduct);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
