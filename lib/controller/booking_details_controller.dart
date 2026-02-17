import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';
import '../model/booking_details_model.dart';

class BookingDetailsController extends GetxController {
  var isLoading = false.obs;
  Rx<BookingDetailsModel?> booking = Rx<BookingDetailsModel?>(null);

  Future<void> fetchBookingDetails(String bookingId) async {
    try {
      isLoading.value = true;

      final url = Uri.parse("${AppConstants.baseUrl}Yuser_api/bookingDetails");
      String userId = await Prefs.getUserId() ?? "";
      String token = AppConstants.token;

      final headers = {
        "Token": token,
        "UserId": userId,
        "Content-Type": "application/json",
      };

      final body = {"bookingId": bookingId};

      print("=== BOOKING DETAILS REQUEST ===");
      print(jsonEncode(body));
      debugPrint("Userid ${userId}");

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      print("=== BOOKING DETAILS RESPONSE ===");
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          booking.value = BookingDetailsModel.fromJson(data["data"]);
        }
      }
    } catch (e) {
      print("BOOKING DETAILS ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
