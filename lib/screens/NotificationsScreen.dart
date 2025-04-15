import 'package:app_tuan89/screens/GeneralNotificationsScreen.dart';
import 'package:flutter/material.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F4352)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Thông báo",
          style: TextStyle(
            color: Color(0xFF1F4352),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.check_circle, color: Color(0xFF1F4352)),
            onPressed: () {},
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          GestureDetector(
            onTap: () {
              // Điều hướng đến GeneralNotificationsScreen khi nhấn vào "Thông báo chung"
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const GeneralNotificationsScreen(),
                ),
              );
            },
            child: const NotificationCard(
              title: "Thông báo chung",
              description:
                  "Thông báo chung về sản phẩm, thông tin, khuyến mãi, chính sách và quyền lợi của thành viên",
              icon: Icons.notifications_active_outlined,
              badgeCount: 3,
            ),
          ),
          const SizedBox(height: 16),
          const NotificationCard(
            title: "Tích điểm",
            description:
                "Thông báo nhận điểm thưởng khi mua hàng hoặc tham gia các chương trình nhận thưởng,...",
            icon: Icons.monetization_on_outlined,
            badgeCount: 0,
          ),
        ],
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final int badgeCount;

  const NotificationCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    this.badgeCount = 0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF2EEEA),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFF1F4352),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, size: 36, color: Color(0xFFCC9C60)),
              ),
              if (badgeCount > 0)
                Positioned(
                  top: -6,
                  right: -6,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Color(0xFFCC9C60),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      badgeCount.toString(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF1F4352),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF1F4352)),
        ],
      ),
    );
  }
}