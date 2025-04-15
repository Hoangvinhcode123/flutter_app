import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cartprovider.dart';

class ProductDetailScreen extends StatelessWidget {
  final String productId;
  final String imageUrl;
  final String title;
  final double productPrice;
  final String description;

  ProductDetailScreen({
    required this.productId,
    required this.imageUrl,
    required this.title,
    required this.productPrice,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      backgroundColor: Colors.brown[100],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(imageUrl, height: 300, width: double.infinity, fit: BoxFit.cover),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${productPrice.toStringAsFixed(0)} VNĐ",
                    style: const TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 15),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      cartProvider.addToCart(
                        productId,       // productId
                        title,          // title
                        productPrice,   // price
                        imageUrl,       // image
                        1,             // quantity
                      );
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Đã thêm $title vào giỏ hàng")),
                      );
                    },
                    icon: const Icon(Icons.shopping_cart, color: Colors.white),
                    label: const Text(
                      "Thêm vào giỏ hàng",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                      elevation: 5,
                    ),
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