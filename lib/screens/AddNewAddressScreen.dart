// Không thay đổi phần import và models của bạn
import 'package:app_tuan89/models/address.dart';
import 'package:app_tuan89/providers/addressprovider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// ... Address + AddressProvider giữ nguyên như bạn viết ở trên ...

// Màn hình thêm địa chỉ
class AddNewAddressScreen extends StatefulWidget {
  @override
  State<AddNewAddressScreen> createState() => _AddNewAddressScreenState();
}

class _AddNewAddressScreenState extends State<AddNewAddressScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController detailController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  bool isDefault = false;
  String selectedAddressType = 'Nhà riêng';
  List<String> addressTypes = ['Nhà riêng', 'Văn phòng', 'Khác'];

  final List<String> tinhList = ['Hà Nội', 'TP. HCM', 'Đà Nẵng'];
  final List<String> huyenList = ['Quận 1', 'Quận 3', 'Quận 5'];
  final List<String> xaList = ['Phường A', 'Phường B', 'Phường C'];

  String? selectedTinh;
  String? selectedHuyen;
  String? selectedXa;

  void _handleSubmit() {
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        detailController.text.isEmpty ||
        selectedTinh == null ||
        selectedHuyen == null ||
        selectedXa == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Vui lòng điền đầy đủ thông tin")));
      return;
    }

    final address = Address(
      name: nameController.text,
      phone: phoneController.text,
      addressType: selectedAddressType,
      tinh: selectedTinh!,
      huyen: selectedHuyen!,
      xa: selectedXa!,
      detail: detailController.text,
      note: noteController.text,
      isDefault: isDefault,
    );

    Provider.of<AddressProvider>(context, listen: false).addAddress(address);
    Navigator.pop(context, address);
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    detailController.dispose();
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Thêm địa chỉ mới",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionLabel("Liên hệ"),
            _inputField("Tên người nhận", nameController),
            _inputField("Số điện thoại", phoneController),
            SizedBox(height: 16),
            _sectionLabel("Địa chỉ"),
            _dropdownField("Loại địa chỉ", selectedAddressType, addressTypes),
            _inputSelector("Tỉnh/Thành phố", selectedTinh, () {
              _showSelectLocationModal(
                title: "Chọn Tỉnh/Thành phố",
                items: tinhList,
                onSelected: (value) {
                  setState(() {
                    selectedTinh = value;
                    selectedHuyen = null;
                    selectedXa = null;
                  });
                },
              );
            }),
            _inputSelector("Quận/Huyện", selectedHuyen, () {
              _showSelectLocationModal(
                title: "Chọn Quận/Huyện",
                items: huyenList,
                onSelected: (value) {
                  setState(() {
                    selectedHuyen = value;
                    selectedXa = null;
                  });
                },
              );
            }),
            _inputSelector("Xã/Phường", selectedXa, () {
              _showSelectLocationModal(
                title: "Chọn Xã/Phường",
                items: xaList,
                onSelected: (value) {
                  setState(() {
                    selectedXa = value;
                  });
                },
              );
            }),
            _inputField("Tên đường, Tòa nhà, Số nhà", detailController),
            _inputField("Ghi chú khác", noteController),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Đặt làm địa chỉ mặc định",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Switch(
                  value: isDefault,
                  onChanged: (value) {
                    setState(() => isDefault = value);
                  },
                  activeColor: Color(0xFFC49B6C),
                ),
              ],
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: _handleSubmit,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: Color(0xFFE9DDCE),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    "Hoàn thành",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String title) => Container(
        width: double.infinity,
        color: Colors.grey.shade200,
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      );

  Widget _inputField(String label, TextEditingController controller) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ],
      );

  Widget _dropdownField(
          String label, String selectedValue, List<String> options) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedValue,
                isExpanded: true,
                icon: Icon(Icons.keyboard_arrow_down),
                items: options
                    .map((type) =>
                        DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) =>
                    setState(() => selectedAddressType = value!),
              ),
            ),
          ),
        ],
      );

  Widget _inputSelector(String label, String? value, VoidCallback onTap) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 12),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 6),
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade400),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                value ?? "Chọn $label",
                style: TextStyle(
                  color: value == null ? Colors.grey : Colors.black,
                ),
              ),
            ),
          ),
        ],
      );

  void _showSelectLocationModal({
    required String title,
    required List<String> items,
    required Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            SizedBox(height: 12),
            ...items.map(
              (item) => ListTile(
                title: Text(item),
                onTap: () {
                  Navigator.pop(context);
                  onSelected(item);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
