import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/katinat_app_bar.dart';
import '../widgets/katinat_footer.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const Color katinatGold = Color(0xFFD3A374);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const KatinatAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Tin tức & sự kiện',
                    style: GoogleFonts.playfairDisplay(
                      color: katinatGold,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    width: 60,
                    height: 3,
                    color: katinatGold,
                  ),
                  const SizedBox(height: 40),
                  _buildNewsListCard(
                    context,
                    imageUrl: 'assets/images/news_list_1.jpg',
                    title: 'XIN CHÀO KATIES! ƯU ĐÃI NGẬP TRÀN...',
                    date: 'By KATINAT / 02/03/2025',
                  ),
                  _buildNewsListCard(
                    context,
                    imageUrl: 'assets/images/news_list_2.jpg',
                    title: 'KẾT QUẢ TRÚNG THƯỞNG CHƯƠNG TRÌNH PHIẾU XÉ MAY MẮN',
                    date: 'By KATINAT / 16/02/2025',
                  ),
                  _buildNewsListCard(
                    context,
                    imageUrl: 'assets/images/news_list_3.jpg',
                    title: 'KATINAT BOWTIFUL CHRISTMAS - MỞ NƠ XINH BÍ ẨN...',
                    date: 'By KATINAT / 12/11/2024',
                  ),
                  _buildNewsListCard(
                    context,
                    imageUrl: 'assets/images/news_list_4.jpg',
                    title: '[KATINAT x FACOLOS] - HẸN KATIES CHECK-IN RINh VỢT...',
                    date: 'By KATINAT / 26/02/2024',
                  ),
                  _buildNewsListCard(
                    context,
                    imageUrl: 'assets/images/news_list_5.jpg',
                    title: 'MINI GAME: ĐOÁN TÊN SIÊU PHẨM MỚI...',
                    date: 'By KATINAT / 15/01/2024',
                  ),
                ],
              ),
            ),
            const KatinatFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsListCard(BuildContext context, {required String imageUrl, required String title, required String date}) {
    const Color katinatGold = Color(0xFFD3A374);

    return Container(
      margin: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 250,
                color: Colors.grey[200],
                child: const Icon(Icons.image, color: Colors.grey, size: 50),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            date,
            style: GoogleFonts.montserrat(
              fontSize: 14,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(50, 30),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Read More >',
              style: GoogleFonts.montserrat(
                color: katinatGold,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Divider(color: Colors.black12, thickness: 1),
        ],
      ),
    );
  }
}
