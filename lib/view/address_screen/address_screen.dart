import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yalla_wrapp_supervisor/controller/change_address_controller.dart';
import 'package:yalla_wrapp_supervisor/model/address_model.dart';
import 'package:yalla_wrapp_supervisor/view/address_screen/add_address_screen.dart';
import 'package:yalla_wrapp_supervisor/view/address_screen/edite_address_screen.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';
import '../../controller/address_controller.dart';

class AddressScreen extends StatefulWidget {
  const AddressScreen({super.key});

  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final AddressController addressController = Get.find<AddressController>();
  final ChangeAddressController changeController =
   // Get.put(ChangeAddressController(), permanent: true);
Get.put(ChangeAddressController());


  final bool fromCheckout =
    Get.arguments?["fromCheckout"] == true;
final String bookingId =
    Get.arguments?["bookingId"] ?? "";


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'My Addresses'.tr,
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
      body: Padding(
  padding: const EdgeInsets.all(16),
  child: Obx(() {
    
    return RefreshIndicator(
      color: AppColors.primaryPurple,
      onRefresh: () async {
        await addressController.fetchAddressList();
      },

      child: addressController.addresses.isEmpty &&
              !addressController.isLoading.value
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children:  [
                SizedBox(height: 200),
                Center(child: Text("No Addresses Found".tr)),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: addressController.addresses.length,
              itemBuilder: (context, index) {
                final address =
                    addressController.addresses[index];

                final parts = [
                  address.municipality,
                  address.area,
                  address.street,
                  address.zone,
                  address.unit,
                  address.building,
                  address.landmark,
                ]
                    .where((e) => e != null && e!.isNotEmpty)
                    .toList();

                final fullAddress = parts.join(", ");

                return Column(
                  children: [
                    _addressItem(
                      address: address,
                      title: address.addressType ?? "Address",
                      description:
                          fullAddress.isEmpty ? "No details" : fullAddress,
                      dateText: address.phone ?? "",
                      onTap: () {
                        addressController
                            .selectAddress(address.addressId);
                      },
                      deleteCallback: () {
                        addressController.deleteAddress(
                          address.addressId,
                          context,
                        );
                      },
                    ),
                    const SizedBox(height: 12),
                  ],
                );
              },
            ),
    );
  }),
),

     
      bottomNavigationBar: SafeArea(
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: fromCheckout
        ? _continueButton(bookingId)
        : _addNewAddressButton(),
  ),
),

   
    );
  }

Widget _continueButton(String bookingId) {
  final addressController = Get.find<AddressController>();
  final changeController = Get.find<ChangeAddressController>();

  return SizedBox(
    height: 50,
    child: ElevatedButton(
      onPressed: () async {
        final selectedId = addressController.selectedAddressId.value;

        if (selectedId.isEmpty) {
          Get.snackbar("Error", "Please select an address");
          return;
        }

        final success = await changeController.changeAddress(
          bookingId: bookingId,
          addressId: selectedId,
        );

        if (success) {
          // ✅ PASS BACK SELECTED ADDRESS ID
         // Navigator.of(context).pop();
Navigator.pop(context, selectedId);

          Get.back(result: selectedId);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      child: Text(
        "Continue".tr,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    ),
  );
}

  // ---------------- ADDRESS ITEM ----------------

  Widget _addressItem({
    required AddressModel address,
    required String title,
    required String description,
    required String dateText,
    required VoidCallback onTap,
    VoidCallback? deleteCallback,
  }) {
    final controller = Get.find<AddressController>();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 250, 250, 250),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Obx(() {
            final isSelected =
                controller.selectedAddressId.value == address.addressId;

            return GestureDetector(
              onTap: () {
                controller.selectAddress(address.addressId);
              },
              child: Container(
                width: 19,
                height: 19,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Colors.green, width: 1.5),
                  color: isSelected ? Colors.green : Colors.transparent,
                ),
                child: isSelected
                    ? const Icon(Icons.check,
                        size: 16, color: Colors.white)
                    : null,
              ),
            );
          }),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: Colors.black),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style:
                      TextStyle(fontSize: 11.5, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 3),
                Text(
                  dateText,
                  style:
                      TextStyle(fontSize: 11.5, color: Colors.grey.shade700),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.to(
                          () => EditAddressScreen(address: address),
                        );
                      },
                      child: _actionButton(Icons.edit_outlined),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: deleteCallback,
                      child: _actionButton(Icons.delete_outline),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addNewAddressButton() {
  return SizedBox(
    height: 50,
    child: ElevatedButton(
      onPressed: () {
        Get.to(() => const AddAddressScreen());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.buttonGreen,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 0,
      ),
      child: Text(
        "Add New Address".tr,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 13,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}


  Widget _actionButton(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Icon(icon, size: 18, color: Colors.black),
    );
  }
}
