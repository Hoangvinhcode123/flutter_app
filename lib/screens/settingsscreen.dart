import 'package:app_tuan89/screens/drawermenu.dart';
import 'package:flutter/material.dart';
import 'package:app_tuan89/screens/SettingsScreen.dart';

const Color primaryColor = Color(0xFF1F4352);

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isBiometricEnabled = false;
  bool isVietnamese = true;

  void toggleLanguage() {
    setState(() {
      isVietnamese = !isVietnamese;
    });
    // TODO: Áp dụng logic thay đổi ngôn ngữ toàn ứng dụng
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text('Cài Đặt'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      drawer: DrawerMenu(),
      body: ListView(
        children: [
          SwitchListTile(
            activeColor: primaryColor,
            title: Text(
              "Đăng nhập bằng vân tay/khuôn mặt",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            secondary: Icon(Icons.fingerprint, color: primaryColor),
            value: isBiometricEnabled,
            onChanged: (bool value) {
              setState(() {
                isBiometricEnabled = value;
              });
              // TODO: Thêm logic kích hoạt vân tay/khuôn mặt
            },
          ),
          Divider(color: Colors.grey[300]),
          ListTile(
            leading: Icon(Icons.lock, color: primaryColor),
            title: Text(
              "Đổi mật khẩu",
              style: TextStyle(
                color: primaryColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            onTap: () {
              Navigator.pushNamed(context, '/forgotPassword');
            },
          ),
          Divider(color: Colors.grey[300]),
          ListTile(
            leading: Icon(Icons.language, color: primaryColor),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Ngôn ngữ",
                  style: TextStyle(
                    color: primaryColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: primaryColor),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: GestureDetector(
                    onTap: toggleLanguage,
                    child: Text(
                      isVietnamese ? "🇻🇳 Tiếng Việt" : "🇺🇸 English",
                      style: TextStyle(
                        color: primaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: 4, // Settings tab
        selectedItemColor: primaryColor,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/order');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/QR');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/cart');
              break;
            case 4:
              break; // đang ở settings
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Trang chủ"),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink),
            label: "Đặt nước",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: "QR",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: "Giỏ hàng",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Tài khoản"),
        ],
      ),
    );
  }
}
