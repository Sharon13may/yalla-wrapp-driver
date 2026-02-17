import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/model/coupon_model.dart';
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';

class CouponController extends GetxController {
  var isLoading = false.obs;
  var coupons = <CouponModel>[].obs;

  @override
  void onInit() {
    fetchCoupons();
    super.onInit();
  }

  Future<void> fetchCoupons() async {
    try {
      isLoading.value = true;

      String userId = await Prefs.getUserId() ?? "";
      String token = AppConstants.token;

      final response = await http.get(
        Uri.parse("${AppConstants.baseUrl}Yuser_api/userCoupons"),
        headers: {
          "Token": token,
          "UserId": userId,
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final body = json.decode(response.body);
        final List list = body['data']['coupons'];

        coupons.value =
            list.map((e) => CouponModel.fromJson(e)).toList();
      }
    } catch (_) {
    } finally {
      isLoading.value = false;
    }
  }
}
