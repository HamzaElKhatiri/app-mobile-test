import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/calculation_result.dart';
import '../theme/app_theme.dart';
import 'glass_card.dart';

class ResultTile extends StatelessWidget {
  const ResultTile({super.key, required this.item, this.onTap});

  final CalculationResult item;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('dd/MM • HH:mm');
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        borderRadius: 24,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppTheme.red.withOpacity(0.14),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.functions_rounded, color: AppTheme.red),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.expression,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatter.format(item.createdAt),
                    style: const TextStyle(color: AppTheme.muted, fontSize: 12),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Flexible(
              child: Text(
                item.result,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppTheme.neon),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
