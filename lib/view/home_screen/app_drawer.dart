import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla_wrapp_supervisor/controller/profile_controller.dart';
import 'package:yalla_wrapp_supervisor/view/address_screen/address_screen.dart';
import 'package:yalla_wrapp_supervisor/view/auth/login_screen.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';
import 'package:yalla_wrapp_supervisor/view/notification_screen.dart';

class AppDrawer extends StatelessWidget {
  AppDrawer({super.key});

  final ProfileController profileController = Get.put(ProfileController());


  Future<String?> _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId');
     // String userId = await Prefs.getUserId() ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: FutureBuilder<String?>(
          future: _getUserId(),
          builder: (context, snapshot) {
            final userId = snapshot.data;

            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            return ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [
                  const SizedBox(height: 20),
                   if (userId != null && userId.isNotEmpty) ...[
      


  _drawerHeader(profileController),

  const SizedBox(height: 10),

                   ],
                if (userId == null || userId.isEmpty) ...[
                  const Text(
                    "For booking create your account",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Color.fromARGB(255, 95, 95, 95),
                    ),
                  ),
                  const SizedBox(height: 7),
                  ElevatedButton(
                    onPressed: () {
                      Get.offAll(const LoginScreen());
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.buttonGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text("Login",style: TextStyle(color: Colors.white),),
                  ),
                  const Divider(height: 30),
                ],

                if (userId != null && userId.isNotEmpty) ...[
                  _drawerItem(
                    icon: Icons.location_on_outlined,
                    title: "My Address",
                    onTap: () => Get.to(const AddressScreen()),
                  ),
                  _drawerItem(
                    icon: Icons.notifications_outlined,
                    title: "Notifications",
                    onTap: () => Get.to(const NotificationScreen()),
                  ),
                  const Divider(),
                ],

               
                _drawerItem(
                  icon: Icons.help_outline,
                  title: "Help & Support",
                ),
                _drawerItem(
                  icon: Icons.info_outline,
                  title: "Terms & Conditions",
                ),
                _drawerItem(
                  icon: Icons.privacy_tip_outlined,
                  title: "Privacy Policy",
                ),

                if (userId != null && userId.isNotEmpty) ...[
                  const Divider(),
                  _drawerItem(
                    icon: Icons.logout,
                    title: "Logout",
                    iconColor: AppColors.error,
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.remove('userId');
                      Get.offAll(const LoginScreen());
                    },
                  ),
                ],
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _drawerItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    Color? iconColor,
  }) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? AppColors.midGrey),
      title: Text(
        title,
        style: const TextStyle(fontSize: 13),
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    );
  }

  Widget _drawerHeader(ProfileController profileController) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    decoration: BoxDecoration(
      color: AppColors.primaryPurple,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Obx(() {
      final data = profileController.profile.value;

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            data == null
                ? 'Welcome'
                : '${data.firstName} ${data.lastName}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.phone_outlined,
                  color: AppColors.lightTextGrey, size: 18),
              const SizedBox(width: 8),
              Text(
                data?.phone ?? '—',
                style: const TextStyle(
                  color: AppColors.lightTextGrey,
                  fontSize: 11,
                ),
              ),
            ],
          ),

          const SizedBox(height: 4),

          Row(
            children: [
              const Icon(Icons.email_outlined,
                  color: AppColors.lightTextGrey, size: 18),
              const SizedBox(width: 8),
              Text(
                data?.email ?? '—',
                style: const TextStyle(
                  color: AppColors.lightTextGrey,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ],
      );
    }),
  );
}

}
