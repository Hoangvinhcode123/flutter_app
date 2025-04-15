import 'package:app_tuan89/screens/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cartprovider.dart';
import './orderconfirmationscreen.dart';

class OrderScreen extends StatelessWidget {
  const OrderScreen({super.key});

  final List<Map<String, dynamic>> products = const [
    {
      'title': 'COMBO LẮP LẠNH - TRÀ SỮA CHÔM CHÔM',
      'price': 169000.0,
      'originalPrice': 218000.0,
      'image': 'assets/images/combo1.jpg',
    },
    {
      'title': 'COMBO LẮP LẠNH - CỐC CỐC ĐẶC ĐẶC',
      'price': 169000.0,
      'originalPrice': 229000.0,
      'image': 'assets/images/combo2.jpg',
    },
    {
      'title': 'COMBO LẮP LẠNH - BỘ GIÁ DỤA NÓN',
      'price': 169000.0,
      'originalPrice': 228000.0,
      'image': 'assets/images/combo3.jpg',
    },
    {
      'title': 'COMBO LẮP LẠNH - HIBI SỐ RỈ',
      'price': 169000.0,
      'originalPrice': 228000.0,
      'image': 'assets/images/combo4.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => MainScreen()),
            );
          },
        ),
        title: const Text(
          "Đặt nước",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: IconButton(
              icon: const Icon(Icons.local_drink, color: Colors.black),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Hiển thị danh mục đồ uống')),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Bạn của ĐƯƠNG muốn tìm ...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _categoryButton("Tất cả"),
                _categoryButton("Best Seller"),
                _categoryButton("Món ngon phải thử"),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "ƯU ĐÃI",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return _buildProductCard(context, product, cart);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("${cart.totalItems} sản phẩm"),
                    Text(
                      "${cart.totalPrice.toStringAsFixed(0)}đ",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    if (cart.items.isNotEmpty) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderConfirmationScreen(),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            "Giỏ hàng trống! Vui lòng thêm sản phẩm.",
                          ),
                          backgroundColor: Colors.redAccent,
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC49B6C),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 14,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Xem giỏ hàng",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _categoryButton(String label) {
    return TextButton(
      onPressed: () {},
      child: Text(label, style: const TextStyle(color: Colors.grey)),
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    Map<String, dynamic> product,
    CartProvider cart,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Container(
                height: 120,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                  image: DecorationImage(
                    image: AssetImage(product['image']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E6EF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "-26% CHIẾT",
                    style: TextStyle(color: Colors.red, fontSize: 12),
                  ),
                ),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    "169K",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['title'],
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${(product['price'] as double).toStringAsFixed(0)}đ",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.red,
                          ),
                        ),
                        Text(
                          "${(product['originalPrice'] as double).toStringAsFixed(0)}đ",
                          style: const TextStyle(
                            decoration: TextDecoration.lineThrough,
                            color: Colors.red,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFC49B6C),
                          width: 2,
                        ),
                      ),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Icons.add,
                            size: 20,
                            color: Color(0xFFC49B6C),
                          ),
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            cart.addToCart(
                              product['title'],
                              product['title'],
                              product['price'].toDouble(),
                              product['image'],
                              1,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  "${product['title']} đã được thêm vào giỏ hàng",
                                ),
                                duration: const Duration(seconds: 2),
                                backgroundColor: Colors.green.shade600,
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
