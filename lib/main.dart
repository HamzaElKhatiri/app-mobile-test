import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'screens/about_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/insights_screen.dart';
import 'theme/app_theme.dart';
import 'widgets/app_shell.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const CalcNoirApp());
}

class CalcNoirApp extends StatelessWidget {
  const CalcNoirApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calc Noir',
      theme: AppTheme.darkTheme,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
          child: child ?? const SizedBox.shrink(),
        );
      },
      initialRoute: '/',
      routes: {
        '/': (context) => const AppShell(),
        '/calculator': (context) => const HomeScreen(),
        '/history': (context) => const HistoryScreen(),
        '/insights': (context) => const InsightsScreen(),
        '/about': (context) => const AboutScreen(),
      },
      onGenerateTitle: (context) => GoogleFonts.poppins().fontFamily == null ? 'Calc Noir' : 'Calc Noir',
    );
  }
}
