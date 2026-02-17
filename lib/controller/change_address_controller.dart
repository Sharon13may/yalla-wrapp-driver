import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';
import '../utils/app_constants.dart';

class ChangeAddressController extends GetxController {
  RxBool isLoading = false.obs;

  Future<bool> changeAddress({
    required String bookingId,
    required String addressId,
  }) async {
    try {
      isLoading.value = true;
 String userId = await Prefs.getUserId() ?? "";
      final res = await http.post(
        Uri.parse("${AppConstants.baseUrl}Yuser_api/changeAddress"),
        
        headers: {
          "Token": AppConstants.token,
          "Userid": userId, 
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "bookingId": bookingId,
          "addressId": addressId,
        }),
      );

      final data = jsonDecode(res.body);

      debugPrint("🔁 CHANGE ADDRESS RESPONSE → ${res.body}");

      if (data["success"] == true) {
        Get.snackbar(
          "Success",
          data["message"],
          snackPosition: SnackPosition.BOTTOM,
        );
        return true;
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Failed",
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    } catch (e) {
      debugPrint("❌ CHANGE ADDRESS ERROR → $e");
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
