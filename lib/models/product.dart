import 'package:cloud_firestore/cloud_firestore.dart';

class Product {
  String? id;
  String name;
  double price;
  String imageUrl;

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  // Firestore에서 데이터를 가져올 때 사용
  factory Product.fromDocument(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return Product(
      id: doc.id,
      name: data['name'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      imageUrl: data['imageUrl'] ?? '',
    );
  }

  // Firestore에 데이터를 저장할 때 사용
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'imageUrl': imageUrl,
    };
  }
}
