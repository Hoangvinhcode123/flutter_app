class Address {
  final String name;
  final String phone;
  final String addressType;
  final String tinh;
  final String huyen;
  final String xa;
  final String detail;
  final String note;
  final bool isDefault;

  Address({
    required this.name,
    required this.phone,
    required this.addressType,
    required this.tinh,
    required this.huyen,
    required this.xa,
    required this.detail,
    required this.note,
    required this.isDefault,
  });

  /// Dùng để sao chép Address hiện tại, có thể thay đổi một số trường
  Address copyWith({
    String? name,
    String? phone,
    String? addressType,
    String? tinh,
    String? huyen,
    String? xa,
    String? detail,
    String? note,
    bool? isDefault,
  }) {
    return Address(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      addressType: addressType ?? this.addressType,
      tinh: tinh ?? this.tinh,
      huyen: huyen ?? this.huyen,
      xa: xa ?? this.xa,
      detail: detail ?? this.detail,
      note: note ?? this.note,
      isDefault: isDefault ?? this.isDefault,
    );
  }

  /// Lấy địa chỉ đầy đủ dạng chuỗi
  String get fullAddress => '$detail, $xa, $huyen, $tinh';

  /// Chuyển đối tượng thành Map để lưu trữ (vd: SharedPreferences, Firebase,...)
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'addressType': addressType,
      'tinh': tinh,
      'huyen': huyen,
      'xa': xa,
      'detail': detail,
      'note': note,
      'isDefault': isDefault,
    };
  }

  /// Tạo Address từ Map (vd: khi đọc từ SharedPreferences hoặc JSON)
  factory Address.fromMap(Map<String, dynamic> map) {
    return Address(
      name: map['name'],
      phone: map['phone'],
      addressType: map['addressType'],
      tinh: map['tinh'],
      huyen: map['huyen'],
      xa: map['xa'],
      detail: map['detail'],
      note: map['note'],
      isDefault: map['isDefault'],
    );
  }

  String? get phoneNumber => null;

  @override
  String toString() {
    return 'Address(name: $name, phone: $phone, address: $fullAddress, note: $note, isDefault: $isDefault)';
  }
}
