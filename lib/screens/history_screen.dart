import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/calculation_result.dart';
import '../services/history_store.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';
import '../widgets/result_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryStore _store = HistoryStore();
  late Future<List<CalculationResult>> _future;

  @override
  void initState() {
    super.initState();
    _future = _store.load();
  }

  void _reload() {
    setState(() => _future = _store.load());
  }

  Future<void> _clear() async {
    await _store.clear();
    _reload();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
        child: Padding(
          padding: Responsive.pagePadding(context),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text('Résultats', style: GoogleFonts.poppins(fontSize: 34, fontWeight: FontWeight.w900, letterSpacing: -1.2)),
                  ),
                  IconButton.filledTonal(onPressed: _clear, icon: const Icon(Icons.delete_outline_rounded)),
                ],
              ),
              const SizedBox(height: 8),
              const Text('Tous tes calculs validés sont sauvegardés localement sur l’appareil.', style: TextStyle(color: AppTheme.muted)),
              const SizedBox(height: 18),
              Expanded(
                child: FutureBuilder<List<CalculationResult>>(
                  future: _future,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: AppTheme.red));
                    }
                    if (snapshot.hasError) {
                      return _StateCard(icon: Icons.warning_rounded, title: 'Erreur', message: 'Impossible de charger l’historique.');
                    }
                    final items = snapshot.data ?? [];
                    if (items.isEmpty) {
                      return const _StateCard(icon: Icons.history_rounded, title: 'Aucun résultat', message: 'Effectue un calcul puis appuie sur = pour le retrouver ici.');
                    }
                    return RefreshIndicator(
                      onRefresh: () async => _reload(),
                      child: ListView.builder(
                        itemCount: items.length,
                        itemBuilder: (context, index) => ResultTile(item: items[index]),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StateCard extends StatelessWidget {
  const _StateCard({required this.icon, required this.title, required this.message});

  final IconData icon;
  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GlassCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.red, size: 48),
            const SizedBox(height: 14),
            Text(title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center, style: const TextStyle(color: AppTheme.muted)),
          ],
        ),
      ),
    );
  }
}
