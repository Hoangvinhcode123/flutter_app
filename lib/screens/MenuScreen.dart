import 'package:flutter/material.dart';

class MenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A2A3E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A2A3E),
        elevation: 0,
        centerTitle: true,
        title: Text(
          'MENU',
          style: TextStyle(
            fontFamily: 'Merriweather',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFFD4AA6C),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/images/menu.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Để đảm bảo trải nghiệm tốt nhất, Quý khách vui lòng thông báo trước cho nhân viên về các thành phần thực phẩm có thể gây dị ứng hoặc ảnh hưởng sức khoẻ quý khách.',
                style: TextStyle(
                  color: Color(0xFF8C6239),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Đồng thời, KATINAT khuyến nghị Quý khách nên thưởng thức đồ uống trong vòng 2 giờ đầu tiên kể từ khi nhận thức uống tại quầy. Việc để đồ uống quá lâu hoặc vận chuyển với thời gian dài có thể ảnh hưởng đến hương vị và chất lượng của sản phẩm.',
                style: TextStyle(
                  color: Color(0xFF8C6239),
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'ĐƯƠNG không chịu trách nhiệm đảm bảo chất lượng sản phẩm trong trường hợp các sản phẩm pha chế được dùng sau 2h kể từ khi rời quầy.',
                style: TextStyle(
                  color: Color(0xFF8C6239),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Color(0xFF8C6239)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {
                  // TODO: Chuyển sang màn hệ thống cửa hàng
                },
                child: Text(
                  'Xem Hệ Thống Cửa Hàng',
                  style: TextStyle(
                    color: Color(0xFF8C6239),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
