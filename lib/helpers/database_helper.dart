import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import '../models/product.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database? _database;

  DatabaseHelper._privateConstructor();

  Future<Database> get database async => _database ??= await _initDatabase();

  // 데이터베이스 초기화
  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'products.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // 테이블 생성
  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE products(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        price REAL NOT NULL,
        imagePath TEXT NOT NULL
      )
    ''');
  }

  // 상품 추가
  Future<int> insertProduct(Product product) async {
    Database db = await instance.database;
    return await db.insert('products', product.toMap());
  }

  // 모든 상품 가져오기
  Future<List<Product>> getProducts() async {
    Database db = await instance.database;
    var products = await db.query('products', orderBy: 'id');
    List<Product> productList =
        products.isNotEmpty ? products.map((p) => Product.fromMap(p)).toList() : [];
    return productList;
  }

  // 특정 상품 가져오기
  Future<Product?> getProduct(int id) async {
    Database db = await instance.database;
    var products = await db.query('products', where: 'id = ?', whereArgs: [id]);
    if (products.isNotEmpty) {
      return Product.fromMap(products.first);
    }
    return null;
  }

  // 상품 삭제 (선택 사항)
  Future<int> deleteProduct(int id) async {
    Database db = await instance.database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // 상품 업데이트 (선택 사항)
  Future<int> updateProduct(Product product) async {
    Database db = await instance.database;
    return await db.update('products', product.toMap(),
        where: 'id = ?', whereArgs: [product.id]);
  }
}
