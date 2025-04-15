import 'package:flutter/material.dart';
import 'package:app_tuan89/screens/cartscreen.dart';
import 'homescreen.dart';
import 'OrderScreen.dart';
import 'QRScreen.dart';
import 'profilescreen.dart';
import 'drawermenu.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _screens = [
    HomeScreen(),
    OrderScreen(),
    QRScreen(),
    CartScreen(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
        _pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color(0xFF1F4352),
          elevation: 0,
          flexibleSpace: Stack(
            children: [
              ClipPath(
                clipper: BottomCurveClipper(),
                child: Container(color: const Color(0xFF1F4352), height: 100),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    SizedBox(height: 30),
                    Text(
                      "ĐƯƠNG",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      "COFFEE & TEA HOUSE",
                      style: TextStyle(
                        fontSize: 12,
                        letterSpacing: 1,
                        color: Colors.white70,
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Positioned(
                right: 16,
                top: 40,
                child: IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    if (Navigator.canPop(context)) {
                      Navigator.pop(context);
                    }
                    Navigator.pushNamed(context, '/notifications');
                  },
                ),
              ),
              Positioned(
                left: 16,
                top: 40,
                child: Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.white),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: DrawerMenu(),
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _screens,
        onPageChanged: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.brown,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Trang chủ",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_cafe), // icon ly nước
            label: "Đặt nước",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner), // icon QR
            label: "QR code",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Giỏ hàng",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Tài khoản",
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 20,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
