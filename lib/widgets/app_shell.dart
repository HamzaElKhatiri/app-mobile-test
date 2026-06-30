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
                    backgroundColor: Colors.black.withOpacity(0.20),
                    selectedIndex: _index,
                    onDestinationSelected: (value) => setState(() => _index = value),
                    labelType: NavigationRailLabelType.all,
                    selectedIconTheme: const IconThemeData(color: AppTheme.red),
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
          radius: 1.2,
          colors: [Color(0x552A0004), AppTheme.black],
        ),
      ),
      child: Stack(
        children: [
          Positioned(top: -90, right: -80, child: _Glow(color: AppTheme.red.withOpacity(0.36), size: 240)),
          Positioned(bottom: 120, left: -120, child: _Glow(color: AppTheme.neon.withOpacity(0.12), size: 260)),
          Positioned(bottom: -130, right: 40, child: _Glow(color: Colors.white.withOpacity(0.08), size: 210)),
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
        boxShadow: [BoxShadow(color: color, blurRadius: 110, spreadRadius: 48)],
      ),
    );
  }
}
