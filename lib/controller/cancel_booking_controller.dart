import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';

class BookingCancelController extends GetxController {
  var isLoading = false.obs;

  Future<String> cancelBooking({
    required String bookingId,
    required String reason,
  }) async {
    isLoading.value = true;

    try {
    
      String userId = await Prefs.getUserId() ?? "";

      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}Yuser_api/updateCancelStatus"),
        headers: {
          "Token":  AppConstants.token,
          "UserId": userId,
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "bookingId": bookingId,
          "status": "Cancelled",
          "reason": reason,
        }),
      );

      final data = jsonDecode(response.body);

      return data["message"] ?? "Something went wrong";
    } catch (e) {
      return "Unable to cancel booking";
    } finally {
      isLoading.value = false;
    }
  }
}
