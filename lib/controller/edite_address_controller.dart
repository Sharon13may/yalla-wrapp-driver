import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_wrapp_supervisor/model/address_model.dart';

class EditAddressController extends GetxController {
  late AddressModel address;

  late TextEditingController phoneController;
  late TextEditingController streetController;

  late String latitude;
  late String longitude;
  late String postalCode;

  @override
  void onInit() {
    super.onInit();

    address = Get.arguments as AddressModel;

    phoneController = TextEditingController(text: address.phone ?? "");
    streetController = TextEditingController(text: address.street ?? "");

    latitude = address.latitude ?? "";
    longitude = address.longitude ?? "";
    postalCode = address.postalCode ?? "";
  }
}
