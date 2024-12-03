import 'package:flutter/material.dart';
import '../models/product.dart';
import 'add_product_page.dart';

class DetailPage extends StatefulWidget {
  final Product product;

  DetailPage({required this.product});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int likes = 0;
  bool hasLiked = false;

  @override
  void initState() {
    super.initState();
    likes = widget.product.liked ? 1 : 0;
    hasLiked = widget.product.liked;
  }

  void _likeProduct() {
    if (!hasLiked) {
      setState(() {
        likes += 1;
        hasLiked = true;
        widget.product.liked = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You liked this product!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('You have already liked this product.')),
      );
    }
  }

  void _editProduct() async {
    var updatedProduct = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddProductPage(
          product: widget.product,
          isEditing: true,
        ),
      ),
    );
    if (updatedProduct != null) {
      setState(() {
        widget.product.name = updatedProduct.name;
        widget.product.description = updatedProduct.description;
        widget.product.price = updatedProduct.price;
        widget.product.imagePath = updatedProduct.imagePath;
      });
    }
  }

  void _deleteProduct() {
    // Since we don't have a database, we'll pop with a result
    Navigator.pop(context, 'delete');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        actions: [
          if (widget.product.isAuthor) ...[
            IconButton(
              icon: Icon(Icons.create),
              onPressed: _editProduct,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteProduct();
              },
            ),
          ],
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(widget.product.imagePath),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    widget.product.name,
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(height: 10),
                  Text(
                    '\$${widget.product.price}',
                    style: TextStyle(fontSize: 20, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 20),
                  Text(widget.product.description),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.thumb_up,
                            color: hasLiked ? Colors.blue : Colors.grey),
                        onPressed: _likeProduct,
                      ),
                      Text('$likes'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
