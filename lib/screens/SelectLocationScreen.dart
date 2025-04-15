import 'package:flutter/material.dart';

class SelectLocationModal extends StatefulWidget {
  final String title;
  final List<String> items;
  final Function(String) onSelected;

  const SelectLocationModal({
    super.key,
    required this.title,
    required this.items,
    required this.onSelected,
  });

  @override
  State<SelectLocationModal> createState() => _SelectLocationModalState();
}

class _SelectLocationModalState extends State<SelectLocationModal> {
  String searchQuery = '';
  late List<String> filteredItems;

  @override
  void initState() {
    super.initState();
    filteredItems = widget.items;
  }

  void updateSearch(String query) {
    setState(() {
      searchQuery = query;
      filteredItems = widget.items
          .where((item) =>
              item.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tiêu đề
        AppBar(
          automaticallyImplyLeading: false,
          elevation: 0,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ),

        // Ô tìm kiếm
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: TextField(
            onChanged: updateSearch,
            decoration: InputDecoration(
              hintText: 'Tìm kiếm',
              prefixIcon: const Icon(Icons.search, color: Colors.white),
              filled: true,
              fillColor: const Color(0xFF2F4858),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintStyle: const TextStyle(color: Colors.white),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ),

        // Danh sách
        Expanded(
          child: ListView.separated(
            itemCount: filteredItems.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                  filteredItems[index],
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  widget.onSelected(filteredItems[index]);
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
