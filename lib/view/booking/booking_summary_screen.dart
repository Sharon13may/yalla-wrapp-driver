import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get.dart';
import 'package:yalla_wrapp_supervisor/controller/address_detaill_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/booking_details_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/cancel_booking_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/rating_controller.dart';
import 'package:yalla_wrapp_supervisor/view/booking/edite_booking.dart';
import 'package:yalla_wrapp_supervisor/view/booking/track_your_booking_screen.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';

class BookingSummaryScreen extends StatefulWidget {
  final String bookingId;
  const BookingSummaryScreen({super.key, required this.bookingId});

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  final BookingDetailsController controller =
      Get.put(BookingDetailsController());
      final AddressDetailController addressDetailController =
    Get.put(AddressDetailController());

bool isRated = false;



  String _selectedPayment = "option1";
  String getStatusText(String status) {
    switch (status) {
      case "0":
        return " Pending";
      case "1":
        return " Processing";
      case "2":
        return " Cancelled";
      case "3":
        return " Rejected";
      case "4":
        return " Finished";
      case "5":
        return " On The Way";
      default:

        return "Booking Status";
    }
  }

  bool canShowRating(String status) {
  return status == "4" && !isRated;
}

bool canCancelBooking(String status) {
  return status == "0" || status == "1";
}

bool canModifyBooking(String status) {
  return status == "0" || status == "1";
}

bool canTrackBooking(String status) {
  return status == "5";
}


  bool useAlternateCard(String status) {
    return status == "0" || status == "2" || status == "3";
  }

  String getActionButtonText(String status) {
    return status == "5" ? "Track".tr : "Modify Booking".tr;
  }

