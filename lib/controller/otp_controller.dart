import 'package:flutter/material.dart';
import 'package:yalla_wrapp_supervisor/controller/auth_controller.dart';
import '../utils/prefs.dart';

class OTPController {
  static Future<void> verify({
    required BuildContext context,
    required String otp,
    required String userId,
    required Function() onSuccess,

    
  }) async {
    if (otp.length != 4) {
      _showSnack(context, "Enter valid OTP");
      return;
    }

    try {
      final res = await AuthAPI.verifyOtp(userId, otp);

      if (res.success) {
        await Prefs.saveUserId(res.data["userId"]);
        _showSnack(context, res.message);
        onSuccess();
      } else {
        _showSnack(context, res.message);
      }
    } catch (_) {
      _showSnack(context, "Something went wrong");
    }
  }

  static void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }
}
