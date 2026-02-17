import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/model/address_model.dart';
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import '../utils/prefs.dart';

class AddressController extends GetxController {
  RxBool isLoading = false.obs;
  RxList<AddressModel> addresses = <AddressModel>[].obs;
  RxString selectedAddressId = "".obs;
  

  @override
  void onInit() {
    super.onInit();
    _init();
  }

  Future<void> _init() async {
    await loadSelectedAddress();
    await fetchAddressList();
  }

  Future loadSelectedAddress() async {
    final id = await Prefs.getSelectedAddressId() ?? "";
    debugPrint("🟢 SAVED ADDRESS ID FROM PREFS → $id");
    selectedAddressId.value = id;
  }

  Future fetchAddressList() async {
    try {
      isLoading.value = true;

    
      String userId = await Prefs.getUserId() ?? "";

      var res = await http.get(
        Uri.parse("${AppConstants.baseUrl}Yuser_api/addressList"),
        headers: {
          "Token":  AppConstants.token,
          "UserId": userId,
          "Content-Type": "application/json",
        },
      );
  debugPrint("Address userid: $userId");
      var data = jsonDecode(res.body);
 debugPrint("Address list responce : ${res.body}");
      if (data["success"] == true) {
        addresses.value = (data["data"] as List)
            .map((e) => AddressModel.fromJson(e))
            .toList();
      }
    } catch (e) {
      print("Address error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void selectAddress(String id) async {
    selectedAddressId.value = id;
    await Prefs.saveSelectedAddressId(id);
  }

  Future<void> deleteAddress(String addressId, BuildContext context) async {
    try {
      isLoading.value = true;

      var userId = await Prefs.getUserId();

      var response = await http.post(
        Uri.parse("${AppConstants.baseUrl}Yuser_api/deleteAddress"),
        headers: {
          "Token":  AppConstants.token,
          "UserId": userId ?? "0",
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "addressId": addressId,
        }),
      );

      final res = jsonDecode(response.body);

      if (res["success"] == true) {
        Get.snackbar(
          "Success",
          res["message"],
          snackPosition: SnackPosition.BOTTOM,
        );

        await fetchAddressList();
      } else {
        Get.snackbar(
          "Error",
          res["message"] ?? "Failed to delete",
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar("Error", e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

Future<void> editAddress({
  required String addressId,
  String? phone,
  String? addressType,
  String? municipality,
  String? area,
  String? street,
  String? zone,
  String? unit,
  String? building,
  String? landmark,
  String? postalCode,
  String? latitude,
  String? longitude,
}) async {

    try {
      isLoading.value = true;

      final userId = await Prefs.getUserId();

      final res = await http.post(
        Uri.parse("${AppConstants.baseUrl}Yuser_api/editAddress"),
        headers: {
          "Token":  AppConstants.token,
          "UserId": userId ?? "",
          "Content-Type": "application/json",
        },
       body: jsonEncode({
  "addressId": addressId,
  "countryISO": "IN",
  "phone": phone ?? "",
  "addressType": addressType ?? "",
  "zone": zone ?? "",
  "area": area ?? "",
  "municipality": municipality ?? "",
  "building": building ?? "",
  "street": street ?? "",
  "unit": unit ?? "",
  "landmark": landmark ?? "",
  "postalCode": postalCode ?? "",
  "latitude": latitude ?? "",
  "longitude": longitude ?? "",
  "bluePlateImage": ""
}),

      );

      final data = jsonDecode(res.body);

      if (data["success"] == true) {
        Get.back();
        await fetchAddressList();
        Get.snackbar("Success", data["message"]);
      } else {
        Get.snackbar("Error", data["message"]);
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
