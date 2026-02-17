import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla_wrapp_supervisor/controller/home_controller.dart';
import 'package:yalla_wrapp_supervisor/model/service_model.dart';
import 'package:yalla_wrapp_supervisor/view/auth/login_screen.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';
import 'package:yalla_wrapp_supervisor/view/luggage_wrapping/luggage_wrapping_form.dart';

class ServicesScreen extends StatelessWidget {
  ServicesScreen({super.key});
  final homeController = Get.put(HomeController());

  Future<void> _handleServiceTap(
    ServiceModel service,
    BuildContext context,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId == null || userId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please login to continue'),
          backgroundColor: AppColors.primaryPurple,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 2),
        ),
      );

      Future.delayed(const Duration(milliseconds: 300), () {
        Get.to(const LoginScreen());
      });

      return;
    }

    Get.to(
      LuggageWrappingScreen(
        serviceId: service.serviceId,
        serviceName: service.displayName,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        centerTitle: true,
        title: Text(
          'Services'.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() {
              if (homeController.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              return Column(
                children: homeController.services.map((service) {
                  return _buildServiceTile(service, () {
                    _handleServiceTap(service, context);
                  });
                }).toList(),
              );
            })
          ],
        ),
      ),
    );
  }

  Widget _buildServiceTile(ServiceModel service, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: const Color.fromARGB(255, 190, 190, 190),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                height: 55,
                width: 55,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 243, 238, 245),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  // child: Image.network(
                  //   service.icon,
                  //   height: 25,
                  //   width: 25,
                  //   fit: BoxFit.cover,
                  //   errorBuilder: (_, __, ___) => Image.asset(
                  //     'assets/images/Vector.png',
                  //     height: 25,
                  //     width: 25,
                  //   ),
                  // ),
                  child: serviceIcon(service.icon),
                ),
              ),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  service.displayName,
                  style: const TextStyle(
                    color: Colors.black87,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 16, color: Color.fromARGB(255, 87, 87, 87)),
            ],
          ),
        ),
      ),
    );
  }

  Widget serviceIcon(String url) {
    final isSvg = url.toLowerCase().endsWith('.svg');

    return isSvg
        ? Padding(
            padding: const EdgeInsets.all(4.0),
            child: SvgPicture.network(
              url,
              height: 25,
              width: 25,
              fit: BoxFit.contain,
            ),
          )
        : Image.network(
            url,
            height: 20,
            width: 20,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Image.asset(
              'assets/images/Vector.png',
              height: 25,
              width: 25,
            ),
          );
  }
}
