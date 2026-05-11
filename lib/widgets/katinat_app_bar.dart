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

    final bool isMobile = MediaQuery.of(context).size.width < 800;

    return AppBar(
      backgroundColor: katinatBlue,
      elevation: 0,
      titleSpacing: isMobile ? 0 : 16,
      automaticallyImplyLeading: false, 
      leading: isMobile 
        ? IconButton(
            icon: const Icon(Icons.menu, color: katinatGold),
            onPressed: () => Scaffold.of(context).openDrawer(),
          )
        : null,
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
          if (!isMobile) ...[
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
        ],
      ),
      actions: [
        if (auth.isLoggedIn)
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white, size: 20),
            tooltip: 'Cài đặt tài khoản',
            onPressed: () => Navigator.pushNamed(context, '/profile'),
          )
        else
          IconButton(
            icon: const Icon(Icons.person_outline, color: Colors.white, size: 20),
            tooltip: 'Đăng nhập',
            onPressed: () => Navigator.pushNamed(context, '/login'),
          ),
        IconButton(
          icon: const Icon(Icons.shopping_cart_outlined, color: Colors.white, size: 20),
          tooltip: 'Giỏ hàng',
          onPressed: () => Navigator.pushNamed(context, '/cart'),
        ),
        if (isAdmin && !isMobile) // Ẩn icon admin trên mobile appBar vì đã có trong drawer
          IconButton(
            icon: const Icon(Icons.admin_panel_settings_outlined, color: Colors.white, size: 20),
            tooltip: 'Quản trị',
            onPressed: () => Navigator.pushNamed(context, '/admin'),
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
