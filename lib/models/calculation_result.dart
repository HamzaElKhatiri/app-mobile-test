import 'dart:convert';

class CalculationResult {
  const CalculationResult({
    required this.expression,
    required this.result,
    required this.createdAt,
  });

  final String expression;
  final String result;
  final DateTime createdAt;

  Map<String, dynamic> toMap() {
    return {
      'expression': expression,
      'result': result,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CalculationResult.fromMap(Map<String, dynamic> map) {
    return CalculationResult(
      expression: map['expression'] as String,
      result: map['result'] as String,
      createdAt: DateTime.parse(map['createdAt'] as String),
    );
  }

  String toJson() => jsonEncode(toMap());

  factory CalculationResult.fromJson(String source) {
    return CalculationResult.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }
}
