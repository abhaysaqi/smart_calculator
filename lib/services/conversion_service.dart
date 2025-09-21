// lib/services/conversion_service.dart
class ConversionService {
  // Currency conversion rates (relative to USD)
  final Map<String, double> _currencyRates = {
    'USD': 1.0,
    'EUR': 0.85,
    'GBP': 0.73,
    'JPY': 110.0,
    'INR': 74.5,
  };

  // Length conversion (to meters)
  final Map<String, double> _lengthRates = {
    'm': 1.0,
    'km': 1000.0,
    'cm': 0.01,
    'in': 0.0254,
    'ft': 0.3048,
    'yd': 0.9144,
    'mi': 1609.34,
  };

  // Weight conversion (to grams)
  final Map<String, double> _weightRates = {
    'g': 1.0,
    'kg': 1000.0,
    'lb': 453.592,
    'oz': 28.3495,
    'ton': 1000000.0,
    'stone': 6350.29,
  };

  double convertCurrency(double value, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return value;
    
    double usdValue = value / (_currencyRates[fromUnit] ?? 1.0);
    return usdValue * (_currencyRates[toUnit] ?? 1.0);
  }

  double convertTemperature(double value, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return value;
    
    // Convert to Celsius first
    double celsius = value;
    switch (fromUnit) {
      case '°F':
        celsius = (value - 32) * 5 / 9;
        break;
      case 'K':
        celsius = value - 273.15;
        break;
    }
    
    // Convert from Celsius to target
    switch (toUnit) {
      case '°F':
        return celsius * 9 / 5 + 32;
      case 'K':
        return celsius + 273.15;
      default:
        return celsius;
    }
  }

  double convertLength(double value, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return value;
    
    double meters = value * (_lengthRates[fromUnit] ?? 1.0);
    return meters / (_lengthRates[toUnit] ?? 1.0);
  }

  double convertWeight(double value, String fromUnit, String toUnit) {
    if (fromUnit == toUnit) return value;
    
    double grams = value * (_weightRates[fromUnit] ?? 1.0);
    return grams / (_weightRates[toUnit] ?? 1.0);
  }
}
