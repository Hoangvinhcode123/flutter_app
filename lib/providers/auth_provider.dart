import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  String? _token;
  Map<String, dynamic>? _rawUser;

  User? get currentUser => _currentUser;
  String? get token => _token;
  Map<String, dynamic>? get user => _rawUser;
  
  bool get isAuthenticated => _currentUser != null;
  bool get isLoggedIn => isAuthenticated;
  bool get isAdmin => _currentUser?.role == UserRole.ADMIN || _currentUser?.role == UserRole.SUPER_ADMIN;

  Future<void> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('http://localhost:3000/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token = data['token'];
        _rawUser = data['user'];
        _currentUser = _mapUser(_rawUser!);

        // Save to Local Storage
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await prefs.setString('user_data', json.encode(_rawUser));
        
        notifyListeners();
      } else {
        throw Exception(json.decode(response.body)['message'] ?? 'Login failed');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('token')) return false;

    _token = prefs.getString('token');
    final userData = json.decode(prefs.getString('user_data')!);
    _rawUser = userData;
    _currentUser = _mapUser(_rawUser!);
    
    notifyListeners();
    return true;
  }

  User _mapUser(Map<String, dynamic> data) {
    return User(
      id: data['id'].toString(),
      role: data['role'] == 'ADMIN' ? UserRole.ADMIN : (data['role'] == 'SUPER_ADMIN' ? UserRole.SUPER_ADMIN : UserRole.USER),
      fullName: data['name'],
      email: data['email'],
      passwordHash: '',
      createdAt: DateTime.parse(data['created_at'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.now(),
    );
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    final response = await http.put(
      Uri.parse('http://localhost:3000/api/auth/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $_token',
      },
      body: json.encode(data),
    );

    if (response.statusCode == 200) {
      _rawUser = json.decode(response.body)['user'];
      _currentUser = _mapUser(_rawUser!);
      
      // Update Local Storage
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_data', json.encode(_rawUser));
      
      notifyListeners();
    } else {
      throw Exception(json.decode(response.body)['message'] ?? 'Cập nhật thất bại');
    }
  }

  Future<List<dynamic>> fetchMyOrders() async {
    final response = await http.get(
      Uri.parse('http://localhost:3000/api/orders'),
      headers: {'Authorization': 'Bearer $_token'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Không thể tải lịch sử đơn hàng');
    }
  }

  void logout() async {
    _currentUser = null;
    _token = null;
    _rawUser = null;
    
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('user_data');
    
    notifyListeners();
  }
}