  final RatingController ratingController = RatingController();

void _submitRating(int rating, String review) async {
  if (rating == 0) return;

  final message = await ratingController.submitRating(
    bookingId: widget.bookingId,
    rating: rating,
    review: review,
  );

  setState(() {
    isRated = true; 
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 2),
    ),
  );
}
void _showCancelReasonDialog(BuildContext context) {
  final TextEditingController reasonController = TextEditingController();
  final cancelController = Get.put(BookingCancelController());

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        // title: const Text(
        //   "Cancel Booking",
        //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        // ),
        titlePadding: const EdgeInsets.fromLTRB(16, 16, 2, 0),
title: Row(
  children: [
    Expanded(
      child: Text(
        "Cancel Booking".tr,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    IconButton(
      icon: const Icon(Icons.close, size: 20),
      splashRadius: 20,
      onPressed: () {
        Navigator.pop(context);
      },
    ),
  ],
),

        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: "Enter reason for cancellation".tr,
                hintStyle: TextStyle(fontSize: 11,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 16),

            Obx(() => InkWell(
              onTap: cancelController.isLoading.value
    ? null
    : () async {
        if (reasonController.text.trim().isEmpty) return;

        final message = await cancelController.cancelBooking(
          bookingId: widget.bookingId,
          reason: reasonController.text.trim(),
        );

        Navigator.pop(context); // ✅ close dialog AFTER API

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 2),
          ),
        );

        controller.fetchBookingDetails(widget.bookingId);
      },

                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: AppColors.buttonGreen,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    alignment: Alignment.center,
                    child: cancelController.isLoading.value
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.buttonGreen,
                            ),
                          )
                        : Text(
                            "Submit Reason".tr,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                )),
          ],
        ),
      );
    },
  );
}


  @override
  void initState() {
    super.initState();
    controller.fetchBookingDetails(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Booking Summary'.tr,
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RefreshIndicator(
        
         color: AppColors.primaryPurple, // ✅ purple loader
  onRefresh: () async {
    await controller.fetchBookingDetails(widget.bookingId);
    addressDetailController.address.value = null;
  },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
            child: Obx(() {
              final booking = controller.booking.value;
        
              if (controller.isLoading.value || booking == null) {
                return const SizedBox();
              }
              
          final data = booking;
          final bool showActionButtons =
            canCancelBooking(data.status) ||
            canModifyBooking(data.status) ||
            canTrackBooking(data.status);
        
              // 🔥 CALL ADDRESS API ONCE USING addressId
        // if (addressDetailController.address.value == null &&
        //     data.addressId.isNotEmpty) {
        //   addressDetailController.fetchAddress(data.addressId);
        // }
        WidgetsBinding.instance.addPostFrameCallback((_) {
  if (addressDetailController.address.value == null &&
      data.addressId.isNotEmpty) {
    addressDetailController.fetchAddress(data.addressId);
  }
});

        
        
              return Column(
                children: [
                  const SizedBox(height: 15),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        
                        Image.asset(
                          useAlternateCard(data.status)
                              ? "assets/images/booking_summary_card2.png"
                              : "assets/images/booking_summary_card.png",
                          width: double.infinity,
                          height: 135,
                          fit: BoxFit.cover,
                        ),
        
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
        
                              Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      data.quantity,
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: useAlternateCard(data.status)
                                              ? AppColors.primaryPurple
                                              : const Color.fromARGB(
                                                  255, 182, 82, 0)),
                                    ),
                                  ),
        
                                  const SizedBox(width: 13),
                                  Text(
                                    data.serviceName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                    ),
                                  ),
                                ],
                              ),
        
                              const SizedBox(height: 14),
        
                              Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    padding: const EdgeInsets.all(6),
                                    child: Image.asset(
                                      "assets/images/deliveryicon.png",
                                      fit: BoxFit.cover,
                                    ),
                                  ),
        
                                  const SizedBox(width: 13),
        
                                  RichText(
                                    text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Your Booking is ".tr,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.normal,
                                            fontSize: 18,
                                          ),
                                        ),
                                        TextSpan(
                                          text: getStatusText(data.status),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                if (showActionButtons) ...[
          const SizedBox(height: 20),
                  Row(
                    children: [
                          if (canCancelBooking(data.status))
                      Expanded(
                        child: InkWell(
                          onTap: (){
                                 _showCancelReasonDialog(context);
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(25),
                              border: Border.all(
                                  color: AppColors.buttonGreen, width: 1.2),
                            ),
                            child: Center(
                              child: Text(
                                'Cancel Booking'.tr,
                                style: TextStyle(
                                  color: AppColors.buttonGreen,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
        
                      const SizedBox(width: 12),
                      
        
                          if (canCancelBooking(data.status) &&
          (canModifyBooking(data.status) || canTrackBooking(data.status)))
        const SizedBox(width: 0),
        
            /// MODIFY OR TRACK BUTTON
            if (canModifyBooking(data.status) || canTrackBooking(data.status))
                      Expanded(
                        child: InkWell(
                          onTap: () async{
                            // Get.to(TrackYourBookingScreen(
                            //   bookingId: widget.bookingId,
                            //   referenceId: data.referenceId,
                            // ));
                             if (canTrackBooking(data.status)) {
                Get.to(TrackYourBookingScreen(bookingId: widget.bookingId, referenceId: data.referenceId));
              } else {
              if (!canTrackBooking(data.status)) {
          // Get.to(
          //   EditBookingScreen(
          //     bookingId: widget.bookingId,
          //     serviceId: data.serviceId,
          //     serviceName: data.serviceName,
          //   ),
          // );
          await Get.to(
          EditBookingScreen(
            bookingId: widget.bookingId,
            serviceId: data.serviceId,
            serviceName: data.serviceName,
          ),
        );
        
        // ✅ REFRESH AFTER RETURN
        controller.fetchBookingDetails(widget.bookingId);
        
        // also refresh address if needed
        addressDetailController.address.value = null;
        
        }
        
              }
                          },
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: AppColors.buttonGreen,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Center(
                              child: Text(
                                getActionButtonText(data.status),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                
                ],
                  SizedBox(height: 20,),
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 253, 253, 253),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade400, width: 0.8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                        'Booking Details'.tr,
                          style: TextStyle(
                              fontSize: 13,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        _buildDetailRow('No. of items'.tr, data.quantity),
                        _buildDetailRow('Selected Date'.tr, data.bookDate),
                        _buildDetailRow('Selected Time'.tr, data.slotTime),
                        _buildDetailRow( 'Airline Name'.tr, data.airline),
        
                         if (data.addons.isNotEmpty) ...[
                        const Divider(height: 20, thickness: 0.8),
        
                        // const Text(
                        //   "Add-ons",
                        //   style: TextStyle(
                        //       fontSize: 14,
                        //       color: Color.fromARGB(255, 87, 87, 87),
                        //       fontWeight: FontWeight.normal),
                        // ),
                        // const SizedBox(height: 4),
                      
                        // Column(
                        //   crossAxisAlignment: CrossAxisAlignment.start,
                        //   children: data.addons
                        //       .map((a) => Text(
                        //             a.name,
                        //             style: const TextStyle(
                        //                 fontSize: 11, color: Colors.grey),
                        //           ))
                        //       .toList(),
                        // ),
        
                        // const Divider(height: 20, thickness: 0.8),
                     
  Text(
 'Add-ons'.tr,
    style: TextStyle(
      fontSize: 14,
      color: Color.fromARGB(255, 87, 87, 87),
      fontWeight: FontWeight.normal,
    ),
  ),
  const SizedBox(height: 4),

  Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: data.addons
        .map((a) => Text(
              a.name,
              style: const TextStyle(
                fontSize: 11,
                color: Colors.grey,
              ),
            ))
        .toList(),
  ),],
if (data.notes.isNotEmpty) ...[
  const Divider(height: 20, thickness: 0.8),


                        Text(
                        'Additional Note'.tr,
                          style: TextStyle(
                              fontSize: 14,
                              color: Color.fromARGB(255, 87, 87, 87),
                              fontWeight: FontWeight.normal),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          data.notes.isNotEmpty ? data.notes : "No notes".tr,
                          style:
                              const TextStyle(fontSize: 11, color: Colors.grey),
                        ),],
                      ],
                    ),
                  ),            
              if (canShowRating(data.status))
        
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: InkWell(
        onTap: () {
          _showRatingPopup(context);
        },
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade400, width: 0.8),
          ),
          child: Column(
            children: [
            Align(
              alignment: Alignment.topLeft,
              child: Text(
              "Rate Our Service".tr,
                        
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
                        ),
            ),
          SizedBox(height: 10,),
              Row(
                children: List.generate(
                  5,
                  (index) => const Padding(
                    padding: EdgeInsets.only(right: 6),
                    child: Icon(
                      Icons.star,
                      color: Color.fromARGB(255, 216, 216, 216),
                      size: 25,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
            ),
          ),
        
                 
                 Obx(() {
          final addr = addressDetailController.address.value;
        
          if (addr == null) {
            return const SizedBox();
          }
        
          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 253, 253, 253),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade400, width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Text(
          'Address'.tr,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            
            /// addressType
            Text(
              addr.addressType,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            
            const SizedBox(height: 4),
            
            /// phone + postal code
            Text(
              "${addr.phone} • ${addr.postalCode}",
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
            
            const SizedBox(height: 4),
            
            /// full address
            Text(
              addr.fullAddress,
              style: const TextStyle(fontSize: 11, color: Colors.grey),
            ),
          ],
        ),
            ),
          );
        }),
        
                
        
                  const SizedBox(height: 20),
        
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 253, 253, 253),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade400, width: 0.8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                         'Pricing Details'.tr,
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        _buildDetailRow(
                          "Wrapping Charge X ${data.quantity}",
                          "QAR ${data.basePrice}",
                        ),
                        _buildDetailRow(
                          "Home Service Fee",
                          "QAR ${data.homeServiceFee}",
                        ),
                        _buildDetailRow(
                          "Other Charges",
                          "QAR ${data.otherCharges}",
                        ),
                        _buildDetailRow(
                          "Grand Total",
                          "QAR ${data.totalPrice}",
                          isBold: true,
                          color: AppColors.buttonGreen,
                        ),
                      ],
                    ),
                  ),
        
                  const SizedBox(height: 25),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value,
      {bool isBold = false, Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: color ?? Colors.black,
              fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

  void _showRatingPopup(BuildContext context) {
    int selectedRating = 0;
    final TextEditingController reviewController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                   'Rate Our Service'.tr,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  /// ⭐ STARS
                 Row(
                  mainAxisAlignment: MainAxisAlignment.center,
  children: List.generate(5, (index) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedRating = index + 1;
          });
        },
        child: Icon(
          Icons.star,
          size: 28,
          color: index < selectedRating
              ? Colors.amber
              : const Color.fromARGB(255, 194, 194, 194),
        ),
      ),
    );
  }),
),


                  const SizedBox(height: 10),

                  /// 📝 REVIEW FIELD
                  TextField(
                    controller: reviewController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: "Enter Your Review".tr,
                      hintStyle: TextStyle(fontSize: 11, color: Colors.grey),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),

                  const SizedBox(height: 14),

                  /// SUBMIT BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.buttonGreen,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: () {
                        _submitRating(
                          selectedRating,
                          reviewController.text,
                        );
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Submit".tr,
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
