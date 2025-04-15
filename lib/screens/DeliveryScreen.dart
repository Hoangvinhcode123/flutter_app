import 'package:app_tuan89/models/address.dart';
import 'package:app_tuan89/screens/AddNewAddressScreen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:app_tuan89/providers/addressprovider.dart' as address_provider;
import 'package:app_tuan89/providers/cartprovider.dart';
import 'package:app_tuan89/models/address.dart' as model_address;

class DeliveryScreen extends StatefulWidget {
  const DeliveryScreen({super.key});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  int selectedCategory = 0;
  int selectedToggle = 0;

  final categories = ["Tất cả", "Best Seller", "Món ngon phải thử"];

  final List<Map<String, dynamic>> promotions = [
    {
      "title": "GIỖ TỔ SUM VẦY - MUA 2 TẶNG 1",
      "discount": "-28%",
      "image": "assets/images/haitangmot.jpg",
      "price": 138000,
      "oldPrice": 192000,
    },
    {
      "title": "1X COMBO LẤP LÁNH - TRÀ SỮA CHÔM CHÔM",
      "discount": "-27%",
      "image": "assets/images/mottangmot.jpg",
      "price": 159000,
      "oldPrice": 218000,
    },
    {
      "title": "COMBO LẤP LÁNH - CÓC CÓC ĐẮC ĐẮC",
      "discount": "-30%",
      "image": "assets/images/mottangmot.jpg",
      "price": 159000,
      "oldPrice": 228000,
    },
    {
      "title": "COMBO LẤP LÁNH - BƠ GIÀ DỪA NON",
      "discount": "-30%",
      "image": "assets/images/mottangmot.jpg",
      "price": 159000,
      "oldPrice": 228000,
    },
  ];

  final currencyFormatter = NumberFormat("#,##0", "vi_VN");

  void _navigateToAddAddress() async {
    final newAddress = await Navigator.pushNamed(context, '/add-address');
    if (newAddress != null && newAddress is model_address.Address) {
      Provider.of<address_provider.AddressProvider>(context, listen: false)
          .setSelectedAddress(newAddress);
    }
  }

  void showAddedToCartSnackBar(BuildContext context, String productName) {
    final snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.green,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      duration: const Duration(seconds: 2),
      content: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.white, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '$productName đã thêm vào giỏ hàng',
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F4352),
        elevation: 0,
        title: Text(
          "KATINAT",
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            letterSpacing: 4,
            fontSize: 22,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchAndModeToggle(),
          _buildCategoryTabs(),
          _buildAddressSection(),
          Expanded(child: _buildPromotionsGrid()),
        ],
      ),
    );
  }

  Widget _buildSearchAndModeToggle() {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Bạn của ĐƯƠNG muốn tìm gì?",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Row(
            children: List.generate(2, (index) {
              final labels = ["Giao hàng", "Đến lấy"];
              final isSelected = selectedToggle == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    selectedToggle = index;
                  });
                  if (index == 1) {
                    Navigator.pushNamed(context, '/pickup');
                  }
                },
                child: Container(
                  margin: EdgeInsets.only(left: index == 0 ? 0 : 8),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF1F4352) : Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: const Color(0xFF1F4352)),
                  ),
                  child: Text(
                    labels[index],
                    style: TextStyle(
                      color: isSelected ? Colors.white : const Color(0xFF1F4352),
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }),
          )
        ],
      ),
    );
  }

  Widget _buildCategoryTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: List.generate(categories.length, (index) {
          final isSelected = selectedCategory == index;
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedCategory = index;
              });
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF1F4352) : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                categories[index],
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade600,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildAddressSection() {
    return Consumer<address_provider.AddressProvider>(
      builder: (context, addressProvider, _) {
        final selectedAddress = addressProvider.selectedAddress;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, color: Colors.redAccent),
              const SizedBox(width: 8),
              Expanded(
                child: selectedAddress != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${selectedAddress.name} - ${selectedAddress.phone}",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            selectedAddress.fullAddress,
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      )
                    : GestureDetector(
                        onTap: _navigateToAddAddress,
                        child: const Text(
                          "Thêm địa chỉ giao hàng",
                          style: TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ),
              ),
              if (selectedAddress != null)
                IconButton(
                  icon: const Icon(Icons.edit, size: 20),
                  onPressed: _navigateToAddAddress,
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPromotionsGrid() {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.64,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: promotions.length,
      itemBuilder: (context, index) {
        final item = promotions[index];
        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade200),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.asset(
                        item["image"],
                        height: 130,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Positioned(
                      right: 8,
                      top: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.brown,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item["discount"],
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    item["title"],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Text(
                        "${currencyFormatter.format(item["price"])}đ",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        "${currencyFormatter.format(item["oldPrice"])}đ",
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Align(
                  alignment: Alignment.bottomRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () {
                        final cartProvider = Provider.of<CartProvider>(context, listen: false);
                        final productId = DateTime.now().millisecondsSinceEpoch.toString();

                        cartProvider.addToCart(
                          productId,
                          item['title'],
                          item['price'].toDouble(),
                          item['image'],
                          1,
                        );

                        showAddedToCartSnackBar(context, item['title']);
                        Navigator.pushNamed(context, '/cart');
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.brown),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: const Icon(Icons.add, color: Colors.brown, size: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
