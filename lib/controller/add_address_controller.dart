import 'dart:convert';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';


class AddAddressController extends GetxController {
  GoogleMapController? mapController;
  LatLng? _lastTarget;
  final currentAddress = ''.obs;


  final latitude = 25.3548.obs;
  final longitude = 51.1839.obs;

  /// address type
  final addressType = 'office'.obs;

  /// loader
  final isSaving = false.obs;

  @override
  void onInit() {
    super.onInit();
    _getCurrentLocation();
  }

  Future<void> fetchAddressFromLatLng(double lat, double lng) async {
  try {
    final url =
        'https://maps.googleapis.com/maps/api/geocode/json'
        '?latlng=$lat,$lng'
        '&key=AIzaSyBzA-206XMmmD99RVU_6rn7WcAhKtWZO8s';

    final res = await http.get(Uri.parse(url));
    final data = jsonDecode(res.body);

    if (data['status'] == 'OK') {
      currentAddress.value =
          data['results'][0]['formatted_address'];
    } else {
      currentAddress.value = 'Unable to fetch address';
    }
  } catch (e) {
    currentAddress.value = 'Error fetching address';
  }
}


  Future<void> _getCurrentLocation() async {
    if (!await Geolocator.isLocationServiceEnabled()) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    latitude.value = pos.latitude;
    longitude.value = pos.longitude;
  }

  void onCameraMove(CameraPosition position) {
    _lastTarget = position.target;
  }

  // void onCameraIdle() {
  //   if (_lastTarget == null) return;

  //   latitude.value = _lastTarget!.latitude;
  //   longitude.value = _lastTarget!.longitude;
  // }
  void onCameraIdle() {
  if (_lastTarget == null) return;

  latitude.value = _lastTarget!.latitude;
  longitude.value = _lastTarget!.longitude;

  fetchAddressFromLatLng(
    latitude.value,
    longitude.value,
  );
}


  /// ADD ADDRESS API
 Future<String?> addAddress({
  required String countryISO,
  required String phone,
  required String zone,
  required String area,
  required String municipality,
  required String building,
  required String street,
  required String unit,
  required String landmark,
  required String postalCode,
}) async {
  try {
    isSaving.value = true;

    final userId = await Prefs.getUserId() ?? "";

    final body = {
      "countryISO": countryISO,
      "phone": phone,
      "addressType": addressType.value,
      "zone": zone,
      "area": area,
      "municipality": municipality,
      "building": building,
      "street": street,
      "unit": unit,
      "landmark": landmark,
      "postalCode": postalCode,
      "latitude": latitude.value.toString(),
      "longitude": longitude.value.toString(),
      "bluePlateImage": null,
    };

    final res = await http.post(
      Uri.parse("${AppConstants.baseUrl}Yuser_api/addAddress"),
      headers: {
        "Token": AppConstants.token,
        "Userid": userId,
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    final data = jsonDecode(res.body);
    debugPrint("ADD ADDRESS RESPONSE → ${res.body}");

    if (data['success'] == true) {
      return data['message'];
    } else if (data['errors'] != null) {
      return data['errors'][0].values.first.toString();
    } else {
      return "Failed to add address";
    }
  } catch (e) {
    return e.toString();
  } finally {
    isSaving.value = false;
  }
}
}
