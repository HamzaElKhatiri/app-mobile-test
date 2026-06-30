import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color black = Color(0xFF02040A);
  static const Color nearBlack = Color(0xFF060A14);
  static const Color graphite = Color(0xFF0D1424);
  static const Color card = Color(0xFF111A2F);
  static const Color electricBlue = Color(0xFF147CFF);
  static const Color deepBlue = Color(0xFF063BFF);
  static const Color cyan = Color(0xFF00E5FF);
  static const Color violet = Color(0xFF7C3CFF);
  static const Color white = Color(0xFFF4F8FF);
  static const Color muted = Color(0xFF8FA4C8);
  static const Color gold = Color(0xFF79F2FF);
  static const Color neon = cyan;
  static const Color red = electricBlue;

  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: black,
      colorScheme: const ColorScheme.dark(
        primary: electricBlue,
        secondary: cyan,
        surface: graphite,
        error: Color(0xFFFF4D8D),
      ),
      textTheme: baseTextTheme.apply(
        bodyColor: white,
        displayColor: white,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 20,
          fontWeight: FontWeight.w800,
          color: white,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: const Color(0xE6081020),
        indicatorColor: electricBlue.withOpacity(0.22),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w800 : FontWeight.w500,
            color: states.contains(WidgetState.selected) ? white : muted,
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: electricBlue,
          foregroundColor: white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
          textStyle: GoogleFonts.poppins(fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
