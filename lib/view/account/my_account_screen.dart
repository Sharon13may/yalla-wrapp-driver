import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:get/get.dart';
import 'package:yalla_wrapp_supervisor/controller/profile_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/signup_controller.dart';
import 'package:yalla_wrapp_supervisor/view/account/edit_profile_screen.dart';
import 'package:yalla_wrapp_supervisor/view/address_screen/address_screen.dart';
import 'package:yalla_wrapp_supervisor/view/auth/login_screen.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';
import 'package:yalla_wrapp_supervisor/view/notification_screen.dart';

class MyAccountScreen extends StatelessWidget {
  MyAccountScreen({super.key});
  final ProfileController profileController = Get.put(ProfileController());

  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
  }

  Widget _buildLoginRequired(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.lock_outline,
              size: 60,
              color: Color.fromARGB(255, 170, 170, 170),
            ),
            const SizedBox(height: 15),
            Text(
              'Please_login_to_access_your_account'.tr,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color.fromARGB(255, 126, 126, 126),
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 40),
            InkWell(
                onTap: () {
                  Get.offAll(const LoginScreen());
                },
                child: _buildOptionRow(Icons.login_outlined, 'login'.tr)),
            const Divider(height: 1, color: AppColors.borderGrey),
            InkWell(
                onTap: () {
                  _showLanguageDialog(context);
                },
                child: _buildOptionRow(
                    Icons.language_outlined, 'Language_Settings'.tr)),
            const Divider(height: 1, color: AppColors.borderGrey),
            _buildOptionRow(Icons.help_outline_sharp, 'Help & Support'.tr),
            const Divider(height: 1, color: AppColors.borderGrey),
            _buildOptionRow(Icons.info_outline, 'Terms & Conditions'.tr),
            const Divider(height: 1, color: AppColors.borderGrey),
            _buildOptionRow(Icons.privacy_tip_outlined, "Privacy Policy"),
            const SizedBox(height: 60),
          ],
        ),
      ),
    );
  }

  Future<void> _changeLanguage(String langCode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language', langCode);

    Get.updateLocale(Locale(langCode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'my_account'.tr,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<String?>(
        future: _getUserId(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final userId = snapshot.data;

          if (userId == null || userId.isEmpty) {
            return _buildLoginRequired(context);
          }

          return _buildAccountContent(context);
        },
      ),
    );
  }

  Widget _buildOptionRow(IconData icon, String title,
      {Color? iconColor, Color? textColor}) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon, color: iconColor ?? AppColors.midGrey, size: 21),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? AppColors.darkGrey,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: AppColors.dividerGrey,
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Delete_Account'.tr,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: const Icon(
                        Icons.close,
                        size: 25,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'This action can’t be undone. When you delete all your data it will ne errased from our system'
                      .tr,
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color.fromARGB(255, 116, 116, 116),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        style: OutlinedButton.styleFrom(
                          side: const BorderSide(color: AppColors.buttonGreen),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(
                          'Cancel'.tr,
                          style: const TextStyle(
                            color: AppColors.buttonGreen,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          SignupController.deleteAccount(context: context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.buttonGreen,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: Text(
                          'Confirm'.tr,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildAccountContent(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 19),
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryPurple,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() {
                      final data = profileController.profile.value;
                      return Text(
                        data == null
                            ? 'Welcome'.tr
                            : "${data.firstName} ${data.lastName}",
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }),
                    InkWell(
                      onTap: () {
                        Get.to(const EditProfileScreen());
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.edit_outlined,
                                size: 18, color: AppColors.primaryPurple),
                            const SizedBox(width: 5),
                            Text(
                              'Edit Profile'.tr,
                              style: const TextStyle(
                                fontSize: 10,
                                color: AppColors.primaryPurple,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.phone_outlined,
                        color: AppColors.lightTextGrey, size: 18),
                    const SizedBox(width: 8),
                    Obx(() {
                      final data = profileController.profile.value;
                      return Text(
                        data?.phone ?? "—",
                        style: const TextStyle(
                          color: AppColors.lightTextGrey,
                          fontSize: 10,
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.email_outlined,
                        color: AppColors.lightTextGrey, size: 18),
                    const SizedBox(width: 8),
                    Obx(() {
                      final data = profileController.profile.value;
                      return Text(
                        data?.email ?? "—",
                        style: const TextStyle(
                          color: AppColors.lightTextGrey,
                          fontSize: 10,
                        ),
                      );
                    }),
                  ],
                ),
                const SizedBox(height: 5),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // InkWell(
                //     onTap: () {
                //       Get.to(const MyBookingsScreen());
                //     },
                //     child: _buildOptionRow(
                //         Icons.list_alt_outlined, "My Bookings")),
                // const Divider(height: 1, color: AppColors.borderGrey),
                InkWell(
                    onTap: () {
                      Get.to(const AddressScreen());
                    },
                    child: _buildOptionRow(
                        Icons.location_on_outlined, 'My Address'.tr)),
                const Divider(height: 1, color: AppColors.borderGrey),
                InkWell(
                  onTap: () {
                    Get.to(const NotificationScreen());
                  },
                  child: _buildOptionRow(
                      Icons.notifications_outlined, 'Notifications'.tr),
                ),
                const Divider(height: 1, color: AppColors.borderGrey),
                InkWell(
                    onTap: () {
                      _showLanguageDialog(context);
                    },
                    child: _buildOptionRow(
                        Icons.language_outlined, 'Language Settings'.tr)),
                const Divider(height: 1, color: AppColors.borderGrey),
                _buildOptionRow(Icons.help_outline_sharp, 'Help & Support'.tr),
                const Divider(height: 1, color: AppColors.borderGrey),
                _buildOptionRow(Icons.thumbs_up_down_outlined, 'Feedback'.tr),
                const Divider(height: 1, color: AppColors.borderGrey),
                _buildOptionRow(Icons.info_outline, 'Terms & Conditions'.tr),
                const Divider(height: 1, color: AppColors.borderGrey),
                _buildOptionRow(
                    Icons.privacy_tip_outlined, 'Privacy_Policy'.tr),
                const Divider(height: 1, color: AppColors.borderGrey),
                InkWell(
                  onTap: () {
                    _showDeleteAccountDialog(context);
                  },
                  child: _buildOptionRow(
                      Icons.delete_outline_sharp, 'Delete_Account'.tr),
                ),
                const Divider(height: 1, color: AppColors.borderGrey),
                InkWell(
                  onTap: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('userId');
                    Get.to(const LoginScreen());
                  },
                  child: _buildOptionRow(
                    Icons.logout,
                    'logout'.tr,
                    iconColor: AppColors.error,
                    textColor: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 90),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    String selectedLang = "en";

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Language_Settings'.tr,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close, size: 25),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    InkWell(
                      // onTap: () {
                      //   setState(() {
                      //     selectedLang = "en";
                      //   });
                      // },
                      onTap: () async {
                        setState(() {
                          selectedLang = "en";
                        });
                        await _changeLanguage("en");
                        Navigator.pop(context);
                      },

                      child: Row(
                        children: [
                          Radio(
                            value: "en",
                            groupValue: selectedLang,
                            activeColor: AppColors.buttonGreen,
                            onChanged: (value) {
                              setState(() {
                                selectedLang = value.toString();
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              "English",
                              style: TextStyle(
                                  fontSize: 13, color: AppColors.darkGrey),
                            ),
                          ),
                          const Text(
                            "english",
                            style: TextStyle(
                                fontSize: 13, color: AppColors.darkGrey),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.borderGrey),
                    InkWell(
                      // onTap: () {
                      //   setState(() {
                      //     selectedLang = "ar";
                      //   });
                      // },
                      onTap: () async {
                        setState(() {
                          selectedLang = "ar";
                        });
                        await _changeLanguage("ar");
                        Navigator.pop(context);
                      },

                      child: Row(
                        children: [
                          Radio(
                            value: "ar",
                            groupValue: selectedLang,
                            activeColor: AppColors.buttonGreen,
                            onChanged: (value) {
                              setState(() {
                                selectedLang = value.toString();
                              });
                            },
                          ),
                          const Expanded(
                            child: Text(
                              "Arabic",
                              style: TextStyle(
                                  fontSize: 13, color: AppColors.darkGrey),
                            ),
                          ),
                          const Text(
                            "العربية",
                            style: TextStyle(
                                fontSize: 13, color: AppColors.darkGrey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
