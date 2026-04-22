import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/katinat_app_bar.dart';
import '../widgets/katinat_footer.dart';

class DisclaimerScreen extends StatelessWidget {
  const DisclaimerScreen({super.key});

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
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 80.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Zalo Floating Action Button mock icon could be here usually, but keeping it clean
                  Align(
                    alignment: Alignment.centerRight,
                    child: Container(
                      width: 50,
                      height: 50,
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
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  Text(
                    'Để đảm bảo trải nghiệm tốt nhất, Quý khách vui lòng thông báo trước cho nhân viên về các thành phần thực phẩm có thể gây dị ứng hoặc ảnh hưởng sức khoẻ quý khách.',
                    style: GoogleFonts.montserrat(
                      color: katinatGold,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  
                  Text(
                    'Đồng thời, ĐƯƠNG khuyến nghị Quý khách nên thưởng thức đồ uống trong vòng 2 giờ đầu tiên để từ khi nhận thức uống tại quán/ Việc để đồ uống quá lâu hoặc vận chuyển với thời gian dài có thể ảnh hưởng đến hương vị và chất lượng của sản phẩm.',
                    style: GoogleFonts.montserrat(
                      color: katinatGold,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  
                  Text(
                    'ĐƯƠNG không chịu trách nhiệm đảm bảo chất lượng sản phẩm trong trường hợp các sản phẩm pha chế được dùng sau 2h kể từ khi rời quầy.',
                    style: GoogleFonts.montserrat(
                      color: katinatGold,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.italic,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 60),

                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: katinatGold, width: 1.5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
                    ),
                    child: Text(
                      'Xem Hệ Thống Cửa Hàng',
                      style: GoogleFonts.montserrat(
                        color: katinatGold,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
            const KatinatFooter(),
          ],
        ),
      ),
    );
  }
}
