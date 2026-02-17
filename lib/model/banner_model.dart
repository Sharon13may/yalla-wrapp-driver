class ServiceBannerModel {
  final String serviceId;
  final List<String> bannerImages;

  ServiceBannerModel({
    required this.serviceId,
    required this.bannerImages,
  });

  factory ServiceBannerModel.fromJson(Map<String, dynamic> json) {
    return ServiceBannerModel(
      serviceId: json['serviceId'],
      bannerImages: List<String>.from(json['bannerImage'] ?? []),
    );
  }
}
