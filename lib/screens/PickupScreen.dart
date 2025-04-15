import 'package:flutter/material.dart';

class PickupScreen extends StatefulWidget {
  const PickupScreen({super.key});

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  String selectedProvince = "Tỉnh/Thành Phố";
  String selectedDistrict = "Quận/Huyện";
  bool _isListView = true;
  bool _isNearestTab = true;

  final List<Map<String, String>> stores = [
    {
      "name": "KATINAT LÊ VĂN THỌ",
      "address": "196 Lê Văn Thọ, Phường 11, Gò Vấp, Hồ Chí Minh, Việt Nam",
      "openTime": "07:00",
      "closeTime": "22:30",
      "distance": "5,45km",
      "image": "assets/images/katinat1.jpg",
    },
    {
      "name": "KATINAT LÊ TRỌNG TẤN",
      "address": "440-440A Đường Lê Trọng Tấn, Tây Thạnh, Tân Phú, Hồ Chí Minh, Việt Nam",
      "openTime": "07:00",
      "closeTime": "22:30",
      "distance": "5,74km",
      "image": "assets/images/katinat2.jpg",
    },
    {
      "name": "KATINAT AEON MALL TÂN PHÚ",
      "address": "Katinat Aeon Tân Phú, Đường Tân Thắng, Celadon City, Tân Phú, Hồ Chí Minh, Việt Nam",
      "openTime": "07:00",
      "closeTime": "22:30",
      "distance": "5,74km",
      "image": "assets/images/katinat3.jpg",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F4352),
        elevation: 0,
        title: const Text(
          "ĐƯƠNG",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          _buildSearchAndToggle(),
          _buildFilterDropdowns(),
          _buildTabSelector(),
          Expanded(
            child: _isListView
                ? _buildStoreListView()
                // TODO: Add your MapView here if needed
                : const Center(child: Text("Map View Coming Soon")),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndToggle() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 44,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  const Icon(Icons.search, color: Color(0xFF1F4352)),
                  const SizedBox(width: 8),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Tìm kiếm cửa hàng",
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            height: 44,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                _buildToggleButton("Danh sách", _isListView),
                _buildToggleButton("Bản đồ", !_isListView),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterDropdowns() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildDropdown(
              selectedProvince,
              ["Tỉnh/Thành Phố", "Hồ Chí Minh", "Hà Nội"],
              (value) => setState(() => selectedProvince = value!),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: _buildDropdown(
              selectedDistrict,
              ["Quận/Huyện", "Gò Vấp", "Tân Phú"],
              (value) => setState(() => selectedDistrict = value!),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Text(
              "Lọc",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          _buildTab("Gần bạn nhất", _isNearestTab),
          const SizedBox(width: 8),
          _buildTab("Tất cả", !_isNearestTab),
        ],
      ),
    );
  }

  Widget _buildStoreListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: stores.length,
      itemBuilder: (context, index) {
        final store = stores[index];
        return Card(
          color: const Color(0xFFF2EEEA),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 12),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(
                    store["image"]!,
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        store["name"]!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        store["address"]!,
                        style: const TextStyle(fontSize: 13),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${store["openTime"]} - ${store["closeTime"]} | ${store["distance"]}",
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDropdown(String value, List<String> items, ValueChanged<String?> onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(24),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildToggleButton(String text, bool isActive) {
    return GestureDetector(
      onTap: () => setState(() => _isListView = text == "Danh sách"),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        height: 44,
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.grey[300],
          borderRadius: BorderRadius.circular(24),
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            color: isActive ? const Color(0xFF1F4352) : Colors.black54,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String label, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _isNearestTab = label == "Gần bạn nhất"),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1F4352) : Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
