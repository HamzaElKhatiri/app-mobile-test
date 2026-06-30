import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
        child: Padding(
          padding: Responsive.pagePadding(context),
          child: ListView(
            children: [
              Text('Studio', style: GoogleFonts.poppins(fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -1.2)),
              const SizedBox(height: 8),
              const Text('Calc Noir combine une expérience tactile mobile et un rendu web responsive.', style: TextStyle(color: AppTheme.muted)),
              const SizedBox(height: 22),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Design premium', style: GoogleFonts.poppins(fontSize: 26, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 12),
                    const Text(
                      'Noir profond façon Netflix, précision minimaliste façon Apple, énergie sportive façon Nike. L’app reste rapide, lisible et utilisable à une main.',
                      style: TextStyle(color: AppTheme.muted, height: 1.55),
                    ),
                    const SizedBox(height: 18),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: const [
                        _Chip(label: 'Mobile-first'),
                        _Chip(label: 'Flutter Web'),
                        _Chip(label: 'Historique local'),
                        _Chip(label: 'Scientifique'),
                        _Chip(label: 'Dark UI'),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    _Feature(icon: Icons.speed_rounded, title: 'Résultat instantané', text: 'Prévisualisation automatique pendant la saisie.'),
                    _Feature(icon: Icons.lock_rounded, title: 'Local only', text: 'Aucune API, aucune base distante, aucune donnée envoyée.'),
                    _Feature(icon: Icons.devices_rounded, title: 'Responsive', text: 'Adapté aux téléphones, tablettes, desktops et navigateurs web.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: AppTheme.red.withOpacity(0.14), borderRadius: BorderRadius.circular(999)),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
    );
  }
}

class _Feature extends StatelessWidget {
  const _Feature({required this.icon, required this.title, required this.text});
  final IconData icon;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppTheme.neon),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                const SizedBox(height: 4),
                Text(text, style: const TextStyle(color: AppTheme.muted, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
