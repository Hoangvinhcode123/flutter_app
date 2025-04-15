import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cartprovider.dart';
import 'cartscreen.dart';

class DrinkDetailScreen extends StatefulWidget {
  final String title;
  final String imageUrl;
  final int price;

  const DrinkDetailScreen({
    super.key,
    required this.title,
    required this.imageUrl,
    required this.price,
  });

  @override
  State<DrinkDetailScreen> createState() => _DrinkDetailScreenState();
}

class _DrinkDetailScreenState extends State<DrinkDetailScreen> {
  int quantity = 1;
  String sugarLevel = 'Ngọt bình thường';
  String iceLevel = 'Đá bình thường';

  final Map<String, int> toppings = {
    'Trân Châu Trắng': 10000,
    'Thạch hồng đài': 12000,
    'Chôm chôm': 15000,
    'Đào': 15000,
    'Vải': 15000,
    'Nhãn': 15000,
    'Dứa': 15000,
  };

  final List<String> selectedToppings = [];
  final List<String> notes = [
    'Ít cà phê',
    'Ít trà',
    'Đậm trà',
    'Không kem sữa phô mai',
    'Ít kem sữa phô mai',
    'Ít chua',
    'Thêm ngọt',
  ];
  List<String> selectedNotes = []; // ⭐ Thêm để lưu các lưu ý đã chọn

  int get totalPrice {
    int toppingTotal = selectedToppings.fold(0, (sum, topping) => sum + toppings[topping]!);
    return (widget.price + toppingTotal) * quantity;
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBF9),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
        title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined, color: Colors.black),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const CartScreen()));
                },
              ),
              Positioned(
                right: 6,
                top: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: Colors.brown, shape: BoxShape.circle),
                  child: const Text('2', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              )
            ],
          )
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Image.asset(widget.imageUrl, width: 250, height: 250),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: ListView(
                children: [
                  const Text("Chọn mức đường", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSelectOption("Ngọt bình thường", sugarLevel, (val) => setState(() => sugarLevel = val)),
                      const SizedBox(width: 12),
                      _buildSelectOption("Ít ngọt", sugarLevel, (val) => setState(() => sugarLevel = val)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text("Chọn đá", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 12,
                    runSpacing: 8,
                    children: [
                      "Đá bình thường",
                      "Ít đá",
                      "Đá riêng",
                      "Không đá",
                    ]
                        .map((e) => _buildSelectOption(e, iceLevel, (val) => setState(() => iceLevel = val)))
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  const Text("Thêm Topping", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ...toppings.entries.map((entry) {
                    bool selected = selectedToppings.contains(entry.key);
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      title: Text(entry.key),
                      trailing: Text(
                          "${entry.value.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}đ"),
                      leading: IconButton(
                        icon: Icon(
                          selected ? Icons.remove_circle : Icons.add_circle,
                          color: Colors.grey,
                        ),
                        onPressed: () {
                          setState(() {
                            if (selected) {
                              selectedToppings.remove(entry.key);
                            } else {
                              selectedToppings.add(entry.key);
                            }
                          });
                        },
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 20),
                  const Text("Lưu ý cho món", style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: notes.map((note) {
                      bool isSelected = selectedNotes.contains(note);
                      return ChoiceChip(
                        label: Text(note),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              selectedNotes.add(note);
                            } else {
                              selectedNotes.remove(note);
                            }
                          });
                        },
                        selectedColor: const Color(0xFFB58D65),
                        backgroundColor: Colors.grey.shade200,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "$quantity sản phẩm\n${totalPrice.toString().replaceAllMapped(RegExp(r"(\d)(?=(\d{3})+(?!\d))"), (m) => "${m[1]}.")}đ",
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle_outline),
                            onPressed: () {
                              if (quantity > 1) {
                                setState(() => quantity--);
                              }
                            },
                          ),
                          Text('$quantity', style: const TextStyle(fontSize: 18)),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline),
                            onPressed: () {
                              setState(() => quantity++);
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFB58D65),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        cart.addToCart(
                          DateTime.now().toString(), // ID
                          widget.title,
                          widget.price.toDouble(),
                          widget.imageUrl,
                          quantity,
                        );
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const CartScreen()),
                        );
                      },
                      child: const Text("Thêm vào giỏ hàng", style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSelectOption(String label, String selected, Function(String) onTap) {
    bool isSelected = selected == label;
    return GestureDetector(
      onTap: () => onTap(label),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isSelected ? const Color(0xFF1F4352) : Colors.grey,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF1F4352) : Colors.grey,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
