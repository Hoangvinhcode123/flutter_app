import 'package:flutter/material.dart';

const Color primaryColor = Color(0xFF1F4352); // Màu chủ đạo (đồng bộ HomeScreen)

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero, // Loại bỏ padding mặc định của ListView
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: primaryColor),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.local_cafe, size: 40, color: Colors.white),
                SizedBox(height: 10),
                Text(
                  "ĐƯƠNG", // Tên thương hiệu
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.coffee, color: primaryColor),
            title: Text("Menu"),
            onTap: () {
              Navigator.pushNamed(context, '/menu');
            },
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart, color: primaryColor),
            title: Text("Giỏ Hàng"),
            onTap: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
          ListTile(
            leading: Icon(Icons.person, color: primaryColor),
            title: Text("Tài Khoản"),
            onTap: () {
              Navigator.pushNamed(context, '/profile');
            },
          ),
          ListTile(
            leading: Icon(Icons.settings, color: primaryColor),
            title: Text("Cài Đặt"),
            onTap: () {
              Navigator.pushNamed(context, '/settings');
            },
          ),
          const Divider(),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text(
              "Đăng Xuất",
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/login');
            },
          ),
        ],
      ),
    );
  }
}
