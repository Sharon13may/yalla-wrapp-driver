import 'package:get/get.dart';
import 'package:get/route_manager.dart';

class ServiceModel {
  final String serviceId;
  final String name;
    final String nameAR;
  final String image;
  final String icon;
  final List<String> bannerImage; // ✅ ADD THIS

  ServiceModel({
    required this.serviceId,
    required this.name,
        required this.nameAR,
    required this.image,
    required this.icon,
    required this.bannerImage,
  });

    String get displayName {
    return Get.locale?.languageCode == 'ar'
        ? (nameAR.isNotEmpty ? nameAR : name)
        : name;
  }

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      serviceId: json["serviceId"] ?? "",
      name: json["name"] ?? "",
      nameAR: json["nameAR"] ?? "",
      image: json["image"] ?? "",
      icon: json["iconImage"] ?? "",
      bannerImage: json["bannerImage"] != null
          ? List<String>.from(json["bannerImage"])
          : [],
    );
  }
}
