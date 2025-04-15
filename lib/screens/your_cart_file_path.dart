import 'package:app_tuan89/providers/cartprovider.dart';
import 'package:flutter/foundation.dart';// Thay bằng đường dẫn file chứa CartItem
// Ví dụ: import 'cart_provider.dart';

class OrderItem {
  final String id;
  final List<CartItem> items;
  final double total;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.items,
    required this.total,
    required this.dateTime,
  });
}