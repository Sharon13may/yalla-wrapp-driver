import 'package:http/http.dart' as http;
import '../../utils/app_constants.dart';

class ApiBase {
  static Map<String, String> getHeaders({String? userId}) {
    final headers = {
      "Content-Type": "application/json",
      "Token": AppConstants.token,
    };

    if (userId != null) {
      headers["Userid"] = userId;
    }

    return headers;
  }

  static Uri getUrl(String endpoint) {
    return Uri.parse("${AppConstants.baseUrl}$endpoint");
  }
}
