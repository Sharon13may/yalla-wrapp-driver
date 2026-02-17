import 'package:get/get.dart';

class AddonModel {
  final String addonId;
  final String name;
  final String price;
  RxBool isSelected = false.obs;

  AddonModel({
    required this.addonId,
    required this.name,
    required this.price,
  });

  factory AddonModel.fromJson(Map<String, dynamic> json) {
    return AddonModel(
      addonId: json['addonId'] ?? '',
      name: json['name'] ?? '',
      price: json['price'] ?? '',
    );
  }
}
