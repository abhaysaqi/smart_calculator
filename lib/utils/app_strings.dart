// lib/constants/app_strings.dart
class AppStrings {
  // App text
  static const String calculator = 'Calculator';
  static const String history = 'History';
  static const String converter = 'Converter';
  static const String graph = 'Graph';

  // Calculator display
  static const String sampleCalculation = '1,234 + 5,678';
  static const String sampleResult = '6,912';

  // Button labels
  static const String clear = 'C';
  static const String plusMinus = '±';
  static const String percent = '%';
  static const String divide = '÷';
  static const String multiply = '×';
  static const String subtract = '-';
  static const String add = '+';
  static const String equals = '=';
  static const String decimal = '.';
  static const String remove = '⌫';

  // Numbers
  static const String zero = '0';
  static const String one = '1';
  static const String two = '2';
  static const String three = '3';
  static const String four = '4';
  static const String five = '5';
  static const String six = '6';
  static const String seven = '7';
  static const String eight = '8';
  static const String nine = '9';

  // Converter Section Titles
  static const String currencySection = '💰 Currency';
  static const String temperatureSection = '🌡️ Temperature';
  static const String lengthSection = '📏 Length';
  static const String weightSection = '⚖️ Weight';

  // Currency Units
  static const String usd = 'USD';
  static const String eur = 'EUR';
  static const String gbp = 'GBP';
  static const String jpy = 'JPY';
  static const String inr = 'INR';

  // Temperature Units
  static const String celsius = '°C';
  static const String fahrenheit = '°F';
  static const String kelvin = 'K';

  // Length Units
  static const String kilometer = 'km';
  static const String meter = 'm';
  static const String centimeter = 'cm';
  static const String inch = 'in';
  static const String foot = 'ft';
  static const String yard = 'yd';
  static const String mile = 'mi';

  // Weight Units
  static const String kilogram = 'kg';
  static const String gram = 'g';
  static const String pound = 'lb';
  static const String ounce = 'oz';
  static const String ton = 'ton';
  static const String stone = 'stone';

  // Common Words
  static const String to = 'to';
  static const String all = 'All';
  static const String cancel = 'Cancel';
  static const String delete = 'Delete';

  // History Screen
  static const String searchCalculations = 'Search calculations...';
  static const String noCalculationsFound = 'No calculations found';
  static const String calculations = 'calculations';
  static const String clearAll = 'Clear All';
  static const String deleteCalculation = 'Delete Calculation';
  static const String clearAllHistory = 'Clear All History';
  static const String clearAllHistoryMessage =
      'This will permanently delete all calculations.';
  static const String historyCleared = 'History cleared';
  static const String copyResult = 'Copy Result';
  static const String resultCopied = 'Result copied';
  static const String calculationDeleted = 'Calculation deleted';

  // Time Formats
  static const String justNow = 'Just now';
  static const String minutesAgo = 'm ago';
  static const String hoursAgo = 'h ago';
  static const String daysAgo = 'd ago';

  // Calculator Voice Input
  static const String listening = 'Listening...';
  static const String enterCalculation = 'Enter calculation...';
  static const String enterCalculationOrSpeak = 'Enter calculation or speak...';
  static const String listeningForSpeech = 'Listening for speech...';
  static const String speechRecognitionNotAvailable =
      'Speech recognition not available';
  static const String microphonePermissionRequired =
      'Microphone permission required';
  static const String speechRecognitionNotEnabled =
      'Speech recognition not enabled';
  static const String speechRecognitionUnavailable =
      'Speech recognition temporarily unavailable';
  static const String voiceInputCompleted = 'Voice input completed (timeout)';
  static const String calculatorClearedByVoice = 'Calculator cleared by voice';
  static const String voiceCommands = '🎤 Voice Commands';
  static const String voiceHelpTip =
      'Tip: Long press voice button to see this help';

  // Categories
  static const String currency = 'Currency';
  static const String temperature = 'Temperature';
  static const String length = 'Length';
  static const String weight = 'Weight';

  // Error Messages
  static const String failedToLoadHistory = 'Failed to load history';
  static const String speechError = 'Speech error: ';
}
