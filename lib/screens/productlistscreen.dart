import 'package:flutter/material.dart';

class ProductListScreen extends StatelessWidget {
  final String category;

  ProductListScreen({super.key, required this.category});

  final Map<String, List<Map<String, String>>> productsByCategory = {
    "Cà phê": [
      {
        "id": "1",
        "title": "Cà Phê Đen",
        "imageUrl": "assets/images/coffeeden.png",
        "price": "20.000 VNĐ"
      },
      {
        "id": "2",
        "title": "Cà Phê Sữa",
        "imageUrl": "assets/images/coffeesua.jpg",
        "price": "25.000 VNĐ"
      },
    ],
    "Trà": [
      {
        "id": "3",
        "title": "Trà Sữa",
        "imageUrl": "assets/images/trasua.png",
        "price": "30.000 VNĐ"
      },
    ],
    "Nước ép": [
      {
        "id": "4",
        "title": "Nước Cam",
        "imageUrl": "assets/images/lemon.jpg",
        "price": "35.000 VNĐ"
      },
    ],
    "Đồ uống khác": [],
  };

  @override
  Widget build(BuildContext context) {
    final products = productsByCategory[category] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text("Danh Mục - $category"),
      ),
      body: products.isEmpty
          ? const Center(
              child: Text(
                "Không có sản phẩm nào trong danh mục này",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Padding(
              padding: const EdgeInsets.all(10),
              child: GridView.builder(
                itemCount: products.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 sản phẩm trên mỗi hàng
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.75,
                ),
                itemBuilder: (context, index) {
                  final product = products[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/productDetail',
                        arguments: product,
                      );
                    },
                    child: Card(
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: const BorderRadius.vertical(
                                top: Radius.circular(10),
                              ),
                              child: Image.asset(
                                product["imageUrl"]!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 50,
                                      color: Colors.red,
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8),
                            child: Column(
                              children: [
                                Text(
                                  product["title"]!,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  product["price"]!,
                                  style: const TextStyle(
                                    color: Colors.brown,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }
}
