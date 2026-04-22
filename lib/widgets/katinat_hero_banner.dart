import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KatinatHeroBanner extends StatelessWidget {
  const KatinatHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    const Color katinatGold = Color(0xFFD3A374);

    return Container(
      width: double.infinity,
      height: 400,
      color: const Color(0xFF2C1E16),
      child: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/images/Herobanner.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFF2C1E16),
                child: const Center(child: Icon(Icons.broken_image, color: Colors.white54, size: 50)),
              ),
            ),
          ),
          // Dark Overlay for text readability
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.3))),
          // Content
          Positioned.fill(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Trân Châu',
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 24,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  Text(
                    'Dừa Tốt Nốt',
                    style: GoogleFonts.playfairDisplay(
                      color: katinatGold,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
