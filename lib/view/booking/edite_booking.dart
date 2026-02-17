import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yalla_wrapp_supervisor/controller/addon_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/booking_details_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/edite_booking_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/pricing_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/slot_controller.dart';
import 'package:yalla_wrapp_supervisor/utils/app_constants.dart';
import 'package:yalla_wrapp_supervisor/utils/prefs.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';

class EditBookingScreen extends StatefulWidget {
  final String bookingId;
  final String serviceId;
  final String serviceName;

  const EditBookingScreen({
    super.key,
    required this.bookingId,
    required this.serviceId,
    required this.serviceName,
  });

  @override
  State<EditBookingScreen> createState() => _EditBookingScreenState();
}

class _EditBookingScreenState extends State<EditBookingScreen> {
  final EditBookingController editController = Get.put(EditBookingController());
  final BookingDetailsController bookingDetailsController =
    Get.put(BookingDetailsController());

  final PricingController pricingController = Get.put(PricingController());
  final AddonsController addonsController = Get.put(AddonsController());
  final SlotController slotController = Get.put(SlotController());

  final TextEditingController quantityController = TextEditingController();
  final GlobalKey addonKey = GlobalKey();
  OverlayEntry? _addonsOverlay;

  Map<String, String> _convertSlotToApiTime(String slot) {
    // Example slot: "09:00 - 10:00"
    final parts = slot.split('-');

    final start = parts[0].trim(); // 09:00
    final end = parts[1].trim(); // 10:00

    String format(String time) {
      final isPM = time.contains("PM");
      final isAM = time.contains("AM");

      time = time.replaceAll("AM", "").replaceAll("PM", "").trim();

      var split = time.split(":");
      int hour = int.parse(split[0]);
      int minute = int.parse(split[1]);

      if (isPM && hour != 12) hour += 12;
      if (isAM && hour == 12) hour = 0;

      return "${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}:00";
    }

    return {
      "start": format(start),
      "end": format(end),
    };
  }

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedCalendarDate;
@override
void initState() {
  super.initState();

  WidgetsBinding.instance.addPostFrameCallback((_) {
    _loadBookingData();
  });
}

Future<void> _loadBookingData() async {
  await bookingDetailsController.fetchBookingDetails(widget.bookingId);

debugPrint("BOOKING VALUE => ${bookingDetailsController.booking.value}");


  final booking = bookingDetailsController.booking.value;
  if (booking == null) return;

  /// 1️⃣ Quantity
  quantityController.text = booking.quantity;

  /// 2️⃣ Date
  slotController.selectedDate.value = booking.bookDate;

  /// 3️⃣ Time
  slotController.selectedStartTime.value = booking.slotTime;
  slotController.selectedEndTime.value = booking.slotEndTime;

  /// 4️⃣ Add-ons
  await addonsController.fetchAddons(widget.serviceId);

  for (var addon in addonsController.addons) {
    if (booking.addons.any((b) => b.name == addon.name)) {
      addon.isSelected.value = true;
    }
  }

  /// 5️⃣ Pricing
  pricingController.calculatePrice(
    widget.serviceId,
    booking.quantity,
  );
}


  @override
  void dispose() {
    _addonsOverlay?.remove();
    super.dispose();
  }

