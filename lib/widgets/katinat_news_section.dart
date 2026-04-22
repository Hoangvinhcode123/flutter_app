import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KatinatNewsSection extends StatelessWidget {
  const KatinatNewsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                _buildNewsCard(
                  context,
                  imageUrl: 'assets/images/news_1_v3.jpg',
                  title: 'KẾT QUẢ TRÚNG THƯỞNG CHƯƠNG TRÌNH PHIẾU XÉ MAY MẮN',
                  date: 'By ĐƯƠNG / 16/02/2025',
                  snippet: 'Sau khi kết thúc chương trình khuyến mại, Công ty Cổ phần Café Đương thông tin chi tiết về kết...',
                ),
                _buildNewsCard(
                  context,
                  imageUrl: 'assets/images/news_2_v3.jpg',
                  title: 'ĐƯƠNG BOWTIFUL CHRISTMAS - MỞ NƠ XINH BÍ ẨN - ĐÓN GIÁNG SINH PHÉP MÀU',
                  date: 'By ĐƯƠNG / 12/11/2024',
                  snippet: 'Merry Christmas Katies! Mùa lễ hội này, ĐƯƠNG Coffee & Tea House mang đến cho bạn chương trình...',
                ),
                _buildNewsCard(
                  context,
                  imageUrl: 'assets/images/news_3_v3.jpg',
                  title: '[ĐƯƠNG x FACOLOS] - HẸN KATIES CHECK-IN RINh VỢT XINH...',
                  date: 'By ĐƯƠNG / 26/02/2024',
                  snippet: 'Lần đầu tiên ĐƯƠNG hợp tác cùng Facolos - Thương hiệu hàng đầu trong lĩnh vực Pickleball với mong...',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCard(
    BuildContext context, {
    required String imageUrl,
    required String title,
    required String date,
    required String snippet,
    BoxFit fit = BoxFit.cover,
  }) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 200,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                imageUrl,
                height: 200,
                width: double.infinity,
                fit: fit,
                alignment: Alignment.topCenter,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 200,
                  color: Colors.grey[200],
                  child: const Icon(Icons.image, color: Colors.grey),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF3BBEB6), // Xanh mint
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'TIN TỨC & SỰ KIỆN',
              style: TextStyle(
                color: Colors.white,
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: GoogleFonts.montserrat(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 12),
          Text(
            snippet,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.grey[800],
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext dialogContext) {
                  return AlertDialog(
                    title: Text(
                      'Chi tiết tin tức',
                      style: GoogleFonts.playfairDisplay(
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFFD3A374),
                      ),
                    ),
                    content: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(imageUrl, fit: BoxFit.contain),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            title,
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(date, style: GoogleFonts.montserrat(color: Colors.grey[600], fontSize: 12)),
                          const SizedBox(height: 16),
                          Text(
                            snippet,
                            style: GoogleFonts.montserrat(fontSize: 14, height: 1.5),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Nội dung đầy đủ của bài viết đang được cập nhật...',
                            style: GoogleFonts.montserrat(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[800],
                            ),
                          ),
                        ],
                      ),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(dialogContext).pop(),
                        child: Text(
                          'Đóng',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF132A38),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey[300]!),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'Read More',
              style: GoogleFonts.montserrat(
                color: Colors.black87,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
