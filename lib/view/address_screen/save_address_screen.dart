import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:yalla_wrapp_supervisor/controller/add_address_controller.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';

class SaveAddressScreen extends StatelessWidget {
  SaveAddressScreen({super.key});

  final controller = Get.put(AddAddressController());

  final countryCtrl = TextEditingController(text: "QAT");
  final phoneCtrl = TextEditingController();
  final zoneCtrl = TextEditingController();
  final areaCtrl = TextEditingController();
  final municipalityCtrl = TextEditingController();
  final buildingCtrl = TextEditingController();
  final streetCtrl = TextEditingController();
  final unitCtrl = TextEditingController();
  final landmarkCtrl = TextEditingController();
  final postalCtrl = TextEditingController();

  Widget _field(String label, TextEditingController c) {
    return Container(
       padding: const EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 253, 253, 253),
      borderRadius: BorderRadius.circular(30),
      border: Border.all(
        color: Colors.grey.shade400,
        width: 0.8,
      ),
    ),
      child: TextField(
        controller: c,
         style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        isDense: true,
        border: InputBorder.none,
            hintText: label,
        hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),

        /// ✅ ERROR INSIDE FIELD
        errorStyle: const TextStyle(
          fontSize: 10,
          height: 1.2,
          color: Colors.red,
        ),
         contentPadding: const EdgeInsets.symmetric(vertical: 14),
      ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: const Text(
          'Add Address',
          style: TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(
                controller.latitude.value,
                controller.longitude.value,
              ),
              zoom: 16,
            ),
            myLocationEnabled: true,
            onCameraMove: controller.onCameraMove,
            onCameraIdle: controller.onCameraIdle,
            onMapCreated: (c) => controller.mapController = c,
          ),

          const Center(
            child: Icon(Icons.location_pin, size: 48, color: Colors.red),
          ),

          DraggableScrollableSheet(
            initialChildSize: 0.55,
            maxChildSize: 0.9,
            builder: (_, scroll) => Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: ListView(
                controller: scroll,
                children: [


                  //GEOCODING ADDRESS FETCHING PART

  //                 Obx(() => Container(
  // padding: const EdgeInsets.symmetric(
  //   horizontal: 12,
  //   vertical: 10,
  // ),
  // decoration: BoxDecoration(
  //   color: const Color.fromARGB(255, 247, 240, 255),
  //   borderRadius: BorderRadius.circular(16),
  // ),
  // child: Row(
  //   crossAxisAlignment: CrossAxisAlignment.start,
  //   children: [
      // const Icon(
      //   Icons.location_on,
      //   color: AppColors.buttonGreen,
      //   size: 18,
      // ),
      // const SizedBox(width: 8),
    //   Expanded(
    //     child: Text(
    //       controller.currentAddress.value.isEmpty
    //           ? 'Fetching address...'
    //           : controller.currentAddress.value,
    //       style: const TextStyle(
    //         fontSize: 12,
    //         color: Colors.black87,
    //         fontWeight: FontWeight.w500,
    //       ),
    //     ),
    //   ),
//     ],
//   ),
// )),
const SizedBox(height: 6),

                   
                                const Text(
                      "Country ISO*",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 53, 53, 53)),
                    ),
                    const SizedBox(height: 10),
               
                  _field("Country ISO", countryCtrl),
                    const SizedBox(height: 14),
                              const Text(
                      "Phone*",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 53, 53, 53)),
                    ),
                    const SizedBox(height: 10),
                  _field("Phone", phoneCtrl),
                    const SizedBox(height: 14),
                              const Text(
                      "Zone*",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 53, 53, 53)),
                    ),
                    const SizedBox(height: 10),
                  _field("Zone", zoneCtrl),
                    const SizedBox(height: 14),
                              const Text(
                      "Area*",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 53, 53, 53)),
                    ),
                    const SizedBox(height: 10),
                  _field("Area", areaCtrl),
                    const SizedBox(height: 14),
                              const Text(
                      "Municipality*",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 53, 53, 53)),
                    ),
                    const SizedBox(height: 10),
                  _field("Municipality", municipalityCtrl),
                     const SizedBox(height: 14),
                              const Text(
                      "Building*",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 53, 53, 53)),
                    ),
                    const SizedBox(height: 10),
                  _field("Building", buildingCtrl),
                  const SizedBox(height: 14),
                              const Text(
                      "Street*",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 53, 53, 53)),
                    ),
                    const SizedBox(height: 10),
                  _field("Street", streetCtrl),
                  const SizedBox(height: 14),
                              const Text(
                      "Unit / Flat No*",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 53, 53, 53)),
                    ),
                    const SizedBox(height: 10),
                  _field("Unit / Flat No", unitCtrl),
                  const SizedBox(height: 14),
                              const Text(
                      "Landmark*",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 53, 53, 53)),
                    ),
                    const SizedBox(height: 10),
                  _field("Landmark", landmarkCtrl),
                    const SizedBox(height: 14),
                              const Text(
                      "Postal Code*",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 53, 53, 53)),
                    ),
                    const SizedBox(height: 10),
                  _field("Postal Code", postalCtrl),
                         const SizedBox(height: 25),
                              const Text(
                      "Save As*",
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 53, 53, 53)),
                    ),
                    const SizedBox(height: 6),
                     Obx(() => Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                       children: ["home", "office", "other"]
    .map(
      (e) => Row(
        children: [
          Radio<String>(
            value: e,
            groupValue: controller.addressType.value,
            onChanged: (v) => controller.addressType.value = v!,
            activeColor: AppColors.buttonGreen, // ✅ selected fill color
            fillColor: MaterialStateProperty.resolveWith((states) {
              if (states.contains(MaterialState.selected)) {
                return AppColors.buttonGreen; // selected
              }
              return AppColors.buttonGreen; // unselected border
            }),
          ),
          Text(
            e.capitalizeFirst!,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    )

                            .toList(),
                      )
                      ),


                  const SizedBox(height: 40),

                  Obx(() => SizedBox(
                    height: 50,
                    child: ElevatedButton(
                        onPressed: controller.isSaving.value
                        ? null
                        : () async {
                            if ([
                              countryCtrl,
                              phoneCtrl,
                              zoneCtrl,
                              areaCtrl,
                              municipalityCtrl,
                              buildingCtrl,
                              streetCtrl,
                              unitCtrl,
                              landmarkCtrl,
                              postalCtrl
                            ].any((e) => e.text.isEmpty)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text("All fields are required")),
                              );
                              return;
                            }
                    
                            final message = await controller.addAddress(
                              countryISO: countryCtrl.text,
                              phone: phoneCtrl.text,
                              zone: zoneCtrl.text,
                              area: areaCtrl.text,
                              municipality: municipalityCtrl.text,
                              building: buildingCtrl.text,
                              street: streetCtrl.text,
                              unit: unitCtrl.text,
                              landmark: landmarkCtrl.text,
                              postalCode: postalCtrl.text,
                            );
                    
                            if (message != null && message.contains("successfully")) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(message)),
                              );
                    
                              Future.delayed(const Duration(milliseconds: 500), () {
                                Navigator.pop(context, true); // ✅ GO BACK
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(message ?? "Something went wrong")),
                              );
                            }
                          },
                     style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 0,
                          ),
                          child: controller.isSaving.value
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : const Text("Save Address",
                              style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),),
                        ),
                  )),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:yalla_wrapp/controller/add_address_controller.dart';
