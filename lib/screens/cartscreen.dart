import 'package:app_tuan89/screens/OrderHistoryScreen.dart' as OrderHistoryScreenLib;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cartprovider.dart' as cart_provider;
import './orderscreen.dart';
import './orderconfirmationscreen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<cart_provider.CartProvider>(context);
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Giỏ hàng",
          style: textTheme.headlineLarge?.copyWith(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          if (cart.items.isNotEmpty)
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.brown[100],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Icon(Icons.shopping_bag, color: Colors.brown[400]),
                  const SizedBox(width: 10),
                  Text(
                    "Bạn có ${cart.items.length} sản phẩm trong giỏ hàng",
                    style: textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          if (cart.items.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sản phẩm đã chọn",
                    style: textTheme.headlineLarge?.copyWith(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const OrderScreen(),
                        ),
                      );
                    },
                    style: TextButton.styleFrom(
                      backgroundColor: const Color(0xFFC19F72),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      "+ Thêm",
                      style: textTheme.labelLarge?.copyWith(
                        color: const Color(0xFF6D4BAF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: cart.items.isEmpty
                ? Center(
                    child: Text(
                      "Giỏ hàng trống",
                      style: textTheme.bodyLarge?.copyWith(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                    ),
                  )
                : ListView.builder(
                    itemCount: cart.items.length,
                    itemBuilder: (context, index) {
                      String productId = cart.items.keys.elementAt(index);
                      var item = cart.items[productId]!;

                      return Container(
                        key: ValueKey(productId),
                        margin: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.brown[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Image.asset(
                                item.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    color: Colors.grey.shade300,
                                    child: const Icon(
                                      Icons.broken_image,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.title,
                                    style: textTheme.headlineLarge?.copyWith(
                                      fontSize: 16,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "Ngọt bình thường, Đá bình thường",
                                    style: textTheme.bodyLarge?.copyWith(
                                      color: Colors.grey,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        children: [
                                          Text(
                                            "${item.price.toStringAsFixed(0)}đ",
                                            style: textTheme.headlineLarge
                                                ?.copyWith(fontSize: 16),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            "218,000đ",
                                            style: textTheme.bodyLarge
                                                ?.copyWith(
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        children: [
                                          IconButton(
                                            icon: Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.brown[400],
                                            ),
                                            onPressed: () {
                                              if (item.quantity > 1) {
                                                cart.updateQuantity(
                                                  productId,
                                                  item.quantity - 1,
                                                );
                                              } else {
                                                cart.removeFromCart(
                                                  productId,
                                                );
                                              }
                                            },
                                          ),
                                          Text("${item.quantity}"),
                                          IconButton(
                                            icon: Icon(
                                              Icons.add_circle_outline,
                                              color: Colors.brown[400],
                                            ),
                                            onPressed: () {
                                              cart.addToCart(
                                                item.productId,
                                                item.title,
                                                item.price,
                                                item.image,
                                                1,
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          if (cart.items.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.brown[100],
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
                      Text(
                        "${cart.totalItems} sản phẩm",
                        style: textTheme.bodyLarge,
                      ),
                      Row(
                        children: [
                          Text(
                            "${cart.totalPrice.toStringAsFixed(0)}đ",
                            style: textTheme.headlineLarge?.copyWith(
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "218,000đ",
                            style: textTheme.bodyLarge?.copyWith(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      final cartProvider =
                          Provider.of<cart_provider.CartProvider>(
                            context,
                            listen: false,
                          );
                      final orderProvider = Provider.of<
                          OrderHistoryScreenLib.OrderHistoryProvider>(
                        context,
                        listen: false,
                      );

                      if (cartProvider.items.isEmpty) return;

                      // Lưu đơn hàng vào lịch sử
                      orderProvider.addOrder(
                        cartProvider.items.values.toList(),
                        cartProvider.totalPrice,
                      );

                      // Xóa giỏ hàng sau khi thanh toán
                      cartProvider.clearCart();

                      // Điều hướng đến màn hình xác nhận
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OrderConfirmationScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFC19F72),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 40,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: Text(
                      "Tiếp tục",
                      style: textTheme.labelLarge?.copyWith(
                        fontSize: 16,
                        color: const Color(0xFF6D4BAF),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}