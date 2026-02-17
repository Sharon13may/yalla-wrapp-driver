import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yalla_wrapp_supervisor/view/account/my_account_screen.dart';
import 'package:yalla_wrapp_supervisor/view/booking/my_bookings_screen.dart';
import 'package:yalla_wrapp_supervisor/view/constants/app_colors.dart';
import 'package:yalla_wrapp_supervisor/view/home_screen/home_screen.dart';
import 'package:yalla_wrapp_supervisor/view/rewards_screen.dart';
import 'package:yalla_wrapp_supervisor/view/services_screen.dart';
import 'package:yalla_wrapp_supervisor/view/widgets/bottomnavclipper.dart';


class BottomNavBar extends StatefulWidget {
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar>


    with SingleTickerProviderStateMixin {
  int _selectedIndex = 2;
  late AnimationController _controller;
  late Animation<double> _animation;
  double _previousIndex = 2.0;
bool _isLoggedIn = false;
bool _isLoading = true;
List<String> _icons = [];
List<Widget> _screens = [];
  
  @override
void initState() {
  super.initState();
  _checkLoginStatus();

  _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 600),
  );

  _animation = Tween<double>(
    begin: _selectedIndex.toDouble(),
    end: _selectedIndex.toDouble(),
  ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
}

bool get _isRTL {
  return Directionality.of(context) == TextDirection.rtl;
}

Future<void> _checkLoginStatus() async {
  final prefs = await SharedPreferences.getInstance();
  final userId = prefs.getString('userId');

  _isLoggedIn = userId != null && userId.isNotEmpty;

  _buildTabs();

  // setState(() {
  //   _isLoading = false;
  //   _selectedIndex = _isLoggedIn ? 2 : 1; // Home index
  //   _previousIndex = _selectedIndex.toDouble();
  // });
  setState(() {
  _isLoading = false;
  _selectedIndex = _isLoggedIn ? 2 : 1;
  _previousIndex = _selectedIndex.toDouble();

  // 🔑 FORCE animation sync on first load
  _animation = AlwaysStoppedAnimation(_selectedIndex.toDouble());
});

}


void _buildTabs() {
  if (_isLoggedIn) {
    _icons = [
      'assets/images/booking_list_bottom_bar.svg', // leftmost (EN)
      'assets/images/services.svg',
      'assets/images/home.svg',
      'assets/images/reward_bottombar.svg',
      'assets/images/profile.svg', // rightmost (EN)
    ];

    _screens = [
      const MyBookingsScreen(showBack: false),
      ServicesScreen(),
      const HomeScreen(),
      const RewardsScreen(showBack: false),
      MyAccountScreen(),
    ];
  } else {
    _icons = [
      'assets/images/services.svg',
      'assets/images/home.svg',
      'assets/images/profile.svg',
    ];

    _screens = [
      ServicesScreen(),
      const HomeScreen(),
      MyAccountScreen(),
    ];
  }
}


// void _buildTabs() {
//   if (_isLoggedIn) {

//     _icons = [
//       'assets/images/booking_list_bottom_bar.svg',
//       'assets/images/services.svg',
//       'assets/images/home.svg',
//       'assets/images/reward_bottombar.svg',
//       'assets/images/profile.svg',
//     ];

//     _screens = [
//       const MyBookingsScreen(showBack: false),
//       ServicesScreen(),
//       const HomeScreen(),
//       const RewardsScreen(showBack: false),
//       MyAccountScreen(),
//     ];
//   } else {

//     _icons = [
//       'assets/images/services.svg',
//       'assets/images/home.svg',
//       'assets/images/profile.svg',
//     ];

//     _screens = [
//       ServicesScreen(),
//       const HomeScreen(),
//       MyAccountScreen(),
//     ];
//   }
// }


  void _onItemTapped(int index) {
    _animation = Tween<double>(begin: _previousIndex, end: index.toDouble())
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _controller.forward(from: 0);
    setState(() {
      _selectedIndex = index;
      _previousIndex = index.toDouble();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
      if (_isLoading) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
    return PopScope(
      canPop: 
      false,  
      child: Scaffold(
        body: _screens[_selectedIndex],
        extendBody: true,
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          child: Stack(
            alignment: Alignment.bottomCenter,
            clipBehavior: Clip.none,
            children: [
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return ClipPath(
                  //  clipper: NavBarClipper(selectedIndex: _animation.value,   itemCount: _icons.length,),
                  clipper: NavBarClipper(
  selectedIndex: _animation.value,
  itemCount: _icons.length,
    isRTL: Directionality.of(context) == TextDirection.rtl,
),

                    child: Container(
                      height: 65,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple,
                        borderRadius: BorderRadius.circular(40),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 8,
                            offset: const Offset(0, -2),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(_icons.length, (index) {
                          bool isSelected = _selectedIndex == index;
      
                          return GestureDetector(
                            onTap: () => _onItemTapped(index),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeOut,
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.transparent,
                              ),
                              child: isSelected
                                  ? const SizedBox(width: 22, height: 15)
                                  : SvgPicture.asset(
                                      _icons[index],
                                      // height: 22,
                                      // width: 22,
                                    
                                    ),
                            ),
                          );
                        }),
                      ),
                    ),
                  );
                },
              ),
      
              AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Positioned(
                    bottom: 45,
                    left: _getAnimatedIconPosition(context, _animation.value),
                    child: GestureDetector(
                      onTap: () => _onItemTapped(_selectedIndex),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 350),
                        curve: Curves.easeOutBack,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryGreen,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: SvgPicture.asset(
                          _icons[_selectedIndex],
                          
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }


double _getAnimatedIconPosition(BuildContext context, double index) {
  final totalWidth = MediaQuery.of(context).size.width - 32;
  final spacing = totalWidth / _icons.length;

  final logicalX = spacing * index + spacing / 2 - 28;

  if (_isRTL) {
    return totalWidth - logicalX - 56; // mirror correctly
  }

  return logicalX;
}


  // double _getAnimatedIconPosition(BuildContext context, double index) {
  //   final width = MediaQuery.of(context).size.width - 32;
    
  //   final spacing = width / _icons.length;

  //   return spacing * index + spacing / 2 - 28;
  // }
}
