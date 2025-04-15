import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// ignore: depend_on_referenced_packages
import 'package:image_picker/image_picker.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String avatarUrl = '';
  String selectedGender = 'Nam';
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _loadUserData();
    _nameController.text = "";
    _saveUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    print("Tên người dùng đã lưu: ${prefs.getString('username')}");
    setState(() {
      _nameController.text = prefs.getString('username') ?? ''; // ✅
      _phoneController.text = prefs.getString('phoneNumber') ?? '';
      avatarUrl = prefs.getString('avatarUrl') ?? 'assets/images/duong.jpg';
      selectedGender = prefs.getString('gender') ?? 'Nam';
      if (File(avatarUrl).existsSync()) {
        _imageFile = File(avatarUrl);
      }
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', _nameController.text);
    await prefs.setString('phoneNumber', _phoneController.text);
    await prefs.setString('gender', selectedGender);
    if (_imageFile != null) {
      await prefs.setString('avatarUrl', _imageFile!.path);
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Cập nhật thành công!')));
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
        avatarUrl = pickedImage.path;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            const SizedBox(height: 8),
            _buildAvatarSection(),
            const SizedBox(height: 24),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLabel("Số điện thoại *"),
                    _buildPhoneField(_phoneController),
                    const SizedBox(height: 8),
                    const Text(
                      "Xác thực",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF1F4352),
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildLabel("Họ và tên *"),
                    _buildEditableTextField(_nameController),
                    const SizedBox(height: 16),
                    _buildLabel("Giới tính *"),
                    _buildGenderDropdown(),
                    const SizedBox(height: 24),
                    const Divider(),
                    const SizedBox(height: 8),
                    _buildOtherInfoSection(),
                    const SizedBox(height: 24),
                    _buildUpdateButton(),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.remove('username');
                        await prefs.remove('phoneNumber');
                        await prefs.remove('avatarUrl');
                        await prefs.remove('gender');
                        setState(() {
                          _nameController.clear();
                          _phoneController.clear();
                          _imageFile = null;
                          avatarUrl = 'assets/images/duong.jpg';
                          selectedGender = 'Nam';
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Đã xoá dữ liệu người dùng'),
                          ),
                        );
                      },
                      child: const Text(
                        "🧹 Xoá dữ liệu người dùng",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFFB68F64),
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),

                    _buildDeleteAccountButton(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF1F4352)),
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 8),
          const Text(
            'Chỉnh sửa trang cá nhân',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F4352),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarSection() {
    ImageProvider avatarImage;

    if (_imageFile != null) {
      avatarImage = FileImage(_imageFile!);
    } else if (avatarUrl.isNotEmpty && avatarUrl.startsWith('http')) {
      avatarImage = NetworkImage(avatarUrl);
    } else if (avatarUrl.isNotEmpty) {
      avatarImage = AssetImage(avatarUrl);
    } else {
      avatarImage = const AssetImage('assets/images/duong.jpg');
    }

    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: CircleAvatar(radius: 48, backgroundImage: avatarImage),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: _pickImage,
          child: const Text(
            'Đổi ảnh đại diện',
            style: TextStyle(fontSize: 14, color: Color(0xFF1F4352)),
          ),
        ),
      ],
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        color: Color(0xFF1F4352),
      ),
    );
  }

  Widget _buildPhoneField(TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.phone,
        style: const TextStyle(fontSize: 16),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Nhập số điện thoại',
        ),
      ),
    );
  }

  Widget _buildEditableTextField(TextEditingController controller) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(fontSize: 16, color: Color(0xFF4A4A4A)),
        decoration: const InputDecoration(
          border: InputBorder.none,
          hintText: 'Nhập họ và tên',
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      height: 50,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButton<String>(
        value: selectedGender,
        isExpanded: true,
        underline: const SizedBox(),
        icon: const Icon(Icons.keyboard_arrow_down),
        items:
            ['Nam', 'Nữ', 'Khác']
                .map(
                  (gender) =>
                      DropdownMenuItem(value: gender, child: Text(gender)),
                )
                .toList(),
        onChanged: (value) {
          if (value != null) {
            setState(() {
              selectedGender = value;
            });
          }
        },
      ),
    );
  }

  Widget _buildOtherInfoSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "THÔNG TIN KHÁC",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F4352),
              ),
            ),
            Text(
              "Mở rộng",
              style: TextStyle(
                color: Color(0xFFB68F64),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          "SỞ THÍCH",
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1F4352),
          ),
        ),
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFF1F4352),
            ),
            child: const Icon(Icons.edit, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildUpdateButton() {
    return GestureDetector(
      onTap: _saveUserData,
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: const Color(0xFFE8D9C4),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Text(
          "Cập nhật",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Color(0xFF1F4352),
          ),
        ),
      ),
    );
  }

  Widget _buildDeleteAccountButton() {
    return TextButton(
      onPressed: () {
        // TODO: xử lý xóa tài khoản
      },
      child: const Text(
        "Xóa tài khoản",
        style: TextStyle(
          fontSize: 14,
          color: Color(0xFF4A4A4A),
          decoration: TextDecoration.underline,
        ),
      ),
    );
  }
}
