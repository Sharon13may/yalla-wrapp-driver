import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:http/http.dart' as http;
import 'package:get/get_navigation/get_navigation.dart';
import 'package:yalla_wrapp_supervisor/services/fcm_service.dart';
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';
import 'package:yalla_wrapp_supervisor/view/auth/otp_screen.dart';
import 'package:yalla_wrapp_supervisor/view/auth/register_screen.dart';
import 'package:yalla_wrapp_supervisor/view/bottom_nav_bar.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';


class LoginController {
  static const String baseUrl = "${AppConstants.baseUrl}Yuser_api";


  static Future<void> checkUser({
    required BuildContext context,
    required String phone,
  }) async {
    if (phone.isEmpty) {
      _showSnack(context, "Please enter phone number");
      return;
    }

    try {
      final url = Uri.parse("$baseUrl/checkUser");
      final response = await http.post(
        url,
        headers: {
          "Token":  AppConstants.token,
          "Content-Type": "application/json",
        },
        body: json.encode({"phone": phone}),
      );

      debugPrint("Status: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      final res = json.decode(response.body);

      if (res["success"] == true) {
        _showSnack(context, res["message"] ?? "Success");

        String userId = res["data"]["userId"];

        Get.to(() => OTPScreen(
              isLogin: true,
              userId: userId,
            ));
      } else {
      //  _showSnack(context, res["message"] ?? "User unavailable.");
        _showRegisterPopup(context, phone);
      }
    } catch (e) {
      _showSnack(context, "Something went wrong");
      debugPrint("Exception: $e");
    }
  }

  static void _showRegisterPopup(BuildContext context, String phone) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        title: const Text(
          "User not found",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        content: const Text(
          "This user didn’t register yet, please register.",
          style: TextStyle(fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
            },
            child: const Text("Cancel",style: TextStyle(color: Colors.black),),
          ),
         ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.buttonGreen,
    foregroundColor: Colors.white,   
    shape: RoundedRectangleBorder(
      
      borderRadius: BorderRadius.circular(20),
    ),
  ),
  onPressed: () {
    Navigator.pop(ctx);
    Get.to(() => RegisterScreen(
          prefillPhone: phone,
        ));
  },
  child: const Text(
    "Register",
    style: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
    ),
  ),
),

        ],
      );
    },
  );
}


  static Future<void> verifyLoginOTP({
    required BuildContext context,
    required String otp,
    required String userId,
  }) async {
    if (otp.isEmpty) {
      _showSnack(context, "Please enter OTP");
      return;
    }
final pushToken = await FCMService.getDeviceToken();
debugPrint("PUSH TOKEN :$pushToken");

    try {
      final response = await http.post(
        Uri.parse("$baseUrl/userLogin"),
        headers: {
          "Token": AppConstants.token,
          "UserId": userId,
          "Content-Type": "application/json",
        },
        body: json.encode({
          "pushToken":  pushToken ?? "",
          "otp": otp,
        }),
      );

      debugPrint("Status: ${response.statusCode}");
      debugPrint("Body: ${response.body}");

      final res = json.decode(response.body);

      if (res["success"] == true) {
        _showSnack(context, res["message"]);

        final newUserId = res["data"]["userId"];
        await Prefs.saveUserId(newUserId);
        debugPrint("Saved UserId: $newUserId");

        Get.to(const BottomNavBar());
      } else {
        if (res["code"] == "303" && res["errors"] != null) {
          final err = res["errors"][0].values.first.toString();
          _showSnack(context, err);
        } else {
          _showSnack(context, res["message"] ?? "Invalid OTP");
        }
      }
    } catch (e) {
      _showSnack(context, "Something went wrong");
    }
  }

  static void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg)),
    );
  }
}
