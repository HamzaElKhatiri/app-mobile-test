import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color black = Color(0xFF050505);
  static const Color nearBlack = Color(0xFF0A0A0D);
  static const Color graphite = Color(0xFF141419);
  static const Color card = Color(0xFF1C1C22);
  static const Color red = Color(0xFFE50914);
  static const Color neon = Color(0xFFB6FF00);
  static const Color white = Color(0xFFF7F7F7);
  static const Color muted = Color(0xFF9B9BA3);
  static const Color gold = Color(0xFFFFD166);

  static ThemeData get darkTheme {
    final baseTextTheme = GoogleFonts.poppinsTextTheme();
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: black,
      colorScheme: const ColorScheme.dark(
        primary: red,
        secondary: neon,
        surface: graphite,
        error: Color(0xFFFF4D6D),
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
        backgroundColor: const Color(0xDD111116),
        indicatorColor: red.withOpacity(0.18),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => GoogleFonts.poppins(
            fontSize: 12,
            fontWeight: states.contains(WidgetState.selected) ? FontWeight.w700 : FontWeight.w500,
            color: states.contains(WidgetState.selected) ? white : muted,
          ),
        ),
      ),
      cardTheme: CardTheme(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: red,
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
