import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';
import 'dart:convert';
import '../model/upcoming_bookings_model.dart';

class UpcomingBookingController extends GetxController {
  var isLoading = false.obs;
  var upcomingList = <UpcomingBookingModel>[].obs;

  Future<void> fetchUpcomingBookings() async {
    try {
      isLoading.value = true;

      String userId = await Prefs.getUserId() ?? "";
      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}Yuser_api/upComingBookings"),
        headers: {
          "Token":AppConstants.token,
          "UserId": userId,
          "Content-Type": "application/json",
        },
      );

      var jsonBody = json.decode(response.body);

      if (jsonBody["success"] == true) {
        var list = jsonBody["data"] as List;
        upcomingList.value =
            list.map((e) => UpcomingBookingModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Upcoming Error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
