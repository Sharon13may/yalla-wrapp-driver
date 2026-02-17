import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_wrapp_supervisor/controller/booking_details_controller.dart';
import 'package:yalla_wrapp_supervisor/view/bottom_nav_bar.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';

class SuccessScreen extends StatefulWidget {
  final String bookingId;
  const SuccessScreen({super.key, required this.bookingId});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  final bookingDetailsController = Get.put(BookingDetailsController());

  @override
  void initState() {
    super.initState();
    bookingDetailsController.fetchBookingDetails(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 80),

              Image.asset('assets/images/success.png', height: 190),
              const SizedBox(height: 10),

              Text(
                "Your Booking Has Been Placed Successfully".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),

              Text(
                "Our agent will be in touch before service delivery".tr,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 25),

              Obx(() {
                final data = bookingDetailsController.booking.value;

                // safe local variables with defaults
                final quantity = data?.quantity ?? "--";
                final bookDate = data?.bookDate ?? "--";
                final slotTime = data?.slotTime ?? "--";
                final slotEndTime = data?.slotEndTime ?? "--";
                final airline =
                    (data?.airline != null && data!.airline.isNotEmpty)
                        ? data.airline
                        : "--";
                final notes = data?.notes ?? "No notes added".tr;
                final addons = data?.addons ?? [];

                return Container(
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
                        "Booking Details".tr,
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),

                      _buildDetailRow("No. of items".tr, quantity),
                      _buildDetailRow("Selected Date".tr, bookDate),
                      _buildDetailRow(
                          "Selected Time".tr, "$slotTime - $slotEndTime"),
                      _buildDetailRow("Airline Name".tr, airline),

                      const Divider(height: 20, thickness: 0.8),

                      Text(
                        "Add-ons".tr,
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 87, 87, 87),
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 4),

                      if (addons.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: addons
                              .map((a) => Text(
                                    a.name ?? "",
                                    style: const TextStyle(
                                        fontSize: 11, color: Colors.grey),
                                  ))
                              .toList(),
                        )
                      else
                        Text("No Add-ons".tr,
                            style: TextStyle(fontSize: 11, color: Colors.grey)),

                      const Divider(height: 20, thickness: 0.8),

                      Text(
                        "Additional Note".tr,
                        style: TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 87, 87, 87),
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 4),

                      Text(
                        notes,
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                Get.to(const BottomNavBar());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Text(
                "Back to Home".tr,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
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
}

// import 'package:flutter/material.dart';
// import 'package:get/get_core/get_core.dart';
// import 'package:yalla_wrapp/view/bottom_nav_bar.dart';
// import 'package:yalla_wrapp/view/constants/app_colors.dart';
// import 'package:get/get_navigation/get_navigation.dart';

// class SuccessScreen extends StatefulWidget {
//      final String bookingId;
//   const SuccessScreen({super.key, required this.bookingId});

//   @override
//   State<SuccessScreen> createState() => _SuccessScreenState();
// }

// class _SuccessScreenState extends State<SuccessScreen> {

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color.fromARGB(255, 252, 252, 252),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               const SizedBox(height: 80),

//               Image.asset(
//                 'assets/images/success.png',
//                 height: 190,
//               ),
//               const SizedBox(height: 10),

//               const Text(
//                 "Your Booking Has Been Placed Successfully",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 6),
//               const Text(
//                 "Our agent will be in touch before service delivery",
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 11,
//                   color: Colors.grey,
//                 ),
//               ),

//               const SizedBox(height: 25),

//               Container(
//                 width: double.infinity,
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//                 decoration: BoxDecoration(
//                   color: const Color.fromARGB(255, 253, 253, 253),
//                   borderRadius: BorderRadius.circular(20),
//                   border: Border.all(color: Colors.grey.shade400, width: 0.8),
//                 ),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       "Booking Details",
//                       style: TextStyle(
//                           fontSize: 13,
//                           color: Colors.black,
//                           fontWeight: FontWeight.bold),
//                     ),
//                     const SizedBox(height: 8),
//                     _buildDetailRow("No. of Luggage", "3"),
//                     _buildDetailRow("Selected Date", "07 Nov 2025"),
//                     _buildDetailRow("Selected Time", "9:00 AM - 10:00 AM"),
//                     _buildDetailRow("Airline Name", "IndiGo Airlines (6E)"),
//                     const Divider(height: 20, thickness: 0.8),

//                     const Text(
//                       "Add-ons",
//                       style: TextStyle(
//                           fontSize: 14,
//                           color: Color.fromARGB(255, 87, 87, 87),
//                           fontWeight: FontWeight.normal),
//                     ),
//                     const SizedBox(height: 4),
//                     const Text(
//                       "Dubai International Airport, Terminal 1",
//                       style: TextStyle(fontSize: 11, color: Colors.grey),
//                     ),
//                     const Divider(height: 20, thickness: 0.8),
//                     const Text(
//                       "Additional Note",
//                       style: TextStyle(
//                           fontSize: 14,
//                           color: Color.fromARGB(255, 87, 87, 87),
//                           fontWeight: FontWeight.normal),
//                     ),
//                     const SizedBox(height: 4),
//                     const Text(
//                       "Please make sure all zippers and handles are properly secured and covered while wrapping to prevent any damage during travel.",
//                       style: TextStyle(fontSize: 11, color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 20),
//             ],
//           ),
//         ),
//       ),

//       bottomNavigationBar: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
//           child: SizedBox(
//             height: 50,
//             child: ElevatedButton(
//               onPressed: () {
//               Get.to(const BottomNavBar());
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.buttonGreen,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(30),
//                 ),
//                 elevation: 0,
//               ),
//               child: const Text(
//                 "Back to Home",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 13,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(String title, String value,
//       {bool isBold = false, Color? color}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 2),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(title,
//               style: const TextStyle(fontSize: 12, color: Colors.black54)),
//           Text(
//             value,
//             style: TextStyle(
//               fontSize: 12,
//               color: color ?? Colors.black,
//               fontWeight: isBold ? FontWeight.bold : FontWeight.w400,
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
