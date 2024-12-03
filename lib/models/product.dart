class Product {
  String id;
  String name;
  String description;
  double price;
  String imagePath;
  bool liked;
  bool isAuthor;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imagePath,
    this.liked = false,
    this.isAuthor = true,
  });
}
