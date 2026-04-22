import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/katinat_app_bar.dart';
import '../widgets/katinat_footer.dart';

class OrdersHistoryScreen extends StatefulWidget {
  const OrdersHistoryScreen({super.key});

  @override
  State<OrdersHistoryScreen> createState() => _OrdersHistoryScreenState();
}

class _OrdersHistoryScreenState extends State<OrdersHistoryScreen> {
  List<dynamic> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await Provider.of<AuthProvider>(context, listen: false).fetchMyOrders();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const Color katinatBlue = Color(0xFF132A38);
    const Color katinatGold = Color(0xFFD3A374);

    return Scaffold(
      appBar: const KatinatAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(40.0),
              child: Column(
                children: [
                  Text(
                    'LỊCH SỬ ĐẶT HÀNG',
                    style: GoogleFonts.barlowCondensed(fontSize: 48, fontWeight: FontWeight.bold, color: katinatBlue),
                  ),
                  const SizedBox(height: 10),
                  Text('Theo dõi và quản lý các đơn hàng đã đặt của bạn', style: GoogleFonts.montserrat(color: Colors.grey[600])),
                ],
              ),
            ),
            if (_isLoading)
              const Center(child: Padding(padding: EdgeInsets.all(50.0), child: CircularProgressIndicator()))
            else if (_orders.isEmpty)
              Padding(
                padding: const EdgeInsets.all(100.0),
                child: Column(
                  children: [
                    Icon(Icons.receipt_long_outlined, size: 80, color: Colors.grey[300]),
                    const SizedBox(height: 20),
                    const Text('Bạn chưa có đơn hàng nào.'),
                  ],
                ),
              )
            else
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _orders.length,
                    itemBuilder: (context, index) {
                      final o = _orders[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 16),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('Đơn hàng #${o['id']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                                  _buildStatusChip(o['status']),
                                ],
                              ),
                              const Divider(),
                              Text('Ngày đặt: ${o['created_at'].toString().split('T')[0]}'),
                              Text('Tổng tiền: ${o['total_price']}đ', style: const TextStyle(color: katinatGold, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 10),
                              const Text('Sản phẩm:', style: TextStyle(fontWeight: FontWeight.w600)),
                              if (o['items'] != null)
                                ... (o['items'] as List).map((item) => Padding(
                                  padding: const EdgeInsets.only(left: 10, top: 4),
                                  child: Text('• ${item['name']} x ${item['quantity']} (${item['price']}đ)'),
                                )),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            const KatinatFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color color = Colors.grey;
    if (status == 'Hoàn tất') color = Colors.green;
    if (status == 'Đang giao') color = Colors.blue;
    if (status == 'pending') color = Colors.orange;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: color)),
      child: Text(status, style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.bold)),
    );
  }
}
