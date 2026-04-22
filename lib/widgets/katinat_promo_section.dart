import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KatinatPromoSection extends StatelessWidget {
  const KatinatPromoSection({super.key});

  @override
  Widget build(BuildContext context) {
    const Color katinatGold = Color(0xFFD3A374);
    const Color bgBeige = Color(0xFFFAF8F5);

    return Column(
      children: [
        // Cà phê Phin Mê
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 30.0),
          child: Image.asset(
            'assets/images/Herobanner.jpg',
            height: 350,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
                height: 350,
                color: Colors.brown[900],
                child: Center(
                  child: Text(
                    'CÀ PHÊ PHIN MÊ',
                    style: GoogleFonts.playfairDisplay(
                        color: Colors.white, fontSize: 30),
                  ),
                ),
              ),
          ),
        ),
        // Cửa hàng
        Container(
          color: bgBeige,
          padding: const EdgeInsets.symmetric(vertical: 60.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 3,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          'assets/images/Duong.jpg',
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            height: 250,
                            color: Colors.grey[300],
                            child: const Icon(Icons.store, size: 50, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    Flexible(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cửa Hàng',
                            style: GoogleFonts.playfairDisplay(
                              color: katinatGold,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Lấy cảm hứng từ các vùng đất trên thế giới, ĐƯƠNG tạo ra không gian mở và thân thiện nhằm kết nối và ghi lại những khoảnh khắc tươi vui trong lúc thưởng thức.',
                            style: GoogleFonts.montserrat(
                              color: katinatGold.withOpacity(0.8),
                              fontSize: 13,
                              height: 1.6,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
