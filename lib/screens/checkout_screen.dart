import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../providers/cart_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/katinat_app_bar.dart';
import '../widgets/katinat_footer.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'Tiền mặt';
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _voucherController = TextEditingController();
  
  bool _isOrdering = false;
  bool _showQR = false;
  int? _lastOrderId;
  double _discount = 0;
  String? _appliedVoucher;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    if (user != null) {
      _nameController.text = user['name'] ?? '';
      _phoneController.text = user['phone'] ?? '';
    }
  }

  Future<void> _validateVoucher(double total) async {
    if (_voucherController.text.isEmpty) return;
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/promotions/validate'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'code': _voucherController.text, 'total_price': total * 1000}),
      );

      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['valid'] == true) {
        setState(() {
          _discount = double.parse(data['discount'].toString()) / 1000;
          _appliedVoucher = _voucherController.text;
        });
        if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Áp dụng mã giảm giá thành công!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green));
      } else {
        throw Exception(data['message'] ?? 'Mã không hợp lệ');
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString().replaceAll('Exception: ', '')), backgroundColor: Colors.red));
    }
  }

  void _handlePlaceOrder() async {
    if (_nameController.text.isEmpty || _phoneController.text.isEmpty || _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Vui lòng nhập đủ thông tin giao hàng')));
      return;
    }

    setState(() => _isOrdering = true);
    final cart = Provider.of<CartProvider>(context, listen: false);
    final auth = Provider.of<AuthProvider>(context, listen: false);

    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/orders'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${auth.token}',
        },
        body: json.encode({
          'items': cart.items.map((i) => {
            'product_id': int.parse(i.productId.replaceAll('p', '')),
            'name': i.name,
            'price': i.unitPrice,
            'quantity': i.quantity,
          }).toList(),
          'payment_method': _selectedPaymentMethod,
          'note': 'Giao tới: ${_addressController.text}',
          'promo_code': _appliedVoucher,
        }),
      );

      if (response.statusCode == 201) {
        final data = json.decode(response.body);
        _lastOrderId = data['order']['id'];
        
        if (_selectedPaymentMethod == 'Tiền mặt') {
          _showSuccessDialog();
        } else {
          setState(() {
            _showQR = true;
            _isOrdering = false;
          });
        }
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 'Lỗi đặt hàng');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}'), backgroundColor: Colors.red));
      }
      setState(() => _isOrdering = false);
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Đặt hàng thành công'),
        content: const Text('Đơn hàng của bạn đã được ghi nhận. Chúng tôi sẽ sớm liên hệ!'),
        actions: [
          TextButton(
            onPressed: () {
              Provider.of<CartProvider>(context, listen: false).clearCart();
              Navigator.of(context).pushNamedAndRemoveUntil('/', (route) => false);
            },
            child: const Text('Về trang chủ'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const Color katinatBlue = Color(0xFF132A38);
    const Color katinatGold = Color(0xFFD3A374);
    final cart = Provider.of<CartProvider>(context);
    final subtotal = cart.totalAmount;
    final finalTotal = subtotal - _discount;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const KatinatAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'THANH TOÁN',
                    style: GoogleFonts.barlowCondensed(color: katinatBlue, fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 32),
                  if (_showQR) _buildQRView(finalTotal) else _buildCheckoutForm(subtotal, finalTotal, katinatBlue, katinatGold),
                ],
              ),
            ),
            const KatinatFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckoutForm(double subtotal, double finalTotal, Color katinatBlue, Color katinatGold) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('THÔNG TIN GIAO HÀNG'),
              const SizedBox(height: 16),
              _buildTextField('Họ và tên', _nameController),
              const SizedBox(height: 16),
              _buildTextField('Số điện thoại', _phoneController),
              const SizedBox(height: 16),
              _buildTextField('Địa chỉ chi tiết', _addressController),
              const SizedBox(height: 32),
              _buildSectionTitle('PHƯƠNG THỨC THANH TOÁN'),
              const SizedBox(height: 16),
              _buildPaymentOption('Tiền mặt', Icons.money),
              _buildPaymentOption('Ví Momo', Icons.account_balance_wallet),
              _buildPaymentOption('Ngân hàng MB Bank', Icons.account_balance),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 1,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                color: Colors.grey[50],
                child: Column(
                  children: [
                    _buildSectionTitle('MÃ GIẢM GIÁ'),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _voucherController,
                            decoration: const InputDecoration(hintText: 'Nhập mã...', border: OutlineInputBorder(), contentPadding: EdgeInsets.symmetric(horizontal: 10)),
                          ),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () => _validateVoucher(subtotal),
                          style: ElevatedButton.styleFrom(backgroundColor: katinatGold),
                          child: const Text('ÁP DỤNG', style: TextStyle(color: Colors.black, fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(24),
                color: Colors.grey[50],
                child: Column(
                  children: [
                    _buildSectionTitle('TÓM TẮT ĐƠN HÀNG'),
                    const Divider(),
                    _buildPriceRow('Tạm tính', '${subtotal.toStringAsFixed(0)}.000đ'),
                    if (_discount > 0) _buildPriceRow('Giảm giá', '-${_discount.toStringAsFixed(0)}.000đ', color: Colors.green),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Tổng cộng', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text('${finalTotal.toStringAsFixed(0)}.000đ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFFD3A374))),
                      ],
                    ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isOrdering ? null : _handlePlaceOrder,
                        style: ElevatedButton.styleFrom(backgroundColor: katinatBlue, padding: const EdgeInsets.symmetric(vertical: 16)),
                        child: _isOrdering 
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('XÁC NHẬN ĐẶT HÀNG', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }



  Widget _buildQRView(double total) {
    final amountInt = total.toInt();
    final description = 'THANHTOAN DONHANG ${_lastOrderId}';
    
    // Thông tin tài khoản thật của ông
    const String myAccount = '0817713006';
    const String myName = 'TRAN DUONG HOANG VINH';

    if (_selectedPaymentMethod == 'Ví Momo') {
      return _buildStaticQRView('assets/images/momo_qr.jpg', amountInt);
    } else {
      // MB Bank VietQR - Đã cập nhật STK thật
      final qrUrl = 'https://img.vietqr.io/image/MB-$myAccount-compact.png?amount=${amountInt}&addInfo=${description}&accountName=${Uri.encodeComponent(myName)}';
      return _buildDynamicQRView(qrUrl, amountInt);
    }
  }

  Widget _buildDynamicQRView(String qrUrl, int amountInt) {
    return Center(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('THANH TOÁN ĐƠN HÀNG #$_lastOrderId', style: GoogleFonts.barlowCondensed(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(
                'Số tiền: ${amountInt.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ', 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(12)),
                child: Image.network(qrUrl, width: 250, height: 250),
              ),
              const SizedBox(height: 20),
              const Text('Vui lòng quét mã để hoàn tất thanh toán', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              _buildPayButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStaticQRView(String assetPath, int amountInt) {
    return Center(
      child: Card(
        elevation: 8,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('THANH TOÁN ĐƠN HÀNG #$_lastOrderId', style: GoogleFonts.barlowCondensed(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              Text(
                'Số tiền: ${amountInt.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ', 
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(border: Border.all(color: Colors.grey[200]!), borderRadius: BorderRadius.circular(12)),
                child: Image.asset(assetPath, width: 250, height: 450, fit: BoxFit.contain),
              ),
              const SizedBox(height: 20),
              const Text('Vui lòng quét mã và nhập đúng số tiền', style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 40),
              _buildPayButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPayButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _showSuccessDialog,
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: const EdgeInsets.symmetric(vertical: 16)),
        child: const Text('TÔI ĐÃ THANH TOÁN', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {Color? color}) {
    String formattedValue = value;
    if (value.contains('.000đ')) {
       final valStr = value.replaceAll('.000đ', '');
       final valInt = int.tryParse(valStr);
       if (valInt != null) {
         formattedValue = '${(valInt * 1000).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ';
       }
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label), Text(formattedValue, style: TextStyle(color: color, fontWeight: color != null ? FontWeight.bold : FontWeight.normal))]),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF132A38)));
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(controller: controller, decoration: InputDecoration(labelText: label, border: const OutlineInputBorder())),
    );
  }

  Widget _buildPaymentOption(String title, IconData icon) {
    bool isSelected = _selectedPaymentMethod == title;
    return GestureDetector(
      onTap: () => setState(() => _selectedPaymentMethod = title),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: isSelected ? const Color(0xFFD3A374) : Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? const Color(0xFFD3A374).withOpacity(0.05) : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? const Color(0xFFD3A374) : Colors.grey[600]),
            const SizedBox(width: 16),
            Text(title, style: GoogleFonts.montserrat(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            const Spacer(),
            if (isSelected) const Icon(Icons.check_circle, color: Color(0xFFD3A374)),
          ],
        ),
      ),
    );
  }
}
