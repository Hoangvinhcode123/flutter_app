import 'package:flutter/material.dart';

class GeneralNotificationsScreen extends StatelessWidget {
  const GeneralNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EC), // Màu nền giống MainScreen
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F4352), // Màu chủ đạo
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          "Thông báo chung",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F4352),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Colors.white),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Đã đánh dấu tất cả là đã đọc")),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildNotificationCard(
            title: "PHẦN THƯỞNG CỦA BẠN",
            content:
                "Chúc mừng bạn nhận được phần thưởng là LƯU ĐẠI 30K CHO ĐƠN TỪ THIẾU 60K (NM)",
            date: "05/04/2025",
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            title: "PHẦN THƯỞNG CỦA BẠN",
            content:
                "Chúc mừng bạn nhận được phần thưởng là MIỄN PHÍ 01 TOPPING TRÂN CHÂU PHÔ MAI DẺO (NM)",
            date: "05/04/2025",
          ),
          const SizedBox(height: 12),
          _buildNotificationCard(
            title: "CHÀO MỪNG ĐẾN ĐƯƠNG COFFEE & TEA HOUSE",
            content:
                "ĐƯƠNG đã tạo thành công tài khoản thành viên. Khi đăng nhập, vui lòng sử dụng số 0388290904 và mật khẩu mà bạn đã đăng ký.",
            date: "05/04/2025",
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationCard({
    required String title,
    required String content,
    required String date,
  }) {
    return Card(
      color: const Color(0xFFFFFFFF), // Màu trắng cho card
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(
              Icons.notifications,
              color: Color(0xFF5A6A72),
              size: 24,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    content,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF4F4F4F),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 16,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFDCE7EC), // Màu be nhạt
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Text(
                "Xem thêm",
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
