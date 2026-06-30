import 'package:flutter/material.dart';

import '../screens/about_screen.dart';
import '../screens/history_screen.dart';
import '../screens/home_screen.dart';
import '../screens/insights_screen.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _index = 0;
  final _pages = const [HomeScreen(), HistoryScreen(), InsightsScreen(), AboutScreen()];

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    return Scaffold(
      body: Stack(
        children: [
          const _AmbientBackground(),
          SafeArea(
            child: Row(
              children: [
                if (isDesktop)
                  NavigationRail(
                    backgroundColor: Colors.black.withOpacity(0.18),
                    selectedIndex: _index,
                    onDestinationSelected: (value) => setState(() => _index = value),
                    labelType: NavigationRailLabelType.all,
                    selectedIconTheme: const IconThemeData(color: AppTheme.cyan),
                    unselectedIconTheme: const IconThemeData(color: AppTheme.muted),
                    selectedLabelTextStyle: const TextStyle(color: AppTheme.white, fontWeight: FontWeight.w800),
                    unselectedLabelTextStyle: const TextStyle(color: AppTheme.muted),
                    destinations: const [
                      NavigationRailDestination(icon: Icon(Icons.calculate_rounded), label: Text('Calcul')),
                      NavigationRailDestination(icon: Icon(Icons.history_rounded), label: Text('Résultats')),
                      NavigationRailDestination(icon: Icon(Icons.insights_rounded), label: Text('Stats')),
                      NavigationRailDestination(icon: Icon(Icons.bolt_rounded), label: Text('Studio')),
                    ],
                  ),
                Expanded(child: AnimatedSwitcher(duration: const Duration(milliseconds: 280), child: _pages[_index])),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: isDesktop
          ? null
          : NavigationBar(
              selectedIndex: _index,
              onDestinationSelected: (value) => setState(() => _index = value),
              destinations: const [
                NavigationDestination(icon: Icon(Icons.calculate_rounded), label: 'Calcul'),
                NavigationDestination(icon: Icon(Icons.history_rounded), label: 'Résultats'),
                NavigationDestination(icon: Icon(Icons.insights_rounded), label: 'Stats'),
                NavigationDestination(icon: Icon(Icons.bolt_rounded), label: 'Studio'),
              ],
            ),
    );
  }
}

class _AmbientBackground extends StatelessWidget {
  const _AmbientBackground();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.black,
        gradient: RadialGradient(
          center: Alignment.topRight,
          radius: 1.25,
          colors: [Color(0x55386DFF), AppTheme.black],
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -90, right: -80, child: _Glow(color: AppTheme.electricBlue.withOpacity(0.42), size: 260)),
          Positioned(bottom: 120, left: -120, child: _Glow(color: AppTheme.cyan.withOpacity(0.18), size: 280)),
          Positioned(bottom: -130, right: 40, child: _Glow(color: AppTheme.violet.withOpacity(0.16), size: 230)),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(painter: _GridPainter()),
            ),
          ),
        ],
      ),
    );
  }
}

class _Glow extends StatelessWidget {
  const _Glow({required this.color, required this.size});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [BoxShadow(color: color, blurRadius: 120, spreadRadius: 52)],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppTheme.cyan.withOpacity(0.035)
      ..strokeWidth = 1;
    const gap = 46.0;
    for (double x = 0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x + size.width * 0.10, size.height), paint);
    }
    for (double y = 0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + size.height * 0.04), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
