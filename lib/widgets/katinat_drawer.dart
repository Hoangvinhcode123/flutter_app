import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class KatinatDrawer extends StatelessWidget {
  const KatinatDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    const Color katinatBlue = Color(0xFF132A38);
    const Color katinatGold = Color(0xFFD3A374);
    final auth = Provider.of<AuthProvider>(context);
    final isAdmin = auth.isAdmin;

    return Drawer(
      backgroundColor: katinatBlue,
      child: Column(
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.white12)),
            ),
            child: Center(
              child: Text(
                'ĐƯƠNG',
                style: GoogleFonts.barlowCondensed(
                  color: katinatGold,
                  fontSize: 40,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 3.0,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildDrawerItem(
                  context,
                  title: 'TRANG CHỦ',
                  icon: Icons.home_outlined,
                  route: '/',
                ),
                _buildDrawerItem(
                  context,
                  title: 'CỬA HÀNG',
                  icon: Icons.storefront_outlined,
                  route: '/shop',
                ),
                _buildDrawerItem(
                  context,
                  title: 'VỀ CHÚNG TÔI',
                  icon: Icons.info_outline,
                  route: '/about',
                ),
                _buildDrawerItem(
                  context,
                  title: 'TIN TỨC & SỰ KIỆN',
                  icon: Icons.newspaper_outlined,
                  route: '/news',
                ),
                const Divider(color: Colors.white12),
                _buildDrawerItem(
                  context,
                  title: 'GIỎ HÀNG',
                  icon: Icons.shopping_cart_outlined,
                  route: '/cart',
                ),
                _buildDrawerItem(
                  context,
                  title: auth.isLoggedIn ? 'TÀI KHOẢN' : 'ĐĂNG NHẬP',
                  icon: Icons.person_outline,
                  route: auth.isLoggedIn ? '/profile' : '/login',
                ),
                if (isAdmin) ...[
                  const Divider(color: Colors.white12),
                  _buildDrawerItem(
                    context,
                    title: 'QUẢN TRỊ (ADMIN)',
                    icon: Icons.admin_panel_settings_outlined,
                    route: '/admin',
                    color: katinatGold,
                  ),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              '© 2024 ĐƯƠNG COFFEE',
              style: GoogleFonts.montserrat(
                color: Colors.white24,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
    Color color = Colors.white,
  }) {
    final currentRoute = ModalRoute.of(context)?.settings.name;
    final bool isActive = currentRoute == route;

    return ListTile(
      leading: Icon(icon, color: isActive ? const Color(0xFFD3A374) : color.withOpacity(0.7)),
      title: Text(
        title,
        style: GoogleFonts.montserrat(
          color: isActive ? const Color(0xFFD3A374) : color,
          fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          fontSize: 14,
        ),
      ),
      onTap: () {
        Navigator.pop(context); // Close drawer
        if (!isActive) {
          Navigator.pushReplacementNamed(context, route);
        }
      },
    );
  }
}
