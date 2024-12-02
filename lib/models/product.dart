import 'dart:convert';

class Product {
  int? id;
  String name;
  double price;
  String imagePath; // 로컬에 저장된 이미지의 경로

  Product({
    this.id,
    required this.name,
    required this.price,
    required this.imagePath,
  });

  // 데이터베이스에서 데이터를 가져올 때 사용
  factory Product.fromMap(Map<String, dynamic> json) => Product(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        imagePath: json['imagePath'],
      );

  // 데이터베이스에 데이터를 저장할 때 사용
  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'price': price,
        'imagePath': imagePath,
      };
}
