import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/model/home_banner_model.dart';
import 'package:yalla_wrapp_supervisor/model/service_model.dart';
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import '../utils/prefs.dart';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var services = <ServiceModel>[].obs;
  var homeBanners = <HomeBannerItem>[].obs;


  final String baseUrl = "${AppConstants.baseUrl}Yuser_api/serviceList";


  @override
  void onInit() {
    fetchServices();
    super.onInit();
  }

  Future<void> fetchServices() async {
    try {
      isLoading(true);

      String userId = await Prefs.getUserId() ?? "";

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          "Token":  AppConstants.token,
          "UserId": userId,
          "Content-Type": "application/json",
        },
      );
debugPrint(userId);
      final res = json.decode(response.body);

      if (res["success"] == true) {
        List data = res["data"];
        services.value =
            data.map((e) => ServiceModel.fromJson(e)).toList();   


             _buildHomeBanners();       
      }
    } catch (e) {
      debugPrint("Service Fetch Error: $e");
    } finally {
      isLoading(false);
    }
  }

  void _buildHomeBanners() {
  final List<HomeBannerItem> temp = [];

  for (final service in services) {
    if (service.bannerImage.isNotEmpty) {
      for (final banner in service.bannerImage) {
        temp.add(
          HomeBannerItem(
            image: banner,
            serviceId: service.serviceId,
            serviceName: service.displayName,
          ),
        );
      }
    } else if (service.image.isNotEmpty) {
      // fallback to service image if no banner
      temp.add(
        HomeBannerItem(
          image: service.image,
          serviceId: service.serviceId,
          serviceName: service.displayName,
        ),
      );
    }
  }

  homeBanners.assignAll(temp);
}

}
