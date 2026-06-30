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
      KeypadButtonType.number => [const Color(0xFF19191E), const Color(0xFF111116)],
      KeypadButtonType.operator => [AppTheme.red, const Color(0xFF8D0007)],
      KeypadButtonType.action => [const Color(0xFF2A2A31), const Color(0xFF18181E)],
      KeypadButtonType.premium => [AppTheme.neon, const Color(0xFF6EA000)],
    };
    final textColor = type == KeypadButtonType.premium ? Colors.black : AppTheme.white;
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
                    color: colors.first.withOpacity(0.22),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
                border: Border.all(color: Colors.white.withOpacity(0.08)),
              ),
              child: Center(
                child: Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: textColor,
                    fontSize: label.length > 3 ? 15 : 22,
                    fontWeight: FontWeight.w800,
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
