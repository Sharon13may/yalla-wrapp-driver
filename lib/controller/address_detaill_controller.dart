import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/model/address_detail_model.dart';
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';

class AddressDetailController extends GetxController {
  var isLoading = false.obs;
  var address = Rxn<AddressDetailModel>();

 Future<void> fetchAddress(String addressId) async {
  try {
    isLoading.value = true;

    debugPrint("📍 ADDRESS API CALLED with ID → $addressId");

    String userId = await Prefs.getUserId() ?? "";
    String token = AppConstants.token;

    final response = await http.post(
      Uri.parse("${AppConstants.baseUrl}Yuser_api/getAddress"),
      headers: {
        "Token": token,
        "UserId": userId,
        "Content-Type": "application/json",
      },
      body: jsonEncode({"addressId": addressId}),
    );

    debugPrint("📍 ADDRESS RESPONSE → ${response.body}");

    final json = jsonDecode(response.body);

    if (json['success'] == true) {
      address.value = AddressDetailModel.fromJson(json['data']);
      debugPrint("✅ ADDRESS SET → ${address.value?.fullAddress}");
    }
  } catch (e) {
    debugPrint("❌ ADDRESS ERROR → $e");
  } finally {
    isLoading.value = false;
  }
}

}
