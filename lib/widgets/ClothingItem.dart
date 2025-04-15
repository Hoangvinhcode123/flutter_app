import 'package:flutter/material.dart';

class ClothingItem extends StatelessWidget {
  final String productId;
  final String title;
  final String imageUrl;
  final String price; // Thêm tham số price

  ClothingItem({
    required this.productId,
    required this.title,
    required this.imageUrl,
    required this.price, // Nhận giá tiền
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
            ),
          ),
        ),
        SizedBox(height: 5),
        Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        SizedBox(height: 5),
        Text(
          price, // Hiển thị giá tiền
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      ],
    );
  }
}