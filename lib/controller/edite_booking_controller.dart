import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:yalla_wrapp_supervisor/services/booking_services.dart';

class EditBookingController extends GetxController {
  var isLoading = false.obs;

  Future<bool> updateBooking(Map<String, dynamic> body) async {
    try {
      isLoading.value = true;

      final res = await BookingService.editBooking(body);
          debugPrint("Edit Booking API Response: $res");

      if (res["success"] == true) {
       // Get.snackbar("Success", res["message"]);
        return true;
      } else {
        Get.snackbar("Error", res["message"]);
        return false;
      }
    } catch (e) {
     // Get.snackbar("Error", "Something went wrong");
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
