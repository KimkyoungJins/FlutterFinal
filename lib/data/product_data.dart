import '../models/product.dart';

class ProductData {
  static int _nextId = 1;
  static List<Product> products = [];

  static int getNextId() => _nextId++;

  static void addProduct(Product product) {
    products.add(product);
  }

  static void updateProduct(Product product) {
    int index = products.indexWhere((p) => p.id == product.id);
    if (index != -1) {
      products[index] = product;
    }
  }

  static void deleteProduct(int id) {
    products.removeWhere((p) => p.id == id);
  }

  static Product? getProductById(int id) {
    try {
      return products.firstWhere((p) => p.id == id);
    } catch (e) {
      return null;
    }
  }
}
