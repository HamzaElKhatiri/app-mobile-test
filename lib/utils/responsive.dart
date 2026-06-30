import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) => MediaQuery.sizeOf(context).width < 700;

  static bool isTablet(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= 700 && width < 1100;
  }

  static bool isDesktop(BuildContext context) => MediaQuery.sizeOf(context).width >= 1100;

  static double maxContentWidth(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1200) return 1180;
    if (width >= 800) return 760;
    return width;
  }

  static EdgeInsets pagePadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    if (width >= 1100) return const EdgeInsets.symmetric(horizontal: 36, vertical: 24);
    if (width >= 700) return const EdgeInsets.symmetric(horizontal: 28, vertical: 22);
    return const EdgeInsets.fromLTRB(18, 16, 18, 18);
  }
}
