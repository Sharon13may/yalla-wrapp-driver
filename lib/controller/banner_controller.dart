import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/model/banner_model.dart';
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';

class ServiceBannerController extends GetxController {
  var isLoading = true.obs;
  var banners = <String>[].obs;

  Future<void> fetchServiceBanners(String serviceId) async {
    try {
      isLoading.value = true;

      String userId = await Prefs.getUserId() ?? "";

      final headers = {
        "Token": AppConstants.token,
        "UserId": userId,
        "Content-Type": "application/json",
      };

      final response = await http.post(
        Uri.parse(
            "${AppConstants.baseUrl}Yuser_api/serviceBanners"),
        headers: headers,
        body: jsonEncode({"serviceId": serviceId}),
      );

      final data = jsonDecode(response.body);

      if (data["success"] == true && data["data"] != null) {
        final model = ServiceBannerModel.fromJson(data["data"][0]);
        banners.assignAll(model.bannerImages);
      }
    } catch (e) {
      banners.clear();
    } finally {
      isLoading.value = false;
    }
  }
}
