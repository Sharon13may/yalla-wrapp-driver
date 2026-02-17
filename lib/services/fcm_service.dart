import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  static Future<String?> getDeviceToken() async {
    try {
      await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      final token = await _messaging.getToken();
      debugPrint("🔥 FCM TOKEN → $token");
      return token;
    } catch (e) {
      debugPrint("❌ FCM TOKEN ERROR → $e");
      return null;
    }
  }
}