// import 'package:yalla_wrapp/view/constants/app_colors.dart';

// class SaveAddressScreen extends StatefulWidget {
//   const SaveAddressScreen({super.key});

//   @override
//   State<SaveAddressScreen> createState() => _SaveAddressScreenState();
// }

// class _SaveAddressScreenState extends State<SaveAddressScreen> {
//   final AddAddressController controller = Get.put(AddAddressController());

//   final flatnoController = TextEditingController(text: "House no:34");
//   final apartmentController =
//       TextEditingController(text: "Street 950, Zone 45");
//   final directionController =
//       TextEditingController(text: "eg. Ring the bell on the red gate");

//         Widget _field(String label, TextEditingController c) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: TextField(
//         controller: c,
//         decoration: InputDecoration(labelText: label),
//       ),
//     );
//   }
  
//   final houseCtrl = TextEditingController();
//   final buildingCtrl = TextEditingController();
//   final municipalityCtrl = TextEditingController();
//   final streetCtrl = TextEditingController();
//   final zoneCtrl = TextEditingController();
//   final searchCtrl = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: const Text(
//           'Add Address',
//           style: TextStyle(
//               fontSize: 15, fontWeight: FontWeight.bold, color: Colors.black),
//         ),
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           icon: const Icon(
//             Icons.arrow_back_ios,
//             color: Colors.black,
//             size: 20,
//           ),
//           onPressed: () => Get.back(),
//         ),
//       ),
//       body: Stack(
//         children: [
         
//                  Obx(() => GoogleMap(
//                 initialCameraPosition: CameraPosition(
//                   target: LatLng(
//                     controller.latitude.value,
//                     controller.longitude.value,
//                   ),
//                   zoom: 16,
//                 ),
//                 myLocationEnabled: true,
//                 myLocationButtonEnabled: false,
//                 onMapCreated: (c) => controller.mapController = c,
//                 onCameraIdle: () => controller.onCameraIdle(
//                   LatLng(
//                     controller.latitude.value,
//                     controller.longitude.value,
//                   ),
//                 ),
//                 onCameraMove: (pos) =>
//                     controller.onCameraIdle(pos.target),
//               )),

//           /// Center Pin
//           const Center(
//             child: Icon(Icons.location_pin, size: 50, color: Colors.red),
//           ),

//           /// Search Box
//           // Positioned(
//           //   top: 40,
//           //   left: 16,
//           //   right: 16,
//           //   child: Column(
//           //     children: [
//                 // TextField(
//                 //   controller: searchCtrl,
//                 //   onChanged: controller.searchPlaces,
//                 //   decoration: const InputDecoration(
//                 //     hintText: "Search area, street...",
//                 //     filled: true,
//                 //     fillColor: Colors.white,
//                 //     prefixIcon: Icon(Icons.search),
//                 //   ),
//                 // ),
//                 // Obx(() => ListView.builder(
//                 //       shrinkWrap: true,
//                 //       itemCount: controller.suggestions.length,
//                 //       itemBuilder: (_, i) {
//                 //         final s = controller.suggestions[i];
//                 //         return ListTile(
//                 //           title: Text(s.description),
//                 //           onTap: () {
//                 //             controller.selectPlace(s);
//                 //             searchCtrl.clear();
//                 //           },
//                 //         );
//                 //       },
//                 //     )),
//           //     ],
//           //   ),
//           // ),

//           /// Bottom Form
//            DraggableScrollableSheet(
//             initialChildSize: 0.35,
//             maxChildSize: 0.75,
//             builder: (_, scroll) => Container(
//               padding: const EdgeInsets.all(16),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius:
//                     BorderRadius.vertical(top: Radius.circular(25)),
//               ),
//               child: ListView(
//                 controller: scroll,
//                 children: [
//                   _field("House / Flat No", houseCtrl),
//                   _field("Apartment / Building", buildingCtrl),
//                   _field("Municipality", municipalityCtrl),
//                   _field("Street / Area", streetCtrl),
//                   _field("Zone", zoneCtrl),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                    // onPressed: () {
//                       // print(controller.latitude.value);
//                       // print(controller.longitude.value);

//                     //},
//                     onPressed: () {
//   if (houseCtrl.text.isEmpty ||
//       buildingCtrl.text.isEmpty ||
//       municipalityCtrl.text.isEmpty ||
//       streetCtrl.text.isEmpty ||
//       zoneCtrl.text.isEmpty) {
//     Get.snackbar("Required", "Please fill all fields");
//     return;
//   }

//   controller.addAddress(
//     unit: houseCtrl.text,
//     building: buildingCtrl.text,
//     municipality: municipalityCtrl.text,
//     street: streetCtrl.text,
//     zone: zoneCtrl.text,
//   );
// },

//                     child: const Text("Save Address"),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//           // DraggableScrollableSheet(
//           //   initialChildSize: 0.3,
//           //   minChildSize: 0.3,
//           //   maxChildSize: 0.75,
//           //   builder: (context, scrollController) {
//           //     return Container(
//           //       decoration: BoxDecoration(
//           //         color: Colors.white,
//           //         border: Border.all(color: Colors.grey.shade400),
//           //         borderRadius: const BorderRadius.only(
//           //             topLeft: Radius.circular(25),
//           //             topRight: Radius.circular(25)),
//           //       ),
//           //       child: Column(
//           //         children: [
//           //           Container(
//           //             margin: const EdgeInsets.symmetric(vertical: 10),
//           //             width: 40,
//           //             height: 4,
//           //             decoration: BoxDecoration(
//           //                 color: Colors.grey.shade400,
//           //                 borderRadius: BorderRadius.circular(2)),
//           //           ),
//           //           Expanded(
//           //             child: SingleChildScrollView(
//           //               controller: scrollController,
//           //               padding: const EdgeInsets.all(16),
//           //               child: Column(
//           //                 crossAxisAlignment: CrossAxisAlignment.start,
//           //                 children: [
//           //                   Container(
//           //                     padding: const EdgeInsets.all(12),
//           //                     decoration: BoxDecoration(
//           //                       border: Border.all(color: Colors.grey.shade400),
//           //                       borderRadius: BorderRadius.circular(15),
//           //                     ),
//           //                     child: Row(
//           //                       crossAxisAlignment: CrossAxisAlignment.start,
//           //                       children: [
//           //                         const Icon(Icons.location_on,
//           //                             color: AppColors.primaryPurple, size: 22),
//           //                         const SizedBox(width: 10),
//           //                         Expanded(
//           //                           child: Column(
//           //                             crossAxisAlignment:
//           //                                 CrossAxisAlignment.start,
//           //                             children: [
//           //                               // Text(
//           //                               //   "Doha",
//           //                               //   style: TextStyle(
//           //                               //       fontSize: 14,
//           //                               //       fontWeight: FontWeight.bold,
//           //                               //       color: Colors.black),
//           //                               // ),
//           //                               // SizedBox(height: 2),
//           //                               // Text(
//           //                               //   "Street 950, Zone 45, Al Sadd, Doha, Qatar",
//           //                               //   style: TextStyle(
//           //                               //       fontSize: 12,
//           //                               //       color: Colors.grey,
//           //                               //       fontWeight: FontWeight.w400),
//           //                               // ),
//           //                               Obx(() => Text(
//           //                                     "Lat: ${controller.latitude.value.toStringAsFixed(5)}, "
//           //                                     "Lng: ${controller.longitude.value.toStringAsFixed(5)}",
//           //                                     style:
//           //                                         const TextStyle(fontSize: 12),
//           //                                   )),
//           //                             ],
//           //                           ),
//           //                         ),
//           //                       ],
//           //                     ),
//           //                   ),
//           //                   const SizedBox(height: 20),
//           //                   const Text(
//           //                     "House/Flat/Block No.",
//           //                     style: TextStyle(
//           //                         fontSize: 13,
//           //                         fontWeight: FontWeight.w500,
//           //                         color: Color.fromARGB(221, 46, 46, 46)),
//           //                   ),
//           //                   const SizedBox(height: 6),
//           //                   _buildTextField(
//           //                       controller: flatnoController,
//           //                       hintText: "Enter house/flat no"),
//           //                   const SizedBox(height: 20),
//           //                   const Text(
//           //                     "Apartment/Building*",
//           //                     style: TextStyle(
//           //                         fontSize: 13,
//           //                         fontWeight: FontWeight.w500,
//           //                         color: Color.fromARGB(221, 46, 46, 46)),
//           //                   ),
//           //                   const SizedBox(height: 6),
//           //                   _buildTextField(
//           //                       controller: apartmentController,
//           //                       hintText: "Enter apartment/road/area"),
//           //                   const SizedBox(height: 20),
//           //                   const Text(
//           //                     "Municipality*",
//           //                     style: TextStyle(
//           //                         fontSize: 13,
//           //                         fontWeight: FontWeight.w500,
//           //                         color: Color.fromARGB(221, 46, 46, 46)),
//           //                   ),
//           //                   const SizedBox(height: 6),
//           //                   _buildTextField(
//           //                       controller: directionController,
//           //                       hintText: "Additional directions"),
//           //                   const SizedBox(height: 20),
//           //                   const Text(
//           //                     "Street/Area*",
//           //                     style: TextStyle(
//           //                         fontSize: 13,
//           //                         fontWeight: FontWeight.w500,
//           //                         color: Color.fromARGB(221, 46, 46, 46)),
//           //                   ),
//           //                   const SizedBox(height: 6),
//           //                   _buildTextField(
//           //                       controller: directionController,
//           //                       hintText: "Additional directions"),
//           //                   const SizedBox(height: 20),
//           //                   const Text(
//           //                     "Zone*",
//           //                     style: TextStyle(
//           //                         fontSize: 13,
//           //                         fontWeight: FontWeight.w500,
//           //                         color: Color.fromARGB(221, 46, 46, 46)),
//           //                   ),
//           //                   const SizedBox(height: 6),
//           //                   _buildTextField(
//           //                       controller: directionController,
//           //                       hintText: "Additional directions"),
//           //                   const SizedBox(height: 30),
//           //                 ],
//           //               ),
//           //             ),
//           //           ),
//           //           Padding(
//           //             padding: const EdgeInsets.all(16.0),
//           //             child: SizedBox(
//           //               width: double.infinity,
//           //               height: 50,
//           //               child: ElevatedButton(
//           //                 style: ElevatedButton.styleFrom(
//           //                   backgroundColor: AppColors.buttonGreen,
//           //                   shape: RoundedRectangleBorder(
//           //                     borderRadius: BorderRadius.circular(30),
//           //                   ),
//           //                 ),
//           //                 onPressed: () {},
//           //                 child: const Text(
//           //                   "Save Address",
//           //                   style: TextStyle(
//           //                       fontSize: 12,
//           //                       fontWeight: FontWeight.bold,
//           //                       color: Colors.white),
//           //                 ),
//           //               ),
//           //             ),
//           //           ),
//           //         ],
//           //       ),
//           //     );
//           //   },
//           // ),
   


//   Widget _buildTextField({
//     required TextEditingController controller,
//     required String hintText,
//     TextInputType? keyboardType,
//   }) {
//     return TextField(
//       controller: controller,
//       keyboardType: keyboardType,
//       style: const TextStyle(
//         fontSize: 11,
//         color: Color.fromARGB(255, 65, 65, 65),
//         fontWeight: FontWeight.w700,
//       ),
//       decoration: InputDecoration(
//         hintText: hintText,
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide: const BorderSide(color: Colors.grey, width: 0.5),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(15),
//           borderSide:
//               const BorderSide(color: AppColors.primaryGreen, width: 0.5),
//         ),
//       ),
//     );
//   }
// }
