import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';

class NoteController extends GetxController {
  var isLoading = false.obs;

  Future<bool> saveNote({
    required String bookingId,
    required String note,
    required String airline,
  }) async {
    try {
      isLoading.value = true;

      String userId = await Prefs.getUserId() ?? "";

      final url = Uri.parse("${AppConstants.baseUrl}Yuser_api/saveNote");

      final body = jsonEncode({
        "bookingId": bookingId,
        "note": note,
        "airline": airline,
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
      print("Save Note Response : $data");

      if (response.statusCode == 200 && data["success"] == true) {
        Get.snackbar("Success", data["message"],
            snackPosition: SnackPosition.BOTTOM);
        return true;
      } else {
        Get.snackbar("Failed", data["message"],
            snackPosition: SnackPosition.BOTTOM);
        return false;
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong. Try again.",
          snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
