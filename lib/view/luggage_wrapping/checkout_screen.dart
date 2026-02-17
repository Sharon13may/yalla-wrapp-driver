import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_wrapp_supervisor/controller/address_detaill_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/payment_controller.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';
import 'package:yalla_wrapp_supervisor/view/address_screen/address_screen.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';
import 'package:yalla_wrapp_supervisor/view/luggage_wrapping/success_screen.dart';
import '../../controller/booking_details_controller.dart';

class CheckoutScreen extends StatefulWidget {
  final String bookingId;

  const CheckoutScreen({super.key, required this.bookingId});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPayment = "option1";

  final bookingDetailsController = Get.put(BookingDetailsController());
  final PaymentController paymentController = Get.put(PaymentController());
  final AddressDetailController addressDetailController =
      Get.put(AddressDetailController());

  String _addressId = "";

  @override
  void initState() {
    super.initState();
    bookingDetailsController.fetchBookingDetails(widget.bookingId);
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    final id = await Prefs.getSelectedAddressId() ?? "";
    debugPrint("📌 CHECKOUT ADDRESS ID → $id");

    if (id.isNotEmpty) {
      _addressId = id;
      addressDetailController.fetchAddress(_addressId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (bookingDetailsController.isLoading.value ||
          bookingDetailsController.booking.value == null) {
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      }

      final data = bookingDetailsController.booking.value!;

      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 252, 252, 252),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Checkout'.tr,
            style: const TextStyle(
                color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: RefreshIndicator(
            color: AppColors.buttonGreen,
            onRefresh: () async {
              debugPrint("🔄 CHECKOUT REFRESH TRIGGERED");

              await bookingDetailsController
                  .fetchBookingDetails(widget.bookingId);

              if (_addressId.isNotEmpty) {
                await addressDetailController.fetchAddress(_addressId);
              }
            },
            child: ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                const SizedBox(height: 15),
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
                        "Booking Details".tr,
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow("No. of items".tr, data.quantity),
                      _buildDetailRow("Selected Date".tr, data.bookDate),
                      _buildDetailRow("Selected Time".tr,
                          "${data.slotTime} - ${data.slotEndTime}"),
                      _buildDetailRow("Airline Name".tr, data.airline),
                      const Divider(height: 20, thickness: 0.8),
                      Text(
                        "Add-ons".tr,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 87, 87, 87),
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 4),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: data.addons
                            .map((a) => Text(
                                  a.name,
                                  style: const TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                ))
                            .toList(),
                      ),
                      const Divider(height: 20, thickness: 0.8),
                      Text(
                        "Additional Note".tr,
                        style: const TextStyle(
                            fontSize: 14,
                            color: Color.fromARGB(255, 87, 87, 87),
                            fontWeight: FontWeight.normal),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        data.notes,
                        style:
                            const TextStyle(fontSize: 11, color: Colors.grey),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                Obx(() {
                  final addr = addressDetailController.address.value;

                  if (addr == null) {
                    return const SizedBox();
                  }

                  return Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 253, 253, 253),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: Colors.grey.shade400, width: 0.8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Address".tr,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              addr.addressType ?? "",
                              style: const TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "${addr.phone} • ${addr.postalCode}",
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.grey),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              addr.fullAddress,
                              style: const TextStyle(
                                  fontSize: 11, color: Colors.grey),
                            ),
                          ],
                        ),
                      ),

                      /// CHANGE BUTTON
                      Positioned(
                        top: 10,
                        right: 10,
                        child: InkWell(
                          // onTap: () {
                          //   Get.to(
                          //     () => const AddressScreen(),
                          //     arguments: {
                          //       "fromCheckout": true,
                          //       "bookingId": widget.bookingId,
                          //     },
                          //   );
                          // },
                          //         onTap: () async {
                          //   final result = await Get.to(
                          //     () => const AddressScreen(),
                          //     arguments: {
                          //       "fromCheckout": true,
                          //       "bookingId": widget.bookingId,
                          //     },
                          //   );

                          //   // ✅ RESULT RECEIVED HERE
                          //   if (result != null && result is String && result.isNotEmpty) {
                          //     debugPrint("🔁 NEW ADDRESS ID → $result");

                          //     // reload address
                          //     addressDetailController.fetchAddress(result);
                          //   }
                          // },
                          onTap: () async {
                            final result = await Get.to(
                              () => const AddressScreen(),
                              arguments: {
                                "fromCheckout": true,
                                "bookingId": widget.bookingId,
                              },
                            );

                            if (result != null &&
                                result is String &&
                                result.isNotEmpty) {
                              debugPrint("🔁 NEW ADDRESS ID → $result");

                              _addressId = result;

                              await Prefs.saveSelectedAddressId(result);

                              addressDetailController.fetchAddress(result);
                            }
                          },

                          //         onTap: () async {
                          //   final newAddressId = await Get.to(
                          //     () => const AddressScreen(),
                          //     arguments: {
                          //       "fromCheckout": true,
                          //       "bookingId": widget.bookingId,
                          //     },
                          //   );

                          //   if (newAddressId != null && newAddressId is String) {
                          //     debugPrint("🔄 REFRESH ADDRESS → $newAddressId");

                          //     addressDetailController.fetchAddress(newAddressId);
                          //   }
                          // },

                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6F4EA), 
                              borderRadius: BorderRadius.circular(19),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.edit_outlined,
                                    size: 14, color: Colors.green),
                                SizedBox(width: 4),
                                Text(
                                  "Change".tr,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),

                const SizedBox(height: 20),

                // --------------------------
                // Pricing (Dynamic)
                // --------------------------
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
                        "Pricing Details".tr,
                        style: const TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      _buildDetailRow("Wrapping Charge X ${data.quantity}",
                          "QAR ${data.basePrice}"),
                      _buildDetailRow(
                          "Home Service Fee", "QAR ${data.homeServiceFee}"),
                      _buildDetailRow(
                          "Other Charges", "QAR ${data.otherCharges}"),
                      const Divider(height: 20, thickness: 0.8),
                      _buildDetailRow("Grand Total", "QAR ${data.totalPrice}",
                          isBold: true, color: AppColors.buttonGreen),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                Align(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Preferred Payment after Services".tr,
                        style: const TextStyle(
                            fontSize: 13,
                            color: Colors.black,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 6),
                      RadioListTile<String>(
                        value: "option1",
                        groupValue: _selectedPayment,
                        activeColor: AppColors.buttonGreen,
                        title: Text("Cash on Delivery".tr,
                            style:
                                const TextStyle(fontSize: 12, color: Colors.black)),
                        onChanged: (value) {
                          setState(() => _selectedPayment = value!);
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                      RadioListTile<String>(
                        value: "option2",
                        groupValue: _selectedPayment,
                        activeColor: AppColors.buttonGreen,
                        title: Text("Credit/Debit on Delivery".tr,
                            style:
                                TextStyle(fontSize: 12, color: Colors.black)),
                        onChanged: (value) {
                          setState(() => _selectedPayment = value!);
                        },
                        contentPadding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),

        // --------------------------
        // Confirm Button (NO CHANGE)
        // --------------------------
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () async {
                  String payType = _selectedPayment == "option1" ? "1" : "2";
                  String payStatus =
                      _selectedPayment == "option1" ? "Un Paid" : "paid";

                  bool success = await paymentController.updatePayment(
                    bookingId: widget.bookingId,
                    payType: payType,
                    payStatus: payStatus,
                  );

                  if (success) {
                    Get.to(() => SuccessScreen(
                          bookingId: widget.bookingId,
                        ));
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  "Confirm Booking".tr,
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
    });
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
