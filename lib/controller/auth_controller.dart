import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/model/otp_model.dart';
import 'package:yalla_wrapp_supervisor/model/signup_model.dart';
import 'package:yalla_wrapp_supervisor/utils/api_base.dart';

class AuthAPI {
  static Future<SignupResponse> signup(Map<String, dynamic> body) async {
    final url = ApiBase.getUrl("Yuser_api/userSignup");

    final response = await http.post(
      url,
      headers: ApiBase.getHeaders(),
      body: jsonEncode(body),
    );

    return SignupResponse.fromJson(jsonDecode(response.body));
  }

  static Future<OTPResponse> verifyOtp(String userId, String otp) async {
    final url = ApiBase.getUrl("Yuser_api/verifyOtp");

    final response = await http.post(
      url,
      headers: ApiBase.getHeaders(userId: userId),
      body: jsonEncode({"otp": otp}),
    );

    return OTPResponse.fromJson(jsonDecode(response.body));
  }
}
