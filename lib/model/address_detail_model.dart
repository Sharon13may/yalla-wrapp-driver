class AddressDetailModel {
  final String addressType;
  final String phone;
  final String postalCode;
  final String municipality;
  final String area;
  final String street;
  final String zone;
  final String unit;
  final String building;
  final String landmark;

  AddressDetailModel({
    required this.addressType,
    required this.phone,
    required this.postalCode,
    required this.municipality,
    required this.area,
    required this.street,
    required this.zone,
    required this.unit,
    required this.building,
    required this.landmark,
  });

  factory AddressDetailModel.fromJson(Map<String, dynamic> json) {
    return AddressDetailModel(
      addressType: json['addressType'] ?? '',
      phone: json['phone'] ?? '',
      postalCode: json['postalCode'] ?? '',
      municipality: json['municipality'] ?? '',
      area: json['area'] ?? '',
      street: json['street'] ?? '',
      zone: json['zone'] ?? '',
      unit: json['unit'] ?? '',
      building: json['building'] ?? '',
      landmark: json['landmark'] ?? '',
    );
  }

  /// Combined address line
  String get fullAddress {
    return [
      building,
      unit,
      street,
      area,
      zone,
      municipality,
      landmark,
    ].where((e) => e.isNotEmpty).join(', ');
  }
}
