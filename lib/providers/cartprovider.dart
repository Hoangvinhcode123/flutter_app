import 'package:flutter/material.dart';

class CartItem {
  final String productId;
  final String title;
  final double price;
  final String image;
  int quantity;

  CartItem({
    required this.productId,
    required this.title,
    required this.price,
    required this.image,
    this.quantity = 1,
  });
}

class CartProvider with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  // Lấy danh sách item (read-only)
  Map<String, CartItem> get items => Map.unmodifiable(_items);

  // Kiểm tra giỏ hàng trống
  bool get isEmpty => _items.isEmpty;

  // Tổng số lượng tất cả sản phẩm
  int get totalItems => _items.values.fold(0, (sum, item) => sum + item.quantity);

  // Tổng tiền
  double get totalPrice => _items.values.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

  // Lấy 1 item theo productId
  CartItem? getItemById(String productId) => _items[productId];

  /// Thêm sản phẩm vào giỏ
  void addToCart(String productId, String title, double price, String image, [int quantity = 1]) {
    if (quantity <= 0) return;

    if (_items.containsKey(productId)) {
      _items[productId]!.quantity += quantity;
    } else {
      _items[productId] = CartItem(
        productId: productId,
        title: title,
        price: price,
        image: image,
        quantity: quantity,
      );
    }

    notifyListeners();
  }

  /// Cập nhật số lượng sản phẩm
  void updateQuantity(String productId, int newQuantity) {
    if (!_items.containsKey(productId)) return;

    if (newQuantity <= 0) {
      _items.remove(productId);
    } else {
      _items[productId]!.quantity = newQuantity;
    }

    notifyListeners();
  }

  /// Xóa 1 sản phẩm khỏi giỏ
  void removeItem(String productId) {
    if (_items.remove(productId) != null) {
      notifyListeners();
    }
  }

  /// Giảm số lượng sản phẩm đi 1 (nếu còn lại 0 thì xóa luôn)
  void removeFromCart(String productId) {
    if (!_items.containsKey(productId)) return;

    if (_items[productId]!.quantity > 1) {
      _items[productId]!.quantity -= 1;
    } else {
      _items.remove(productId);
    }

    notifyListeners();
  }

  /// Xóa toàn bộ giỏ hàng
  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
