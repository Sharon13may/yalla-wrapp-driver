import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../utils/app_constants.dart';
import '../utils/prefs.dart';

class PaymentController extends GetxController {
  var isLoading = false.obs;

  Future<bool> updatePayment({
    required String bookingId,
    required String payType,
    required String payStatus,
  }) async {
    try {
      isLoading.value = true;

      final url = Uri.parse("${AppConstants.baseUrl}Yuser_api/payUpdate");
      String userId = await Prefs.getUserId() ?? "";
      String token = AppConstants.token;

      final headers = {
        "Token": token,
        "UserId": userId,
        "Content-Type": "application/json",
      };

      final body = {
        "bookingId": bookingId,
        "payType": payType,
        "payStatus": payStatus
      };

      print("------ PAYMENT UPDATE REQUEST ------");
      print(jsonEncode(body));

      final response = await http.post(
        url,
        headers: headers,
        body: jsonEncode(body),
      );

      print("------ PAYMENT UPDATE RESPONSE ------");
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data["success"] == true;
      } else {
        return false;
      }
    } catch (e) {
      print("PAYMENT ERROR: $e");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
