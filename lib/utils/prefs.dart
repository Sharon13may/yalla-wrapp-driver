import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("userId", userId);
  }

  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("userId");
  }

   static Future saveSelectedAddressId(String id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("selectedAddressId", id);
  }

  static Future<String?> getSelectedAddressId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("selectedAddressId");
  }
}
