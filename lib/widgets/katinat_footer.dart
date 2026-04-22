import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KatinatFooter extends StatelessWidget {
  const KatinatFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFB08C69), // Màu nâu background footer
      padding: const EdgeInsets.only(top: 60, bottom: 20, left: 24, right: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                'ĐƯƠNG',
                style: GoogleFonts.barlowCondensed(
                  color: Colors.white.withOpacity(0.1),
                  fontSize: 80,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 8.0,
                ),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            'VỀ CHÚNG TÔI',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'ĐƯƠNG – HÀNH TRÌNH CHINH PHỤC PHONG VỊ MỚI\nĐƯƠNG không ngừng theo đuổi sứ mệnh mang phong vị mới từ những vùng đất trứ danh tại Việt Nam và trên thế giới đến khách hàng.',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 14,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.facebook, color: Color(0xFFB08C69), size: 20),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                child: const Icon(Icons.camera_alt, color: Color(0xFFB08C69), size: 20),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            'LIÊN HỆ',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildContactRow(Icons.email, 'Email: cs@duong.vn'),
          _buildContactRow(Icons.location_on, 'Representative Store : 91 Đồng Khởi, Bến Nghé, Quận 1, Thành Phố Hồ Chí Minh'),
          _buildContactRow(Icons.business, 'Working Office: 96-98-100 Trần Nguyên Đán, Phường 3, Quận Bình Thạnh, Thành Phố Hồ Chí Minh'),
          _buildContactRow(Icons.phone, 'Customer Service: (028) 7300 1009'),
          
          const SizedBox(height: 40),
          Text(
            'HỖ TRỢ VÀ CHÍNH SÁCH',
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            '– Quy chế hoạt động và Chính sách bảo mật.\n– Chính sách vận chuyển.\n– Chính sách thanh toán.',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 14,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Giấy chứng nhận Đăng kí kinh doanh số 0316612746 do Sở Kế hoạch và Đầu tư Thành phố Hồ Chí Minh cấp ngày 27/11/2020.',
            style: GoogleFonts.montserrat(
              color: Colors.white,
              fontSize: 12,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 60),
          const Divider(color: Colors.white30),
          const SizedBox(height: 20),
          Center(
            child: Text(
              '©Đương Saigon Kafe 2022 | All rights reserved. Website by đương.',
              style: GoogleFonts.montserrat(
                color: Colors.white70,
                fontSize: 12,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.white, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.montserrat(
                color: Colors.white,
                fontSize: 14,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
