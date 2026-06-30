import 'dart:math' as math;

class CalculatorEngine {
  static const Set<String> _operators = {'+', '-', '*', '/', '%', '^'};
  static const Map<String, int> _precedence = {
    '+': 1,
    '-': 1,
    '*': 2,
    '/': 2,
    '%': 2,
    '^': 3,
  };

  static String formatInput(String value) {
    return value
        .replaceAll('×', '*')
        .replaceAll('÷', '/')
        .replaceAll('−', '-')
        .replaceAll(',', '.')
        .replaceAll('π', 'pi')
        .replaceAll('√', 'sqrt');
  }

  static String evaluateToString(String expression) {
    final value = evaluate(expression);
    if (value.isNaN || value.isInfinite) {
      throw const FormatException('Résultat non défini');
    }
    if ((value - value.roundToDouble()).abs() < 0.0000000001) {
      return value.round().toString();
    }
    return value.toStringAsPrecision(12).replaceFirst(RegExp(r'\.?0+$'), '');
  }

  static double evaluate(String expression) {
    final tokens = _tokenize(formatInput(expression));
    if (tokens.isEmpty) throw const FormatException('Expression vide');
    final rpn = _toRpn(tokens);
    return _evalRpn(rpn);
  }

  static List<String> _tokenize(String input) {
    final compact = input.replaceAll(RegExp(r'\s+'), '').toLowerCase();
    final tokens = <String>[];
    var i = 0;
    while (i < compact.length) {
      final char = compact[i];
      final isUnaryMinus = char == '-' && (tokens.isEmpty || _operators.contains(tokens.last) || tokens.last == '(');
      if (RegExp(r'[0-9.]').hasMatch(char) || isUnaryMinus) {
        final buffer = StringBuffer();
        if (isUnaryMinus) {
          buffer.write('-');
          i++;
        }
        var dotCount = 0;
        while (i < compact.length && RegExp(r'[0-9.]').hasMatch(compact[i])) {
          if (compact[i] == '.') dotCount++;
          if (dotCount > 1) throw const FormatException('Nombre invalide');
          buffer.write(compact[i]);
          i++;
        }
        final number = buffer.toString();
        if (number == '-') {
          tokens.add('0');
          tokens.add('-');
        } else {
          tokens.add(number);
        }
        continue;
      }
      if (RegExp(r'[a-z]').hasMatch(char)) {
        final buffer = StringBuffer();
        while (i < compact.length && RegExp(r'[a-z]').hasMatch(compact[i])) {
          buffer.write(compact[i]);
          i++;
        }
        tokens.add(buffer.toString());
        continue;
      }
      if (_operators.contains(char) || char == '(' || char == ')') {
        tokens.add(char);
        i++;
        continue;
      }
      throw FormatException('Caractère non reconnu: $char');
    }
    return tokens;
  }

  static List<String> _toRpn(List<String> tokens) {
    final output = <String>[];
    final stack = <String>[];
    for (final token in tokens) {
      if (double.tryParse(token) != null || token == 'pi' || token == 'e') {
        output.add(token);
      } else if (_isFunction(token)) {
        stack.add(token);
      } else if (_operators.contains(token)) {
        while (stack.isNotEmpty && _operators.contains(stack.last)) {
          final top = stack.last;
          final shouldPop = token == '^' ? _precedence[token]! < _precedence[top]! : _precedence[token]! <= _precedence[top]!;
          if (!shouldPop) break;
          output.add(stack.removeLast());
        }
        stack.add(token);
      } else if (token == '(') {
        stack.add(token);
      } else if (token == ')') {
        while (stack.isNotEmpty && stack.last != '(') {
          output.add(stack.removeLast());
        }
        if (stack.isEmpty) throw const FormatException('Parenthèses invalides');
        stack.removeLast();
        if (stack.isNotEmpty && _isFunction(stack.last)) output.add(stack.removeLast());
      } else {
        throw FormatException('Token invalide: $token');
      }
    }
    while (stack.isNotEmpty) {
      final token = stack.removeLast();
      if (token == '(' || token == ')') throw const FormatException('Parenthèses invalides');
      output.add(token);
    }
    return output;
  }

  static double _evalRpn(List<String> rpn) {
    final stack = <double>[];
    for (final token in rpn) {
      final number = double.tryParse(token);
      if (number != null) {
        stack.add(number);
      } else if (token == 'pi') {
        stack.add(math.pi);
      } else if (token == 'e') {
        stack.add(math.e);
      } else if (_operators.contains(token)) {
        if (stack.length < 2) throw const FormatException('Expression incomplète');
        final b = stack.removeLast();
        final a = stack.removeLast();
        switch (token) {
          case '+':
            stack.add(a + b);
          case '-':
            stack.add(a - b);
          case '*':
            stack.add(a * b);
          case '/':
            if (b == 0) throw const FormatException('Division par zéro');
            stack.add(a / b);
          case '%':
            if (b == 0) throw const FormatException('Modulo par zéro');
            stack.add(a % b);
          case '^':
            stack.add(math.pow(a, b).toDouble());
        }
      } else if (_isFunction(token)) {
        if (stack.isEmpty) throw const FormatException('Fonction incomplète');
        final x = stack.removeLast();
        switch (token) {
          case 'sqrt':
            if (x < 0) throw const FormatException('Racine négative');
            stack.add(math.sqrt(x));
          case 'sin':
            stack.add(math.sin(x));
          case 'cos':
            stack.add(math.cos(x));
          case 'tan':
            stack.add(math.tan(x));
          case 'ln':
            if (x <= 0) throw const FormatException('Logarithme invalide');
            stack.add(math.log(x));
          case 'log':
            if (x <= 0) throw const FormatException('Logarithme invalide');
            stack.add(math.log(x) / math.ln10);
        }
      }
    }
    if (stack.length != 1) throw const FormatException('Expression invalide');
    return stack.single;
  }

  static bool _isFunction(String token) => {'sqrt', 'sin', 'cos', 'tan', 'ln', 'log'}.contains(token);
}
