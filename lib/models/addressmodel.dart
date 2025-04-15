import 'address.dart';

class AddressModel {
  final String name;
  final String phone;
  final String province;
  final String district;
  final String ward;
  final String street;

  AddressModel({
    required this.name,
    required this.phone,
    required this.province,
    required this.district,
    required this.ward,
    required this.street,
    required id,
    required fullAddress,
  });

  @override
  String toString() {
    return '$street, $ward, $district, $province';
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'province': province,
      'district': district,
      'ward': ward,
      'street': street,
    };
  }

  factory AddressModel.fromMap(Map<String, dynamic> map) {
    return AddressModel(
      name: map['name'] ?? '',
      phone: map['phone'] ?? '',
      province: map['province'] ?? '',
      district: map['district'] ?? '',
      ward: map['ward'] ?? '',
      street: map['street'] ?? '',
      id: null,
      fullAddress: null,
    );
  }

  get result => null;

  get id => null;

  get fullAddress => null;

  /// ✅ Hàm chuyển đổi sang Address
  Address toAddress({
    String addressType = 'Home',
    String note = '',
    bool isDefault = false,
  }) {
    return Address(
      name: name,
      phone: phone,
      addressType: addressType,
      tinh: province,
      huyen: district,
      xa: ward,
      detail: street,
      note: note,
      isDefault: isDefault,
    );
  }
}
