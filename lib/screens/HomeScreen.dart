import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import '../widgets/DrinkItem.dart';
import 'NotificationsScreen.dart';
import 'DeliveryScreen.dart';
import 'PickupScreen.dart';
import 'promotionscreen.dart';

const Color primaryColor = Color(0xFF1F4352);

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isLoggedIn = false;
  String userName = "";
  int unreadNotificationCount = 3;

  final List<Map<String, String>> drinks = [
    {
      "productId": "1",
      "title": "Trà Đào Hồng Đài (L)",
      "imageUrl": "assets/images/tradaohongdai.png",
      "price": "64000",
    },
    {
      "productId": "2",
      "title": "TaRo Coco (L)",
      "imageUrl": "assets/images/tarococo.jpg",
      "price": "59000",
    },
    {
      "productId": "3",
      "title": "Bơ Già Dừa Non (L)",
      "imageUrl": "assets/images/bogiaduanon.jpg",
      "price": "55000",
    },
    {
      "productId": "4",
      "title": "Trà Sữa Matcha (L)",
      "imageUrl": "assets/images/ikimatchatofu.jpg",
      "price": "70000",
    },
  ];

  final List<String> bannerImages = [
    "assets/images/banner.jpg",
    "assets/images/banner2.jpg",
    "assets/images/banner3.jpg",
    "assets/images/banner4.jpg",
  ];

  final PageController _bannerController = PageController();
  int currentBannerPage = 0;
  Timer? _bannerTimer;

  @override
  void initState() {
    super.initState();
    _startBannerAutoScroll();
  }

  void _startBannerAutoScroll() {
    _bannerTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_bannerController.hasClients) {
        int nextPage = (currentBannerPage + 1) % bannerImages.length;
        _bannerController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
        setState(() {
          currentBannerPage = nextPage;
        });
      }
    });
  }

  @override
  void dispose() {
    _bannerTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(context),
              _buildBanner(),
              _buildDeliveryOptions(),
              _buildWorkingHours(),
              const SizedBox(height: 10),
              _buildBestSellerSection(),
              const SizedBox(height: 16),
              _buildSuggestedForYouSection(),
              _buildMustTrySection(),
              const SizedBox(height: 16),
              _buildNewsEventSection(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: primaryColor,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Column(
        children: [
          if (!isLoggedIn)
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.black),
                ),
                child: RichText(
                  text: TextSpan(
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    children: [
                      TextSpan(
                        text: 'ĐĂNG NHẬP',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              isLoggedIn = false;
                              userName = "";
                            });
                            Navigator.pushNamed(context, '/login');
                          },
                      ),
                      const TextSpan(text: ' / '),
                      TextSpan(
                        text: 'ĐĂNG KÝ',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              isLoggedIn = false;
                              userName = "";
                            });
                            Navigator.pushNamed(context, '/register');
                          },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isLoggedIn
                  ? const CircleAvatar(
                      radius: 26,
                      backgroundImage: AssetImage("assets/images/avatar.jpg"),
                    )
                  : const SizedBox.shrink(),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isLoggedIn ? "CHÀO BUỔI SÁNG, $userName!" : "CHÀO BUỔI SÁNG!",
                    style: TextStyle(
                      color: Colors.amber[200],
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    isLoggedIn ? userName : "Vui lòng đăng nhập để tiếp tục",
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.local_offer_outlined, color: Colors.white),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const PromotionsScreen()),
                      );
                    },
                  ),
                  Stack(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications_none, color: Colors.white),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const NotificationsScreen()),
                          );
                          setState(() {
                            unreadNotificationCount = 0;
                          });
                        },
                      ),
                      if (unreadNotificationCount > 0)
                        Positioned(
                          right: 8,
                          top: 8,
                          child: Container(
                            padding: const EdgeInsets.all(3),
                            decoration: const BoxDecoration(
                              color: Colors.amber,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$unreadNotificationCount',
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBanner() {
    return Column(
      children: [
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: _bannerController,
            itemCount: bannerImages.length,
            onPageChanged: (index) {
              setState(() {
                currentBannerPage = index;
              });
            },
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    bannerImages[index],
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (_, __, ___) => Container(
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(Icons.image_not_supported, size: 40),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            bannerImages.length,
            (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: currentBannerPage == index ? 12 : 8,
              height: currentBannerPage == index ? 12 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: currentBannerPage == index ? primaryColor : Colors.grey.shade400,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeliveryOptions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const DeliveryScreen()),
            ),
            child: _buildOptionBox(Icons.delivery_dining, "Giao hàng"),
          ),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PickupScreen()),
            ),
            child: _buildOptionBox(Icons.storefront, "Lấy tận nơi"),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionBox(IconData icon, String label) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 5,
                offset: const Offset(2, 2),
              ),
            ],
          ),
          child: Icon(icon, size: 40, color: primaryColor),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  Widget _buildWorkingHours() {
    return const Text(
      "Khung giờ áp dụng đặt hàng từ 7:00 - 21:30",
      style: TextStyle(color: primaryColor),
    );
  }

  Widget _buildBestSellerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildSectionTitle("BEST SELLER"), _buildDrinkList(drinks)],
    );
  }

  Widget _buildSuggestedForYouSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_buildSectionTitle("DÀNH CHO BẠN"), _buildDrinkList(drinks)],
    );
  }

  Widget _buildMustTrySection() {
    final mustTryDrinks = drinks.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("MÓN NGON PHẢI THỬ"),
        _buildDrinkList(mustTryDrinks),
      ],
    );
  }

  Widget _buildNewsEventSection() {
    final List<Map<String, String>> news = [
      {
        "title": "Khuyến mãi 50% mùa hè",
        "image": "assets/images/tintuc.jpg",
      },
      {
        "title": "Khai trương chi nhánh mới",
        "image": "assets/images/sukien.jpg",
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("TIN TỨC - SỰ KIỆN"),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: news.length,
            itemBuilder: (context, index) {
              final item = news[index];
              return Container(
                width: 250,
                margin: const EdgeInsets.only(left: 16, right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  image: DecorationImage(
                    image: AssetImage(item["image"] ?? ""),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    gradient: LinearGradient(
                      colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  alignment: Alignment.bottomLeft,
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    item["title"] ?? "",
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Text("Xem tất cả", style: TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  Widget _buildDrinkList(List<Map<String, String>> drinks) {
    return SizedBox(
      height: 270,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: drinks.length,
        itemBuilder: (context, index) {
          final drink = drinks[index];
          double price = double.tryParse(drink["price"] ?? "0") ?? 0;

          return Padding(
            padding: const EdgeInsets.only(left: 16, right: 4),
            child: DrinkItem(
              productId: drink["productId"] ?? "",
              title: drink["title"] ?? "",
              imageUrl: drink["imageUrl"] ?? "assets/images/default.png",
              price: price,
            ),
          );
        },
      ),
    );
  }
}
