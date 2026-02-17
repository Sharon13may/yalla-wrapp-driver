import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:yalla_wrapp_supervisor/controller/login_controller.dart';
import 'package:yalla_wrapp_supervisor/view/auth/register_screen.dart';
import 'package:yalla_wrapp_supervisor/view/bottom_nav_bar.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController phoneController = TextEditingController();
  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  children: [
                  
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return SizedBox(
                          width: double.infinity,
                          height:
                              constraints.maxWidth * 0.65, 
                          child: Image.asset(
                            "assets/images/login.png",
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),

                    Positioned(
                      top: 38,
                      right: 16,
                      child: InkWell(
                        onTap: () {
                          Get.to(const BottomNavBar());
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 13),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Skip >".tr,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color.fromARGB(221, 255, 255, 255),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                Text(
                  "Login".tr,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Login With Your Phone Number".tr,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: Colors.grey.shade400,
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Image.asset(
                            //   "assets/images/flag.png",
                            //   width: 24,
                            //   height: 24,
                            // ),
                            // const SizedBox(width: 4),
                            const Icon(
                              Icons.call,
                              size: 25,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 50,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.grey.shade400,
                              width: 0.8,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: TextField(
                              controller: phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Phone*'.tr,
                                hintStyle: const TextStyle(
                                    color: Colors.grey, fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
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
                        LoginController.checkUser(
                          context: context,
                          phone: phoneController.text.trim(),
                        );
                      },
                      child: Text(
                        'Continue'.tr,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 35),
                // const Text(
                //   "Other login Options",
                //   style: TextStyle(
                //     fontSize: 11,
                //     color: Colors.black54,
                //   ),
                // ),
                // Column(
                //   children: [
                //     GestureDetector(
                //       onTap: () {},
                //       child: Container(
                //         margin: const EdgeInsets.symmetric(
                //             vertical: 8, horizontal: 24),
                //         padding: const EdgeInsets.symmetric(
                //             vertical: 12, horizontal: 16),
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(30),
                //           border: Border.all(
                //             color: const Color.fromARGB(255, 160, 160, 160),
                //             width: 0.5,
                //           ),
                //         ),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Image.asset(
                //               "assets/images/google.png",
                //               width: 25,
                //               height: 25,
                //             ),
                //             const SizedBox(width: 16),
                //             const Text(
                //               "Login with Google",
                //               style: TextStyle(
                //                 fontSize: 11,
                //                 color: Color.fromARGB(221, 78, 78, 78),
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //     GestureDetector(
                //       onTap: () {},
                //       child: Container(
                //         margin: const EdgeInsets.symmetric(
                //             vertical: 4, horizontal: 24),
                //         padding: const EdgeInsets.symmetric(
                //             vertical: 12, horizontal: 16),
                //         decoration: BoxDecoration(
                //           color: Colors.white,
                //           borderRadius: BorderRadius.circular(30),
                //           border: Border.all(
                //             color: const Color.fromARGB(255, 160, 160, 160),
                //             width: 0.5,
                //           ),
                //         ),
                //         child: Row(
                //           mainAxisAlignment: MainAxisAlignment.center,
                //           children: [
                //             Image.asset(
                //               "assets/images/apple.png",
                //               width: 25,
                //               height: 25,
                //             ),
                //             const SizedBox(width: 16),
                //             const Text(
                //               "Login with Apple",
                //               style: TextStyle(
                //                 fontSize: 11,
                //                 color: Color.fromARGB(221, 78, 78, 78),
                //                 fontWeight: FontWeight.bold,
                //               ),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 80),
                InkWell(
                  onTap: () {
                    Get.to(const RegisterScreen());
                  },
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(136, 58, 58, 58),
                      ),
                      children: [
                        TextSpan(text: 'Dont have an account? '.tr),
                        TextSpan(
                          text: "Register Now".tr,
                          style: const TextStyle(
                            color: AppColors.primaryPurple,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () {
                    Get.to(const BottomNavBar());
                  },
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color.fromARGB(136, 58, 58, 58),
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
                  ),
                ),
                const SizedBox(height: 25),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Text.rich(
                      TextSpan(
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color.fromARGB(137, 59, 59, 59),
                        ),
                        children: [
                          TextSpan(
                              text:
                                  "By signing in with an account, you agree to our "
                                      .tr),
                          TextSpan(
                            text: "Terms of Service".tr,
                            style: const TextStyle(
                              color: AppColors.primaryPurple,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          TextSpan(text: " and ".tr),
                          TextSpan(
                            text: "Privacy Policy".tr,
                            style: const TextStyle(
                              color: AppColors.primaryPurple,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          const TextSpan(text: "."),
                        ],
                      ),
                      textAlign: TextAlign.center,
                    )),
                const SizedBox(height: 70),
              ],
            ),
          ),
          // Positioned(
          //   bottom: 0,
          //   left: 0,
          //   child: SafeArea(
          //     top: false,
          //     child: ClipPath(
          //       clipper: BottomLeftTriangleClipper(),
          //       child: Container(
          //         width: 110,
          //         height: 60,
          //         color: AppColors.primaryGreen,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
