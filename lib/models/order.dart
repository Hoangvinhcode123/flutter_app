enum OrderStatus {
  PENDING,
  PREPARING,
  DELIVERING,
  COMPLETED,
  CANCELLED,
}

enum PaymentMethod {
  CASH,
  MOMO,
  VNPAY,
  CREDIT_CARD,
}

class Order {
  final String id;
  final String orderNumber;
  final String userId;
  final String storeId;
  final String? voucherId;
  final OrderStatus status;
  final PaymentMethod paymentMethod;
  final String paymentStatus; // UNPAID, PAID, REFUNDED
  final double subTotal;
  final double shippingFee;
  final double discountAmount;
  final double finalTotal;
  final String shippingAddress;
  final String customerNote;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Order({
    required this.id,
    required this.orderNumber,
    required this.userId,
    required this.storeId,
    this.voucherId,
    this.status = OrderStatus.PENDING,
    this.paymentMethod = PaymentMethod.CASH,
    this.paymentStatus = 'UNPAID',
    required this.subTotal,
    this.shippingFee = 0.0,
    this.discountAmount = 0.0,
    required this.finalTotal,
    required this.shippingAddress,
    this.customerNote = '',
    required this.createdAt,
    required this.updatedAt,
  });
}

class OrderItem {
  final String id;
  final String orderId;
  final String productId;
  final String name;
  final String variantId;
  final String selectedToppingsJson;
  final int quantity;
  final double unitPrice; // Snapshot of the price
  final double lineTotal;

  const OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.name,
    required this.variantId,
    this.selectedToppingsJson = '[]',
    required this.quantity,
    required this.unitPrice,
    required this.lineTotal,
  });
}
