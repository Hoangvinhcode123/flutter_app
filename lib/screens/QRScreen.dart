import 'package:flutter/material.dart';

class QRScreen extends StatefulWidget {
  const QRScreen({super.key}); // Thêm constructor const

  @override
  _QRScreenState createState() => _QRScreenState();
}

class _QRScreenState extends State<QRScreen> {
  bool isPhoneVisible = false;

  String getMaskedPhoneNumber() {
    return isPhoneVisible ? '0388290904' : '038****904';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE9EBF0), // Nền xám nhạt
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/', (route) => false);
          },
        ),
        title: const Text(
          "QR Tích điểm",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Icon(
              Icons
                  .qr_code_scanner, // Thay đổi biểu tượng thành qr_code_scanner
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF133B4F), // Nền xanh đậm
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "HƯỚNG DẪN TÍCH ĐIỂM",
                style: TextStyle(
                  color: Color(0xFFC49B6C),
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Đưa mã này cho nhân viên để quét",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 20),
              Center(
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xFFC49B6C),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Image.asset(
                    'assets/images/QR.jpg',
                    width: 220,
                    height: 220,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                "Hãy đọc số điện thoại của bạn cho nhân viên",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFC49B6C),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      getMaskedPhoneNumber(),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF133B4F),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isPhoneVisible = !isPhoneVisible;
                        });
                      },
                      child: Icon(
                        isPhoneVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                        color: const Color(0xFF133B4F),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
