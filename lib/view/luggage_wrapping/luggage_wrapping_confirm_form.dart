import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get.dart';
import 'package:yalla_wrapp_supervisor/controller/booking_note_controller.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';
import 'package:yalla_wrapp_supervisor/view/luggage_wrapping/checkout_screen.dart';

class LuggageWrappingConfirmScreen extends StatefulWidget {
  final String bookingId;
  final String servicename;
  const LuggageWrappingConfirmScreen(
      {super.key, required this.bookingId, required this.servicename});

  @override
  State<LuggageWrappingConfirmScreen> createState() =>
      _LuggageWrappingConfirmScreenState();
      
}

class _LuggageWrappingConfirmScreenState
    extends State<LuggageWrappingConfirmScreen> {
  final NoteController noteController = Get.put(NoteController());

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  late PageController _pageController;

  double _currentPage = 0;

  final List<String> _banners = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
  ];

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      viewportFraction: 0.90,
      initialPage: 100 * _banners.length,
    );
    _currentPage = _pageController.initialPage.toDouble();

    _timer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (_pageController.hasClients) {
        _currentPage++;
        _pageController.animateToPage(
          _currentPage.toInt(),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
  final bool isLuggageWrap =
    widget.servicename.trim().toLowerCase() == "luggage wrap";



    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          widget.servicename,
          style: const TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                 Text(
                  "To serve you better, please provide any additional instructions or information below".tr,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(221, 110, 110, 110)),
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(

                  "Additional Note (Optional)".tr,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(221, 53, 53, 53)),
                ),
                const SizedBox(height: 6),
                _buildTextField(
                  maxLines: 3,
                  controller: firstNameController,
                  hint: "E.g., special requests, delivery notes…".tr,
                ),
                const SizedBox(height: 18),
                // const Text(
                //   "Select Airline (Optional)",
                //   style: TextStyle(
                //       fontSize: 12,
                //       fontWeight: FontWeight.bold,
                //       color: Color.fromARGB(221, 53, 53, 53)),
                // ),
                // const SizedBox(height: 6),
                // _buildTextField(
                //   controller: lastNameController,
                //   hint: "IndiGo Airlines (6E)",
                // ),
                // const SizedBox(height: 18),
                if (isLuggageWrap) ...[
                Text(
                    "Select Airline".tr,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(221, 53, 53, 53),
                    ),
                  ),
                  const SizedBox(height: 6),
                  _buildTextField(
                    controller: lastNameController,
                    hint: "Enter Airlines".tr,
                  ),
                  const SizedBox(height: 18),
                ],
              ],
            ),
          ),
          const SizedBox(height: 44),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                String note = firstNameController.text.trim();
                String airline = lastNameController.text.trim();

                bool success = await noteController.saveNote(
                  bookingId: widget.bookingId,
                  note: note,
                  airline: airline,
                );
                final bookingId = await widget.bookingId;

                if (success) {
                  Get.to(CheckoutScreen(bookingId: bookingId));
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
                'Continue to Checkout'.tr,
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: maxLines == 1 ? 50 : null,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 253, 253, 253),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.grey.shade400,
          width: 0.8,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: maxLines == 1 ? 0 : 8,
      ),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.multiline,
        maxLines: maxLines,
        textAlignVertical:
            maxLines == 1 ? TextAlignVertical.center : TextAlignVertical.top,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }
}
