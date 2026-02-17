import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_wrapp_supervisor/controller/track_booking_controller.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';

class TrackYourBookingScreen extends StatelessWidget {
  final String bookingId;
  final String referenceId;
  TrackYourBookingScreen({
    super.key,
    required this.bookingId,
    required this.referenceId,
  });
  final TrackBookingController controller = Get.put(TrackBookingController());

  final steps = [
    "Booking Confirmed",
    "On The Way",
    "Finished",
    "Rejected",
  ];

  bool isStepCompleted(String apiStatus, String step) {
    switch (apiStatus) {
      case "Rejected":
        return step == "Booking Confirmed" || step == "Rejected";

      case "Finished":
        return step != "Rejected";

      case "OnTheWay":
        return step == "Booking Confirmed" || step == "On The Way";

      case "Processing":
      case "Pending":
        return step == "Booking Confirmed";

      default:
        return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    controller.fetchTrackStatus(bookingId);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Track Your Booking',
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Text(
              "Booking ID : $referenceId",
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 25),
            Obx(() {
              final apiStatus = controller.status.value;

              return Column(
                children: [
                  buildTrackStep(
                    isCompleted: true,
                    title: "Booking Confirmed",
                    subtitle: "Confirmed",
                  ),
                  buildTrackStep(
                    isCompleted: isStepCompleted(apiStatus, "On The Way"),
                    title: "On The Way",
                    subtitle:
                        apiStatus == "OnTheWay" ? "In progress" : "Pending",
                  ),
                  buildTrackStep(
                    isCompleted: isStepCompleted(apiStatus, "Finished"),
                    title: "Finished",
                    subtitle: apiStatus == "Finished" ? "Completed" : "Pending",
                  ),
                  buildTrackStep(
                    isCompleted: apiStatus == "Rejected",
                    title: "Rejected",
                    subtitle: apiStatus == "Rejected"
                        ? "Booking rejected"
                        : "Pending",
                  ),
                ],
              );
            })
          ],
        ),
      ),
    );
  }

  Widget buildTrackStep({
    required bool isCompleted,
    required String title,
    required String subtitle,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color:
                    isCompleted ? AppColors.buttonGreen : Colors.grey.shade400,
                shape: BoxShape.circle,
              ),
            ),
            Container(
              width: 3,
              height: 50,
              color: isCompleted ? AppColors.buttonGreen : Colors.grey.shade300,
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: isCompleted
                      ? const Color.fromARGB(255, 0, 0, 0)
                      : const Color.fromARGB(221, 78, 78, 78),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }
}
