import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:yalla_wrapp_supervisor/model/booking_list_model.dart';
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import '../utils/prefs.dart';

class BookingController extends GetxController {
  var isLoading = false.obs;
  var bookingList = <BookingModel>[].obs;
  String mapStatusToApi(String status) {
  switch (status.toLowerCase()) {
    case 'pending':
      return 'Pending';
    case 'processing':
      return 'Processing';
    case 'cancelled':
      return 'Cancelled';
    case 'rejected':
      return 'Rejected';
    case 'finished':
      return 'Finished';
    default:
      return '';
  }
}


  final String url = "${AppConstants.baseUrl}Yuser_api/filterBookings";
 

  String selectedServiceId = "";
  String selectedStatus = "";
  String selectedPriceOrder = "";
  int _requestCounter = 0;

  
  @override
  void onInit() {
    super.onInit();
  fetchBookings(); 
  }

  // Future<void> fetchBookings() async {
  //   try {
  //     isLoading(true);

  //     String userId = await Prefs.getUserId() ?? "";

  //     final body = {
  //       "serviceId": selectedServiceId,
  //       "status": selectedStatus,
  //       "orderByPrice": selectedPriceOrder,
  //     };

  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: {
  //         "Token": token,
  //         "UserId": userId,
  //         "Content-Type": "application/json",
  //       },
  //       body: json.encode(body),
  //     );

  //     final res = json.decode(response.body);
   

  //     if (res["success"] == true) {
  //       List data = res["data"];
  //       bookingList.value =
  //           data.map((e) => BookingModel.fromJson(e)).toList();
  //     }
  //   } catch (e) {
  //     print("Booking Fetch Error: $e");
  //   } finally {
  //     isLoading(false);
  //   }
  // }
Future<void> fetchBookings() async {
  final int requestId = ++_requestCounter;

  try {
    isLoading(true);

    String userId = await Prefs.getUserId() ?? "";

    final body = {
      "serviceId": selectedServiceId.isNotEmpty ? selectedServiceId : "",
      "status": selectedStatus.isNotEmpty ? selectedStatus : "",
      "orderByPrice": selectedPriceOrder.isNotEmpty ? selectedPriceOrder : "",
    };

    print("✅ FINAL BODY [$requestId] → $body");

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Token": AppConstants.token,
        "UserId": userId,
        "Content-Type": "application/json",
      },
      body: json.encode(body),
    );

    // Ignore outdated responses
    if (requestId != _requestCounter) return;

    final res = json.decode(response.body);

    if (res["success"] == true) {
      bookingList.value = (res["data"] as List)
          .map((e) => BookingModel.fromJson(e))
          .toList();
    } else {
      bookingList.clear();
    }
  } catch (e) {
    print("Booking Fetch Error: $e");
  } finally {
    if (requestId == _requestCounter) {
      isLoading(false);
    }
  }
}

  // Update filters
  void updateService(String id) {
  selectedServiceId = id; // may be ""
  fetchBookings();
}

void updateStatus(String status) {
  selectedStatus = status == "All" ? "" : status;
  fetchBookings();
}

void updatePriceOrder(String order) {
  selectedPriceOrder = order; // "ASC" / "DESC" / ""
  fetchBookings();
}
}