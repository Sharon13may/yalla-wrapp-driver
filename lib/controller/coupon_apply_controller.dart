import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';

class CouponApplyController extends GetxController {
  var isLoading = false.obs;
  var discountedPrice = Rxn<double>();

//  Future<void> applyCoupon({
//   required BuildContext context,
//   required String couponCode,
//   required Map<String, dynamic> bookingBody,
// }) async {
//   try {
//     isLoading.value = true;

//     final userId = await Prefs.getUserId() ?? "";
//     final token = AppConstants.token;

//     final url =
//         Uri.parse("${AppConstants.baseUrl}Yuser_api/userApplyCoupon");

//     final requestBody = {
//       ...bookingBody,
//       "couponCode": couponCode,
//     };

//     // 🟢 PRINT REQUEST
//     debugPrint("🟢 APPLY COUPON URL → $url");
//     debugPrint("🟢 APPLY COUPON HEADERS → {");
//     debugPrint("  Token: $token");
//     debugPrint("  UserId: $userId");
//     debugPrint("}");
//     debugPrint("🟢 APPLY COUPON REQUEST BODY →");
//     debugPrint(const JsonEncoder.withIndent('  ').convert(requestBody));

//     final response = await http.post(
//       url,
//       headers: {
//         "Token": token,
//         "UserId": userId,
//         "Content-Type": "application/json",
//       },
//       body: jsonEncode(requestBody),
//     );

//     // 🟡 PRINT RESPONSE
//     debugPrint("🟡 APPLY COUPON STATUS → ${response.statusCode}");
//     debugPrint("🟡 APPLY COUPON RESPONSE BODY →");
//     debugPrint(const JsonEncoder.withIndent('  ').convert(
//       jsonDecode(response.body),
//     ));

//     final data = jsonDecode(response.body);

//     if (data["success"] == true) {
//       discountedPrice.value =
//           double.tryParse(data["data"]["finalPrice"].toString());

//       _showSnack(context, data["message"]);
//     } else {
//       _showSnack(context, data["message"] ?? "Invalid coupon");
//     }
//   } catch (e) {
//     debugPrint("🔴 APPLY COUPON ERROR → $e");
//     _showSnack(context, "Something went wrong");
//   } finally {
//     isLoading.value = false;
//   }
// }

Future<void> applyCoupon({
  required BuildContext context,
  required String couponId,
  required double bookingTotal,
}) async {
  try {
    isLoading.value = true;

    final userId = await Prefs.getUserId() ?? "";
    final token = AppConstants.token;

    final url =
        Uri.parse("${AppConstants.baseUrl}Yuser_api/applyCoupon");

    final requestBody = {
      "couponId": couponId,
      "bookingTotal": bookingTotal,
    };

    // 🟢 REQUEST LOG
    debugPrint("🟢 APPLY COUPON URL → $url");
    debugPrint("🟢 APPLY COUPON HEADERS → { Token: $token, UserId: $userId }");
    debugPrint("🟢 APPLY COUPON REQUEST BODY →");
    debugPrint(const JsonEncoder.withIndent('  ').convert(requestBody));

    final response = await http.post(
      url,
      headers: {
        "Token": token,
        "UserId": userId,
        "Content-Type": "application/json",
      },
      body: jsonEncode(requestBody),
    );

    debugPrint("🟡 APPLY COUPON STATUS → ${response.statusCode}");
    debugPrint("🟡 APPLY COUPON RAW RESPONSE → ${response.body}");

    if (response.statusCode != 200) {
      _showSnack(context, "Coupon not applicable");
      return;
    }

    final data = jsonDecode(response.body);

    if (data["success"] == true) {
discountedPrice.value = double.parse(
  (data["data"]["finalAmount"] as num).toStringAsFixed(2),
);



      _showSnack(context, data["message"]);
    } else {
      _showSnack(context, data["message"] ?? "Invalid coupon".tr);
    }
  } catch (e) {
    debugPrint("🔴 APPLY COUPON ERROR → $e");
    _showSnack(context, "Something went wrong");
  } finally {
    isLoading.value = false;
  }
}

  void _showSnack(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}
