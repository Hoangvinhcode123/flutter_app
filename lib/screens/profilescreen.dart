import 'package:app_tuan89/screens/mainscreen.dart';
import 'package:app_tuan89/screens/promotionscreen.dart';
import 'package:flutter/material.dart';
import 'editprofilescreen.dart';
import 'package:app_tuan89/screens/orderhistoryscreen.dart';

const Color primaryColor = Color(0xFF1F4352);

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Column(
          children: [
            // AppBar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              color: primaryColor,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => MainScreen()),
                      );
                    },
                  ),
                  const CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white,
                    backgroundImage: AssetImage("assets/images/duong.jpg"),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      "Vinh Thái Tín",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        '/login',
                        (route) => false,
                      );
                    },
                    child: const Text(
                      "Đăng xuất",
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            // Nội dung
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  color: Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                ),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // NEW MEMBER CARD
                    Container(
                      margin: const EdgeInsets.only(bottom: 20, top: 20),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE9ECF9),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "NEW MEMBER",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF4A4A4A),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text("0 KAT", style: TextStyle(fontSize: 14)),
                          const Text(
                            "(KAT khả dụng)",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          const SizedBox(height: 12),
                          const Align(
                            alignment: Alignment.centerRight,
                            child: Icon(
                              Icons.local_drink_outlined,
                              size: 48,
                              color: Colors.blueGrey,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // DANH MỤC TÀI KHOẢN
                    _buildSectionContainer([
                      _buildAccountItem(
                        Icons.edit,
                        "Chỉnh sửa trang cá nhân",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const EditProfileScreen(),
                            ),
                          );
                        },
                      ),
                      _buildAccountItem(Icons.local_cafe, "Sở thích"),
                      _buildAccountItem(
                        Icons.bookmark_border,
                        "Danh sách yêu thích",
                      ),
                      _buildAccountItem(
                        Icons.emoji_events,
                        "Đặc quyền hạng thành viên",
                      ),
                      _buildAccountItem(
                        Icons.discount,
                        "Ưu đãi",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PromotionsScreen(),
                            ),
                          );
                        },
                      ),
                      _buildAccountItem(
                        Icons.history,
                        "Lịch sử đặt hàng",
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const OrderHistoryScreen(),
                            ),
                          );
                        },
                      ),

                      _buildAccountItem(Icons.reviews, "Đánh giá đơn hàng"),
                      _buildAccountItem(Icons.group_add, "Giới thiệu bạn bè"),
                    ]),

                    const SizedBox(height: 20),

                    // DANH MỤC KHÁC
                    _buildSectionContainer([
                      _buildAccountItem(Icons.swap_horiz, "Đổi KAT"),
                      _buildAccountItem(
                        Icons.credit_card,
                        "Quản lý thẻ ATM/Credit Card",
                      ),
                      _buildAccountItem(Icons.timeline, "Lịch sử điểm"),
                      _buildAccountItem(Icons.location_on, "Địa chỉ đã lưu"),
                      _buildAccountItem(
                        Icons.store_mall_directory,
                        "Về chúng tôi",
                      ),
                      _buildAccountItem(
                        Icons.settings,
                        "Cài đặt",
                        onTap: () {
                          Navigator.pushNamed(context, '/settings');
                        },
                      ),
                      _buildAccountItem(
                        Icons.help_outline,
                        "Trợ giúp & Liên hệ",
                      ),
                      _buildAccountItem(
                        Icons.description,
                        "Điều khoản & Chính sách",
                      ),
                    ]),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountItem(IconData icon, String title, {VoidCallback? onTap}) {
    return ListTile(
      leading: Icon(icon, color: primaryColor),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          color: primaryColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: primaryColor),
      onTap: onTap,
    );
  }

  Widget _buildSectionContainer(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(children: children),
    );
  }
}
