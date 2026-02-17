import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:yalla_wrapp_supervisor/controller/signup_controller.dart';
import 'package:yalla_wrapp_supervisor/view/auth/login_screen.dart';
import 'package:yalla_wrapp_supervisor/view/auth/otp_screen.dart';
import 'package:yalla_wrapp_supervisor/view/bottom_nav_bar.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';

class RegisterScreen extends StatelessWidget {
    final String? prefillPhone;
  const RegisterScreen({super.key, this.prefillPhone});

  @override
  Widget build(BuildContext context) {
    final TextEditingController firstNameController = TextEditingController();
    final TextEditingController lastNameController = TextEditingController();
    //final TextEditingController phoneController = TextEditingController();
    final TextEditingController phoneController =
    TextEditingController(text: prefillPhone ?? "");
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    "assets/images/login.png",
                    width: double.infinity,
                    height: 230,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 38,
                    left: 16,
                    child: GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 13),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        "Register".tr,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Create your account and book services effortlessly".tr,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Colors.black54,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'First Name*'.tr,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      _buildTextField(
                        controller: firstNameController,
                        hint: 'Enter first name'.tr,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Last Name'.tr,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      _buildTextField(
                        controller: lastNameController,
                        hint: 'Enter last name'.tr,
                      ),
                      const SizedBox(height: 18),
                      Text(
                         'Phone*'.tr,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      _buildTextField(
                        controller: phoneController,
                        hint:'Enter phone'.tr,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 18),
                      Text(
                      'Email*'.tr,
                        style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87),
                      ),
                      const SizedBox(height: 6),
                      _buildTextField(
                        controller: emailController,
                        hint: 'Enter email'.tr,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 30),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.buttonGreen,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          onPressed: () {
                            SignupController.registerUser(
                              context: context,
                              first: firstNameController.text.trim(),
                              last: lastNameController.text.trim(),
                              email: emailController.text.trim(),
                              phone: phoneController.text.trim(),
                              onSuccess: (userId) {
                                Get.to(() => const OTPScreen(),
                                    arguments: userId);
                              },
                            );
                          },
                          child: Text(
                           "Register".tr,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      InkWell(
                        onTap: () {
                          Get.to(const LoginScreen());
                        },
                        child: Container(
                          color: Colors.white.withOpacity(0.95),
                          padding: const EdgeInsets.only(
                              bottom: 8, top: 10, left: 60, right: 60),
                          child: Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontSize: 11,
                                color: Color.fromARGB(137, 59, 59, 59),
                              ),
                              children: [
                                TextSpan(text: "Already have an account?".tr),
                                TextSpan(
                                  text: "Login".tr,
                                  style: const TextStyle(
                                    color: AppColors.primaryPurple,
                                    decoration: TextDecoration.underline,
                                  ),
                                ), 
                                 
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      Center(
                        child: InkWell(
                          onTap: () {
                          Get.to(const BottomNavBar());
                          },
                          child: Text.rich(
                            TextSpan(
                              style: const TextStyle(
                                fontSize: 11,
                                color:  Color.fromARGB(137, 59, 59, 59),
                              ),
                              children: [
                                TextSpan(text: "Don't want to log in?".tr),
                                TextSpan(
                                  text: "Continue as Guest".tr,
                                  style: const TextStyle(
                                    color: AppColors.primaryPurple,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
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
        color: Colors.white,
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
}
