import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';
import '../model/addon_model.dart';

class AddonsController extends GetxController {
  var addons = <AddonModel>[].obs;
  var isLoading = false.obs;

  Future<void> fetchAddons(String? serviceId) async {
    try {
      isLoading.value = true;

      final url = Uri.parse("${AppConstants.baseUrl}Yuser_api/addonsList");
     String userId = await Prefs.getUserId() ?? "";
      final body = {
        "serviceId": serviceId,
      };

      final headers = {
        "token": AppConstants.token,
        "userid": userId,
      };

      final response = await http.post(url,  body: jsonEncode(body), headers: headers);
 debugPrint("API RESPONSE: ${response.body}");
      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        addons.value = (data["data"] as List)
            .map((e) => AddonModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  List<AddonModel> get selectedAddons =>
      addons.where((a) => a.isSelected.value).toList();
}
