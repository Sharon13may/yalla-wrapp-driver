import 'package:flutter/material.dart';

class NavBarClipper extends CustomClipper<Path> {
  final double selectedIndex;
  final int itemCount;
  final bool isRTL;

  NavBarClipper({
    required this.selectedIndex,
    required this.itemCount,
    required this.isRTL,
  });

  @override
  Path getClip(Size size) {
    final path = Path();

    // 🔑 dynamic width (unchanged)
    final iconWidth = size.width / itemCount;

    double centerX = iconWidth * selectedIndex + iconWidth / 2;

    // 🔥 RTL MIRROR (only math change)
    if (isRTL) {
      centerX = size.width - centerX;
    }

    const curveHeight = 30.0;
    const curveWidth = 120.0;

    path.moveTo(0, 0);
    path.lineTo(centerX - curveWidth / 2, 0);

    path.cubicTo(
      centerX - curveWidth / 5, 0,
      centerX - curveWidth / 4, curveHeight,
      centerX, curveHeight,
    );

    path.cubicTo(
      centerX + curveWidth / 4, curveHeight,
      centerX + curveWidth / 4, 0,
      centerX + curveWidth / 2, 0,
    );

    path.lineTo(size.width, 0);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant NavBarClipper oldClipper) {
    return selectedIndex != oldClipper.selectedIndex ||
        itemCount != oldClipper.itemCount ||
        isRTL != oldClipper.isRTL;
  }
}

// import 'package:flutter/material.dart';

// class NavBarClipper extends CustomClipper<Path> {
//   final double selectedIndex;
//   final int itemCount;

//   NavBarClipper({
//     required this.selectedIndex,
//     required this.itemCount,
//   });

//   @override
//   Path getClip(Size size) {
//     final path = Path();

//     // 🔑 dynamic width
//     final iconWidth = size.width / itemCount;
//     final centerX = iconWidth * selectedIndex + iconWidth / 2;

//     const curveHeight = 30.0;
//     const curveWidth = 120.0;

//     path.moveTo(0, 0);
//     path.lineTo(centerX - curveWidth / 2, 0);

//     path.cubicTo(
//       centerX - curveWidth / 5, 0,
//       centerX - curveWidth / 4, curveHeight,
//       centerX, curveHeight,
//     );

//     path.cubicTo(
//       centerX + curveWidth / 4, curveHeight,
//       centerX + curveWidth / 4, 0,
//       centerX + curveWidth / 2, 0,
//     );

//     path.lineTo(size.width, 0);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(covariant NavBarClipper oldClipper) {
//     return selectedIndex != oldClipper.selectedIndex ||
//         itemCount != oldClipper.itemCount;
//   }
// }

// import 'package:flutter/material.dart';

// class NavBarClipper extends CustomClipper<Path> {
//   final double selectedIndex;

//   NavBarClipper({required this.selectedIndex});

//   @override
//   Path getClip(Size size) {
//     final path = Path();
//     final iconWidth = size.width / 5;
//     final centerX = iconWidth * selectedIndex + iconWidth / 2;
//     const curveHeight = 30.0;
//     const curveWidth = 120.0;

//     path.moveTo(0, 0);
//     path.lineTo(centerX - curveWidth / 2, 0);

//     path.cubicTo(
//       centerX - curveWidth / 5, 0,
//       centerX - curveWidth / 4, curveHeight,
//       centerX, curveHeight,
//     );

//     path.cubicTo(
//       centerX + curveWidth / 4, curveHeight,
//       centerX + curveWidth / 4, 0,
//       centerX + curveWidth / 2, 0,
//     );

//     path.lineTo(size.width, 0);
//     path.lineTo(size.width, size.height);
//     path.lineTo(0, size.height);
//     path.close();

//     return path;
//   }

//   @override
//   bool shouldReclip(covariant NavBarClipper oldClipper) {
//     return oldClipper.selectedIndex != selectedIndex;
//   }
// }
