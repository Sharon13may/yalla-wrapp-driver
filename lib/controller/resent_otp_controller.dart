import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/model/resent_otp_model.dart';
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import '../utils/prefs.dart';

class ResendOtpController extends GetxController {
  var isLoading = false.obs;

  Future<ResendOtpModel?> resendOtp(String phone) async {
    try {
      isLoading(true);

      final userId = await Prefs.getUserId();
      const token = "your_token_here";

      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}Yuser_api/resendOtp"),
        headers: {
          "Token": token,
          "UserId": userId ?? "",
          "Content-Type": "application/json",
        },
        body: jsonEncode({"phone": phone}),
      );

      final jsonRes = jsonDecode(response.body);
      return ResendOtpModel.fromJson(jsonRes);

    } catch (e) {
      return null;
    } finally {
      isLoading(false);
    }
  }
}
