import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KatinatAboutSection extends StatelessWidget {
  const KatinatAboutSection({super.key});

  @override
  Widget build(BuildContext context) {
    const Color katinatGold = Color(0xFFD3A374);

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 60.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Về ĐƯƠNG',
                  style: GoogleFonts.playfairDisplay(
                    color: katinatGold,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'ĐƯƠNG Coffee & Tea House – HÀNH TRÌNH CHINH PHỤC PHONG VỊ MỚI',
                  style: GoogleFonts.montserrat(
                    color: katinatGold.withOpacity(0.8),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Hành trình luôn bắt đầu từ việc chọn lựa nguyên liệu kỹ càng từ các vùng đất trù phú, cho đến việc bảo quản, pha chế từ bàn tay nghệ nhân. Qua những nỗ lực không ngừng, ĐƯƠNG luôn hướng đến...',
                  style: GoogleFonts.montserrat(
                    color: katinatGold.withOpacity(0.8),
                    fontSize: 15,
                    height: 1.8,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Zalo Icon placeholder mapped to image
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blueAccent, width: 2),
            ),
            child: const Center(
              child: Text(
                'Zalo',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
