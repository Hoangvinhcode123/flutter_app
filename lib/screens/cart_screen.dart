import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../models/order.dart';
import '../widgets/katinat_app_bar.dart';
import '../widgets/katinat_footer.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color katinatBlue = Color(0xFF132A38);
    const Color katinatGold = Color(0xFFD3A374);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const KatinatAppBar(),
      body: Consumer<CartProvider>(
        builder: (context, cartProvider, child) {
          final items = cartProvider.items;
          final total = cartProvider.totalAmount;
          
          return SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Cart Items Left Pane
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'GIỎ HÀNG CỦA BẠN (${items.length} món)',
                              style: GoogleFonts.barlowCondensed(
                                color: katinatBlue,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.5,
                              ),
                            ),
                            const SizedBox(height: 24),
                            if (items.isEmpty)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 40.0),
                                child: Center(
                                  child: Column(
                                    children: [
                                      Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey[300]),
                                      const SizedBox(height: 16),
                                      Text('Giỏ hàng trống. Hãy mua sắm nhé!', style: GoogleFonts.montserrat(fontSize: 16, color: Colors.grey[500])),
                                    ],
                                  ),
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: items.length,
                                separatorBuilder: (c, i) => const Divider(height: 40),
                                itemBuilder: (context, index) {
                                  final item = items[index];
                                  final formattedPrice = '${item.unitPrice.toStringAsFixed(0)}.000đ'.replaceAll('000.000', '000');
                                  
                                  return _buildCartItem(
                                    context,
                                    item: item,
                                    priceFormatted: formattedPrice,
                                    // Bóc ID gốc của món nướng ghép vào asset URL
                                    imageUrl: 'assets/images/sp_${item.productId.replaceAll("p", "")}.jpg',
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 40),
                      // Order Summary Right Pane
                      Expanded(
                        flex: 1,
                        child: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.grey[50],
                            border: Border.all(color: Colors.grey[200]!),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                                Text(
                                  'TÓM TẮT ĐƠN HÀNG',
                                  style: GoogleFonts.montserrat(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 20),
                                // Voucher Section in Cart
                                _buildSummaryRow('Tạm tính', _formatPrice(total)),
                                const SizedBox(height: 12),
                                _buildSummaryRow('Phí vận chuyển', 'Liên hệ'),
                                const SizedBox(height: 12),
                                _buildSummaryRow('Khuyến mãi', '-${_formatPrice(cartProvider.discount)}', color: Colors.green),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 16.0),
                                  child: Divider(),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'TỔNG CỘNG',
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      _formatPrice(total - cartProvider.discount),
                                      style: GoogleFonts.montserrat(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 24,
                                        color: katinatGold,
                                      ),
                                    ),
                                  ],
                                ),
                              const SizedBox(height: 32),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    final auth = Provider.of<AuthProvider>(context, listen: false);
                                    if (auth.isLoggedIn) {
                                      Navigator.pushNamed(context, '/checkout');
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng đăng nhập để thanh toán')));
                                      Navigator.pushNamed(context, '/login');
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: katinatBlue,
                                    padding: const EdgeInsets.symmetric(vertical: 16),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  child: Text(
                                    'TIẾN HÀNH THANH TOÁN',
                                    style: GoogleFonts.montserrat(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const KatinatFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCartItem(BuildContext context, {
    required OrderItem item,
    required String priceFormatted,
    required String imageUrl,
  }) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Image.asset(
            imageUrl,
            width: 100,
            height: 100,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 100, height: 100, color: Colors.grey[300],
              child: const Icon(Icons.broken_image, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      item.name,
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    priceFormatted,
                    style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: const Color(0xFFD3A374),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Size M, Đá bình thường',
                style: GoogleFonts.montserrat(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300]!),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        IconButton(icon: const Icon(Icons.remove, size: 16), onPressed: () => cart.decrementQuantity(item.productId), constraints: const BoxConstraints()),
                        Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        IconButton(icon: const Icon(Icons.add, size: 16), onPressed: () => cart.incrementQuantity(item.productId), constraints: const BoxConstraints()),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  TextButton(
                    onPressed: () => cart.removeItem(item.productId),
                    child: const Text('Xoá', style: TextStyle(color: Colors.redAccent)),
                  )
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  String _formatPrice(double price) {
    return '${price.toInt().toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ';
  }

  Widget _buildSummaryRow(String label, String value, {Color? color}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(color: Colors.grey[700]),
        ),
        Text(
          value,
          style: GoogleFonts.montserrat(fontWeight: FontWeight.w600, color: color),
        ),
      ],
    );
  }
}
