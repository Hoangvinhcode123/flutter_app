import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class KatinatAppBar extends StatelessWidget implements PreferredSizeWidget {
  const KatinatAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    const Color katinatBlue = Color(0xFF132A38);
    const Color katinatGold = Color(0xFFD3A374);

    final auth = Provider.of<AuthProvider>(context);
    final isAdmin = auth.isAdmin;

    return AppBar(
      backgroundColor: katinatBlue,
      elevation: 0,
      titleSpacing: 16,
      automaticallyImplyLeading: false, // Bỏ nút mũi tên quay lại
      title: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pushReplacementNamed(context, '/'),
            child: Text(
              'ĐƯƠNG',
              style: GoogleFonts.barlowCondensed(
                color: katinatGold,
                fontSize: 28,
                fontWeight: FontWeight.w600,
                letterSpacing: 2.0,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _buildNavTextButton(context, title: 'TRANG CHỦ', route: '/'),
                  _buildNavTextButton(context, title: 'VỀ CHÚNG TÔI', route: '/about'),
                  _buildNavTextButton(context, title: 'TIN TỨC & SỰ KIỆN', route: '/news'),
                  _buildNavTextButton(context, title: 'CỬA HÀNG', route: '/shop'),
                ],
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.person_outline, color: Colors.white),
          tooltip: auth.isLoggedIn ? 'Cài đặt tài khoản' : 'Đăng nhập',
          onPressed: () => Navigator.pushNamed(context, auth.isLoggedIn ? '/profile' : '/login'),
        ),
        if (auth.isLoggedIn)
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, color: Colors.white),
            tooltip: 'Thông báo',
            onPressed: () => Navigator.pushNamed(context, '/notifications'),
          ),
        if (auth.isLoggedIn)
          IconButton(
            icon: const Icon(Icons.favorite_outline, color: Colors.white),
            tooltip: 'Danh sách yêu thích',
            onPressed: () => Navigator.pushNamed(context, '/wishlist'),
          ),
        if (auth.isLoggedIn)
          IconButton(
            icon: const Icon(Icons.list_alt, color: Colors.white),
            tooltip: 'Lịch sử đơn hàng',
            onPressed: () => Navigator.pushNamed(context, '/orders'),
          ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
          tooltip: 'Giỏ hàng',
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
        if (isAdmin)
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined, color: Colors.white),
            tooltip: 'Quản trị',
            onPressed: () => Navigator.pushNamed(context, '/admin'),
          ),
        if (auth.isLoggedIn)
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            tooltip: 'Đăng xuất',
            onPressed: () {
              auth.logout();
              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
          ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildNavTextButton(BuildContext context, {required String title, required String route}) {
    final isActive = ModalRoute.of(context)?.settings.name == route;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: TextButton(
        onPressed: () {
          if (!isActive) {
            Navigator.pushNamed(context, route);
          }
        },
        child: Text(
          title,
          style: GoogleFonts.montserrat(
            color: isActive ? Colors.white : const Color(0xFFD3A374).withOpacity(0.8),
            fontSize: 14,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
