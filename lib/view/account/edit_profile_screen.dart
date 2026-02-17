import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:yalla_wrapp_supervisor/controller/profile_controller.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _selectedPayment = "option1";
  final ProfileController profileController = Get.find();

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    final data = profileController.profile.value;
    if (data != null) {
      firstNameController.text = data.firstName;
      lastNameController.text = data.lastName;
      phoneController.text = data.phone;
      emailController.text = data.email;
    }
  }

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
          'Profile'.tr,
          style: TextStyle(
              color: Colors.black, fontSize: 15, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 15),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      "First Name*".tr,
                      style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 53, 53, 53)),
                    ),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: firstNameController,
                      hint: "Enter first name".tr,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "name is required".tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Last Name".tr,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 53, 53, 53)),
                    ),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: lastNameController,
                      hint: "Enter last name".tr,
                      validator: (value) {
                        if (value != null &&
                            value.isNotEmpty &&
                            RegExp(r'[0-9]').hasMatch(value)) {
                          return "Last name cannot contain numbers".tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Phone*".tr,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 53, 53, 53)),
                    ),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: phoneController,
                      hint: "Enter phone".tr,
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(14),
                      ],
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Phone number is required".tr;
                        }
                        if (value.length < 7) {
                          return "Enter a valid phone number".tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                    Text(
                      "Email*".tr,
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(221, 53, 53, 53)),
                    ),
                    const SizedBox(height: 6),
                    _buildTextField(
                      controller: emailController,
                      hint: "Enter email".tr,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return "Email is required".tr;
                        }

                        final emailRegex =
                            RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

                        if (!emailRegex.hasMatch(value.trim())) {
                          return "Enter a valid email".tr;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
          child: SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: () async {
                if (!_formKey.currentState!.validate()) {
                  return;
                }

                bool success = await profileController.updateProfile(
                  firstName: firstNameController.text.trim(),
                  lastName: lastNameController.text.trim(),
                  phone: phoneController.text.trim(),
                  email: emailController.text.trim(),
                  context: context,
                );

                if (success) {
                  Navigator.pop(context);
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
                "Save Profile".tr,
                style: const TextStyle(
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

  // Widget _buildTextField({
  //   required TextEditingController controller,
  //   required String hint,
  //   TextInputType? keyboardType,
  // }) {
  //   return Container(
  //     height: 50,
  //     decoration: BoxDecoration(
  //       color: const Color.fromARGB(255, 253, 253, 253),
  //       borderRadius: BorderRadius.circular(30),
  //       border: Border.all(
  //         color: Colors.grey.shade400,
  //         width: 0.8,
  //       ),
  //     ),
  //     padding: const EdgeInsets.symmetric(horizontal: 16),
  //     child: TextField(
  //       controller: controller,
  //       keyboardType: keyboardType,
  //       decoration: InputDecoration(
  //         border: InputBorder.none,
  //         hintText: hint,
  //         hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),
  //       ),
  //     ),
  //   );
  // }
  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
  }) {
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
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        validator: validator,
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          isDense: true,
          border: InputBorder.none,
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 12),

          /// ✅ ERROR INSIDE FIELD
          errorStyle: const TextStyle(
            fontSize: 10,
            height: 1.2,
            color: Colors.red,
          ),
          errorMaxLines: 2,
          alignLabelWithHint: true,

          /// Push error text inside padding
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }
}
