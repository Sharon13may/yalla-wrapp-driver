import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shimmer/shimmer.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:yalla_wrapp_supervisor/controller/addon_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/banner_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/coupon_apply_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/create_booking_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/pricing_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/slot_controller.dart';
import 'package:yalla_wrapp_supervisor/model/addon_model.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';
import 'package:yalla_wrapp_supervisor/view/luggage_wrapping/luggage_wrapping_confirm_form.dart';


class LuggageWrappingScreen extends StatefulWidget {
  final String serviceId;
  final String serviceName;
  const LuggageWrappingScreen({
    super.key,
    required this.serviceId,
    required this.serviceName,
  });

  @override
  State<LuggageWrappingScreen> createState() => _LuggageWrappingScreenState();
}

class _LuggageWrappingScreenState extends State<LuggageWrappingScreen> {
  final CouponApplyController couponController =
      Get.put(CouponApplyController());

  final TextEditingController couponControllerText = TextEditingController();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  late PageController _pageController;
  String? selectedTimePeriod;
  final AddonsController addonsController = Get.put(AddonsController());
  final SlotController slotController = Get.put(SlotController());
  final GlobalKey addonKey = GlobalKey();

  double _currentPage = 0;
  final PricingController pricingController = Get.put(PricingController());
  final CBookingController bookingController = Get.put(CBookingController());
  final ServiceBannerController bannerController =
    Get.put(ServiceBannerController());


  final List<String> _banners = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
  ];

  Timer? _timer;
int _currentIndex = 0;


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

     // _pageController = PageController(viewportFraction: 0.85);

  bannerController.fetchServiceBanners(widget.serviceId);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  void _removeSelectedAddon(AddonModel addon) {
    addon.isSelected.value = false;
    lastNameController.text = addonsController.addons
        .where((a) => a.isSelected.value)
        .map((a) => a.addonId)
        .join(', ');
  }

  Widget _buildAddonSelectorField() {
    return GestureDetector(
      onTap: () async {
        FocusScope.of(context).unfocus();

        await addonsController.fetchAddons(widget.serviceId);

        // final renderBox = context.findRenderObject() as RenderBox;
        // final offset = renderBox.localToGlobal(Offset.zero);

        // _showAddonsDropdown(offset.dy + renderBox.size.height, offset.dx);
        RenderBox box =
            addonKey.currentContext!.findRenderObject() as RenderBox;
        Offset position = box.localToGlobal(Offset.zero);

        final top = position.dy + box.size.height;
        final left = position.dx;

        _showAddonsDropdown(top, left);
      },
      child: Container(
        key: addonKey,
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Obx(() {
          final selected =
              addonsController.addons.where((a) => a.isSelected.value).toList();

          if (selected.isEmpty) {
            return Row(
              children: [
                Expanded(
                  child: Text(
                    'Select add-ons'.tr,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                  ),
                ),
                Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey.shade600),
              ],
            );
          }
          return Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: selected.map((addon) {
                      return Container(
                        margin: const EdgeInsets.only(right: 8),
                        child:
                        Chip(
  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
  backgroundColor: Colors.grey.shade100,
  label: Text(addon.name, style: const TextStyle(fontSize: 13)),
  deleteIcon: const Icon(Icons.close, size: 18),
  onDeleted: () => _removeSelectedAddon(addon),
),

                       
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.keyboard_arrow_down_rounded,
                  color: Colors.grey.shade600),
            ],
          );
        }),
      ),
    );
  }

