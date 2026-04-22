class Product {
  final String id;
  final String categoryId;
  final String sku;
  final String name;
  final String slug;
  final String description;
  final double basePrice;
  final String primaryImageUrl;
  final bool isAvailable;
  final DateTime createdAt;

  const Product({
    required this.id,
    required this.categoryId,
    required this.sku,
    required this.name,
    required this.slug,
    required this.description,
    required this.basePrice,
    required this.primaryImageUrl,
    this.isAvailable = true,
    required this.createdAt,
  });
}

class ProductVariant {
  final String id;
  final String productId;
  final String sizeName; // S, M, L
  final double priceAdjustment; // +10.000 for L
  final bool isActive;

  const ProductVariant({
    required this.id,
    required this.productId,
    required this.sizeName,
    required this.priceAdjustment,
    this.isActive = true,
  });
}
