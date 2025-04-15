import 'package:app_tuan89/models/address.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:app_tuan89/screens/AddNewAddressScreen.dart';

class AddressProvider extends ChangeNotifier {
  List<Address> _addresses = [];
  Address? _selectedAddress;

  // Getter danh sách địa chỉ
  List<Address> get addresses => List.unmodifiable(_addresses);

  // Getter địa chỉ được chọn
  Address? get selectedAddress => _selectedAddress;

  // Thêm địa chỉ mới
  void addAddress(Address address) {
    if (address.isDefault) {
      _addresses = _addresses.map((addr) => addr.copyWith(isDefault: false)).toList();
      _selectedAddress = address;
    }

    bool isDuplicate = _addresses.any((a) => a.toString() == address.toString());
    if (!isDuplicate) {
      _addresses.add(address);
    }

    saveAddressesToPrefs();
    notifyListeners();
  }

  // Chọn một địa chỉ đơn giản (không cập nhật mặc định)
  void selectAddressSimple(Address address) {
    _selectedAddress = address;
    saveAddressesToPrefs();
    notifyListeners();
  }

  // Chọn một địa chỉ và cập nhật trạng thái mặc định
  void selectAddress(Address address) {
    _selectedAddress = address;

    _addresses = _addresses.map((addr) {
      return addr == address
          ? addr.copyWith(isDefault: true)
          : addr.copyWith(isDefault: false);
    }).toList();

    saveAddressesToPrefs();
    notifyListeners();
  }

  // Cập nhật địa chỉ được chọn
  void setSelectedAddress(Address address) {
    _selectedAddress = address;
    saveAddressesToPrefs();
    notifyListeners();
  }

  // Xoá địa chỉ
  void removeAddress(Address address) {
    _addresses.remove(address);
    if (_selectedAddress == address) {
      _selectedAddress = null;
    }
    saveAddressesToPrefs();
    notifyListeners();
  }

  // Reset danh sách địa chỉ
  void clearAddresses() {
    _addresses.clear();
    _selectedAddress = null;
    saveAddressesToPrefs();
    notifyListeners();
  }

  // Lưu vào SharedPreferences
  Future<void> saveAddressesToPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final addressList = _addresses.map((e) => e.toMap()).toList();
    await prefs.setString('address_list', jsonEncode(addressList));

    if (_selectedAddress != null) {
      await prefs.setString('selected_address', jsonEncode(_selectedAddress!.toMap()));
    }
  }

  // Load từ SharedPreferences
  Future<void> loadAddressesFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final addressJson = prefs.getString('address_list');
    if (addressJson != null) {
      final List<dynamic> decoded = jsonDecode(addressJson);
      _addresses = decoded.map((e) => Address.fromMap(e)).toList();
    }

    final selectedJson = prefs.getString('selected_address');
    if (selectedJson != null) {
      _selectedAddress = Address.fromMap(jsonDecode(selectedJson)) as Address?;
    }

    notifyListeners();
  }
}