Widget _bannerShimmer() {
  return ListView.separated(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(horizontal: 16),
    itemBuilder: (_, __) => Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: double.infinity,
        height:double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Colors.white,
        ),
      ),
    ),
    separatorBuilder: (_, __) => const SizedBox(width: 14),
    itemCount: 3,
  );
}


  void _showAddonsDropdown(double top, double left) {
    final overlay = Overlay.of(context);
    late OverlayEntry entry;

    entry = OverlayEntry(
      builder: (context) {
        final maxHeight = MediaQuery.of(context).size.height * 0.45;

        return Stack(
          children: [
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                entry.remove();
              },
            ),
            Positioned(
              top: top,
              left: left,
              width: MediaQuery.of(context).size.width - 48,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  constraints: BoxConstraints(maxHeight: maxHeight),
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Obx(() {
                    if (addonsController.isLoading.value) {
                      return const Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final list = addonsController.addons;

                    if (list.isEmpty) {
                      return Padding(
                        padding: EdgeInsets.all(18),
                        child: Center(
                          child: Text(
                            "Add-ons not found".tr,
                            style:
                                TextStyle(fontSize: 14, color: Colors.black54),
                          ),
                        ),
                      );
                    }

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Expanded(
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: list.length,
                            itemBuilder: (context, idx) {
  final addon = list[idx];

  return Obx(() {
    return ListTile(
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4),
      title: Text(
        "${addon.name} (${addon.price})",
        style: const TextStyle(fontSize: 13),
      ),
      trailing: Checkbox(
        value: addon.isSelected.value,
        activeColor: Colors.green,
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        visualDensity: VisualDensity.compact,
        onChanged: (val) {
          addon.isSelected.value = val ?? false;

          lastNameController.text = addonsController.addons
              .where((a) => a.isSelected.value)
              .map((a) => a.name)
              .join(', ');
        },
      ),
      onTap: () {
        addon.isSelected.toggle();

        lastNameController.text = addonsController.addons
            .where((a) => a.isSelected.value)
            .map((a) => a.name)
            .join(', ');
      },
    );
  });
},

                      
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                lastNameController.text = addonsController
                                    .addons
                                    .where((a) => a.isSelected.value)
                                    .map((a) => a.name)
                                    .join(', ');

                                entry.remove();
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryGreen,
                                minimumSize: const Size(double.infinity, 40),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Text(
                                "Submit".tr,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(entry);
  }
  void _startAutoScroll(int length) {
  _timer?.cancel();

  if (length <= 1) return; // ❌ no scroll if only one image

  _timer = Timer.periodic(const Duration(seconds: 3), (_) {
    if (!_pageController.hasClients) return;

    _currentIndex++;

    if (_currentIndex >= length) {
      // jump back to first (no animation flicker)
      _currentIndex = 0;
      _pageController.jumpToPage(0);
    } else {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  });
}


  @override
  Widget build(BuildContext context) {
           final bool isLuggageWrap = widget.serviceName == "Luggage Wrap";
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 252, 252, 252),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          widget.serviceName,
          style: const TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            // SizedBox(
            //   height: 125,
            //   child: PageView.builder(
            //     controller: _pageController,
            //     itemBuilder: (context, index) {
            //       final realIndex = index % _banners.length;
                  
            //       return AnimatedBuilder(
            //         animation: _pageController,
            //         builder: (context, child) {
            //           double value = 1.0;
            //           if (_pageController.position.haveDimensions) {
            //             value = (_pageController.page ?? _currentPage) - index;
            //             value = (1 - (value.abs() * 0.70)).clamp(0.9, 1.0);
            //           }
            //           return Center(
            //             child: SizedBox(
            //               height: Curves.easeOut.transform(value) * 150,
            //               child: child,
            //             ),
            //           );
            //         },
            //         child: Container(
            //           margin: const EdgeInsets.symmetric(horizontal: 7),
            //           decoration: BoxDecoration(
            //             borderRadius: BorderRadius.circular(20),
            //             image: DecorationImage(
            //               image: AssetImage(_banners[realIndex]),
            //               fit: BoxFit.cover,
            //             ),
            //             boxShadow: const [
            //               BoxShadow(
            //                 color: Color.fromARGB(66, 197, 197, 197),
            //                 blurRadius: 5,
            //                 offset: Offset(0, 5),
            //               ),
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // ),
            SizedBox(
  height: 125,
  child: Obx(() {
    if (bannerController.isLoading.value) {
      return _bannerShimmer();
    }

    // final bannerList = bannerController.banners.isNotEmpty
    //     ? bannerController.banners
    //     : _banners; // fallback to default assets

        final bannerList = bannerController.banners.isNotEmpty
    ? bannerController.banners
    : _banners;

// ensure first image is shown
WidgetsBinding.instance.addPostFrameCallback((_) {
  _currentIndex = 0;
  _pageController.jumpToPage(0);
  _startAutoScroll(bannerList.length);
});


    return 
    // PageView.builder(
    //   controller: _pageController,
    //   itemCount: bannerList.length,
    //   itemBuilder: (context, index) {
    //     return AnimatedBuilder(
    //       animation: _pageController,
    //       builder: (context, child) {
    //         double value = 1.0;
    //         if (_pageController.position.haveDimensions) {
    //           value = (_pageController.page ?? _currentPage) - index;
    //           value = (1 - (value.abs() * 0.70)).clamp(0.9, 1.0);
    //         }
    //         return Center(
    //           child: SizedBox(
    //             height: Curves.easeOut.transform(value) * 150,
    //             child: child,
    //           ),
    //         );
    //       },
    //       child: Container(
    //         margin: const EdgeInsets.symmetric(horizontal: 7),
    //         decoration: BoxDecoration(
    //           borderRadius: BorderRadius.circular(20),
    //           image: DecorationImage(
    //             image: bannerList[index].startsWith("http")
    //                 ? NetworkImage(bannerList[index])
    //                 : AssetImage(bannerList[index]) as ImageProvider,
    //             fit: BoxFit.cover,
    //           ),
    //           boxShadow: const [
    //             BoxShadow(
    //               color: Color.fromARGB(66, 197, 197, 197),
    //               blurRadius: 5,
    //               offset: Offset(0, 5),
    //             ),
    //           ],
    //         ),
    //       ),
    //     );
    //   },
    // );
PageView.builder(
  controller: _pageController,
  itemCount: bannerList.length,
  onPageChanged: (index) {
    _currentIndex = index;
  },
  itemBuilder: (context, index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color.fromARGB(66, 197, 197, 197),
            blurRadius: 5,
            offset: Offset(0, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      // child: Image(
      //   image: bannerList[index].startsWith("http")
      //       ? NetworkImage(bannerList[index])
      //       : AssetImage(bannerList[index]) as ImageProvider,
      //   fit: BoxFit.cover, 
      //   width: double.infinity,
      //   height: double.infinity,
      // ),
      child: bannerList[index].toLowerCase().endsWith(".svg")
    ? SvgPicture.network(
        bannerList[index],
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholderBuilder: (context) => Container(
          color: Colors.grey.shade300,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        ),
      )
    : bannerList[index].startsWith("http")
        ? Image.network(
            bannerList[index],
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;

              return Container(
                color: Colors.grey.shade300,
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey.shade300,
                child: const Center(
                  child: Icon(Icons.image_not_supported, size: 40),
                ),
              );
            },
          )
        : Image.asset(
            bannerList[index],
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

    );
  },
);


  }),
),

            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                
                children: [
           

Text(
  isLuggageWrap ? "No. of Luggage*".tr : "No. Of Items*".tr,
  style: const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Color.fromARGB(221, 53, 53, 53),
  ),
),
const SizedBox(height: 6),
_buildNumberField(
  controller: firstNameController,
  hint: isLuggageWrap
      ? "Enter no. of luggage".tr
      : "Enter no. of Items".tr,
),

              
                  const SizedBox(height: 18),
                  Text(
                    "Add-Ons".tr,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(221, 53, 53, 53)),
                  ),
                  const SizedBox(height: 6),
                  _buildAddonSelectorField(),
                  const SizedBox(height: 18),
                  Text(
                    "Date & Time".tr,
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(221, 53, 53, 53)),
                  ),
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: () {
                      _openDateTimeSheet(context);
                    },
                    child: AbsorbPointer(
                      child: _buildTextField(
                        controller: phoneController,
                        hint: "Select a date and time slot".tr,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 253, 253, 253),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 0.8,
                      ),
                    ),
                    child: Obx(() {
                      final pricing = pricingController.pricing.value;

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Pricing Details".tr,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 6),

                          // If no price yet → show subtitle
                          if (pricing == null) ...[
                            Text(
                              "Add no. of luggage to get pricing summary".tr,
                              style: TextStyle(
                                fontSize: 11,
                                color: Color.fromARGB(255, 104, 104, 104),
                              ),
                            ),
                          ] else ...[
                            _priceRow("Base Price".tr, "QAR ${pricing.basePrice}"),
                            _priceRow(
                                "Service Fee".tr, "QAR ${pricing.serviceFee}"),
                            _priceRow(
                                "Other Charges".tr, "QAR ${pricing.otherCharges}"),
                            const Divider(height: 16),
                            _priceRow(
                              "Total Price",
                              "QAR ${pricing.totalPrice}",
                              isBold: true,
                            ),
                          ],
                        ],
                      );
                    }),
                  ),
                  const SizedBox(height: 10),
                  _couponApplySection(),
                  const SizedBox(height: 30),
                ],
              ),
            ),
            const SizedBox(height: 44),
             Text(
              "Free Home Service".tr,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(221, 0, 0, 0)),
            ),
            const SizedBox(height: 3),
             Text(
              "If you have more than 3 luggage".tr,
              style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.normal,
                  color: Color.fromARGB(221, 87, 87, 87)),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, bottom: 16, top: 5),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                if (slotController.selectedDate.value.isEmpty ||
                    slotController.selectedStartTime.value.isEmpty) {
                  Get.snackbar("Required", "Please select date & time",
                      snackPosition: SnackPosition.BOTTOM);
                  return;
                }

                final pricing = pricingController.pricing.value;

                if (pricing == null) {
                  Get.snackbar(
                      "Required".tr, "Please add number of luggage to get price".tr,
                      snackPosition: SnackPosition.BOTTOM);
                  return;
                }

                final addressid = await Prefs.getSelectedAddressId() ?? "";
                debugPrint(
                    "🟢 SAVED ADDRESS ID FROM PREFS TO BOOKING → $addressid");

                final selectedAddons = addonsController.addons
                    .where((a) => a.isSelected.value)
                    .map((a) => a.addonId)
                    .toList();

                final body = {
                  "serviceId": widget.serviceId,
                  "addressId": addressid,
                  "assignedStaffId": slotController.assignedStaffId.value,
                  "bookDate": slotController.selectedDate.value,
                  "slotTime": slotController.selectedStartTime.value,
                  "slotEndTime": slotController.selectedEndTime.value,
                  "basePrice": double.tryParse(pricing.basePrice) ?? 0,
                  "homeServiceFee": pricing.serviceFee ?? 0,
                  "quantity": int.tryParse(firstNameController.text) ?? 1,
                  "otherCharges": double.tryParse(pricing.otherCharges) ?? 0,
                  "totalPrice": pricing.totalPrice ?? 0,
                  "addons": selectedAddons,
                };

                final bookingId = await bookingController.submitBooking(body);

                if (bookingId != null) {
                  Get.to(LuggageWrappingConfirmScreen(bookingId: bookingId, servicename : widget.serviceName));
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                elevation: 0,
              ),
              child: Obx(() {
                return bookingController.isLoading.value
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    :  Text(
                        'Book Now'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
  }) {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 253, 253, 253),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: Colors.grey.shade400,
          width: 0.8,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ),
    );
  }

  void _openDateTimeSheet(BuildContext context) {
    DateTime selectedDate = DateTime.now();
    String? selectedTime;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            List<String> times = [
              "7:00 AM - 8:00 AM",
              "8:00 AM - 9:00 AM",
              "9:00 AM - 10:00 AM",
              "10:00 AM - 11:00 AM",
              "11:00 AM - 12:00 PM",
              "12:00 PM - 1:00 PM",
              "1:00 PM - 2:00 PM",
              "2:00 PM - 3:00 PM",
              "3:00 PM - 4:00 PM",
              "4:00 PM - 5:00 PM",
              "5:00 PM - 6:00 PM",
              "6:00 PM - 7:00 PM",
              "7:00 PM - 8:00 PM",
              "8:00 PM - 9:00 PM",
            ];

            return SizedBox(
              height: MediaQuery.of(context).size.height * 0.87,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 16, top: 20, bottom: 10, right: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Select Date & Time".tr,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 15)),
                        GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Icon(Icons.close, size: 25)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                           Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text("Select Preferred Date".tr,
                                style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 68, 68, 68))),
                          ),
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 247, 240, 255),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: TableCalendar(
                              firstDay: DateTime.now(),
                              lastDay:
                                  DateTime.now().add(const Duration(days: 365)),
                              focusedDay: selectedDate,
                              selectedDayPredicate: (day) =>
                                  isSameDay(selectedDate, day),
                              onDaySelected: (selected, focused) {
                                setState(() {
                                  selectedDate = selected;
                                });
                              },
                              calendarStyle:  CalendarStyle(
                                defaultTextStyle: TextStyle(fontSize: 13),
                                weekendTextStyle: TextStyle(fontSize: 13),
                                  todayDecoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(
      color: AppColors.primaryPurple,
      width: 1.5,
    ),
  ),
  todayTextStyle: const TextStyle(
    fontSize: 13,
    color: Colors.black,
  ),

                               
                                selectedTextStyle: TextStyle(
                                    fontSize: 13, color: Colors.white),
                              ),
                              headerStyle: const HeaderStyle(
                                formatButtonVisible: false,
                                titleCentered: true,
                                titleTextStyle: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            child: Text("Select Preferred Time".tr,
                                style: TextStyle( fontSize: 12,
                                    color: Color.fromARGB(255, 68, 68, 68),
                                   )),
                          ),
              
                   
                          const SizedBox(height: 10),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 16),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 247, 240, 255),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 4,
                                mainAxisSpacing: 0,
                                crossAxisSpacing: 1,
                              ),
                              itemCount: times.length,
                              itemBuilder: (context, index) {
                                final time = times[index];
                                final isSelected = selectedTime == time;

                                return GestureDetector(
                                  onTap: () =>
                                      setState(() => selectedTime = time),
                                  child: Container(
                                    alignment: Alignment.center,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primaryPurple
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primaryPurple
                                            : Colors.transparent,
                                      ),
                                    ),
                                    child: Text(
                                      time,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 12,
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          const SizedBox(height: 16),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('You didnt find a vacant slot?'.tr,
                                          style: TextStyle(
                                              fontSize: 11,
                                              color: Colors.grey)),
                                      SizedBox(height: 4),
                                      Text("Call or WhatsApp".tr,
                                          style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    _smallIconBox(Icons.call),
                                    const SizedBox(width: 10),
                                    _smallIconBox(
                                        Icons.messenger_outline_rounded),
                                  ],
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () async {
                          try {
                            if (selectedTime == null) {
                              Get.snackbar(
                                  "Required".tr, "Please select a time slot".tr,
                                  snackPosition: SnackPosition.BOTTOM);
                              return;
                            }

                            final now = DateTime.now();
                            final selectedDateTime = DateTime(
                              selectedDate.year,
                              selectedDate.month,
                              selectedDate.day,
                            );

                            if (selectedDateTime.isBefore(
                                DateTime(now.year, now.month, now.day))) {
                              Get.snackbar(
                                  "Invalid", "Past dates cannot be selected",
                                  snackPosition: SnackPosition.BOTTOM);
                              return;
                            }

                            String slotTimeFormatted =
                                _convertTimeToApiFormat(selectedTime!);
                            debugPrint(
                                "DEBUG: formatted slot for API = $slotTimeFormatted");

                            final bookDateStr =
                                "${selectedDate.year}-${selectedDate.month.toString().padLeft(2, '0')}-${selectedDate.day.toString().padLeft(2, '0')}";
                            debugPrint("DEBUG: bookDateStr = $bookDateStr");

                            bool available =
                                await slotController.checkSlotAvailable(
                              bookDate: bookDateStr,
                              slotTime: slotTimeFormatted,
                              token: "yourTokenHere",
                            );

                            debugPrint("DEBUG: slot available = $available");

                            if (!available) return;

                            List<String> parts = slotTimeFormatted.split("-");
                            int startHour = int.tryParse(parts[0]) ?? 0;
                            int endHour =
                                int.tryParse(parts[1]) ?? (startHour + 1);

                            String startTimeFull =
                                "${startHour.toString().padLeft(2, '0')}:00:00";
                            String endTimeFull =
                                "${endHour.toString().padLeft(2, '0')}:00:00";

                            debugPrint(
                                "DEBUG: startTimeFull = $startTimeFull, endTimeFull = $endTimeFull");

                            slotController.selectedDate.value = bookDateStr;
                            slotController.selectedStartTime.value =
                                startTimeFull;
                            slotController.selectedEndTime.value = endTimeFull;

                            phoneController.text =
                                "${selectedDate.day} ${_month(selectedDate.month)}, ${selectedDate.year} | $selectedTime";

                            Navigator.of(context).pop();
                          } catch (e, st) {
                            debugPrint("ERROR in confirm handler: $e\n$st");
                            Get.snackbar("Error",
                                "Something went wrong while selecting slot",
                                snackPosition: SnackPosition.BOTTOM);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Text("Confirm Date & Time".tr,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.bold)),
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

  Widget _smallIconBox(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 18),
    );
  }

  String _month(int m) {
    const months = [
      "Jan",
      "Feb",
      "Mar",
      "Apr",
      "May",
      "Jun",
      "Jul",
      "Aug",
      "Sep",
      "Oct",
      "Nov",
      "Dec"
    ];
    return months[m - 1];
  }

  String _convertTimeToApiFormat(String timeText) {
    final parts = timeText.split(" - ");

    String start = parts[0].trim();
    String end = parts[1].trim();

    int startHour = _to24Hour(start);
    int endHour = _to24Hour(end);

    return "$startHour-$endHour";
  }

  int _to24Hour(String time) {
    final t = time.split(" ");
    final hm = t[0];
    final zone = t[1];

    int hour = int.parse(hm.split(":")[0]);

    if (zone == "PM" && hour != 12) hour += 12;
    if (zone == "AM" && hour == 12) hour = 0;

    return hour;
  }

  Widget _buildNumberField({
    required TextEditingController controller,
    required String hint,
  }) {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: const TextStyle(
                    fontSize: 13, color: Color.fromARGB(255, 95, 95, 95)),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            int value = int.tryParse(controller.text) ?? 0;
            if (value > 0) value--;
            controller.text = value.toString();
            _updatePrice();
          },
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
            ),
            child: const Icon(Icons.remove, size: 20),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            int value = int.tryParse(controller.text) ?? 0;
            value++;
            controller.text = value.toString();
            _updatePrice();
          },
          child: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
            ),
            child: const Icon(Icons.add, size: 20),
          ),
        ),
      ],
    );
  }

  void _updatePrice() {
    if (firstNameController.text.isNotEmpty) {
      pricingController.calculatePrice(
        widget.serviceId,
        firstNameController.text,
      );
    }
  }

  Widget _priceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 12,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 12,
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Map<String, dynamic> _buildBookingRequest() {
    final pricing = pricingController.pricing.value;

    final selectedAddons = addonsController.addons
        .where((a) => a.isSelected.value)
        .map((a) => a.addonId)
        .toList();

    return {
      "serviceId": widget.serviceId,
      "addressId": "Njp5d0B2MQ==",
      "assignedStaffId": "ODp5d0B2MQ==",
      "bookDate": slotController.selectedDate.value,
      "slotTime": slotController.selectedStartTime.value,
      "slotEndTime": slotController.selectedEndTime.value,
      "basePrice": pricing?.basePrice.toString() ?? 0,
      "homeServiceFee": pricing?.serviceFee.toString() ?? 0,
      "quantity": int.tryParse(firstNameController.text) ?? 1,
      "otherCharges": pricing?.otherCharges.toString() ?? 0,
      "totalPrice": pricing?.totalPrice.toString() ?? 0,
      "addons": selectedAddons,
    };
  }

  String _getEndTime(String start) {
    final parts = start.split(":");
    int hour = int.parse(parts[0]);
    int min = int.parse(parts[1]);

    final end = TimeOfDay(hour: hour, minute: min).replacing(hour: hour + 1);

    return "${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}:00";
  }

  Widget _couponApplySection() {
    return Obx(() {
      final pricing = pricingController.pricing.value;

      if (pricing == null || pricing.totalPrice == null) {
        return const SizedBox.shrink();
      }

      return Column(
        children: [
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: Container(
                  // height: 46,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(color: Colors.grey.shade400),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: couponControllerText,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Enter coupon code",
                      hintStyle: TextStyle(
                        fontSize: 13,
                        color: Color.fromARGB(255, 138, 138, 138),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 46,
                child: ElevatedButton(
                  onPressed: couponController.isLoading.value
                      ? null
                      : () {
                          if (couponControllerText.text.trim().isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Enter coupon code"),
                              ),
                            );
                            return;
                          }

                          couponController.applyCoupon(
                            context: context,
                            couponId: couponControllerText.text
                                .trim(), // couponId, NOT code
                            bookingTotal: double.tryParse(
                                  pricing?.totalPrice.toString() ?? "0",
                                ) ??
                                0,
                          );
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: couponController.isLoading.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      :  Text(
                          "Apply".tr,
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),

          /// Final price after coupon
          if (couponController.discountedPrice.value != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Final Price".tr,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                Text(
                  "QAR ${couponController.discountedPrice.value!.toStringAsFixed(2)}",
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.green),
                ),
              ],
            ),
          ],
        ],
      );
    });
  }
}
