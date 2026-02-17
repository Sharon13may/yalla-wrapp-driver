import 'dart:nativewrappers/_internal/vm/lib/async_patch.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/get_core.dart';

import 'package:url_launcher/url_launcher.dart';
import 'package:yalla_wrapp_supervisor/controller/home_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/upcoming_boooking_controller.dart';
import 'package:yalla_wrapp_supervisor/model/service_model.dart';
import 'package:yalla_wrapp_supervisor/view/booking/booking_summary_screen.dart';
import 'package:yalla_wrapp_supervisor/view/booking/my_bookings_screen.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';
import 'package:yalla_wrapp_supervisor/view/home_screen/app_drawer.dart';
import 'package:yalla_wrapp_supervisor/view/luggage_wrapping/luggage_wrapping_form.dart';
import 'package:yalla_wrapp_supervisor/view/notification_screen.dart';
import 'package:yalla_wrapp_supervisor/view/rewards_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  final HomeController homeController = Get.put(HomeController());
  final UpcomingBookingController upcomingController =
      Get.put(UpcomingBookingController());

  double _currentPage = 0;
  final List<String> _banners = [
    'assets/images/banner1.png',
    'assets/images/banner2.png',
    'assets/images/banner3.png',
  ];
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _pageController = PageController(
      viewportFraction: 0.90,
      initialPage: 100 * _banners.length,
    );
    _currentPage = _pageController.initialPage.toDouble();

  
    upcomingController.fetchUpcomingBookings();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _callSupport() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '0000000');

    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      Get.snackbar("Error", "Could not open dialer");
    }
  }

  Widget serviceIcon(String url) {
  final isSvg = url.toLowerCase().endsWith('.svg');

  return isSvg
      ? Padding(
        padding: const EdgeInsets.all(4.0),
        child: SvgPicture.network(
            url,
            height: 21,
            width: 21,
            fit: BoxFit.cover,
          ),
      )
      : Image.network(
          url,
          height: 25,
          width: 25,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => Image.asset(
            'assets/images/Vector.png',
            height: 20,
            width: 20,
          ),
        );
}


  Widget _buildDynamicCard(ServiceModel service) {
    return Container(
      width: 107,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 140, 86, 206).withOpacity(0.10),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            // child: Image.network(
            //   "${service.icon}",
            //   height: 22,
            //   width: 22,
            //   fit: BoxFit.cover,
            //   errorBuilder: (_, __, ___) => Image.asset(
            //       'assets/images/Vector.png',
            //       height: 20,
            //       width: 20),
            // ),
            child: serviceIcon(service.icon),

          ),
          const SizedBox(height: 16),
          Text(
            service.displayName,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 11,
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _shimmerCard() {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Container(height: 20, width: 20, color: Colors.grey.shade400),
          const SizedBox(height: 12),
          Container(height: 12, width: 80, color: Colors.grey.shade400),
          const SizedBox(height: 4),
          Container(height: 12, width: 60, color: Colors.grey.shade400),
          const SizedBox(height: 6),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      backgroundColor: Colors.white,
      body: Column(
        children: [
          ClipPath(
            clipper: TopAppBarClipper(),
            child: Container(
              color: AppColors.primaryPurple,
              padding: const EdgeInsets.fromLTRB(16, 55, 16, 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                Builder(
  builder: (context) => InkWell(
    onTap: () {
      Scaffold.of(context).openDrawer();
    },
    child: _buildIconCircle(Icons.menu),
  ),
),

                
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Row(
                          children: [
                            _buildIconCircle(Icons.location_on_outlined,
                                circleColor:
                                    const Color.fromARGB(255, 231, 231, 231)
                                        .withOpacity(0.2)),
                            const SizedBox(width: 8),
                            const Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Location',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 226, 226, 226),
                                      fontWeight: FontWeight.normal,
                                      fontSize: 10),
                                ),
                                Text(
                                  'Doha, West Bay  ',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 243, 243, 243),
                                      fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      InkWell(
                          onTap: () {
                            Get.to(const NotificationScreen());
                          },
                          child:
                              _buildIconCircle(Icons.notifications_outlined)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Positioned.fill(
                    child: Image.asset(
                      'assets/images/homebg.png',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 80),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                   Padding(
                        padding: const EdgeInsets.only(right: 16, left: 16),
                        child: Text(
                          'Smart Wrapping for Smart Traveller'.tr,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      SizedBox(
  height: 125,
  child: Obx(() {
    final banners = homeController.homeBanners;

    if (banners.isEmpty) return const SizedBox();

    return PageView.builder(
      controller: _pageController,
      itemBuilder: (context, index) {
        final realIndex = index % banners.length;
        final item = banners[realIndex];

        return AnimatedBuilder(
          animation: _pageController,
          builder: (context, child) {
            double value = 1.0;
            if (_pageController.position.haveDimensions) {
              value =
                  (_pageController.page ?? _currentPage) - index;
              value = (1 - (value.abs() * 0.70)).clamp(0.9, 1.0);
            }
            return Center(
              child: SizedBox(
                height: Curves.easeOut.transform(value) * 150,
                child: child,
              ),
            );
          },
          child: GestureDetector(
  onTap: () {
    Get.to(
      LuggageWrappingScreen(
        serviceId: item.serviceId,
        serviceName: item.serviceName,
      ),
    );
  },
  child: Container(
    margin: const EdgeInsets.symmetric(horizontal: 7),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
      boxShadow: const [
        BoxShadow(
          color: Color.fromARGB(66, 197, 197, 197),
          blurRadius: 0, 
          offset: Offset(0, 0),
        ),
      ],
    ),
    // child: ClipRRect(
    //   borderRadius: BorderRadius.circular(20),
    //   child: Image.network(
    //     item.image,
    //     fit: BoxFit.cover,
    //     width: double.infinity,
    //     height: double.infinity,
    //   ),
    // ),
    child: item.image.toLowerCase().endsWith('.svg')
    ? SvgPicture.network(
        item.image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        placeholderBuilder: (context) =>
            const Center(child: CircularProgressIndicator()),
      )
    : Image.network(
        item.image,
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
        errorBuilder: (_, __, ___) =>
            const Center(child: Icon(Icons.broken_image)),
      ),

  ),
),

          // child: GestureDetector(
          //   onTap: () {
          //     Get.to(
          //       LuggageWrappingScreen(
          //         serviceId: item.serviceId,
          //         serviceName: item.serviceName,
          //       ),
          //     );
          //   },
          //   child: Container(
          //     margin: const EdgeInsets.symmetric(horizontal: 7),
          //     decoration: BoxDecoration(
          //       borderRadius: BorderRadius.circular(20),
          //       boxShadow: const [
          //         BoxShadow(
          //           color: Color.fromARGB(66, 197, 197, 197),
          //           blurRadius: 0,
          //           offset: Offset(0, 5),
                    
          //         ),
          //       ],
          //     ),
          //     clipBehavior: Clip.antiAlias,
          //     child: Image.network(
          //       item.image,
          //       fit: BoxFit.cover,
          //       width: double.infinity,
          //       height: double.infinity,
          //     ),
          //   ),
          // ),
        );
      },
    );
  }),
),

                    
                  Padding(
                        padding: const EdgeInsets.only(
                            right: 16, top: 20, bottom: 10, left: 16),
                        child: Text(
                          'Yalla Services'.tr,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child:
                              //  Row(
                              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              //   children: [
                              //     InkWell(
                              //       onTap: (){
                              //         Get.to(const LuggageWrappingScreen());
                              //       },

                              //       child: _buildServiceCard('assets/images/bag.png', 'Luggage\nWrapping')),
                              //     InkWell(
                              //       onTap: (){
                              //         Get.to(const FurnitureWrapping());
                              //       },
                              //       child: _buildServiceCard('assets/images/Vector.png', 'Furniture\nWrapping')),
                              //     InkWell(
                              //       onTap: (){
                              //         Get.to(const OfficeAndHomeShiftingScreen());
                              //       },
                              //       child: _buildServiceCard('assets/images/Vector (1).png', 'Office/Home\nShifting')),
                              //   ],
                              // ),
                              Obx(() {
                            if (homeController.isLoading.value) {
                              return SizedBox(
                                height: 110,
                                child: ListView.separated(
                                  padding: const EdgeInsets.only(left: 0),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: 3,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 12),
                                  itemBuilder: (context, index) =>
                                      _shimmerCard(),
                                ),
                              );
                            }

                            return SizedBox(
                              height: 104,
                              child: ListView.separated(
                                padding: const EdgeInsets.only(left: 0),
                                scrollDirection: Axis.horizontal,
                                itemCount: homeController.services.length,
                                separatorBuilder: (_, __) =>
                                    const SizedBox(width: 12),
                                itemBuilder: (context, index) {
                                  final item = homeController.services[index];

                                  return InkWell(
                                    onTap: () {
                                      Get.to(LuggageWrappingScreen(
                                          serviceId: item.serviceId,
                                          serviceName: item.name));
                                    },
                                    child: _buildDynamicCard(item),
                                  );
                                },
                              ),
                            );
                          })),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: SizedBox(
                            width: double.infinity,
                            height: 60,
                            child: InkWell(
                              onTap: () {
                                Get.to(const LuggageWrappingScreen(
                                    serviceId: "MTp5d0B2MQ==",
                                    serviceName: "Luggage Wrap"));
                              },
                              child: Image.asset(
                                'assets/images/home_banner2.png',
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                     Padding(
                        padding: const EdgeInsets.only(
                            right: 16, top: 20, bottom: 10, left: 16),
                        child: Text(
                          'Shortcuts'.tr,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 0, 0, 0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                Get.to(const MyBookingsScreen(
                                  showBack: true,
                                ));
                              },
                              child: _buildServiceCardd(
                                  'assets/images/my_booking.svg',
                                  'My\nBookings'.tr),
                            ),
                            InkWell(
                              onTap: () {
                                Get.to(const RewardsScreen(
                                  showBack: true,
                                ));
                              },
                              child: _buildServiceCardd(
                                  'assets/images/reward.svg',
                                  'Rewards &\nCoupons'.tr),
                            ),
                            // _buildServiceCardd('assets/images/contact.svg',
                            //     'Contact\nYalla Wrapp'),
                            GestureDetector(
                              onTap: _callSupport,
                              child: _buildServiceCardd(
                                'assets/images/contact.svg',
                                'Contact\nYalla Wrapp'.tr,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                          Text(
                              "Upcoming Bookings".tr,
                              style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            GestureDetector(
                              onTap: () {
                                Get.to(const MyBookingsScreen(showBack: true));
                              },
                              child:  Text(
                                "View All".tr,
                                style: const TextStyle(
                                    color: AppColors.primaryPurple,
                                    fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Obx(() {
                        if (upcomingController.isLoading.value) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        if (upcomingController.upcomingList.isEmpty) {
                          return  Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(
                                child: Text(
                              'no_upcoming'.tr,
                              style: const TextStyle(
                                  color: AppColors.darkGrey, fontSize: 12),
                            )),
                          );
                        }

                        return Column(
                          children:
                              upcomingController.upcomingList.map((booking) {
                            return InkWell(
                              onTap: () {
                                Get.to(BookingSummaryScreen(
                                    bookingId: booking.bookingId));
                              },
                              child: Container(
                                margin: const EdgeInsets.only(
                                    bottom: 12, left: 16, right: 16),
                                padding: const EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                      Border.all(color: Colors.grey.shade300),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 55,
                                      width: 55,
                                      decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 243, 238, 245),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(14.0),
                                        child: SvgPicture.asset(
                                          'assets/images/luggage_icon.svg',
                                          height: 15,
                                          width: 15,
                                          colorFilter: const ColorFilter.mode(
                                            AppColors.primaryPurple,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            booking.referenceId,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            "${booking.bookDate} | ${booking.slotTime}",
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          booking.status == "1"
                                              ? "Completed"
                                              : "Upcoming",
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: booking.status == "1"
                                                ? Colors.green
                                                : Colors.orange,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "QAR ${booking.totalPrice}",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIconCircle(IconData icon, {Color circleColor = Colors.white24}) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: circleColor,
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: const Color.fromARGB(255, 231, 231, 231)),
    );
  }
}

Widget _buildServiceCardd(String imagePath, String title) {
  return Container(
    width: 110,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 95, 204, 113).withOpacity(0.10),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        SvgPicture.asset(
          imagePath,
          height: 22,
          width: 22,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
      ],
    ),
  );
}

Widget _buildServiceCard(String imagePath, String title) {
  return Container(
    width: 110,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: const Color.fromARGB(255, 140, 86, 206).withOpacity(0.10),
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Image.asset(
          imagePath,
          height: 20,
          width: 20,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 12),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 6),
      ],
    ),
  );
}

class TopAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    const curveRadius = 30.0;

    path.moveTo(0, 0);
    path.lineTo(0, size.height - curveRadius);

    path.quadraticBezierTo(0, size.height, curveRadius, size.height);
    path.lineTo(size.width - curveRadius, size.height);
    path.quadraticBezierTo(
        size.width, size.height, size.width, size.height - curveRadius);
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
