import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';

class TrackBookingController extends GetxController {
  var isLoading = false.obs;
  var status = "".obs;

  Future<void> fetchTrackStatus(String bookingId) async {
    try {
      isLoading.value = true;

      final url = Uri.parse(
        "${AppConstants.baseUrl}Yuser_api/realTimeStatus",
      );

      String userId = await Prefs.getUserId() ?? "";
      String token = AppConstants.token;

      final headers = {
        "Token": token,
        "UserId": userId,
        "Content-Type": "application/json",
      };

      final body = {
        "bookingId": bookingId,
      };

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["success"] == true) {
          status.value = data["data"]["status"]; // Rejected / Finished / etc
        }
      }
    } catch (e) {
      print("TRACK STATUS ERROR: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
