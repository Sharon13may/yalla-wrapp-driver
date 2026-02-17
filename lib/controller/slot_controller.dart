import 'dart:convert';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';

class SlotController extends GetxController {
  var isLoading = false.obs;
  var selectedDate = "".obs;
  var selectedStartTime = "".obs;
  var selectedEndTime = "".obs;
  var assignedStaffId = "".obs;

  Future<bool> checkSlotAvailable({
    required String bookDate,
    required String slotTime,
    required String token,
  }) async {
    try {
      isLoading.value = true;

      final url = Uri.parse("${AppConstants.baseUrl}Yuser_api/slotCheck");
      String userId = await Prefs.getUserId() ?? "";

      final body = jsonEncode({
        "bookDate": bookDate,
        "slotTime": slotTime,
        
      });

      final response = await http.post(
        url,
        headers: {
          "Token": AppConstants.token,
          "UserId": userId,
          "Content-Type": "application/json",
        },
        body: body,
      );

      final data = jsonDecode(response.body);
      debugPrint("Slot Check Response ${response.body}");

      if (response.statusCode == 200 && data["success"] == true) {
        assignedStaffId.value = data["data"]["assignedStaffId"] ?? "";

        Get.snackbar("Success", data["message"],
            snackPosition: SnackPosition.BOTTOM);
        return true;
      } else {
        Get.snackbar("Unavailable", data["message"],
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: const Color.fromARGB(255, 175, 175, 175));
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Please try again.",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
