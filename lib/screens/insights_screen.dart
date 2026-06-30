import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/calculation_result.dart';
import '../services/history_store.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';

class InsightsScreen extends StatefulWidget {
  const InsightsScreen({super.key});

  @override
  State<InsightsScreen> createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen> {
  late Future<List<CalculationResult>> _future;

  @override
  void initState() {
    super.initState();
    _future = HistoryStore().load();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
        child: Padding(
          padding: Responsive.pagePadding(context),
          child: FutureBuilder<List<CalculationResult>>(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator(color: AppTheme.cyan));
              }
              final items = snapshot.data ?? [];
              final total = items.length;
              final scientific = items.where((e) => RegExp(r'sin|cos|sqrt|log|π|\^').hasMatch(e.expression)).length;
              final longest = items.fold<int>(0, (max, item) => item.expression.length > max ? item.expression.length : max);
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Stats', style: GoogleFonts.poppins(fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -1.2)),
                  const SizedBox(height: 8),
                  const Text('Un aperçu simple de ton usage, calculé localement.', style: TextStyle(color: AppTheme.muted)),
                  const SizedBox(height: 22),
                  Expanded(
                    child: GridView.count(
                      crossAxisCount: Responsive.isMobile(context) ? 1 : 3,
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: Responsive.isMobile(context) ? 2.2 : 1.15,
                      children: const [
                        _MetricCard(label: 'Calculs sauvés', value: null, icon: Icons.save_rounded, accent: AppTheme.electricBlue),
                        _MetricCard(label: 'Calculs avancés', value: null, icon: Icons.science_rounded, accent: AppTheme.cyan),
                        _MetricCard(label: 'Expression max', value: null, icon: Icons.straighten_rounded, accent: AppTheme.violet),
                      ].asMap().entries.map((entry) {
                        final values = ['$total', '$scientific', '$longest'];
                        final card = entry.value;
                        return _MetricCard(label: card.label, value: values[entry.key], icon: card.icon, accent: card.accent);
                      }).toList(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value, required this.icon, required this.accent});

  final String label;
  final String? value;
  final IconData icon;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: accent.withOpacity(0.16), borderRadius: BorderRadius.circular(18), border: Border.all(color: accent.withOpacity(0.18))),
            child: Icon(icon, color: accent),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(value ?? '0', style: GoogleFonts.poppins(fontSize: 40, fontWeight: FontWeight.w900, color: accent, shadows: [Shadow(color: accent.withOpacity(0.38), blurRadius: 16)])),
              Text(label, style: const TextStyle(color: AppTheme.muted, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}