  Widget _buildNumberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10,),
          const Text(
                    "No. Of Items*",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(221, 53, 53, 53)),
                  ),
                  const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              border: Border.all(color: Colors.grey.shade300),
            ),
                  padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  child: TextField(
                    controller: quantityController,
                    keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                  hintText: "Enter No. Of Luggage",
                  border: InputBorder.none,
                  isDense: true,
                ),
                style: const TextStyle(
                    fontSize: 13, color: Color.fromARGB(255, 95, 95, 95)),
                    
                    onChanged: (_) => _updatePrice(),
                    
                  ),
                  
                ),
              ),
              const SizedBox(width: 10),
              _circleBtn(Icons.remove, () {
                int v = int.tryParse(quantityController.text) ?? 1;
                if (v > 1) v--;
                quantityController.text = v.toString();
                _updatePrice();
              }),
              const SizedBox(width: 10),
              _circleBtn(Icons.add, () {
                int v = int.tryParse(quantityController.text) ?? 0;
                v++;
                quantityController.text = v.toString();
                _updatePrice();
              }),
            ],
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _circleBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42,
        height: 42,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Icon(icon),
      ),
    );
  }
  void _openDateTimeSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return DraggableScrollableSheet(
          initialChildSize: 0.9,
          minChildSize: 0.6,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Obx(() {
                return SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// 🔹 Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Select Date & Time",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      /// 🔹 Calendar
                      const Text(
                        "Select Preferred Date",
                        style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 68, 68, 68),
                        ),
                      ),
                      const SizedBox(height: 10),

                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 247, 240, 255),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: TableCalendar(
                          firstDay: DateTime.now(),
                          lastDay:
                              DateTime.now().add(const Duration(days: 365)),
                          focusedDay: _focusedDay,

                          selectedDayPredicate: (day) =>
                              isSameDay(_selectedCalendarDate, day),

                          onDaySelected: (selectedDay, focusedDay) {
                            setState(() {
                              _selectedCalendarDate = selectedDay;
                              _focusedDay = focusedDay;

                              // slotController.selectedDate.value =
                              //     "${selectedDay.day}/${selectedDay.month}/${selectedDay.year}";

final apiDate =
    "${selectedDay.year}-${selectedDay.month.toString().padLeft(2, '0')}-${selectedDay.day.toString().padLeft(2, '0')}";

slotController.selectedDate.value = apiDate;


                              slotController.selectedStartTime.value = "";
                              slotController.selectedEndTime.value = "";
                            });
                          },

                          /// ✅ FIX: Day names cut issue
                          daysOfWeekHeight: 28,
                          daysOfWeekStyle: const DaysOfWeekStyle(
                            weekdayStyle: TextStyle(fontSize: 12),
                            weekendStyle: TextStyle(fontSize: 12),
                          ),

                          calendarStyle: CalendarStyle(
                            defaultTextStyle: const TextStyle(fontSize: 13),
                            weekendTextStyle: const TextStyle(fontSize: 13),

                            /// 🔹 TODAY → BORDER ONLY
                            todayDecoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: AppColors.primaryPurple,
                                width: 1.5,
                              ),
                            ),
                            todayTextStyle: const TextStyle(
                              fontSize: 13,
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.w600,
                            ),

                            /// 🔹 SELECTED → SOLID
                            selectedDecoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.primaryPurple,
                            ),
                            selectedTextStyle: const TextStyle(
                              fontSize: 13,
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          headerStyle: const HeaderStyle(
                            formatButtonVisible: false,
                            titleCentered: true,
                            titleTextStyle: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        // child: TableCalendar(
                        //   firstDay: DateTime.now(),
                        //   lastDay:
                        //       DateTime.now().add(const Duration(days: 365)),
                        //   focusedDay: _focusedDay,
                        //   selectedDayPredicate: (day) =>
                        //       isSameDay(_selectedCalendarDate, day),
                        //   onDaySelected: (selectedDay, focusedDay) {
                        //     setState(() {
                        //       _selectedCalendarDate = selectedDay;
                        //       _focusedDay = focusedDay;

                        //       slotController.selectedDate.value =
                        //           "${selectedDay.day}/${selectedDay.month}/${selectedDay.year}";

                        //       slotController.selectedStartTime.value = "";
                        //       slotController.selectedEndTime.value = "";
                        //     });
                        //   },
                        //   calendarStyle: const CalendarStyle(
                        //     todayDecoration: BoxDecoration(
                        //       color: AppColors.primaryPurple,
                        //       shape: BoxShape.circle,
                        //     ),
                        //     selectedDecoration: BoxDecoration(
                        //       color: AppColors.primaryPurple,
                        //       shape: BoxShape.circle,
                        //     ),
                        //     todayTextStyle:
                        //         TextStyle(color: Colors.white),
                        //     selectedTextStyle:
                        //         TextStyle(color: Colors.white),
                        //   ),
                        //   headerStyle: const HeaderStyle(
                        //     formatButtonVisible: false,
                        //     titleCentered: true,
                        //   ),
                        // ),
                      ),

                      const SizedBox(height: 16),

                      /// 🔹 Time Slots
                      const Text(
                        "Select Time Slot",
                          style: TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(255, 68, 68, 68),
                        ),
                      ),
                      const SizedBox(height: 8),

                      // Wrap(
                      //   spacing: 8,
                      //   runSpacing: 8,
                      //   children: [
                      //     "8:00 AM - 9:00 AM",
                      //     "9:00 AM - 10:00 AM",
                      //     "10:00 AM - 11:00 AM",
                      //     "11:00 AM - 12:00 PM",
                      //     "12:00 PM - 1:00 PM",
                      //     "1:00 PM - 2:00 PM",
                      //     "2:00 PM - 3:00 PM",
                      //     "3:00 PM - 4:00 PM",
                      //     "4:00 PM - 5:00 PM",
                      //     "5:00 PM - 6:00 PM",
                      //     "6:00 PM - 7:00 PM",
                      //     "7:00 PM - 8:00 PM",
                      //     "8:00 PM - 9:00 PM",
                      //   ].map((slot) {
                      //     final selected =
                      //         slotController.selectedStartTime.value ==
                      //             _convertSlotToApiTime(slot)["start"];

                      //     return GestureDetector(
                      //       onTap: () {
                      //         final time = _convertSlotToApiTime(slot);
                      //         slotController.selectedStartTime.value =
                      //             time["start"]!;
                      //         slotController.selectedEndTime.value =
                      //             time["end"]!;
                      //       },
                      //       child: Container(
                      //         padding: const EdgeInsets.symmetric(
                      //             horizontal: 14, vertical: 10),
                      //         decoration: BoxDecoration(
                      //           color: selected
                      //               ? AppColors.buttonGreen
                      //               : Colors.grey.shade200,
                      //           borderRadius: BorderRadius.circular(20),
                      //         ),
                      //         child: Text(
                      //           slot,
                      //           style: TextStyle(
                      //             fontSize: 11,
                      //             color: selected ? Colors.white : Colors.black,
                      //           ),
                      //         ),
                      //       ),
                      //     );
                      //   }).toList(),
                      // ),
                      Container(
  padding: const EdgeInsets.all(14),
  decoration: BoxDecoration(
    color: const Color.fromARGB(255, 247, 240, 255), // light purple bg
    borderRadius: BorderRadius.circular(20),
  ),
  child: LayoutBuilder(
    builder: (context, constraints) {
      final itemWidth = (constraints.maxWidth - 8) / 2; // 👈 2 per row

      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
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
        ].map((slot) {
          final selected =
              slotController.selectedStartTime.value ==
                  _convertSlotToApiTime(slot)["start"];

          return GestureDetector(
            onTap: () {
              final time = _convertSlotToApiTime(slot);
              slotController.selectedStartTime.value = time["start"]!;
              slotController.selectedEndTime.value = time["end"]!;
              setState(() {});
            },
            child: Container(
              width: itemWidth, // ✅ force 2 per row
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primaryPurple // ✅ selected purple
                    : Colors.transparent, // ❌ no grey, no border
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                slot,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  color: selected ? Colors.white : Colors.black,
                ),
              ),
            ),
          );
        }).toList(),
      );
    },
  ),
),


                      const SizedBox(height: 24),

                      /// 🔹 Confirm Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: slotController
                                      .selectedDate.value.isEmpty ||
                                  slotController.selectedStartTime.value.isEmpty
                              ? null
                              : () async {
                                  final ok =
                                      await slotController.checkSlotAvailable(
                                    bookDate: slotController.selectedDate.value,
                                    slotTime:
                                        slotController.selectedStartTime.value,
                                    token: AppConstants.token,
                                  );
                                  if (ok) Navigator.pop(context);
                                },
                          child: slotController.isLoading.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text(
                                  "Confirm",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                        ),
                      ),

                      const SizedBox(height: 16),
                    ],
                  ),
                );
              }),
            );
          },
        );
      },
    );
  }

  Widget _buildAddonSelectorField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
                    "Add-Ons",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(221, 53, 53, 53)),
                  ),
                  const SizedBox(height: 6),
          GestureDetector(
            onTap: () async {
              await addonsController.fetchAddons(widget.serviceId);

              RenderBox box =
                  addonKey.currentContext!.findRenderObject() as RenderBox;
              Offset pos = box.localToGlobal(Offset.zero);
              _showAddonsDropdown(pos.dy + box.size.height, pos.dx);
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
                    addonsController.addons.where((a) => a.isSelected.value);

                if (selected.isEmpty) {
                  return Row(
                    children: [
                      Expanded(
                        child: Text("Select add-ons",
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),),
                      ),
                        Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.grey.shade600),
                    ],
                  );
                }

                return Wrap(
                  spacing: 6,
                  children: selected
                      .map((a) => Chip(
                            //label: Text(a.name),
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
  backgroundColor: Colors.grey.shade100,
  label: Text(a.name, style: const TextStyle(fontSize: 13)),
  deleteIcon: const Icon(Icons.close, size: 18),
                            onDeleted: () => a.isSelected.value = false,
                          ))
                      .toList(),
                );
              }),
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  void _showAddonsDropdown(double top, double left) {
    // close if already open
    _addonsOverlay?.remove();
    _addonsOverlay = null;

    final overlay = Overlay.of(context);

    _addonsOverlay = OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            /// 🔹 Click outside to close
            GestureDetector(
              onTap: () {
                _addonsOverlay?.remove();
                _addonsOverlay = null;
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                color: Colors.transparent,
              ),
            ),

            /// 🔹 Dropdown
            Positioned(
              top: top,
              left: 16,
              right: 16,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(12),
                child: Obx(() {
                  if (addonsController.isLoading.value) {
                    return const Padding(
                      padding: EdgeInsets.all(20),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  }

                  /// ✅ EMPTY STATE
                  if (addonsController.addons.isEmpty) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Text(
                        "No add-ons available for this service",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    );
                  }

                  return ListView(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    children: addonsController.addons.map((addon) {
                      return Obx(
                        () => CheckboxListTile(
                          value: addon.isSelected.value,
                          title: Text(
                            "${addon.name} (QAR ${addon.price})",
                            style: const TextStyle(fontSize: 13),
                          ),
                          onChanged: (v) {
                            addon.isSelected.value = v ?? false;
                          },
                        ),
                      );
                    }).toList(),
                  );
                }),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_addonsOverlay!);
  }

  Widget _buildDateTimeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
                    "Date & Time*",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(221, 53, 53, 53)),
                  ),
                  const SizedBox(height: 6),
          GestureDetector(
            onTap: () => _openDateTimeSheet(context),
            child: AbsorbPointer(
              child: Container(
                height: 50,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
          border: Border.all(color: Colors.grey.shade300),
                ),
                child: Obx(() {
                  final date = slotController.selectedDate.value;
                  final time = slotController.selectedStartTime.value;

                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      date.isEmpty ? "Select date & time" : "$date | $time",
                      style: const TextStyle(fontSize: 12,color: Color.fromARGB(255, 104, 104, 104)),
                    ),
                  );
                }),
              ),
            ),
          ),
          const SizedBox(height: 18),
        ],
      ),
    );
  }

  Widget _buildPricingSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: Obx(() {
          final pricing = pricingController.pricing.value;

          if (pricing == null) {
            return const Text(
              "Add luggage quantity to view pricing",
              style: TextStyle(fontSize: 11, color: Colors.grey),
            );
          }

          return Column(
            children: [
              _priceRow("Base Price", pricing.basePrice),
              _priceRow("Service Fee", pricing.serviceFee),
              _priceRow("Other Charges", pricing.otherCharges),
              const Divider(),
              _priceRow("Total", pricing.totalPrice, bold: true),
            ],
          );
        }),
      ),
    );
  }

  Widget _priceRow(String label, dynamic value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
               style: TextStyle(
                fontSize: 12,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal),),
          Text("QAR $value",
               style: TextStyle(
                fontSize: 12,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal),),
        ],
      ),
    );
  }

  void _updatePrice() {
    if (quantityController.text.isNotEmpty) {
      pricingController.calculatePrice(
        widget.serviceId,
        quantityController.text,
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.black,
            size: 18,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.serviceName,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      /// 👇 SAME UI AS LUGGAGE WRAPPING
      body: SingleChildScrollView(
        child: Column(
          children: [
            // quantity
            _buildNumberField(),

            // add-ons (reuse your method)
            _buildAddonSelectorField(),

            // date & time (reuse)
            _buildDateTimeSelector(),

            // pricing
            _buildPricingSection(),
          ],
        ),
      ),

      /// 👇 UPDATE BUTTON
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Obx(() {
            return SizedBox(
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.buttonGreen,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  elevation: 0,
                ),
                onPressed:
                    editController.isLoading.value ? null : _submitUpdate,
                child: editController.isLoading.value
                    ? const CircularProgressIndicator()
                    : const Text(
                        "Update Booking",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            );
          }),
        ),
      ),
    );
  }

  /// ===============================
  /// SUBMIT UPDATE
  /// ===============================
  Future<void> _submitUpdate() async {
    final pricing = pricingController.pricing.value;
    if (pricing == null) return;
    debugPrint("Address ${await Prefs.getSelectedAddressId()}");
    final body = {
      "bookingId": widget.bookingId,
      "serviceId": widget.serviceId,
      "addressId": await Prefs.getSelectedAddressId(),
      "assignedStaffId": slotController.assignedStaffId.value,
      "bookDate": slotController.selectedDate.value,
      // "slotTime": "04:00:00",
      // "slotEndTime": "05:00:00",

      "slotTime": slotController.selectedStartTime.value,
      "slotEndTime": slotController.selectedEndTime.value,

      "basePrice": pricing.basePrice,
      "homeServiceFee": pricing.serviceFee,
      "quantity": int.tryParse(quantityController.text) ?? 1,
      "otherCharges": pricing.otherCharges,
      "totalPrice": pricing.totalPrice,
      "addons": addonsController.addons
          .where((a) => a.isSelected.value)
          .map((a) => a.addonId)
          .toList(),
    };

    final success = await editController.updateBooking(body);

    // if (success) {
    //   Get.back(); // go back to summary
    // }
    
  if (success) {
    // ✅ SHOW SINGLE LINE SNACKBAR
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          "Booking updated successfully",
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        duration: Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );

    // ✅ GO BACK AFTER SHORT DELAY (important)
    Future.delayed(const Duration(milliseconds: 300), () {
     Navigator.pop(context);
    });
  }
}
}