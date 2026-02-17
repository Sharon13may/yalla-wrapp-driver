import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla_wrapp_supervisor/view/auth/login_screen.dart';
import 'package:yalla_wrapp_supervisor/view/bottom_nav_bar.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart'; 

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({Key? key}) : super(key: key);

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}

class _IntroductionScreenState extends State<IntroductionScreen>
    with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<Offset>> _slideAnimations;
  late List<Animation<double>> _fadeAnimations;
  final List<String> _imagePaths = [
    "assets/images/wrap.svg",
    "assets/images/travell.svg",
    "assets/images/relax.svg",
  ];

  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;

  @override
  void initState() {
    super.initState();

    _controllers = List.generate(
      _imagePaths.length,
      (index) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 800),
      ),
    );

    _slideAnimations = _controllers
        .map((controller) => Tween<Offset>(
              begin: const Offset(0, 0.3),
              end: Offset.zero,
            ).animate(
              CurvedAnimation(parent: controller, curve: Curves.easeOut),
            ))
        .toList();

    _fadeAnimations = _controllers
        .map((controller) =>
            Tween<double>(begin: 0.0, end: 1.0).animate(controller))
        .toList();

    _startLoopAnimation();

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.0,
      upperBound: 0.05,
    );
    _buttonAnimation =
        Tween<double>(begin: 1.0, end: 0.95).animate(_buttonController);
  }

  void _startLoopAnimation() async {
    while (mounted) {
      for (int i = 0; i < _controllers.length; i++) {
        await Future.delayed(const Duration(milliseconds: 500));
        _controllers[i].forward();
      }
      await Future.delayed(const Duration(seconds: 2));
      for (int i = 0; i < _controllers.length; i++) {
        _controllers[i].reverse();
      }
      await Future.delayed(const Duration(milliseconds: 500));
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    _buttonController.dispose();
    super.dispose();
  }

  void _onButtonTap() async {
    await _buttonController.forward();
    await _buttonController.reverse();

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('userId');

    if (userId != null && userId.isNotEmpty) {
      // User already logged in → go to BottomNavBar
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => BottomNavBar()),
      );
    } else {
      // User not logged in → go to LoginScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.primaryGreen,
      body: Stack(
        children: [
          Positioned.fill(
            child: SvgPicture.asset(
              "assets/images/splash (1).svg",
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            left: 24,
            bottom: 130,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: List.generate(_imagePaths.length, (index) {
                return SlideTransition(
                  position: _slideAnimations[index],
                  child: FadeTransition(
                    opacity: _fadeAnimations[index],
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 0),
                      child: SvgPicture.asset(
                        _imagePaths[index],
                      
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 55,
            child: GestureDetector(
              onTap: _onButtonTap,
              child: ScaleTransition(
                scale: _buttonAnimation,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Get Started".tr,
                        style: TextStyle(
                          fontSize: 14,
                          color: AppColors.primaryPurple,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(width: 8),
                      Row(
                        children: [
                          Text(
                            ">",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 133, 73, 206)),
                          ),
                          Text(
                            ">",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(255, 208, 169, 255)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
