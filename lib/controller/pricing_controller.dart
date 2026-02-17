import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/model/pricing_model.dart';
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';

class PricingController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<PricingModel?> pricing = Rx<PricingModel?>(null);

  Future<void> calculatePrice(String serviceId, String quantity) async {
    try {
      isLoading.value = true;

      final url = Uri.parse("${AppConstants.baseUrl}Yuser_api/calculatePrice2");
             String userId = await Prefs.getUserId() ?? "";

      final response = await http.post(
        url,
        headers: {
          "Token": AppConstants.token,
          "Userid": userId,
          "Content-Type": "application/json",
        },
        
        body: jsonEncode({
          "serviceId": serviceId,
          "quantity": quantity,
        }),
      );
       debugPrint("userid: $userId");
debugPrint(serviceId);
      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        pricing.value = PricingModel.fromJson(data["data"]);
      }
    } catch (e) {
      print("PRICING ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
