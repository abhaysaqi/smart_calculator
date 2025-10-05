// lib/services/calculation_service.dart
class CalculationService {
  double calculate(double a, String operator, double b) {
    switch (operator) {
      case '+':
        return a + b;
      case '-':
      case '−':
        return a - b;
      case '*':
      case '×':
        return a * b;
      case '/':
      case '÷':
        if (b != 0) return a / b;
        throw ArgumentError('Division by zero');
      case '%':
        return (a / b) * 100;
      default:
        throw ArgumentError('Unknown operator: $operator');
    }
  }

  String formatResult(double result) {
    if (result == result.toInt()) {
      return result.toInt().toString();
    } else {
      return result
          .toStringAsFixed(8)
          .replaceAll(RegExp(r'0*$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }
  }
}
