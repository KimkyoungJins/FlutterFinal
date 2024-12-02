class Product {
  int id;
  String name;
  double price;
  String imagePath; // 이 부분이 String 타입인지 확인
  String description;
  int likeCount;
  bool isLiked;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imagePath,
    required this.description,
    this.likeCount = 0,
    this.isLiked = false,
  });
}
