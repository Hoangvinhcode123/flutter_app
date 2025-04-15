import 'package:app_tuan89/providers/cartprovider.dart';
import 'package:app_tuan89/screens/orderscreen.dart';
import 'package:flutter/material.dart';

import '../providers/OrderItem.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F4352)),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrderScreen()),
            );
          },
        ),
        title: const Text(
          'Lịch sử đặt hàng',
          style: TextStyle(
            color: Color(0xFF1F4352),
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: Icon(Icons.filter_list, color: Color(0xFF1F4352)),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF1F4352),
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: const [
                Icon(Icons.delete_outline, color: Colors.white),
                SizedBox(width: 8),
                Text(
                  'Bạn chưa có đơn hàng nào hoàn tất',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/duong.jpg', // hoặc ảnh trống khác
                    height: 200,
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const OrderScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB6906B),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text(
                        'MUA NGAY',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
class OrderHistoryProvider with ChangeNotifier {
  final List<OrderItem> _orders = [];

  List<OrderItem> get orders => _orders;

  void addOrder(List<CartItem> items, double totalPrice) {
    final newOrder = OrderItem(
      id: DateTime.now().toString(),
      products: items,
      total: totalPrice,
      dateTime: DateTime.now(),
    );
    _orders.insert(0, newOrder);
    notifyListeners();
  }
}