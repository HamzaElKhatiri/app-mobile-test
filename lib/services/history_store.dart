import 'package:shared_preferences/shared_preferences.dart';

import '../models/calculation_result.dart';

class HistoryStore {
  static const String _key = 'calc_noir_history';

  Future<List<CalculationResult>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_key) ?? <String>[];
    return raw.map(CalculationResult.fromJson).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> add(CalculationResult item) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getStringList(_key) ?? <String>[];
    final next = [item.toJson(), ...current].take(80).toList();
    await prefs.setStringList(_key, next);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
