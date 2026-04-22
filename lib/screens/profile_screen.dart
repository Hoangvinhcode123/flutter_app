import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/katinat_app_bar.dart';
import '../widgets/katinat_footer.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  late TextEditingController _birthdayController;
  String _selectedGender = 'Nam';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    _nameController = TextEditingController(text: user?['name'] ?? '');
    _phoneController = TextEditingController(text: user?['phone'] ?? '');
    _emailController = TextEditingController(text: user?['email'] ?? '');
    _birthdayController = TextEditingController(text: user?['birthday'] != null ? user!['birthday'].toString().split('T')[0] : '');
    _selectedGender = user?['gender'] ?? 'Nam';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _birthdayController.dispose();
    super.dispose();
  }

  void _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      await Provider.of<AuthProvider>(context, listen: false).updateProfile({
        'name': _nameController.text,
        'phone': _phoneController.text,
        'birthday': _birthdayController.text,
        'gender': _selectedGender,
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cập nhật thông tin thành công!', style: TextStyle(color: Colors.white)), backgroundColor: Colors.green));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}'), backgroundColor: Colors.red));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
            Container(
              padding: const EdgeInsets.symmetric(vertical: 40),
              color: katinatBlue,
              width: double.infinity,
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: katinatGold,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _nameController.text,
                    style: GoogleFonts.barlowCondensed(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    _emailController.text,
                    style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 600),
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(32.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('CÀI ĐẶT TÀI KHOẢN', style: GoogleFonts.barlowCondensed(fontSize: 24, fontWeight: FontWeight.bold, color: katinatBlue)),
                            const Divider(),
                            const SizedBox(height: 20),
                            _buildTextField('Họ và Tên', _nameController, Icons.person_outline),
                            const SizedBox(height: 20),
                            _buildTextField('Số điện thoại', _phoneController, Icons.phone_outlined),
                            const SizedBox(height: 20),
                            _buildTextField(
                              'Ngày sinh', 
                              _birthdayController, 
                              Icons.cake_outlined,
                              readOnly: true,
                              onTap: () async {
                                final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: _birthdayController.text.isNotEmpty ? DateTime.tryParse(_birthdayController.text) ?? DateTime(2000) : DateTime(2000),
                                  firstDate: DateTime(1950),
                                  lastDate: DateTime.now(),
                                );
                                if (picked != null) {
                                  setState(() {
                                    _birthdayController.text = picked.toIso8601String().split('T')[0];
                                  });
                                }
                              },
                            ),
                            const SizedBox(height: 20),
                            Text('Giới tính', style: GoogleFonts.montserrat(fontWeight: FontWeight.w600)),
                            Row(
                              children: [
                                Radio<String>(value: 'Nam', groupValue: _selectedGender, onChanged: (v) => setState(() => _selectedGender = v!)),
                                const Text('Nam'),
                                const SizedBox(width: 20),
                                Radio<String>(value: 'Nữ', groupValue: _selectedGender, onChanged: (v) => setState(() => _selectedGender = v!)),
                                const Text('Nữ'),
                              ],
                            ),
                            const SizedBox(height: 40),
                            const Text('TIỆN ÍCH', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            const SizedBox(height: 16),
                            _buildQuickLink(context, 'Lịch sử đơn hàng', Icons.list_alt, '/orders'),
                            _buildQuickLink(context, 'Thông báo', Icons.notifications_none_outlined, '/notifications'),
                            _buildQuickLink(context, 'Danh sách yêu thích', Icons.favorite_outline, '/wishlist'),
                            const SizedBox(height: 40),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: _isLoading ? null : _saveProfile,
                                style: ElevatedButton.styleFrom(backgroundColor: katinatGold, padding: const EdgeInsets.symmetric(vertical: 16)),
                                child: _isLoading 
                                  ? const CircularProgressIndicator(color: Colors.black)
                                  : const Text('LƯU THÔNG TIN', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                              ),
                            ),
                            const SizedBox(height: 16),
                             SizedBox(
                               width: double.infinity,
                               child: OutlinedButton(
                                 onPressed: () {
                                   Provider.of<AuthProvider>(context, listen: false).logout();
                                   Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
                                 },
                                 style: OutlinedButton.styleFrom(
                                   side: const BorderSide(color: Colors.red),
                                   padding: const EdgeInsets.symmetric(vertical: 16),
                                 ),
                                 child: const Text('ĐĂNG XUẤT', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                               ),
                             ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 ),
               ),
             ),
            const KatinatFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon, {bool readOnly = false, VoidCallback? onTap}) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: const Color(0xFFD3A374)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
    );
  }

  Widget _buildQuickLink(BuildContext context, String title, IconData icon, String route) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF132A38)),
      title: Text(title, style: GoogleFonts.montserrat(fontSize: 14, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, size: 20),
      onTap: () => Navigator.pushNamed(context, route),
      contentPadding: EdgeInsets.zero,
      visualDensity: VisualDensity.compact,
    );
  }
}
