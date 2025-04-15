import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cartprovider.dart';
import '../screens/drinkdetailscreen.dart';

const Color primaryColor = Color(0xFF1F4352);
class DrinkItem extends StatelessWidget {
  final String productId;
  final String title;
  final String imageUrl;
  final double price;

  const DrinkItem({
    Key? key,
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cart = context.read<CartProvider>();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => DrinkDetailScreen(
              title: title,
              imageUrl: imageUrl,
              price: price.toInt(),
            ),
          ),
        );
      },
      child: Container(
        width: 160,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade300,
              blurRadius: 6,
              offset: const Offset(2, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hình ảnh sản phẩm
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: imageUrl.startsWith("http")
                  ? Image.network(
                      imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 120,
                        color: Colors.grey.shade200,
                        child: const Center(child: Icon(Icons.image_not_supported, size: 40)),
                      ),
                    )
                  : Image.asset(
                      imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 120,
                        color: Colors.grey.shade200,
                        child: const Center(child: Icon(Icons.image_not_supported, size: 40)),
                      ),
                    ),
            ),

            // Nội dung sản phẩm
            Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "${price.toStringAsFixed(0)} VNĐ",
                    style: const TextStyle(color: Colors.redAccent, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: InkWell(
                      onTap: () {
                        cart.addToCart(
                          productId,
                          title,
                          price,
                          imageUrl,
                          1,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text("✅ $title đã thêm vào giỏ hàng"),
                            duration: const Duration(seconds: 2),
                            backgroundColor: Colors.green.shade600,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(50),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.brown.shade100,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add_shopping_cart,
                          size: 20,
                          color: Colors.brown,
                        ),
                      ),
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
