import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:yalla_wrapp_supervisor/controller/booking_list_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/home_controller.dart';
import 'package:yalla_wrapp_supervisor/view/booking/booking_summary_screen.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';

class MyBookingsScreen extends StatefulWidget {
  final bool showBack;
  const MyBookingsScreen({super.key, this.showBack = false});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  final homeController = Get.put(HomeController());
  final bookingController = Get.put(BookingController());

  String selectedDropdown = '';
  String selectedFilter = 'All';

  final List<String> filterOptions = [
    'All',
    'Pending',
    'Processing',
    'Cancelled',
    'Rejected',
    'Finished',
  ];
  @override
  void initState() {
    super.initState();

    ever(homeController.services, (_) {
      if (homeController.services.isNotEmpty &&
          bookingController.selectedServiceId.isEmpty) {
        final firstService = homeController.services.first;

        setState(() {
          selectedDropdown = firstService.displayName;
        });

        bookingController.updateService(
          firstService.serviceId.toString(),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        //automaticallyImplyLeading: false,
        centerTitle: true,
        automaticallyImplyLeading: widget.showBack, // 👈 KEY LINE
        leading: widget.showBack
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () => Get.back(),
              )
            : null,
        title: Text(
          'My Bookings'.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 10),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(child: Obx(() {
                    if (homeController.isLoading.value) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 175, 175, 175)),
                          borderRadius: BorderRadius.circular(25),
                          color: Colors.white,
                        ),
                        child: const Text("Loading...",
                            style: TextStyle(fontSize: 12)),
                      );
                    }

                    if (homeController.services.isEmpty) {
                      return const Text("No services found");
                    }

                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 175, 175, 175)),
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.white,
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                            // value: selectedDropdown.isEmpty
                            //     ? homeController.services.first.name
                            //     : selectedDropdown,
                            value: selectedDropdown.isEmpty
                                ? null
                                : selectedDropdown,
                            hint: Text("Select Service".tr,
                                style: const TextStyle(fontSize: 12)),
                            isExpanded: true,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            items: homeController.services.map((service) {
                              return DropdownMenuItem<String>(
                                value: service.displayName,
                                child: Text(service.displayName,
                                    style: const TextStyle(fontSize: 12)),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedDropdown = value!;
                              });

                              String id = homeController.services
                                  .firstWhere((e) => e.name == value)
                                  .serviceId
                                  .toString();

                              bookingController.updateService(id);
                            }),
                      ),
                    );
                  })),
                  const SizedBox(width: 10),
                  GestureDetector(
                    onTap: () {
                      Get.bottomSheet(
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.vertical(top: Radius.circular(20)),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ListTile(
                                title: Text("Low to High (ASC)".tr),
                                onTap: () {
                                  bookingController.updatePriceOrder("ASC");
                                  Get.back();
                                },
                              ),
                              ListTile(
                                title: Text("High to Low (DESC)".tr),
                                onTap: () {
                                  bookingController.updatePriceOrder("DESC");
                                  Get.back();
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 175, 175, 175)),
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white,
                      ),
                      child: Image.asset('assets/images/filtericon.png',
                          height: 25, width: 25),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 15),
              SizedBox(
                height: 45,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: filterOptions.map((option) {
                      final isSelected = selectedFilter == option;

                      return Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedFilter = option;
                            });
                            bookingController.updateStatus(option);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 14),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF00CE7C)
                                  : Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              option,
                              style: TextStyle(
                                color:
                                    isSelected ? Colors.white : Colors.black87,
                                fontSize: 11,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Obx(() {
                if (bookingController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: bookingController.bookingList.map((booking) {
                    bool isComplete = booking.status == 'Completed';

                    return InkWell(
                      onTap: () {
                        final bookingId = booking.bookingid;
                        print("➡️ Navigating with bookingId: $bookingId");

                        if (bookingId.isNotEmpty) {
                          Get.to(BookingSummaryScreen(bookingId: bookingId));
                        } else {
                          print("❌ bookingId is empty, navigation stopped");
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Container(
                              height: 55,
                              width: 55,
                              decoration: BoxDecoration(
                                color: const Color.fromARGB(255, 243, 238, 245),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: SvgPicture.asset(
                                  'assets/images/luggage_icon.svg',
                                  height: 25,
                                  width: 25,
                                  colorFilter: const ColorFilter.mode(
                                    AppColors.primaryPurple,
                                    BlendMode.srcIn,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    booking.referenceId,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "${booking.bookDate} | ${booking.slotTime}",
                                    style: const TextStyle(
                                      fontSize: 10,
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  booking.status,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isComplete
                                        ? Colors.green
                                        : Colors.orange,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  "QAR ${booking.totalPrice}",
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
}
