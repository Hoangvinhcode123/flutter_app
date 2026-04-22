import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/auth_provider.dart';
import '../widgets/katinat_app_bar.dart';
import '../widgets/katinat_footer.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<dynamic> _wishlistItems = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchWishlist();
  }

  Future<void> _fetchWishlist() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (!auth.isLoggedIn) return;

    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/wishlist'),
        headers: {'Authorization': 'Bearer ${auth.token}'},
      );

      if (response.statusCode == 200) {
        setState(() {
          _wishlistItems = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Lỗi tải danh sách yêu thích');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}'), backgroundColor: Colors.red));
      }
    }
  }

  Future<void> _removeFromWishlist(int productId) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/wishlist/toggle'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${auth.token}',
        },
        body: json.encode({'product_id': productId}),
      );

      if (response.statusCode == 200) {
        _fetchWishlist(); // Refresh
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã xóa khỏi danh sách yêu thích')));
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không thể xóa sản phẩm')));
      }
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
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Text(
                    'DANH SÁCH YÊU THÍCH',
                    style: GoogleFonts.barlowCondensed(fontSize: 48, fontWeight: FontWeight.bold, color: katinatBlue),
                  ),
                  const SizedBox(height: 10),
                  Text('Lưu lại những món uống "ruột" của bạn', style: GoogleFonts.montserrat(color: Colors.grey[600])),
                ],
              ),
            ),
            if (_isLoading)
              const Center(child: Padding(padding: EdgeInsets.all(50.0), child: CircularProgressIndicator()))
            else if (_wishlistItems.isEmpty)
              Padding(
                padding: const EdgeInsets.all(100.0),
                child: Column(
                  children: [
                    Icon(Icons.favorite_border, size: 80, color: Colors.grey[300]),
                    const SizedBox(height: 20),
                    const Text('Chưa có sản phẩm nào trong danh sách yêu thích.'),
                  ],
                ),
              )
            else
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(20),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                    ),
                    itemCount: _wishlistItems.length,
                    itemBuilder: (context, index) {
                      final item = _wishlistItems[index];
                      return _buildWishlistItem(item, katinatGold, katinatBlue);
                    },
                  ),
                ),
              ),
            const KatinatFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildWishlistItem(dynamic item, Color katinatGold, Color katinatBlue) {
    return Card(
      elevation: 2,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  color: Colors.grey[100],
                  child: Icon(Icons.coffee, size: 50, color: katinatGold.withOpacity(0.5)),
                ),
                Positioned(
                  top: 8, right: 8,
                  child: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () => _removeFromWishlist(item['product_id']),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['category_name'].toString().toUpperCase(), style: GoogleFonts.montserrat(fontSize: 10, color: katinatGold, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(item['name'], style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Text('${item['price']}đ', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
