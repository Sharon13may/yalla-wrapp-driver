import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/app_constants.dart';
import '../utils/prefs.dart';

class BookingService {
  static Future<Map<String, dynamic>> editBooking(
      Map<String, dynamic> body) async {
    final userId = await Prefs.getUserId() ?? "";

    final headers = {
      "Token": AppConstants.token,
      "UserId": userId,
      "Content-Type": "application/json",
    };

    final response = await http.post(
      Uri.parse("${AppConstants.baseUrl}/Yuser_api/editBooking"),
      headers: headers,
      body: jsonEncode(body),
    );

    return jsonDecode(response.body);
  }
}
