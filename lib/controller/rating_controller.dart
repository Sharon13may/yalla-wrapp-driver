import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';

class RatingController {
  Future<String> submitRating({
    required String bookingId,
    required int rating,
    required String review,
  }) async {
    final url =
    
        Uri.parse("${AppConstants.baseUrl}Yuser_api/saveRating");

    String userId = await Prefs.getUserId() ?? "";
    String token = AppConstants.token;

    final headers = {
      "Token": token,
      "UserId": userId,
      "Content-Type": "application/json",
    };

    final body = {
      "bookingId": bookingId,
      "rating": rating.toString(),
      "review": review,
    };

    final response = await http.post(
      url,
      headers: headers,
      body: jsonEncode(body),
    );

    final data = jsonDecode(response.body);
    return data["message"] ?? "Something went wrong";
  }
}
