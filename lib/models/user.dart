enum UserRole {
  SUPER_ADMIN,
  ADMIN,
  MANAGER,
  USER,
}

class User {
  final String id;
  final UserRole role;
  final String fullName;
  final String email;
  final String passwordHash;
  final String phoneNumber;
  final String avatarUrl;
  final bool isVerified;
  final bool isActive;
  final DateTime? lastLoginAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? createdBy; // Foreign key back to User.id (chỉ ai cấp quyền cho)

  const User({
    required this.id,
    this.role = UserRole.USER,
    required this.fullName,
    required this.email,
    required this.passwordHash,
    this.phoneNumber = '',
    this.avatarUrl = '',
    this.isVerified = false,
    this.isActive = true,
    this.lastLoginAt,
    required this.createdAt,
    required this.updatedAt,
    this.createdBy,
  });

  // Có thể parse JSON sang từ REST API trong tương lai
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? '',
      role: UserRole.values.firstWhere(
        (e) => e.toString().split('.').last == json['role'],
        orElse: () => UserRole.USER,
      ),
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      passwordHash: json['password_hash'] ?? '',
      phoneNumber: json['phone_number'] ?? '',
      avatarUrl: json['avatar_url'] ?? '',
      isVerified: json['is_verified'] ?? false,
      isActive: json['is_active'] ?? true,
      lastLoginAt: json['last_login_at'] != null ? DateTime.parse(json['last_login_at']) : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      createdBy: json['created_by'],
    );
  }
}
