import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';

class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;
  SpeechService._internal();

  late stt.SpeechToText _speechToText;
  bool _isInitialized = false;
  bool _isListening = false;

  bool get isInitialized => _isInitialized;
  bool get isListening => _isListening;

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    _speechToText = stt.SpeechToText();
    _isInitialized = await _speechToText.initialize(
      onStatus: (status) => print('Speech status: $status'),
      onError: (error) => print('Speech error: $error'),
    );

    return _isInitialized;
  }

  Future<void> startListening({
    required Function(String) onResult,
    required Function(String) onError,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_isInitialized && !_isListening) {
      _isListening = true;
      await _speechToText.listen(
        onResult: (result) {
          onResult(_processVoiceInput(result.recognizedWords));
        },
        listenFor: const Duration(seconds: 10),
        pauseFor: const Duration(seconds: 3),
        partialResults: true,
        localeId: 'en_US',
        listenMode: stt.ListenMode.confirmation,
      );
    }
  }

  Future<void> stopListening() async {
    if (_isListening) {
      _isListening = false;
      await _speechToText.stop();
    }
  }

  Future<void> cancelListening() async {
    if (_isListening) {
      _isListening = false;
      await _speechToText.cancel();
    }
  }

  // Convert voice input to mathematical expression
  String _processVoiceInput(String voiceText) {
    String processed = voiceText.toLowerCase().trim();

    // Replace number words with digits
    processed = _replaceNumberWords(processed);

    // Replace operator words with symbols
    processed = _replaceOperatorWords(processed);

    // Clean up the expression
    processed = _cleanExpression(processed);

    return processed;
  }

  String _replaceNumberWords(String text) {
    final numberMap = {
      'zero': '0',
      'one': '1',
      'two': '2',
      'three': '3',
      'four': '4',
      'five': '5',
      'six': '6',
      'seven': '7',
      'eight': '8',
      'nine': '9',
      'ten': '10',
      'eleven': '11',
      'twelve': '12',
      'thirteen': '13',
      'fourteen': '14',
      'fifteen': '15',
      'sixteen': '16',
      'seventeen': '17',
      'eighteen': '18',
      'nineteen': '19',
      'twenty': '20',
      'thirty': '30',
      'forty': '40',
      'fifty': '50',
      'sixty': '60',
      'seventy': '70',
      'eighty': '80',
      'ninety': '90',
      'hundred': '100',
      'thousand': '1000',
    };

    String result = text;
    numberMap.forEach((word, digit) {
      result = result.replaceAll(RegExp('\\b$word\\b'), digit);
    });

    return result;
  }

  String _replaceOperatorWords(String text) {
    final operatorMap = {
      // Addition
      'plus': '+', 'add': '+', 'added to': '+', 'sum': '+', 'total': '+',

      // Subtraction
      'minus': '−', 'subtract': '−', 'take away': '−', 'less': '−',
      'difference': '−', 'subtract from': '−',

      // Multiplication
      'times': '×', 'multiply': '×', 'multiplied by': '×', 'into': '×',
      'product': '×', 'of': '×',

      // Division
      'divide': '÷', 'divided by': '÷', 'over': '÷', 'quotient': '÷',

      // Others
      'percent': '%', 'percentage': '%',
      'point': '.', 'decimal': '.',
      'equals': '=', 'equal': '=', 'is': '=', 'result': '=',
    };

    String result = text;
    operatorMap.forEach((word, symbol) {
      result = result.replaceAll(RegExp('\\b$word\\b'), symbol);
    });

    return result;
  }

  String _cleanExpression(String text) {
    // Remove common filler words
    final fillerWords = ['the', 'a', 'an', 'and', 'to', 'by', 'from', 'with'];
    String result = text;

    for (String word in fillerWords) {
      result = result.replaceAll(RegExp('\\b$word\\b'), '');
    }

    // Clean up spaces
    result = result.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Remove spaces around operators
    result = result.replaceAll(RegExp(r'\s*([+\-×÷%=.])\s*'), r'$1');

    // Handle special cases like "twenty five" -> "25"
    result = _handleCompoundNumbers(result);

    return result;
  }

  String _handleCompoundNumbers(String text) {
    // Handle compound numbers like "twenty five" -> "25"
    final patterns = {
      RegExp(r'20\s*1'): '21',
      RegExp(r'20\s*2'): '22',
      RegExp(r'20\s*3'): '23',
      RegExp(r'20\s*4'): '24',
      RegExp(r'20\s*5'): '25',
      RegExp(r'20\s*6'): '26',
      RegExp(r'20\s*7'): '27',
      RegExp(r'20\s*8'): '28',
      RegExp(r'20\s*9'): '29',
      RegExp(r'30\s*1'): '31',
      RegExp(r'30\s*2'): '32',
      RegExp(r'30\s*3'): '33',
      RegExp(r'30\s*4'): '34',
      RegExp(r'30\s*5'): '35',
      RegExp(r'30\s*6'): '36',
      RegExp(r'30\s*7'): '37',
      RegExp(r'30\s*8'): '38',
      RegExp(r'30\s*9'): '39',
      // Add more patterns as needed
    };

    String result = text;
    patterns.forEach((pattern, replacement) {
      result = result.replaceAll(pattern, replacement);
    });

    return result;
  }

  List<String> getExampleCommands() {
    return [
      "Five plus three",
      "Ten minus two",
      "Six times seven",
      "Twenty divided by four",
      "Fifty percent of hundred",
      "Two point five plus one point five",
    ];
  }
}
