import 'package:flutter/material.dart';

class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({super.key});

  @override
  _PromotionsScreenState createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  bool _isAvailableTab = true;

  final List<Map<String, String>> promotions = [
    {
      "title": "[NEW MEMBER] ƯU ĐÃI 10% BST MATCHA",
      "description": "Ưu đãi dành cho thành viên New Member",
      "expiry": "10/04/2025 21:30",
      "image": "assets/images/uudai1.jpg",
    },
    {
      "title": "ƯU ĐÃI 30K CHO ĐƠN TỪ THIẾU 60K (NM)",
      "description": "Áp dụng cho sản phẩm: Đồ uống, Topping và Bánh",
      "expiry": "18/04/2025 23:59",
      "image": "assets/images/uudai1.jpg",
    },
    {
      "title": "ƯU ĐÃI 30K CHO HÓA ĐƠN TỪ 250K",
      "description": "Áp dụng cho tất cả sản phẩm",
      "expiry": "30/06/2025 21:30",
      "image": "assets/images/uudai2.jpg",
    },
    {
      "title": "ƯU ĐÃI 50K CHO HÓA ĐƠN TỪ 350K",
      "description": "Áp dụng cho tất cả sản phẩm",
      "expiry": "30/06/2025 21:30",
      "image": "assets/images/uudai2.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1F4352)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          "Ưu đãi của bạn",
          style: TextStyle(
            color: Color(0xFF1F4352),
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Nhập mã ưu đãi...",
                hintStyle: const TextStyle(color: Colors.grey),
                prefixIcon: const Icon(Icons.search, color: Color(0xFF1F4352)),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                _buildTabButton("Khả dụng", _isAvailableTab),
                const SizedBox(width: 8),
                _buildTabButton("Không khả dụng", !_isAvailableTab),
              ],
            ),
          ),
          Expanded(
            child: _isAvailableTab ? _buildPromotionsList() : _buildNoPromotions(),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _isAvailableTab = label == "Khả dụng"),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1F4352) : Colors.grey[200],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildPromotionsList() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: promotions.length,
      itemBuilder: (context, index) {
        final promo = promotions[index];
        return Card(
          color: const Color(0xFFF2EEEA),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    promo["image"]!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        promo["title"]!,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        promo["description"]!,
                        style: TextStyle(fontSize: 14, color: Colors.grey[800]),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "HSD: ${promo["expiry"]}",
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFCC9C60),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text("Chọn", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildNoPromotions() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/avatar.jpg",
            height: 200,
            errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported, size: 100),
          ),
          const SizedBox(height: 16),
          const Text("Bạn chưa có ưu đãi nào", style: TextStyle(fontSize: 16)),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCC9C60),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: const Text("Đổi ưu đãi ngay", style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        ],
      ),
    );
  }
}
