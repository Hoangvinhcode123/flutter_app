import 'package:app_tuan89/models/address.dart';
import 'package:app_tuan89/models/address.dart' as AddNewAddressScreenAlias;
import 'package:app_tuan89/screens/OrderConfirmationScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:app_tuan89/screens/AddNewAddressScreen.dart'
    as AddNewAddressScreenAlias;
import 'package:app_tuan89/providers/addressprovider.dart'
    as AddressProviderAlias;

class AddressSelectionScreen extends StatelessWidget {
  const AddressSelectionScreen({super.key});
  
  static BuildContext? get context => null;

  @override
  Widget build(BuildContext context) {
    final addressProvider = Provider.of<AddressProviderAlias.AddressProvider>(
      context,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: const Icon(Icons.arrow_back, color: Colors.black),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Nhập địa chỉ",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                        color: Color(0xFF1E2C3A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 28),
              ],
            ),
            const SizedBox(height: 16),

            // Search bar
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF6F6F6),
                borderRadius: BorderRadius.circular(24),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Nhập địa chỉ tìm kiếm',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2C3A),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // From map
            const Text(
              'Từ bản đồ',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E2C3A),
              ),
            ),
            const SizedBox(height: 12),
            Column(
              children: [
                _buildMapOptionTile(
                  icon: Icons.send_rounded,
                  label: 'Địa chỉ của bạn',
                  onTap: () {},
                ),
                const SizedBox(height: 8),
                _buildMapOptionTile(
                  icon: Icons.map_outlined,
                  label: 'Chọn trên bản đồ',
                  trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Saved addresses
            const Text(
              'Địa chỉ đã lưu',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E2C3A),
              ),
            ),
            const SizedBox(height: 12),

            if (addressProvider.addresses.isEmpty)
              Column(
                children: [
                  _buildSavedAddressItem(
                    context,
                    AddNewAddressScreenAlias.Address(
                      name: 'Nguyễn Văn A',
                      phone: '0123456789',
                      detail: '123 Lê Lợi, Quận 1, TP.HCM', addressType: '', tinh: '', huyen: '', xa: '', note: '', isDefault: false,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _buildSavedAddressItem(
                    context,
                    AddNewAddressScreenAlias.Address(
                      name: 'Trần Thị B',
                      phone: '0987654321',
                      detail: '456 Trần Hưng Đạo, Quận 5, TP.HCM', note: '', isDefault: false, xa: '', addressType: '', tinh: '', huyen: '',
                    ),
                  ),
                ],
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: addressProvider.addresses.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (context, index) {
                  final address = addressProvider.addresses[index];
                  return _buildSavedAddressItem(context, address);
                },
              ),

            const SizedBox(height: 16),

            // Add new address
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddNewAddressScreenAlias.AddNewAddressScreen(),
                  ),
                );
                if (result != null &&
                    result is AddNewAddressScreenAlias.Address) {
                  addressProvider.addAddress(result);
                }
              },
              child: Row(
                children: const [
                  Icon(Icons.add, color: Color(0xFF1E2C3A)),
                  SizedBox(width: 8),
                  Text(
                    'Thêm địa chỉ mới',
                    style: TextStyle(
                      color: Color(0xFF1E2C3A),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
          ),
        ),
      );
    }
  }

  Widget _buildSavedAddressItem(
    BuildContext context,
    AddNewAddressScreenAlias.Address address,
  ) {
    final addressProvider = Provider.of<AddressProviderAlias.AddressProvider>(
      context,
      listen: false,
    );

    return InkWell(
      onTap: () {
        addressProvider.setSelectedAddress(address);
        Navigator.pop(context, address);
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F6F6),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.location_on_outlined, color: Color(0xFF1E2C3A)),
                SizedBox(width: 8),
                Text(
                  "Địa chỉ",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E2C3A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              address.detail,
              style: const TextStyle(fontSize: 14, color: Color(0xFF1E2C3A)),
            ),
            const SizedBox(height: 4),
            Text(
              '${address.name} • ${address.phone}',
              style: const TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapOptionTile({
    required IconData icon,
    required String label,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return InkWell(
  onTap: () {
    var context;
    Navigator.push(
      context!,
      MaterialPageRoute(
        builder: (context) => OrderConfirmationScreen(),
      ),
    );
  },
  child: Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey.shade100,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.location_on_outlined, color: Colors.black87),
            SizedBox(width: 8),
            Text('Địa chỉ', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          '123 Lê Lợi, Quận 1, TP.HCM',
          style: TextStyle(fontSize: 16),
        ),
        const SizedBox(height: 4),
        const Text(
          'Nguyễn Văn A • 0123456789',
          style: TextStyle(color: Colors.grey),
        ),
      ],
    ),
  ),
);
}
