import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../models/product.dart';
import '../widgets/katinat_app_bar.dart';
import '../widgets/katinat_footer.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  final int dbId;

  const ProductDetailScreen({super.key, required this.product, required this.dbId});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  List<dynamic> _reviews = [];
  bool _isLoadingReviews = true;
  final _commentController = TextEditingController();
  int _rating = 5;

  @override
  void initState() {
    super.initState();
    _fetchReviews();
  }

  Future<void> _fetchReviews() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/api/products/${widget.dbId}/reviews'));
      if (response.statusCode == 200) {
        setState(() {
          _reviews = json.decode(response.body);
          _isLoadingReviews = false;
        });
      }
    } catch (_) {
      setState(() => _isLoadingReviews = false);
    }
  }

  void _submitReview() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (!auth.isLoggedIn) return;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/reviews'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${auth.token}',
        },
        body: json.encode({
          'product_id': widget.dbId,
          'rating': _rating,
          'comment': _commentController.text,
        }),
      );

      if (response.statusCode == 201) {
        _commentController.clear();
        _fetchReviews();
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cảm ơn bạn đã đánh giá!')));
      } else {
        final msg = json.decode(response.body)['message'] ?? 'Lỗi đánh giá';
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.orange));
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lỗi gửi đánh giá')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color katinatBlue = Color(0xFF132A38);
    const Color katinatGold = Color(0xFFD3A374);

    return Scaffold(
      appBar: const KatinatAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 60),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                         child: widget.product.primaryImageUrl.startsWith('http')
                            ? Image.network(
                                widget.product.primaryImageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(height: 500, color: Colors.grey[100], child: const Icon(Icons.coffee, size: 100, color: Colors.grey)),
                              )
                            : Image.asset(
                                widget.product.primaryImageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => Container(height: 500, color: Colors.grey[100], child: const Icon(Icons.coffee, size: 100, color: Colors.grey)),
                              ),
                        ),
                      ),
                      const SizedBox(width: 60),
                      // Details
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.product.name, style: GoogleFonts.barlowCondensed(fontSize: 48, fontWeight: FontWeight.bold, color: katinatBlue)),
                            const SizedBox(height: 10),
                            Text('${widget.product.basePrice.toStringAsFixed(0)}đ', style: GoogleFonts.montserrat(fontSize: 32, fontWeight: FontWeight.bold, color: katinatGold)),
                            const SizedBox(height: 20),
                            const Divider(),
                            const SizedBox(height: 20),
                            Text(widget.product.description.isEmpty ? 'Hương vị cà phê truyền thống được chế biến từ những hạt cà phê Arabica và Robusta tuyển chọn, mang đến trải nghiệm tuyệt vời cho bạn.' : widget.product.description, style: GoogleFonts.montserrat(fontSize: 16, height: 1.6, color: Colors.grey[700])),
                            const SizedBox(height: 40),
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    onPressed: () {
                                      Provider.of<CartProvider>(context, listen: false).addItem(widget.product);
                                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã thêm vào giỏ hàng')));
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: katinatBlue, padding: const EdgeInsets.symmetric(vertical: 20)),
                                    child: const Text('THÊM VÀO GIỎ HÀNG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // Reviews Section
            Container(
              color: Colors.grey[50],
              padding: const EdgeInsets.all(40),
              width: double.infinity,
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('ĐÁNH GIÁ TỪ KHÁCH HÀNG', style: GoogleFonts.barlowCondensed(fontSize: 32, fontWeight: FontWeight.bold, color: katinatBlue)),
                      const SizedBox(height: 30),
                      _buildReviewForm(katinatGold, katinatBlue),
                      const SizedBox(height: 40),
                      if (_isLoadingReviews)
                        const CircularProgressIndicator()
                      else if (_reviews.isEmpty)
                        const Text('Chưa có đánh giá nào cho sản phẩm này.')
                      else
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _reviews.length,
                          itemBuilder: (context, index) {
                            final r = _reviews[index];
                            return _buildReviewItem(r);
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ),
            const KatinatFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewForm(Color gold, Color blue) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[200]!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Viết đánh giá của bạn', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 10),
          Row(
            children: List.generate(5, (index) => IconButton(
              icon: Icon(index < _rating ? Icons.star : Icons.star_border, color: gold),
              onPressed: () => setState(() => _rating = index + 1),
            )),
          ),
          TextField(
            controller: _commentController,
            maxLines: 3,
            decoration: const InputDecoration(hintText: 'Nhập bình luận của bạn...', border: OutlineInputBorder()),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _submitReview,
            style: ElevatedButton.styleFrom(backgroundColor: gold),
            child: const Text('GỬI ĐÁNH GIÁ', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(dynamic r) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(backgroundColor: Colors.grey, child: Icon(Icons.person, color: Colors.white)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(r['user_name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text(r['created_at'].toString().split('T')[0], style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                  ],
                ),
                Row(children: List.generate(5, (i) => Icon(Icons.star, size: 14, color: i < r['rating'] ? Colors.orange : Colors.grey[300]))),
                const SizedBox(height: 8),
                Text(r['comment'] ?? ''),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
