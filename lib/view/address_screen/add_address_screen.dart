import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:yalla_wrapp_supervisor/view/address_screen/save_address_screen.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 250, 250, 250),
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 250, 250, 250),
                borderRadius: BorderRadius.circular(30),
                border:
                    Border.all(color: const Color.fromARGB(255, 204, 204, 204)),
              ),
              child: const Row(
                children: [
                  Icon(Icons.search, color: Color.fromARGB(255, 133, 133, 133)),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Search for area, street name...",
                          hintStyle: TextStyle(
                              fontSize: 13,
                              color: Color.fromARGB(255, 133, 133, 133))),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: () {
             Get.to( SaveAddressScreen());
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 250, 250, 250),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/locationicon.png",
                      width: 25,
                      height: 25,
                    ),
                    const SizedBox(width: 12),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current Location",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Street 950, Zone 45, Doha, Qatar...",
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              "Recent Search",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              "Doha",
              style: TextStyle(fontSize: 14),
            ),
            const Text(
              "Street 950, Zone 45, Al Sadd, Doha, Qatar",
              style: TextStyle(
                  fontSize: 12.5, color: Color.fromARGB(255, 131, 131, 131)),
            ),
            const SizedBox(
              height: 8,
            ),
            const Divider(
              color: Color.fromARGB(255, 212, 212, 212),
              thickness: 1,
            ),
            const SizedBox(
              height: 8,
            ),
            const Text(
              "Doha",
              style: TextStyle(fontSize: 14),
            ),
            const Text(
              "Street 950, Zone 45, Al Sadd, Doha, Qatar",
              style: TextStyle(
                  fontSize: 12.5, color: Color.fromARGB(255, 131, 131, 131)),
            ),
          ],
        ),
      ),
    );
  }
}
