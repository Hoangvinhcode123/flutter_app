import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import '../providers/auth_provider.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  static const Color katinatBlue = Color(0xFF132A38);
  static const Color katinatGold = Color(0xFFD3A374);

  int _selectedIndex = 0; 
  bool _isLoading = true;
  final String baseUrl = 'http://localhost:3000/api'; // Giả sử chạy local
  
  List<dynamic> _users = [];
  List<dynamic> _products = [];
  List<dynamic> _orders = [];
  List<dynamic> _promotions = [];
  Map<String, dynamic> _stats = {
    'revenue': 0,
    'pendingOrders': 0,
    'newUsers': 0,
    'outOfStock': 0,
    'recentOrders': []
  };
  Map<String, dynamic> _detailedStats = {
    'daily': [],
    'monthly': [],
    'topProducts': []
  };

  String _orderFilter = 'Tất cả';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAllData();
    });
  }

  Future<void> _fetchAllData() async {
    setState(() => _isLoading = true);
    try {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      final headers = {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'};

      final responses = await Future.wait([
        http.get(Uri.parse('$baseUrl/admin/users'), headers: headers),
        http.get(Uri.parse('$baseUrl/products'), headers: headers),
        http.get(Uri.parse('$baseUrl/admin/orders'), headers: headers),
        http.get(Uri.parse('$baseUrl/admin/stats'), headers: headers),
        http.get(Uri.parse('$baseUrl/admin/stats/detailed'), headers: headers),
        http.get(Uri.parse('$baseUrl/admin/promotions'), headers: headers),
      ]);

      if (mounted) {
        setState(() {
          final usersData = json.decode(responses[0].body);
          _users = usersData is List ? usersData : [];
          
          final productsData = json.decode(responses[1].body);
          _products = productsData is List ? productsData : [];
          
          final ordersData = json.decode(responses[2].body);
          _orders = ordersData is List ? ordersData : [];
          
          final statsData = json.decode(responses[3].body);
          if (statsData is Map<String, dynamic>) {
            _stats = statsData;
          }

          final detailedData = json.decode(responses[4].body);
          if (detailedData is Map<String, dynamic>) {
            _detailedStats = detailedData;
          }

          final promoData = json.decode(responses[5].body);
          _promotions = promoData is List ? promoData : [];
          
          _isLoading = false;
        });
        
        // Log errors if any API returned a Map instead of a List (likely an error message)
        if (json.decode(responses[0].body) is Map) print('Users API Error: ${responses[0].body}');
        if (json.decode(responses[1].body) is Map) print('Products API Error: ${responses[1].body}');
        if (json.decode(responses[2].body) is Map) print('Orders API Error: ${responses[2].body}');
      }
    } catch (e) {
      print('Error fetching admin data: $e');
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Route Guard: Nếu không phải admin thì đá về Shop
    final auth = Provider.of<AuthProvider>(context);
    if (!auth.isAdmin) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/shop');
      });
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Row(
        children: [
          // Sidebar Menu
          Container(
            width: 250,
            color: katinatBlue,
            child: Column(
              children: [
                const SizedBox(height: 40),
                GestureDetector(
                  onTap: () => Navigator.pushReplacementNamed(context, '/home'),
                  child: Text(
                    'ĐƯƠNG ADMIN',
                    style: GoogleFonts.barlowCondensed(
                      color: katinatGold,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2.0,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                _buildSidebarItem(icon: Icons.dashboard, title: 'Tổng quan', isActive: _selectedIndex == 0, onTap: () => setState(() => _selectedIndex = 0)),
                _buildSidebarItem(icon: Icons.people, title: 'Nhân Sự & Phân Quyền', isActive: _selectedIndex == 1, onTap: () => setState(() => _selectedIndex = 1)),
                _buildSidebarItem(icon: Icons.shopping_bag, title: 'Quản lý Đơn hàng', isActive: _selectedIndex == 2, onTap: () => setState(() => _selectedIndex = 2)),
                _buildSidebarItem(icon: Icons.inventory, title: 'Quản lý Kho / Sản phẩm', isActive: _selectedIndex == 3, onTap: () => setState(() => _selectedIndex = 3)),
                _buildSidebarItem(icon: Icons.bar_chart, title: 'Báo cáo Tài chính', isActive: _selectedIndex == 4, onTap: () => setState(() => _selectedIndex = 4)),
                _buildSidebarItem(icon: Icons.confirmation_number, title: 'Quản lý Voucher', isActive: _selectedIndex == 5, onTap: () => setState(() => _selectedIndex = 5)),
                _buildSidebarItem(icon: Icons.notifications_active, title: 'Gửi Thông Báo', isActive: _selectedIndex == 6, onTap: () => setState(() => _selectedIndex = 6)),
                const Spacer(),
                _buildSidebarItem(icon: Icons.logout, title: 'Đăng xuất', onTap: () {
                  Provider.of<AuthProvider>(context, listen: false).logout();
                  Navigator.pushReplacementNamed(context, '/home');
                }),
                const SizedBox(height: 20),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Header
                Container(
                  height: 70,
                  color: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Text(
                        _getHeaderTitle(),
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.notifications_none),
                      const SizedBox(width: 20),
                      const CircleAvatar(
                        backgroundColor: katinatGold,
                        child: Icon(Icons.person, color: Colors.white),
                      )
                    ],
                  ),
                ),
                // Dynamic Content
                Expanded(
                  child: _buildCurrentContent(),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  String _getHeaderTitle() {
    switch (_selectedIndex) {
      case 0: return 'Dashboard Tổng Quan';
      case 1: return 'Quản lý Hệ thống Cấp quyền';
      case 2: return 'Trung tâm Xử lý Đơn hàng';
      case 3: return 'Quản lý Danh mục Sản phẩm';
      case 4: return 'Báo cáo Tài chính & Phân tích';
      case 5: return 'Quản lý Chương trình Voucher';
      case 6: return 'Hệ thống Gửi thông báo BroadCast';
      default: return 'Dashboard';
    }
  }

  Widget _buildCurrentContent() {
    switch (_selectedIndex) {
      case 0: return _buildDashboardContent();
      case 1: return _buildUserManagementContent();
      case 2: return _buildOrdersManagementContent();
      case 3: return _buildProductsManagementContent();
      case 4: return _buildFinancialReportContent();
      case 5: return _buildVoucherManagementContent();
      case 6: return _buildNotificationBroadcastContent();
      default: return const Center(child: Text('Tính năng đang phát triển'));
    }
  }

  // ==========================================
  // VIEW 0: TỔNG QUAN (DASHBOARD)
  // ==========================================
  Widget _buildDashboardContent() {
    const Color katinatGold = Color(0xFFD3A374);
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                SizedBox(width: 220, child: _buildKpiCard(title: 'Doanh thu hôm nay', value: '${_stats['revenue']}đ', icon: Icons.attach_money, color: Colors.green)),
                const SizedBox(width: 20),
                SizedBox(width: 220, child: _buildKpiCard(title: 'Đơn hàng mới', value: '${_stats['pendingOrders']}', icon: Icons.shopping_cart, color: Colors.blue)),
                const SizedBox(width: 20),
                SizedBox(width: 220, child: _buildKpiCard(title: 'Khách hàng mới', value: '${_stats['newUsers']}', icon: Icons.person_add, color: Colors.orange)),
                const SizedBox(width: 20),
                SizedBox(width: 220, child: _buildKpiCard(title: 'Sp hết hàng', value: '${_stats['outOfStock']}', icon: Icons.warning, color: Colors.red)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[200]!)),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Đơn hàng cần xử lý gấp', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Divider(),
                      if (_stats['recentOrders'] != null)
                        ...(_stats['recentOrders'] as List).map((o) => _buildRecentOrderRow(o['id'], o['customer'], o['total'], o['status']))
                      else
                        const Center(child: Text('Không có đơn hàng mới')),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: Container(
                  height: 400,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[200]!)),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Phân bổ sản phẩm', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 16)),
                      const Spacer(),
                      Center(
                        child: Container(
                          width: 200, height: 200,
                          decoration: BoxDecoration(shape: BoxShape.circle, border: Border.all(color: katinatGold, width: 20)),
                          child: Center(child: Text('Trà \n70%', textAlign: TextAlign.center, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold))),
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ==========================================
  // VIEW 1: QUẢN LÝ TÀI KHOẢN (USER/ADMIN)
  // ==========================================
  Widget _buildUserManagementContent() {
    const Color katinatBlue = Color(0xFF132A38);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Danh sách Cấp quyền Quản trị viên (Audit Trail)',
                style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton.icon(
                onPressed: () => _showUserFormDialog(null),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Thêm QTV', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: katinatBlue, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16)),
              )
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[200]!)),
              // Bọc cuộn ngang để fix lỗi RenderFlex Overflow
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  _buildAdminUserHeader(),
                  const Divider(height: 1),
                  ..._users.map((u) => Column(
                    children: [
                      _buildAdminUserRow(u['id'].toString(), u['name'] ?? '', u['email'] ?? '', u['role'] ?? '', u['createdBy'] ?? 'Hệ Thống', u['isActive'] ?? true),
                      const Divider(height: 1),
                    ],
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // ==========================================
  // VIEW 2: QUẢN LÝ ĐƠN HÀNG (ORDERS)
  // ==========================================
  Widget _buildOrdersManagementContent() {
    int pendingCount = _orders.where((o) => o['status'] == 'pending' || o['status'] == 'Chờ xác nhận').length;
    int shippingCount = _orders.where((o) => o['status'] == 'Đang giao').length;

    List<dynamic> filteredOrders = _orders.where((o) {
      if (_orderFilter == 'Tất cả') return true;
      if (_orderFilter.contains('Đang chờ')) return o['status'] == 'pending' || o['status'] == 'Chờ xác nhận';
      if (_orderFilter.contains('Đang giao')) return o['status'] == 'Đang giao';
      return true;
    }).toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bộ lọc đơn hàng', style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  GestureDetector(onTap: () => setState(() => _orderFilter = 'Tất cả'), child: _buildFilterChip('Tất cả', _orderFilter == 'Tất cả')),
                  const SizedBox(width: 8),
                  GestureDetector(onTap: () => setState(() => _orderFilter = 'Đang chờ'), child: _buildFilterChip('Đang chờ ($pendingCount)', _orderFilter == 'Đang chờ')),
                  const SizedBox(width: 8),
                  GestureDetector(onTap: () => setState(() => _orderFilter = 'Đang giao'), child: _buildFilterChip('Đang giao ($shippingCount)', _orderFilter == 'Đang giao')),
                ],
              )
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[200]!)),
              child: filteredOrders.isEmpty 
                ? Center(child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.shopping_cart_outlined, size: 64, color: Colors.grey), const SizedBox(height: 16), Text('Không có đơn hàng nào', style: TextStyle(color: Colors.grey[500], fontSize: 16))]))
                : ListView(
                  padding: const EdgeInsets.all(0),
                  children: [
                    _buildOrderHeaderRow(),
                    const Divider(height: 1),
                    ...filteredOrders.map((o) => Column(
                      children: [
                        _buildOrderDataRow(o['id'].toString(), o['created_at'] ?? '', o['user_name'] ?? 'Khách', o['user_phone'] ?? '', '${o['total_price']}đ', o['status'] ?? 'Chờ'),
                        const Divider(height: 1),
                      ],
                    )),
                  ],
                ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildProductsManagementContent() {
    const Color katinatBlue = Color(0xFF132A38);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Kho Sản Phẩm', style: GoogleFonts.montserrat(fontSize: 18, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () => _showProductFormDialog(null),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Thêm Sản Phẩm', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(backgroundColor: katinatBlue, padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16)),
              )
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: Container(
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[200]!)),
              child: ListView(
                padding: const EdgeInsets.all(0),
                children: [
                  _buildProductHeaderRow(),
                  const Divider(height: 1),
                  ..._products.map((p) => Column(
                    children: [
                      _buildProductDataRow(p['image_url'] ?? '', p['id'].toString(), p['name'] ?? '', p['category_name'] ?? '', '${p['price']}đ', p['stock'] ?? 0, p['is_available'] ?? true),
                      const Divider(height: 1),
                    ],
                  )),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  // ==========================================
  // CRUD LOGIC & DIALOGS
  // ==========================================

  void _showUserFormDialog(Map<String, dynamic>? user) {
    final isEditing = user != null;
    final nameController = TextEditingController(text: isEditing ? user['name'] : '');
    final emailController = TextEditingController(text: isEditing ? user['email'] : '');
    String role = isEditing ? (user['role'] ?? 'USER').toString().toUpperCase() : 'ADMIN';
    if (!['SUPER_ADMIN', 'ADMIN', 'MANAGER', 'USER'].contains(role)) role = 'USER';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(isEditing ? 'Sửa thông tin QTV' : 'Thêm Quản trị viên mới', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Họ và tên')),
            TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Email')),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: role,
              items: ['SUPER_ADMIN', 'ADMIN', 'MANAGER', 'USER'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (v) => role = v!,
              decoration: const InputDecoration(labelText: 'Chức vụ'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
          ElevatedButton(
            onPressed: () async {
              final token = Provider.of<AuthProvider>(context, listen: false).token;
              final url = isEditing ? '$baseUrl/admin/users/${user['id']}' : '$baseUrl/auth/register';
              final method = isEditing ? http.put : http.post;
              
              await method(
                Uri.parse(url),
                headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
                body: json.encode({
                  'name': nameController.text,
                  'email': emailController.text,
                  'role': role,
                  'password': 'password123'
                }),
              );
              _fetchAllData();
              Navigator.pop(context);
            },
            child: Text(isEditing ? 'Cập nhật' : 'Thêm mới'),
          ),
        ],
      ),
    );
  }

  Future<String?> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final request = http.MultipartRequest('POST', Uri.parse('$baseUrl/upload'));
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      request.headers['Authorization'] = 'Bearer $token';
      
      final bytes = await image.readAsBytes();
      request.files.add(http.MultipartFile.fromBytes('image', bytes, filename: image.name));
      
      final response = await request.send();
      if (response.statusCode == 200) {
        final respStr = await response.stream.bytesToString();
        return json.decode(respStr)['url'];
      }
    }
    return null;
  }

  void _showProductFormDialog(Map<String, dynamic>? product) {
    final isEditing = product != null;
    final nameController = TextEditingController(text: isEditing ? product['name'] : '');
    final priceController = TextEditingController(text: isEditing ? (product['price'] ?? '').toString().replaceAll('đ', '') : '');
    final stockController = TextEditingController(text: isEditing ? product['stock'].toString() : '0');
    String imageUrl = isEditing ? product['image'] : '';
    String category = isEditing ? (product['category'] ?? 'Cà Phê') : 'Cà Phê';
    bool isAvailable = isEditing ? (product['isActive'] ?? true) : true;
    // Đảm bảo category có trong danh sách dropdown
    final availableCategories = ['Tất cả', 'Best Seller', 'Trà Sữa', 'Cà Phê', 'Trà Trái Cây', 'Combo'];
    if (!availableCategories.contains(category)) category = 'Tất cả';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Cập nhật sản phẩm' : 'Thêm sản phẩm mới', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (imageUrl.isNotEmpty)
                  Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: imageUrl.startsWith('http') 
                            ? Image.network(imageUrl, height: 150, width: 150, fit: BoxFit.cover)
                            : Image.asset(imageUrl, height: 150, width: 150, fit: BoxFit.cover),
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => setDialogState(() => imageUrl = ''),
                        ),
                      ),
                    ],
                  ),
                ElevatedButton.icon(
                  onPressed: () async {
                    final newUrl = await _pickAndUploadImage();
                    if (newUrl != null) {
                      setDialogState(() => imageUrl = newUrl);
                    }
                  },
                  icon: const Icon(Icons.image),
                  label: Text(imageUrl.isEmpty ? 'Tải ảnh lên' : 'Thay đổi ảnh'),
                ),
                const SizedBox(height: 16),
                TextField(controller: nameController, decoration: const InputDecoration(labelText: 'Tên sản phẩm')),
                TextField(controller: priceController, decoration: const InputDecoration(labelText: 'Giá bán'), keyboardType: TextInputType.number),
                TextField(controller: stockController, decoration: const InputDecoration(labelText: 'Tồn kho'), keyboardType: TextInputType.number),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: category,
                  items: availableCategories.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                  onChanged: (v) => category = v!,
                  decoration: const InputDecoration(labelText: 'Danh mục'),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  title: const Text('Trạng thái bán', style: TextStyle(fontSize: 14)),
                  value: isAvailable,
                  activeColor: katinatGold,
                  onChanged: (v) => setDialogState(() => isAvailable = v),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Huỷ')),
            ElevatedButton(
              onPressed: () async {
                final token = Provider.of<AuthProvider>(context, listen: false).token;
                final url = isEditing ? '$baseUrl/admin/products/${product['id']}' : '$baseUrl/admin/products';
                final method = isEditing ? http.put : http.post;

                // Ánh xạ ID danh mục theo seed data
                int categoryId = 1;
                if (category == 'Best Seller') categoryId = 2;
                else if (category == 'Trà Sữa') categoryId = 3;
                else if (category == 'Cà Phê') categoryId = 4;
                else if (category == 'Trà Trái Cây') categoryId = 5;
                else if (category == 'Combo') categoryId = 6;

                await method(
                  Uri.parse(url),
                  headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
                  body: json.encode({
                    'name': nameController.text,
                    'category_id': categoryId, 
                    'price': int.parse(priceController.text.replaceAll(RegExp(r'[^0-9]'), '')),
                    'stock': int.parse(stockController.text),
                    'image_url': imageUrl,
                    'is_best_seller': category == 'Best Seller',
                    'is_available': isAvailable,
                  }),
                );
                _fetchAllData();
                Navigator.pop(context);
              },
              child: Text(isEditing ? 'Cập nhật' : 'Thêm mới'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteUser(String id) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    await http.delete(Uri.parse('$baseUrl/admin/users/$id'), headers: {'Authorization': 'Bearer $token'});
    _fetchAllData();
  }

  Future<void> _deleteProduct(String id) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    await http.delete(Uri.parse('$baseUrl/admin/products/$id'), headers: {'Authorization': 'Bearer $token'});
    _fetchAllData();
  }

  Future<void> _updateOrderStatus(String id, String newStatus) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    await http.put(
      Uri.parse('$baseUrl/admin/orders/$id/status'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: json.encode({'status': newStatus}),
    );
    _fetchAllData();
  }

  // --- Sub-widgets For UI Generation ---

  Widget _buildAdminUserHeader() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(flex: 3, child: Text('Thông tin nhân viên', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 13))),
          Expanded(flex: 2, child: Text('Chức vụ', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 13))),
          Expanded(flex: 2, child: Text('Cấp bởi', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 13))),
          Expanded(flex: 2, child: Text('Trạng thái', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 13))),
          SizedBox(width: 100, child: Text('Thao tác', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 13), textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildAdminUserRow(String id, String name, String email, String role, String createdBy, bool isActive) {
    Color roleColor = role == 'SUPER_ADMIN' ? Colors.purple : (role == 'ADMIN' ? Colors.blue : Colors.orange);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 3, 
            child: Row(
              children: [ 
                CircleAvatar(radius: 16, backgroundColor: Colors.grey[200], child: Text(name.isNotEmpty ? name[0] : 'U', style: const TextStyle(color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 12))), 
                const SizedBox(width: 12), 
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, 
                    children: [
                      Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis), 
                      Text(email, style: TextStyle(fontSize: 11, color: Colors.grey[500]), overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Expanded(flex: 2, child: UnconstrainedBox(child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: roleColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(role, style: TextStyle(color: roleColor, fontWeight: FontWeight.bold, fontSize: 10), textAlign: TextAlign.center)))),
          Expanded(flex: 2, child: Text(createdBy, style: TextStyle(fontSize: 12, color: Colors.grey[700]), overflow: TextOverflow.ellipsis)),
          Expanded(flex: 2, child: Row(children: [Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? Colors.green : Colors.red)), const SizedBox(width: 8), Flexible(child: Text(isActive ? 'Đang chạy' : 'Khoá', style: TextStyle(color: isActive ? Colors.green : Colors.red, fontWeight: FontWeight.w600, fontSize: 12), overflow: TextOverflow.ellipsis))])),
          SizedBox(width: 100, child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            IconButton(icon: const Icon(Icons.edit, size: 18, color: Colors.blue), onPressed: () => _showUserFormDialog({'id': id, 'name': name, 'email': email, 'role': role, 'isActive': isActive}), padding: EdgeInsets.zero, constraints: const BoxConstraints()), 
            const SizedBox(width: 8),
            IconButton(icon: const Icon(Icons.delete, size: 18, color: Colors.red), onPressed: () => _deleteUser(id), padding: EdgeInsets.zero, constraints: const BoxConstraints())
          ])),
        ],
      ),
    );
  }

  Widget _buildOrderHeaderRow() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text('ID', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 13))),
          Expanded(flex: 2, child: Text('Thời Gian', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 13))),
          Expanded(flex: 3, child: Text('Khách Hàng', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 13))),
          Expanded(flex: 2, child: Text('Tổng Tiền', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 13))),
          Expanded(flex: 2, child: Text('Trạng Thái', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 13))),
          SizedBox(width: 100, child: Text('Thao tác', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 13), textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildOrderDataRow(String id, String time, String customer, String phone, String total, String status) {
    Color statusColor = status == 'Chờ xác nhận' || status == 'pending' ? Colors.orange : (status == 'Đang giao' ? Colors.blue : Colors.green);
    String displayStatus = status == 'pending' ? 'Chờ xác nhận' : status;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 1, child: Text('#$id', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12))),
          Expanded(flex: 2, child: Text(time.length > 10 ? time.substring(0, 10) : time, style: TextStyle(color: Colors.grey[700], fontSize: 12))),
          Expanded(flex: 3, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(customer, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis), Text(phone, style: TextStyle(fontSize: 11, color: Colors.grey[500]))])),
          Expanded(flex: 2, child: Text(total, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD3A374), fontSize: 13))),
          Expanded(flex: 2, child: UnconstrainedBox(child: Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(4)), child: Text(displayStatus, style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 10))))),
          SizedBox(width: 100, child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.check_circle, size: 18, color: Colors.green), tooltip: 'Hoàn tất', onPressed: () => _updateOrderStatus(id, 'Hoàn tất'), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
              const SizedBox(width: 8),
              IconButton(icon: const Icon(Icons.cancel, size: 18, color: Colors.red), tooltip: 'Huỷ đơn', onPressed: () => _updateOrderStatus(id, 'Đã huỷ'), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildProductHeaderRow() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          const SizedBox(width: 50), // Image space
          Expanded(flex: 4, child: Text('Sản phẩm', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 13))),
          Expanded(flex: 2, child: Text('Danh mục', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 13))),
          Expanded(flex: 2, child: Text('Giá', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 13))),
          Expanded(flex: 1, child: Text('Kho', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 13))),
          Expanded(flex: 2, child: Text('Trạng thái', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 13))),
          SizedBox(width: 100, child: Text('Thao tác', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600], fontSize: 13), textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildProductDataRow(String imageAsset, String sku, String name, String category, String price, int stock, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 50, 
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4), 
              child: imageAsset.startsWith('http')
                ? Image.network(imageAsset, width: 36, height: 36, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(width: 36, height: 36, color: Colors.grey[200], child: const Icon(Icons.image, size: 14, color: Colors.grey)))
                : Image.asset(imageAsset, width: 36, height: 36, fit: BoxFit.cover, errorBuilder: (c,e,s) => Container(width: 36, height: 36, color: Colors.grey[200], child: const Icon(Icons.image, size: 14, color: Colors.grey)))
            )
          ),
          Expanded(flex: 4, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis), Text(sku, style: TextStyle(fontSize: 11, color: Colors.grey[500]))])),
          Expanded(flex: 2, child: Text(category, style: const TextStyle(fontSize: 12))),
          Expanded(flex: 2, child: Text(price, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13))),
          Expanded(flex: 1, child: Text('$stock', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: stock > 0 ? Colors.black87 : Colors.red))),
          Expanded(flex: 2, child: Row(children: [Container(width: 6, height: 6, decoration: BoxDecoration(shape: BoxShape.circle, color: isActive ? Colors.green : Colors.red)), const SizedBox(width: 8), Flexible(child: Text(isActive ? 'Đang bán' : 'Ngưng', style: TextStyle(color: isActive ? Colors.green : Colors.red, fontWeight: FontWeight.w600, fontSize: 12), overflow: TextOverflow.ellipsis))])),
          SizedBox(width: 100, child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(icon: const Icon(Icons.edit, size: 18, color: Colors.blue), onPressed: () => _showProductFormDialog({'image': imageAsset, 'id': sku, 'name': name, 'category': category, 'price': price, 'stock': stock, 'isActive': isActive}), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
              const SizedBox(width: 8),
              IconButton(icon: const Icon(Icons.delete, size: 18, color: Colors.red), onPressed: () => _deleteProduct(sku), padding: EdgeInsets.zero, constraints: const BoxConstraints()),
            ],
          )),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    const Color katinatGold = Color(0xFFD3A374);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? katinatGold : Colors.white,
        border: Border.all(color: isSelected ? katinatGold : Colors.grey[300]!),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: isSelected ? Colors.white : Colors.grey[700],
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildSidebarItem({required IconData icon, required String title, bool isActive = false, VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.white : Colors.white54),
      title: Text(title, style: TextStyle(color: isActive ? Colors.white : Colors.white54, fontWeight: isActive ? FontWeight.bold : FontWeight.normal)),
      onTap: onTap ?? () {},
      tileColor: isActive ? Colors.white.withOpacity(0.1) : Colors.transparent,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
    );
  }

  Widget _buildKpiCard({required String title, required String value, required IconData icon, required Color color}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.grey[200]!), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4))]),
      child: Row(
        children: [
          Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(icon, color: color, size: 28)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: Colors.grey[500], fontSize: 13), overflow: TextOverflow.ellipsis),
                const SizedBox(height: 4),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(value, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrderRow(String id, String name, String amount, String status) {
    Color statusColor = status == 'Đã giao' ? Colors.green : (status == 'Chờ xác nhận' ? Colors.orange : Colors.blue);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(id, style: const TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(width: 120, child: Text(name, overflow: TextOverflow.ellipsis)),
          Text(amount, style: const TextStyle(fontWeight: FontWeight.bold)),
          Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4), decoration: BoxDecoration(color: statusColor.withOpacity(0.1), borderRadius: BorderRadius.circular(20)), child: Text(status, style: TextStyle(color: statusColor, fontSize: 12, fontWeight: FontWeight.bold)))
        ],
      ),
    );
  }

  // ==========================================
  // VIEW 4: BÁO CÁO TÀI CHÍNH
  // ==========================================
  Widget _buildFinancialReportContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKpiCard(
            title: 'Tổng doanh thu (Hoàn tất)', 
            value: '${_stats['revenue']}đ', 
            icon: Icons.account_balance_wallet, 
            color: katinatGold
          ),
          const SizedBox(height: 30),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _buildReportBox(
                  title: 'Doanh thu 7 ngày gần nhất',
                  child: _buildSimpleTable(
                    headers: ['Ngày', 'Doanh thu'],
                    rows: (_detailedStats['daily'] as List).map((item) => [
                      item['date'].toString(),
                      '${item['amount']}đ'
                    ]).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildReportBox(
                  title: 'Doanh thu 6 tháng gần nhất',
                  child: _buildSimpleTable(
                    headers: ['Tháng', 'Doanh thu'],
                    rows: (_detailedStats['monthly'] as List).map((item) => [
                      item['month'].toString().trim(),
                      '${item['amount']}đ'
                    ]).toList(),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          _buildReportBox(
            title: 'Top 5 sản phẩm bán chạy nhất',
            child: _buildSimpleTable(
              headers: ['Tên sản phẩm', 'Số lượng đã bán', 'Tổng doanh thu'],
              rows: (_detailedStats['topProducts'] as List).map((item) => [
                item['name'].toString(),
                item['sales'].toString(),
                '${item['revenue']}đ'
              ]).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportBox({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 16, color: katinatBlue)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildSimpleTable({required List<String> headers, required List<List<String>> rows}) {
    if (rows.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Chưa có dữ liệu')));
    return Table(
      border: TableBorder(horizontalInside: BorderSide(color: Colors.grey[100]!, width: 1)),
      children: [
        TableRow(
          children: headers.map((h) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(h, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          )).toList(),
        ),
        ...rows.map((row) => TableRow(
          children: row.map((cell) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Text(cell, style: TextStyle(color: katinatBlue.withOpacity(0.8))),
          )).toList(),
        )),
      ],
    );
  }

  // ==========================================
  // VIEW 5: QUẢN LÝ VOUCHER
  // ==========================================
  Widget _buildVoucherManagementContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Danh sách Mã Khuyến Mãi', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 18)),
              ElevatedButton.icon(
                onPressed: () => _showVoucherFormDialog(null),
                icon: const Icon(Icons.add),
                label: const Text('Thêm Voucher mới'),
                style: ElevatedButton.styleFrom(backgroundColor: katinatGold, foregroundColor: Colors.black),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8)),
            child: Column(
              children: [
                _buildVoucherHeader(),
                const Divider(height: 1),
                if (_promotions.isEmpty)
                  const Padding(padding: EdgeInsets.all(40), child: Text('Chưa có voucher nào'))
                else
                  ..._promotions.map((p) => _buildVoucherRow(p)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      color: Colors.grey[50],
      child: const Row(
        children: [
          Expanded(flex: 2, child: Text('Tiêu đề', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text('Mã Code', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text('Giảm giá', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text('Đơn tối thiểu', style: TextStyle(fontWeight: FontWeight.bold))),
          Expanded(flex: 1, child: Text('Trạng thái', style: TextStyle(fontWeight: FontWeight.bold))),
          SizedBox(width: 80, child: Text('Thao tác', style: TextStyle(fontWeight: FontWeight.bold), textAlign: TextAlign.center)),
        ],
      ),
    );
  }

  Widget _buildVoucherRow(Map<String, dynamic> p) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: Colors.grey[100]!))),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(p['title'] ?? '')),
          Expanded(flex: 1, child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: katinatGold.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
            child: Text(p['code'] ?? '', style: const TextStyle(fontWeight: FontWeight.bold, color: katinatGold)),
          )),
          Expanded(flex: 1, child: Text(
            p['promo_type'] == 'bogo' 
              ? 'Mua ${p['buy_qty']} tặng ${p['get_qty']}'
              : (double.tryParse(p['discount_amount']?.toString() ?? '0')! > 0 
                  ? '${p['discount_amount']}đ' 
                  : '${p['discount']}%')
          )),
          Expanded(flex: 1, child: Text('${p['min_order']}đ')),
          Expanded(flex: 1, child: Switch(
            value: p['is_active'] ?? true, 
            activeColor: katinatGold,
            onChanged: (v) => _updateVoucherStatus(p['id'].toString(), v),
          )),
          SizedBox(
            width: 80,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(icon: const Icon(Icons.edit, size: 18, color: Colors.blue), onPressed: () => _showVoucherFormDialog(p)),
                IconButton(icon: const Icon(Icons.delete, size: 18, color: Colors.red), onPressed: () => _deleteVoucher(p['id'].toString())),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==========================================
  // VIEW 6: GỬI THÔNG BÁO (BROADCAST)
  // ==========================================
  Widget _buildNotificationBroadcastContent() {
    final titleController = TextEditingController();
    final bodyController = TextEditingController();
    final scheduleController = TextEditingController(text: DateTime.now().add(const Duration(minutes: 5)).toString().substring(0, 16));

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)]),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Gửi thông báo mới cho tất cả User', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 18)),
              const SizedBox(height: 8),
              const Text('Thông báo này sẽ xuất hiện trong mục Thông báo của tất cả người dùng trên ứng dụng.', style: TextStyle(color: Colors.grey, fontSize: 13)),
              const SizedBox(height: 30),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Tiêu đề thông báo', border: OutlineInputBorder(), prefixIcon: Icon(Icons.title)),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: bodyController,
                maxLines: 3,
                decoration: const InputDecoration(labelText: 'Nội dung thông báo', border: OutlineInputBorder(), alignLabelWithHint: true, prefixIcon: Icon(Icons.message)),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: scheduleController,
                decoration: const InputDecoration(labelText: 'Thời gian gửi (YYYY-MM-DD HH:mm)', border: OutlineInputBorder(), prefixIcon: Icon(Icons.timer)),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _sendBroadcast(titleController.text, bodyController.text, scheduleController.text),
                  icon: const Icon(Icons.send),
                  label: const Text('GỬI THÔNG BÁO'),
                  style: ElevatedButton.styleFrom(backgroundColor: katinatBlue, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Methods for Voucher
  Future<void> _updateVoucherStatus(String id, bool status) async {
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    await http.put(
      Uri.parse('$baseUrl/admin/promotions/$id'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: json.encode({'is_active': status}),
    );
    _fetchAllData();
  }

  Future<void> _deleteVoucher(String id) async {
    final confirm = await showDialog(context: context, builder: (ctx) => AlertDialog(
      title: const Text('Xác nhận xoá'),
      content: const Text('Bạn có chắc muốn xoá voucher này không?'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Huỷ')),
        TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Xoá', style: TextStyle(color: Colors.red))),
      ],
    ));
    if (confirm == true) {
      final token = Provider.of<AuthProvider>(context, listen: false).token;
      await http.delete(Uri.parse('$baseUrl/admin/promotions/$id'), headers: {'Authorization': 'Bearer $token'});
      _fetchAllData();
    }
  }

  void _showVoucherFormDialog(Map<String, dynamic>? promo) {
    final isEditing = promo != null;
    final titleController = TextEditingController(text: isEditing ? promo['title'] : '');
    final codeController = TextEditingController(text: isEditing ? promo['code'] : '');
    final discountController = TextEditingController(text: isEditing ? promo['discount'].toString() : '0');
    final discountAmountController = TextEditingController(text: isEditing ? (promo['discount_amount'] ?? 0).toString() : '0');
    final buyQtyController = TextEditingController(text: isEditing ? (promo['buy_qty'] ?? 0).toString() : '0');
    final getQtyController = TextEditingController(text: isEditing ? (promo['get_qty'] ?? 0).toString() : '0');
    String promoType = isEditing ? (promo['promo_type'] ?? 'discount') : 'discount';
    final minOrderController = TextEditingController(text: isEditing ? promo['min_order'].toString() : '0');
    final descController = TextEditingController(text: isEditing ? promo['description'] : '');

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Text(isEditing ? 'Sửa Voucher' : 'Thêm Voucher mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(controller: titleController, decoration: const InputDecoration(labelText: 'Tên chương trình')),
                TextField(controller: codeController, decoration: const InputDecoration(labelText: 'Mã Voucher')),
                const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: promoType,
                  decoration: const InputDecoration(labelText: 'Loại ưu đãi'),
                  items: const [
                    DropdownMenuItem(value: 'discount', child: Text('Giảm giá (%) hoặc Số tiền')),
                    DropdownMenuItem(value: 'bogo', child: Text('Mua X Tặng Y')),
                  ],
                  onChanged: (v) => setDialogState(() => promoType = v!),
                ),
                if (promoType == 'discount') ...[
                  TextField(controller: discountController, decoration: const InputDecoration(labelText: 'Phần trăm giảm (%)'), keyboardType: TextInputType.number),
                  TextField(controller: discountAmountController, decoration: const InputDecoration(labelText: 'Số tiền giảm cố định (đ)'), keyboardType: TextInputType.number),
                ] else ...[
                  TextField(controller: buyQtyController, decoration: const InputDecoration(labelText: 'Số lượng mua (X)'), keyboardType: TextInputType.number),
                  TextField(controller: getQtyController, decoration: const InputDecoration(labelText: 'Số lượng tặng (Y)'), keyboardType: TextInputType.number),
                ],
                TextField(controller: minOrderController, decoration: const InputDecoration(labelText: 'Đơn hàng tối thiểu (đ)'), keyboardType: TextInputType.number),
                TextField(controller: descController, decoration: const InputDecoration(labelText: 'Mô tả chi tiết'), maxLines: 2),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Huỷ')),
            ElevatedButton(
              onPressed: () async {
                try {
                  final token = Provider.of<AuthProvider>(context, listen: false).token;
                  final data = {
                    'title': titleController.text,
                    'code': codeController.text,
                    'promo_type': promoType,
                    'discount': int.tryParse(discountController.text) ?? 0,
                    'discount_amount': int.tryParse(discountAmountController.text) ?? 0,
                    'buy_qty': int.tryParse(buyQtyController.text) ?? 0,
                    'get_qty': int.tryParse(getQtyController.text) ?? 0,
                    'min_order': int.tryParse(minOrderController.text) ?? 0,
                    'description': descController.text,
                    'is_active': isEditing ? promo['is_active'] : true,
                  };
                  
                  final url = isEditing 
                    ? Uri.parse('$baseUrl/admin/promotions/${promo['id']}')
                    : Uri.parse('$baseUrl/admin/promotions');
                  
                  final response = await (isEditing 
                    ? http.put(url, headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'}, body: json.encode(data))
                    : http.post(url, headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'}, body: json.encode(data)));

                  if (response.statusCode == 200 || response.statusCode == 201) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Lưu Voucher thành công!'), backgroundColor: Colors.green));
                      Navigator.pop(ctx);
                      _fetchAllData();
                    }
                  } else {
                    throw Exception('Lỗi server: ${response.statusCode}');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red));
                  }
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: katinatBlue, foregroundColor: Colors.white),
              child: const Text('Lưu Voucher'),
            ),
        ],
      ),
    ));
  }

  Future<void> _sendBroadcast(String title, String body, String scheduledAt) async {
    if (title.isEmpty || body.isEmpty) return;
    final token = Provider.of<AuthProvider>(context, listen: false).token;
    final response = await http.post(
      Uri.parse('$baseUrl/admin/notifications/broadcast'),
      headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json'},
      body: json.encode({'title': title, 'body': body, 'scheduled_at': scheduledAt}),
    );
    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Đã gửi thông báo thành công cho toàn bộ User!'), backgroundColor: Colors.green));
    }
  }
}
