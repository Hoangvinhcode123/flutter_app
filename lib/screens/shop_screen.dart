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
import 'product_detail_screen.dart';

class ShopScreen extends StatefulWidget {
  const ShopScreen({super.key});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<dynamic> _products = [];
  List<dynamic> _categories = [];
  bool _isLoading = true;
  Set<int> _wishlistIds = {};
  
  String _searchQuery = '';
  int? _selectedCategoryId;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    try {
      final catRes = await http.get(Uri.parse('http://localhost:3000/api/categories'));
      if (mounted) {
        setState(() {
          _categories = json.decode(catRes.body);
          _categories.insert(0, {'id': null, 'name': 'Tất cả'});
        });
      }
      await _fetchProducts();
      await _fetchWishlistIds();
    } catch (e) {
      debugPrint('Error: $e');
    }
  }

  Future<http.Response> _fetchProducts() async {
    String url = 'http://localhost:3000/api/products?';
    if (_searchQuery.isNotEmpty) url += 'search=$_searchQuery&';
    if (_selectedCategoryId != null) url += 'category_id=$_selectedCategoryId&';

    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200 && mounted) {
      setState(() {
        _products = json.decode(res.body);
        _isLoading = false;
      });
    }
    return res;
  }

  Future<void> _fetchWishlistIds() async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (!auth.isLoggedIn) return;
    try {
      final response = await http.get(
        Uri.parse('http://localhost:3000/api/wishlist'),
        headers: {'Authorization': 'Bearer ${auth.token}'},
      );
      if (response.statusCode == 200) {
        final list = json.decode(response.body) as List;
        setState(() {
          _wishlistIds = list.map((item) => item['product_id'] as int).toSet();
        });
      }
    } catch (_) {}
  }

  Future<void> _toggleWishlist(int productId) async {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    if (!auth.isLoggedIn) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng đăng nhập để yêu thích sản phẩm')));
      return;
    }

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
        setState(() {
          if (_wishlistIds.contains(productId)) {
            _wishlistIds.remove(productId);
          } else {
            _wishlistIds.add(productId);
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Không thể cập nhật danh sách yêu thích')));
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color katinatGold = Color(0xFFD3A374);
    const Color katinatBlue = Color(0xFF132A38);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const KatinatAppBar(),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() => _isLoading = true);
          await _fetchProducts();
          await _fetchWishlistIds();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CỬA HÀNG',
                              style: GoogleFonts.barlowCondensed(color: katinatGold, fontSize: 48, fontWeight: FontWeight.bold, letterSpacing: 2.0),
                            ),
                            const SizedBox(height: 10),
                            Text('Thưởng thức phong vị mới ngay tại nhà', style: GoogleFonts.montserrat(color: Colors.grey[700], fontSize: 16)),
                          ],
                        ),
                        // Search Bar
                        SizedBox(
                          width: 300,
                          child: TextField(
                            controller: _searchController,
                            onChanged: (v) {
                              setState(() {
                                _searchQuery = v;
                                _isLoading = true;
                              });
                              _fetchProducts();
                            },
                            decoration: InputDecoration(
                              hintText: 'Tìm kiếm sản phẩm...',
                              prefixIcon: const Icon(Icons.search, color: katinatGold),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey[300]!)),
                              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide(color: Colors.grey[300]!)),
                              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: const BorderSide(color: katinatGold)),
                              contentPadding: const EdgeInsets.symmetric(vertical: 0),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    // Categories Chips
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _categories.map((cat) {
                          bool isSelected = _selectedCategoryId == cat['id'];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: ChoiceChip(
                              label: Text(cat['name'].toString().toUpperCase()),
                              selected: isSelected,
                              onSelected: (selected) {
                                setState(() {
                                  _selectedCategoryId = cat['id'];
                                  _isLoading = true;
                                });
                                _fetchProducts();
                              },
                              selectedColor: katinatGold,
                              backgroundColor: Colors.grey[100],
                              labelStyle: GoogleFonts.montserrat(
                                color: isSelected ? Colors.white : Colors.black87,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 40),
                    if (_isLoading)
                      const Center(child: Padding(padding: EdgeInsets.all(100.0), child: CircularProgressIndicator()))
                    else if (_products.isEmpty)
                      const Center(child: Padding(padding: EdgeInsets.all(100.0), child: Text('Không tìm thấy sản phẩm nào.')))
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 300,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 30,
                        ),
                        itemCount: _products.length,
                        itemBuilder: (context, index) {
                          final p = _products[index];
                          final productObj = Product(
                            id: p['id'].toString(),
                            categoryId: p['category_id']?.toString() ?? '1',
                            sku: p['sku'] ?? p['id'].toString(),
                            name: p['name'],
                            slug: p['slug'] ?? p['name'],
                            description: p['description'] ?? '',
                            basePrice: double.parse(p['price'].toString()),
                            primaryImageUrl: p['image_url'] ?? '',
                            createdAt: DateTime.now(),
                          );

                          return _buildProductCard(context, product: productObj, dbId: p['id']);
                        },
                      ),
                  ],
                ),
              ),
              const KatinatFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProductCard(BuildContext context, {required Product product, required int dbId}) {
    const Color katinatGold = Color(0xFFD3A374);
    final isFavorite = _wishlistIds.contains(dbId);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey[200]!),
        borderRadius: BorderRadius.circular(8),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (c) => ProductDetailScreen(product: product, dbId: dbId))),
              child: Stack(
                children: [
                   ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                    child: product.primaryImageUrl.startsWith('http')
                      ? Image.network(
                          product.primaryImageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[100], child: const Icon(Icons.coffee, size: 50, color: Colors.grey)),
                        )
                      : Image.asset(
                          product.primaryImageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          errorBuilder: (context, error, stackTrace) => Container(color: Colors.grey[100], child: const Icon(Icons.coffee, size: 50, color: Colors.grey)),
                        ),
                  ),
                  Positioned(
                    top: 8, right: 8,
                    child: Container(
                      decoration: BoxDecoration(color: Colors.white.withOpacity(0.8), shape: BoxShape.circle),
                      child: IconButton(
                        icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.red : Colors.grey),
                        onPressed: () => _toggleWishlist(dbId),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 2, overflow: TextOverflow.ellipsis),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('${product.basePrice.toStringAsFixed(0)}đ', style: GoogleFonts.montserrat(color: katinatGold, fontWeight: FontWeight.bold, fontSize: 16)),
                      IconButton(
                        onPressed: () {
                          Provider.of<CartProvider>(context, listen: false).addItem(product);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã thêm ${product.name} vào giỏ!'), duration: const Duration(seconds: 1)));
                        },
                        icon: const Icon(Icons.add_shopping_cart, color: katinatGold),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
