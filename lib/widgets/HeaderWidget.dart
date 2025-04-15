import 'package:flutter/material.dart';

class HeaderWidget extends StatelessWidget {
  final int notificationCount;

  const HeaderWidget({super.key, required this.notificationCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFF1F4352),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "CHÀO BUỔI SÁNG!",
                style: TextStyle(
                  color: Color(0xFFF0C96F), // Màu vàng kem
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "Vui lòng đăng nhập để tiếp tục",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const Spacer(),
          const Icon(Icons.local_offer_outlined, color: Colors.white),
          const SizedBox(width: 16),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.notifications_none, color: Colors.white),
              if (notificationCount > 0)
                Positioned(
                  right: -6,
                  top: -6,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Color(0xFFF0C96F),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      notificationCount.toString(),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
