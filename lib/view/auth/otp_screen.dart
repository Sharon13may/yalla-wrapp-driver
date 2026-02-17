import 'dart:async';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:yalla_wrapp_supervisor/controller/login_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/otp_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/resent_otp_controller.dart';
import 'package:yalla_wrapp_supervisor/view/bottom_nav_bar.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';
import 'package:yalla_wrapp_supervisor/view/widgets/bottom_left_triangle_clipper.dart';

class OTPScreen extends StatefulWidget {
  final bool isLogin;
  final String userId;
  const OTPScreen({
    super.key,
    this.isLogin = false,
    this.userId = "",
  });

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  late List<TextEditingController> otpControllers;

  int remainingSeconds = 300;
  late Timer timer;

  final resendController = Get.put(ResendOtpController());

  @override
  void initState() {
    super.initState();
    otpControllers = List.generate(4, (_) => TextEditingController());
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (remainingSeconds > 0) {
        setState(() => remainingSeconds--);
      } else {
        t.cancel();
        Get.offAllNamed("/login");
      }
    });
  }

  String formatTime(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return "$m:$s";
  }

  @override
  void dispose() {
    timer.cancel();
    for (var c in otpControllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                          height: constraints.maxWidth * 0.65,
                          child: Image.asset(
                            "assets/images/login.png",
                            fit: BoxFit.cover,
                          ),
                        );
                      },
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
                const SizedBox(height: 30),
                Text(
                  "Verification".tr,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  child: Text(
                    "We have sent a verification code to your phone number".tr,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(
                      4,
                      (index) => SizedBox(
                        width: 50,
                        height: 50,
                        child: TextField(
                          onChanged: (value) {
                            if (value.length == 1) {
                              FocusScope.of(context).nextFocus();
                            }
                          },
                          controller: otpControllers[index],
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          maxLength: 1,
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(
                                color: Colors.grey.shade400,
                                width: 1,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                color: AppColors.primaryPurple,
                                width: 1.2,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                        final otp = otpControllers.map((c) => c.text).join();

                        if (widget.isLogin) {
                          LoginController.verifyLoginOTP(
                            context: context,
                            otp: otp.trim(),
                            userId: widget.userId,
                          );
                        } else {
                          final userId = Get.arguments;

                          OTPController.verify(
                            context: context,
                            otp: otp,
                            userId: userId,
                            onSuccess: () {
                            //  Get.offAll(() => const BottomNavBar());
                            Get.offAll(
  () => const BottomNavBar(),
  predicate: (route) => false,
);

                            },
                          );
                        }
                      },
                      child: Text(
                        "Verify".tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  formatTime(remainingSeconds),
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final res = await resendController.resendOtp("98164413420");

                    if (res != null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(res.message)),
                      );

                      if (res.success) {
                        setState(() {
                          remainingSeconds = 300;
                        });
                      }
                    }
                  },
                  child: Text(
                    "Resend OTP".tr,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.primaryPurple,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 100),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: SafeArea(
              top: false,
              child: ClipPath(
                clipper: BottomLeftTriangleClipper(),
                child: Container(
                  width: 110,
                  height: 60,
                  color: AppColors.primaryGreen,
                ),
              ),
            ),
          ),
         Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(bottom: 30, left: 30, right: 30),
              child: Text.rich(
                TextSpan(
                  style: TextStyle(
                    fontSize: 11,
                    color: Color.fromARGB(137, 59, 59, 59),
                  ),
                  children: [
                    TextSpan(
                        text:
                            "By signing in with an account, you agree to our ".tr),
                    TextSpan(
                      text: "Terms of Service".tr,
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: " and ".tr),
                    TextSpan(
                      text: "Privacy Policy".tr,
                      style: TextStyle(
                        color: AppColors.primaryPurple,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    TextSpan(text: "."),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
