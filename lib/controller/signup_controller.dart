import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla_wrapp_supervisor/controller/auth_controller.dart';
import 'package:yalla_wrapp_supervisor/services/fcm_service.dart';
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/view/auth/login_screen.dart';

class SignupController {
  static Future<void> registerUser({
    required BuildContext context,
    required String first,
    required String last,
    required String email,
    required String phone,
    required Function(String userId) onSuccess,
  }) async {
    if (first.isEmpty || email.isEmpty || phone.isEmpty) {
      _showSnack(context, "Please fill required fields");
      return;
    }
    final pushToken = await FCMService.getDeviceToken();
debugPrint("PUSH TOKEN :$pushToken");

    final body = {
      "firstName": first,
      "lastName": last,
      "email": email,
      "phone": phone,
      "pushToken": pushToken ?? ""
    };

    try {
      final res = await AuthAPI.signup(body);

      debugPrint("🔵 SIGNUP RESPONSE → ${res.toJson()}");

      if (!res.success) {
        if (res.code == "303" &&
            res.data != null &&
            res.data['errors'] != null) {
          final errors = res.data['errors'];
          String errorMsg = 'Something went wrong';

          if (errors is List && errors.isNotEmpty) {
            final firstErr = errors.first;
            if (firstErr is Map) {
              final messages = <String>[];
              firstErr.forEach((_, v) {
                if (v != null) messages.add(v.toString());
              });
              if (messages.isNotEmpty) errorMsg = messages.join(', ');
            } else {
              errorMsg = errors.map((e) => e.toString()).join(', ');
            }
          } else if (errors is Map) {
            final messages = errors.values.map((v) => v.toString()).toList();
            if (messages.isNotEmpty) errorMsg = messages.join(', ');
          } else if (errors is String) {
            errorMsg = errors;
          }

          _showSnack(context, errorMsg);
        } else {
          _showSnack(context, res.message ?? 'Something went wrong');
        }
        return;
      }

      _showSnack(context, res.message ?? "Success");
      onSuccess(res.data["userId"]);
    } catch (e) {
      debugPrint("❌ SIGNUP ERROR → $e");
      _showSnack(context, "Something went wrong");
    }
  }

  static Future<void> deleteAccount({
    required BuildContext context,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getString('userId') ?? "";

      if (userId.isEmpty) {
        _showSnack(context, "User not found");
        return;
      }

      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}Yuser_api/deleteUser"),
        headers: {
          "Token": AppConstants.token,
          "UserId": userId,
          "Content-Type": "application/json",
        },
      );

      final res = json.decode(response.body);

      debugPrint("🗑 DELETE USER RESPONSE → $res");

      if (res["success"] == true) {
        _showSnack(context, res["message"] ?? "User deleted successfully");

        await prefs.clear();

        Future.delayed(const Duration(milliseconds: 500), () {
          Get.offAll(const LoginScreen());
        });
      } else {
        _showSnack(context, res["message"] ?? "Something went wrong");
      }
    } catch (e) {
      debugPrint("❌ DELETE USER ERROR → $e");
      _showSnack(context, "Something went wrong");
    }
  }

  static void _showSnack(BuildContext context, String msg) {
    final messenger = ScaffoldMessenger.maybeOf(Get.key.currentContext!);
    if (messenger == null) return;

    messenger.showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
