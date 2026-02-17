class AddressModel {
  final String addressId;
  final String? addressType;
  final String? phone;
  final String? municipality;
  final String? area;
  final String? street;
  final String? zone;
  final String? unit;
  final String? building;
  final String? landmark;
  final String? postalCode;
  final String? latitude;
  final String? longitude;
  final String? bluePlateLink;
  final String createdAt;

  AddressModel({
    required this.addressId,
    this.addressType,
    this.phone,
    this.municipality,
    this.area,
    this.street,
    this.zone,
    this.unit,
    this.building,
    this.landmark,
    this.postalCode,
    this.latitude,
    this.longitude,
    this.bluePlateLink,
    required this.createdAt,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
      addressId: json["addressId"] ?? "",
      phone: json["phone"],
      addressType: json["addressType"],
      municipality: json["municipality"],
      area: json["area"],
      street: json["street"],
      zone: json["zone"],
      unit: json["unit"],
      building: json["building"],
      landmark: json["landmark"],
      postalCode: json["postalCode"],
      latitude: json["latitude"],
      longitude: json["longitude"],
      bluePlateLink: json["bluePlateLink"], 
      createdAt: json["createdAt"] ?? "",
    );
  }
}


// class AddressModel {
//   final String addressId;
//   final String? addressType;
//   final String? phone;
//   final String? municipality;
//   final String? area;
//   final String? street;
//   final String? zone;
//   final String? unit;
//   final String? building;
//   final String? landmark;
//   final String createdAt;

//   AddressModel({
//     required this.addressId,
//     this.addressType,
//     this.phone,
//     this.municipality,
//     this.area,
//     this.street,
//     this.zone,
//     this.unit,
//     this.building,
//     this.landmark,
//     required this.createdAt,
//   });

//   factory AddressModel.fromJson(Map<String, dynamic> json) {
//     return AddressModel(
//       addressId: json["addressId"],
//       phone : json['phone'],
//       addressType: json["addressType"],
//       municipality: json["municipality"],
//       area: json["area"],
//       street: json["street"],
//       zone: json["zone"],
//       unit: json["unit"],
//       building: json["building"],
//       landmark: json["landmark"],
//       createdAt: json["createdAt"],
//     );
//   }
// }
