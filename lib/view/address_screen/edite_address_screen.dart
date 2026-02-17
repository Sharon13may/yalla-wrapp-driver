import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_wrapp_supervisor/model/address_model.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';
import '../../controller/address_controller.dart';

class EditAddressScreen extends StatefulWidget {
  final AddressModel address;

  const EditAddressScreen({super.key, required this.address});

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final controller = Get.find<AddressController>();

  late TextEditingController phoneCtrl;
  late TextEditingController typeCtrl;
  late TextEditingController municipalityCtrl;
  late TextEditingController areaCtrl;
  late TextEditingController streetCtrl;
  late TextEditingController zoneCtrl;
  late TextEditingController unitCtrl;
  late TextEditingController buildingCtrl;
  late TextEditingController landmarkCtrl;
  late TextEditingController postalCtrl;

  @override
void initState() {
  super.initState();

  phoneCtrl = TextEditingController(text: widget.address.phone ?? "");
  typeCtrl = TextEditingController(text: widget.address.addressType ?? "");
  municipalityCtrl =
      TextEditingController(text: widget.address.municipality ?? "");
  areaCtrl = TextEditingController(text: widget.address.area ?? "");
  streetCtrl = TextEditingController(text: widget.address.street ?? "");
  zoneCtrl = TextEditingController(text: widget.address.zone ?? "");
  unitCtrl = TextEditingController(text: widget.address.unit ?? "");
  buildingCtrl = TextEditingController(text: widget.address.building ?? "");
  landmarkCtrl = TextEditingController(text: widget.address.landmark ?? "");
  postalCtrl = TextEditingController(text: widget.address.postalCode ?? "");
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit Address',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _label("Phone*"),
              _field(phoneCtrl, "Enter phone"),

              _label("Address Type*"),
              _field(typeCtrl, "Home / Office"),

              _label("Municipality"),
              _field(municipalityCtrl, "Municipality"),

              _label("Area"),
              _field(areaCtrl, "Area"),

              _label("Street"),
              _field(streetCtrl, "Street"),

              _label("Zone"),
              _field(zoneCtrl, "Zone"),

              _label("Unit"),
              _field(unitCtrl, "Unit"),

              _label("Building"),
              _field(buildingCtrl, "Building"),

              _label("Landmark"),
              _field(landmarkCtrl, "Landmark"),

              _label("Postal Code"),
              _field(postalCtrl, "Postal code"),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
             onPressed: () {
  controller.editAddress(
    addressId: widget.address.addressId,
    phone: phoneCtrl.text,
    addressType: typeCtrl.text,
    municipality: municipalityCtrl.text,
    area: areaCtrl.text,
    street: streetCtrl.text,
    zone: zoneCtrl.text,
    unit: unitCtrl.text,
    building: buildingCtrl.text,
    landmark: landmarkCtrl.text,
    postalCode: postalCtrl.text,
    latitude: widget.address.latitude ?? "",
    longitude: widget.address.longitude ?? "",
  );
},


              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.buttonGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              child: const Text(
                "Save Address",
                style:
                    TextStyle(fontSize: 13, fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 6),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 12, fontWeight: FontWeight.bold),
        ),
      );

  Widget _field(TextEditingController ctrl, String hint) {
    return Container(
      height: 50,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: const Color.fromARGB(255, 202, 202, 202)),
      ),
      child: TextField(
        controller: ctrl,
        style: const TextStyle(
      fontSize: 13,             
      color: Color.fromARGB(255, 88, 88, 88),       
      fontWeight: FontWeight.w500,
    ),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          
          hintStyle: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }
}
