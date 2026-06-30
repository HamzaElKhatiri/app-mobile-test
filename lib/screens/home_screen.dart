import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/calculation_result.dart';
import '../services/calculator_engine.dart';
import '../services/history_store.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/glass_card.dart';
import '../widgets/keypad_button.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HistoryStore _store = HistoryStore();
  String _expression = '';
  String _result = '0';
  String? _error;
  bool _saving = false;

  void _append(String value) {
    setState(() {
      _error = null;
      _expression += value;
    });
    _preview();
  }

  void _clear() {
    setState(() {
      _expression = '';
      _result = '0';
      _error = null;
    });
  }

  void _backspace() {
    if (_expression.isEmpty) return;
    setState(() {
      _expression = _expression.substring(0, _expression.length - 1);
      _error = null;
    });
    _preview();
  }

  void _preview() {
    if (_expression.trim().isEmpty) {
      setState(() => _result = '0');
      return;
    }
    try {
      final next = CalculatorEngine.evaluateToString(_expression);
      setState(() => _result = next);
    } catch (_) {}
  }

  Future<void> _calculate() async {
    if (_expression.trim().isEmpty || _saving) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      final value = CalculatorEngine.evaluateToString(_expression);
      await _store.add(CalculationResult(expression: _expression, result: value, createdAt: DateTime.now()));
      if (!mounted) return;
      setState(() {
        _result = value;
        _expression = value;
      });
    } on FormatException catch (error) {
      if (!mounted) return;
      setState(() => _error = error.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = 'Calcul impossible');
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 900;
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
        child: SingleChildScrollView(
          padding: Responsive.pagePadding(context),
          child: isWide
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(child: _HeroPanel(result: _result)),
                    const SizedBox(width: 22),
                    Expanded(child: _calculatorPanel()),
                  ],
                )
              : Column(
                  children: [
                    _HeroPanel(result: _result),
                    const SizedBox(height: 16),
                    _calculatorPanel(),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _calculatorPanel() {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.38),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: Colors.white.withOpacity(0.08)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  _expression.isEmpty ? 'Tape ton calcul' : _expression,
                  textAlign: TextAlign.right,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppTheme.muted, fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 10),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  child: Text(
                    _error ?? _result,
                    key: ValueKey(_error ?? _result),
                    textAlign: TextAlign.right,
                    style: GoogleFonts.poppins(
                      color: _error == null ? AppTheme.white : Theme.of(context).colorScheme.error,
                      fontSize: _error == null ? 42 : 18,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _row([
            _key('AC', _clear, KeypadButtonType.action),
            _key('⌫', _backspace, KeypadButtonType.action),
            _key('%', () => _append('%'), KeypadButtonType.action),
            _key('÷', () => _append('÷'), KeypadButtonType.operator),
          ]),
          _row([
            _key('sin', () => _append('sin('), KeypadButtonType.action),
            _key('cos', () => _append('cos('), KeypadButtonType.action),
            _key('√', () => _append('√('), KeypadButtonType.action),
            _key('×', () => _append('×'), KeypadButtonType.operator),
          ]),
          _row([
            _key('7', () => _append('7')),
            _key('8', () => _append('8')),
            _key('9', () => _append('9')),
            _key('−', () => _append('−'), KeypadButtonType.operator),
          ]),
          _row([
            _key('4', () => _append('4')),
            _key('5', () => _append('5')),
            _key('6', () => _append('6')),
            _key('+', () => _append('+'), KeypadButtonType.operator),
          ]),
          _row([
            _key('1', () => _append('1')),
            _key('2', () => _append('2')),
            _key('3', () => _append('3')),
            _key('^', () => _append('^'), KeypadButtonType.operator),
          ]),
          _row([
            _key('0', () => _append('0'), KeypadButtonType.number, 2),
            _key('.', () => _append('.')),
            _key(_saving ? '...' : '=', _calculate, KeypadButtonType.premium),
          ]),
          _row([
            _key('(', () => _append('('), KeypadButtonType.action),
            _key(')', () => _append(')'), KeypadButtonType.action),
            _key('π', () => _append('π'), KeypadButtonType.action),
            _key('log', () => _append('log('), KeypadButtonType.action),
          ]),
        ],
      ),
    );
  }

  Widget _row(List<Widget> children) => Row(children: children);

  Widget _key(String label, VoidCallback onTap, [KeypadButtonType type = KeypadButtonType.number, int flex = 1]) {
    return KeypadButton(label: label, onPressed: onTap, type: type, flex: flex);
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.result});

  final String result;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: AppTheme.red, borderRadius: BorderRadius.circular(999)),
                child: const Text('CALC NOIR', style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2)),
              ),
              const Spacer(),
              const Icon(Icons.auto_awesome_rounded, color: AppTheme.neon),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Des calculs nets. Un résultat instantané.',
            style: GoogleFonts.poppins(fontSize: 34, height: 1.02, fontWeight: FontWeight.w900, letterSpacing: -1.4),
          ),
          const SizedBox(height: 14),
          const Text(
            'Une calculatrice responsive au style noir premium, pensée pour mobile, tablette et web.',
            style: TextStyle(color: AppTheme.muted, height: 1.55, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 22),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.34),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: AppTheme.neon.withOpacity(0.22)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Résultat live', style: TextStyle(color: AppTheme.muted, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                Text(
                  result,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.poppins(fontSize: 44, fontWeight: FontWeight.w900, color: AppTheme.neon, letterSpacing: -1.8),
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: const [
              _HeroTag(label: 'Local'),
              _HeroTag(label: 'Scientifique'),
              _HeroTag(label: 'Historique'),
              _HeroTag(label: 'Flutter Web'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroTag extends StatelessWidget {
  const _HeroTag({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withOpacity(0.08)),
      ),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
    );
  }
}
