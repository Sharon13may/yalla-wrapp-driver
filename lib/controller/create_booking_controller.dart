import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';

class CBookingController extends GetxController {
  var isLoading = false.obs;

  Future<String?> submitBooking(Map<String, dynamic> body) async {
    try {
      isLoading.value = true;

      final url = Uri.parse("${AppConstants.baseUrl}Yuser_api/createBooking");
      String userId = await Prefs.getUserId() ?? "";

      final headers = {
        "Token": AppConstants.token,
        "UserId": userId,
        "Content-Type": "application/json",
      };
      debugPrint(userId);

      debugPrint("----- BOOKING API REQUEST -----");
      debugPrint(jsonEncode(body));

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      debugPrint("----- BOOKING API RESPONSE -----");
      debugPrint(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          Get.snackbar("Success", data['message'] ?? "Booking created",
              snackPosition: SnackPosition.BOTTOM);
               return data["data"]["bookingId"]; 
        } else {
          Get.snackbar("Failed", data['message'] ?? "Booking failed",
              snackPosition: SnackPosition.BOTTOM);
       
        }
      } else {
        Get.snackbar("Error", "Server error: ${response.statusCode}",
            snackPosition: SnackPosition.BOTTOM);
    
      }
    } catch (e) {
      debugPrint("BOOKING ERROR: $e");
      Get.snackbar("Error", "Something went wrong",
          snackPosition: SnackPosition.BOTTOM);

    } finally {
      isLoading.value = false;
    }
  }
}
