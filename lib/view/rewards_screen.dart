import 'package:flutter/material.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get.dart';
import 'package:yalla_wrapp_supervisor/controller/coupon_controller.dart';
import 'package:yalla_wrapp_supervisor/controller/reward_controller.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';

class RewardsScreen extends StatefulWidget {
  final bool showBack;
  const RewardsScreen({super.key, this.showBack = false});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  final CouponController couponController = Get.put(CouponController());

  final RewardController rewardController = Get.put(RewardController());

  final List<Map<String, dynamic>> bookings = [
    {
      'title': '#XYZ234',
      'subtitle': 'Today | 10:30 AM',
      'status': 'Luggage Wrapping',
      'price': '+10 Points',
      'image': 'assets/images/doctor.png',
    },
    {
      'title': '#XYZ234',
      'subtitle': 'Today | 10:30 AM',
      'status': 'Office/Home Shifting',
      'price': '+10 Points',
      'image': 'assets/images/lab.png',
    },
    {
      'title': '#XYZ234',
      'subtitle': 'Today | 10:30 AM',
      'status': 'Office/Home Shifting',
      'price': '+10 Points',
      'image': 'assets/images/doctor.png',
    },
    {
      'title': '#XYZ234',
      'subtitle': 'Today | 10:30 AM',
      'status': 'Office/Home Shifting',
      'price': '80',
      'image': 'assets/images/lab.png',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        automaticallyImplyLeading: widget.showBack,
        leading: widget.showBack
            ? IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios,
                  color: Colors.black,
                ),
                onPressed: () => Get.back(),
              )
            : null,
        centerTitle: true,
        title: Text(
          'Rewards'.tr,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 15,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            rewardPointsContainer(),
            const SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.only(left: 16,right: 16),
              child: Text(
                'Available Coupons'.tr,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            couponBanners(),
            const SizedBox(height: 20),
       Padding(
              padding: EdgeInsets.only(left: 16,right:16),
              child: Text(
                'Reward History'.tr,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            rewardHistoryList(),
          ],
        ),
      ),
    );
  }

  Widget rewardPointsContainer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 184, 255, 249),
            Color.fromARGB(255, 219, 210, 255),
          ],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
  Text(
            "Total Reward Points :".tr,
            style: const TextStyle(
              color: Color.fromARGB(255, 36, 36, 36),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Image.asset(
                "assets/images/rewardsicon.png",
                width: 40,
                height: 40,
              ),
              const SizedBox(width: 10),
              Obx(() {
                final points = rewardController.reward.value?.totalRewards ?? 0;
                return Row(
                  children: [
                    Text(
                      "$points ",
                      style: const TextStyle(
                        color: Color.fromARGB(255, 41, 41, 41),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "Points".tr,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 41, 41, 41),
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                );
              }),
            ],
          ),
          const SizedBox(height: 12),
         Text(
            "Keep using services to earn more reward points.".tr,
            style: const TextStyle(
              color: Color.fromARGB(179, 56, 56, 56),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 14),
          Stack(
            children: [
              Container(
                height: 6,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              Obx(() {
                return Container(
                  height: 6,
                  width: 150 * rewardController.progressValue,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 13, 226, 162),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 8),
          const Align(
            alignment: Alignment.bottomRight,
            child: Text(
              "10 Points",
              style: TextStyle(
                color: Color.fromARGB(255, 75, 75, 75),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget couponBanners() {
  //   return Padding(
  //     padding: const EdgeInsets.only(left: 16),
  //     child: SizedBox(
  //       height: 80,
  //       child: ListView(
  //         scrollDirection: Axis.horizontal,
  //         physics: const BouncingScrollPhysics(),
  // children: [
  //   bannerWidget("assets/images/rewards_banner.png"),
  //   bannerWidget("assets/images/rewards_banner.png"),
  //   bannerWidget("assets/images/rewards_banner.png"),
  // ],

  Widget couponBanners() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: SizedBox(
        height: 80,
        child: Obx(() {
          if (couponController.isLoading.value) {
            return const SizedBox();
          }

          return ListView.builder(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: couponController.coupons.length,
            itemBuilder: (context, index) {
              return bannerNetworkWidget(
                couponController.coupons[index].couponImage,
              );
            },
          );
        }),
      ),
    );
  }

  //       ),
  //     ),
  //   );
  // }
  Widget bannerNetworkWidget(String imgUrl) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey.shade200,
        image: DecorationImage(
          image: NetworkImage(imgUrl),
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget rewardHistoryList() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Obx(() {
        if (rewardController.rewardHistory.isEmpty) {
          return const Padding(
            padding: EdgeInsets.only(top: 70),
            child: Center(
              child: Text(
                "Rewards Not Available",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ),
          );
        }

        return Column(
          children: rewardController.rewardHistory.map((history) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: AppColors.borderGrey),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const SizedBox(width: 5),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          history.bookingId,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          history.createdTime,
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Luggage Wrapping",
                        style: TextStyle(
                          fontSize: 10,
                          color: Color.fromARGB(255, 90, 90, 90),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/rewardsicon.png',
                            width: 20,
                            height: 20,
                          ),
                          Text(
                            "+${history.rewardPoints} Points",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            );
          }).toList(),
        );
      }),
    );
  }

  Widget bannerWidget(String img) {
    return Container(
      width: 300,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: Colors.grey.shade200,
        image: DecorationImage(
          image: AssetImage(img),
          fit: BoxFit.fill,
        ),
      ),
    );
  }
}
