import '../providers/cartprovider.dart';

class OrderItem {
  final String id;
  final List<CartItem> products;
  final double total;
  final DateTime dateTime;

  OrderItem({
    required this.id,
    required this.products,
    required this.total,
    required this.dateTime,
  });
}
