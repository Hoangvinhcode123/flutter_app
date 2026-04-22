import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/katinat_app_bar.dart';
import '../widgets/katinat_footer.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color katinatGold = Color(0xFFD3A374);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const KatinatAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Banner
            Image.asset(
              'assets/images/Herobanner.jpg',
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250,
                color: Colors.brown[900],
                child: Center(
                  child: Text(
                    'JOURNEY TO EXPLORE NEW TASTES',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(Icons.eco, color: Color(0xFF132A38), size: 40),
                  const SizedBox(height: 20),
                  Text(
                    'Hành trình chinh phục phong vị mới',
                    style: GoogleFonts.playfairDisplay(
                      color: const Color(0xFF132A38),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),
                  // Thống kê
                  _buildStatItem('9', 'TỈNH THÀNH (PROVINCES)'),
                  const SizedBox(height: 30),
                  _buildStatItem('15+', 'TRẠM DỪNG (STATIONS)'),
                  const SizedBox(height: 30),
                  _buildStatItem('96+', 'CỬA HÀNG (STORES)'),
                  const SizedBox(height: 40),
                  Text(
                    'Mang âm hưởng của phong cách thiết kế hiện đại, ĐƯƠNG chọn cho mình những đường nét tinh tế, sang trọng. Tất cả đều đem lại không gian thoáng đãng, là nơi yêu thích để làm việc, gặp gỡ hay thư giãn.',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),

                  // Cà phê Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Cà Phê',
                      style: GoogleFonts.playfairDisplay(
                        color: katinatGold,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Mỗi hạt cà phê tại ĐƯƠNG đều được chọn lọc kỹ lưỡng, rang xay và pha chế theo phương thức riêng. Dù là phong cách thưởng thức cà phê truyền thống hay hiện đại, ĐƯƠNG luôn mang đến...ĐƯƠNG là sự kết hợp hoàn hảo giữa không gian thiết kế độc đáo và công thức đồ uống chuẩn mực do bàn tay những người thợ lành nghề tạo nên.',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/Sp_2.jpg',
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(height: 300, color: Colors.grey[300]),
                    ),
                  ),
                  const SizedBox(height: 60),

                  // Trà Section
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Trà',
                      style: GoogleFonts.playfairDisplay(
                        color: katinatGold,
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Sự thanh khiết và hương vị tự nhiên của trà xanh được giữ nguyên trọn vẹn, hoà quyện tinh tế với các loại thảo dược tự nhiên...',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      height: 1.6,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      'assets/images/Sp_3.jpg',
                      height: 300,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(height: 300, color: Colors.grey[300]),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            const KatinatFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String number, String label) {
    const Color katinatGold = Color(0xFFD3A374);
    
    return Column(
      children: [
        Text(
          number,
          style: GoogleFonts.playfairDisplay(
            color: katinatGold,
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.montserrat(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            letterSpacing: 1.2,
          ),
        ),
      ],
    );
  }
}
