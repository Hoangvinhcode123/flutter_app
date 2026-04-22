import 'package:flutter/material.dart';
import '../models/product.dart';
import '../models/order.dart'; // To use OrderItem

class CartProvider extends ChangeNotifier {
  final List<OrderItem> _items = [];

  List<OrderItem> get items => _items;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.lineTotal);
  }

  void addItem(Product product, {int quantity = 1}) {
    // Kiểm tra xem sản phẩm đã có trong giỏ chưa
    final existingIndex = _items.indexWhere((item) => item.productId == product.id);

    if (existingIndex >= 0) {
      // Tăng số lượng
      final oldItem = _items[existingIndex];
      _items[existingIndex] = OrderItem(
        id: oldItem.id,
        orderId: oldItem.orderId,
        productId: oldItem.productId,
        name: oldItem.name,
        variantId: oldItem.variantId,
        selectedToppingsJson: oldItem.selectedToppingsJson,
        quantity: oldItem.quantity + quantity,
        unitPrice: oldItem.unitPrice,
        lineTotal: oldItem.unitPrice * (oldItem.quantity + quantity),
      );
    } else {
      // Thêm mới
      _items.add(OrderItem(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        orderId: '',
        productId: product.id,
        name: product.name,
        variantId: 'default',
        quantity: quantity,
        unitPrice: product.basePrice,
        lineTotal: product.basePrice * quantity,
      ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  void incrementQuantity(String productId) {
    final idx = _items.indexWhere((item) => item.productId == productId);
    if (idx >= 0) {
      final old = _items[idx];
      _items[idx] = OrderItem(
        id: old.id,
        orderId: old.orderId,
        productId: old.productId,
        name: old.name,
        variantId: old.variantId,
        quantity: old.quantity + 1,
        unitPrice: old.unitPrice,
        lineTotal: old.unitPrice * (old.quantity + 1),
      );
      notifyListeners();
    }
  }

  void decrementQuantity(String productId) {
    final idx = _items.indexWhere((item) => item.productId == productId);
    if (idx >= 0) {
      if (_items[idx].quantity > 1) {
        final old = _items[idx];
        _items[idx] = OrderItem(
          id: old.id,
          orderId: old.orderId,
          productId: old.productId,
          name: old.name,
          variantId: old.variantId,
          quantity: old.quantity - 1,
          unitPrice: old.unitPrice,
          lineTotal: old.unitPrice * (old.quantity - 1),
        );
        notifyListeners();
      } else {
        removeItem(productId);
      }
    }
  }

  double _discount = 0;
  String? _appliedVoucher;

  double get discount => _discount;
  String? get appliedVoucher => _appliedVoucher;

  void setDiscount(double amount, String? code) {
    _discount = amount;
    _appliedVoucher = code;
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _discount = 0;
    _appliedVoucher = null;
    notifyListeners();
  }
}
