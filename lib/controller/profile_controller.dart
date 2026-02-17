import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/model/profile_model.dart';
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var profile = Rxn<ProfileModel>();

  @override
  void onInit() {
    fetchProfile();
    super.onInit();
  }

  Future<void> fetchProfile() async {
    try {
      isLoading.value = true;

      String userId = await Prefs.getUserId() ?? "";
      String token = AppConstants.token;

      final headers = {
        "Token": token,
        "UserId": userId,
        "Content-Type": "application/json",
      };

      final response = await http.get(
        Uri.parse("${AppConstants.baseUrl}Yuser_api/fetchProfile"),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['success'] == true) {
          profile.value = ProfileModel.fromJson(jsonData['data']);
        }
      }
    } catch (e) {
      print("PROFILE API ERROR → $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> updateProfile({
    required String firstName,
    required String lastName,
    required String email,
    required String phone,
    required context,
  }) async {
    try {
      isLoading.value = true;

      String userId = await Prefs.getUserId() ?? "";
      String token = AppConstants.token;

      final headers = {
        "Token": token,
        "UserId": userId,
        "Content-Type": "application/json",
      };
      debugPrint("USER ID  :${userId}");

      final body = jsonEncode({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "phone": phone,
      });

      final response = await http.post(
        Uri.parse("${AppConstants.baseUrl}Yuser_api/updateProfile"),
        headers: headers,
        body: body,
      );

      final data = jsonDecode(response.body);

      if (data["success"] == true) {
        profile.value = ProfileModel.fromJson(data["data"]);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              data["message"],
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );

        return true;
      } else {
        _showError(context, data["message"]);
        return false;
      }
    } catch (e) {
      _showError(context, "Something went wrong");
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void _showError(context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          msg,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
