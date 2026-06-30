import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';

enum KeypadButtonType { number, operator, action, premium }

class KeypadButton extends StatelessWidget {
  const KeypadButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = KeypadButtonType.number,
    this.flex = 1,
  });

  final String label;
  final VoidCallback onPressed;
  final KeypadButtonType type;
  final int flex;

  @override
  Widget build(BuildContext context) {
    final colors = switch (type) {
      KeypadButtonType.number => [const Color(0xFF10254A), const Color(0xFF071225)],
      KeypadButtonType.operator => [AppTheme.electricBlue, AppTheme.deepBlue],
      KeypadButtonType.action => [const Color(0xFF1B3D72), const Color(0xFF0A1A35)],
      KeypadButtonType.premium => [AppTheme.cyan, AppTheme.electricBlue],
    };
    final textColor = type == KeypadButtonType.premium ? const Color(0xFF00101A) : AppTheme.white;
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(5),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onPressed,
            borderRadius: BorderRadius.circular(22),
            child: Ink(
              height: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                gradient: LinearGradient(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: colors),
                boxShadow: [
                  BoxShadow(
                    color: colors.first.withOpacity(0.34),
                    blurRadius: 24,
                    spreadRadius: -4,
                    offset: const Offset(0, 12),
                  ),
                  if (type == KeypadButtonType.operator || type == KeypadButtonType.premium)
                    BoxShadow(
                      color: AppTheme.cyan.withOpacity(0.22),
                      blurRadius: 34,
                      spreadRadius: -8,
                    ),
                ],
                border: Border.all(color: AppTheme.cyan.withOpacity(type == KeypadButtonType.number ? 0.10 : 0.28)),
              ),
              child: Center(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: label.length > 3 ? 15 : 22,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.2,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
