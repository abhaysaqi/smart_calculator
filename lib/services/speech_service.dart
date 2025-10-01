// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import 'package:speech_to_text/speech_recognition_result.dart';

// class SpeechService {
//   static final SpeechService _instance = SpeechService._internal();
//   factory SpeechService() => _instance;
//   SpeechService._internal();

//   late stt.SpeechToText _speechToText;
//   bool _isInitialized = false;
//   bool _isListening = false;

//   bool get isInitialized => _isInitialized;
//   bool get isListening => _isListening;

//   Future<bool> initialize() async {
//     if (_isInitialized) return true;

//     _speechToText = stt.SpeechToText();
//     _isInitialized = await _speechToText.initialize(
//       onStatus: (status) => print('Speech status: $status'),
//       onError: (error) => print('Speech error: $error'),
//     );

//     return _isInitialized;
//   }

//   Future<void> startListening({
//     required Function(String) onResult,
//     required Function(String) onError,
//   }) async {
//     if (!_isInitialized) {
//       await initialize();
//     }

//     if (_isInitialized && !_isListening) {
//       _isListening = true;
//       await _speechToText.listen(
//         onResult: (result) {
//           onResult(_processVoiceInput(result.recognizedWords));
//         },
//         listenFor: const Duration(seconds: 10),
//         pauseFor: const Duration(seconds: 3),
//         partialResults: true,
//         localeId: 'en_US',
//         listenMode: stt.ListenMode.confirmation,
//       );
//     }
//   }

//   Future<void> stopListening() async {
//     if (_isListening) {
//       _isListening = false;
//       await _speechToText.stop();
//     }
//   }

//   Future<void> cancelListening() async {
//     if (_isListening) {
//       _isListening = false;
//       await _speechToText.cancel();
//     }
//   }

//   // Convert voice input to mathematical expression
//   String _processVoiceInput(String voiceText) {
//     String processed = voiceText.toLowerCase().trim();

//     // Replace number words with digits
//     processed = _replaceNumberWords(processed);

//     // Replace operator words with symbols
//     processed = _replaceOperatorWords(processed);

//     // Clean up the expression
//     processed = _cleanExpression(processed);

//     return processed;
//   }

//   String _replaceNumberWords(String text) {
//     final numberMap = {
//       'zero': '0',
//       'one': '1',
//       'two': '2',
//       'three': '3',
//       'four': '4',
//       'five': '5',
//       'six': '6',
//       'seven': '7',
//       'eight': '8',
//       'nine': '9',
//       'ten': '10',
//       'eleven': '11',
//       'twelve': '12',
//       'thirteen': '13',
//       'fourteen': '14',
//       'fifteen': '15',
//       'sixteen': '16',
//       'seventeen': '17',
//       'eighteen': '18',
//       'nineteen': '19',
//       'twenty': '20',
//       'thirty': '30',
//       'forty': '40',
//       'fifty': '50',
//       'sixty': '60',
//       'seventy': '70',
//       'eighty': '80',
//       'ninety': '90',
//       'hundred': '100',
//       'thousand': '1000',
//     };

//     String result = text;
//     numberMap.forEach((word, digit) {
//       result = result.replaceAll(RegExp('\\b$word\\b'), digit);
//     });

//     return result;
//   }

//   String _replaceOperatorWords(String text) {
//     final operatorMap = {
//       // Addition
//       'plus': '+', 'add': '+', 'added to': '+', 'sum': '+', 'total': '+',

//       // Subtraction
//       'minus': '−', 'subtract': '−', 'take away': '−', 'less': '−',
//       'difference': '−', 'subtract from': '−',

//       // Multiplication
//       'times': '×', 'multiply': '×', 'multiplied by': '×', 'into': '×',
//       'product': '×', 'of': '×',

//       // Division
//       'divide': '÷', 'divided by': '÷', 'over': '÷', 'quotient': '÷',

//       // Others
//       'percent': '%', 'percentage': '%',
//       'point': '.', 'decimal': '.',
//       'equals': '=', 'equal': '=', 'is': '=', 'result': '=',
//     };

//     String result = text;
//     operatorMap.forEach((word, symbol) {
//       result = result.replaceAll(RegExp('\\b$word\\b'), symbol);
//     });

//     return result;
//   }

//   String _cleanExpression(String text) {
//     // Remove common filler words
//     final fillerWords = ['the', 'a', 'an', 'and', 'to', 'by', 'from', 'with'];
//     String result = text;

//     for (String word in fillerWords) {
//       result = result.replaceAll(RegExp('\\b$word\\b'), '');
//     }

//     // Clean up spaces
//     result = result.replaceAll(RegExp(r'\s+'), ' ').trim();

//     // Remove spaces around operators
//     result = result.replaceAll(RegExp(r'\s*([+\-×÷%=.])\s*'), r'$1');

//     // Handle special cases like "twenty five" -> "25"
//     result = _handleCompoundNumbers(result);

//     return result;
//   }

//   String _handleCompoundNumbers(String text) {
//     // Handle compound numbers like "twenty five" -> "25"
//     final patterns = {
//       RegExp(r'20\s*1'): '21',
//       RegExp(r'20\s*2'): '22',
//       RegExp(r'20\s*3'): '23',
//       RegExp(r'20\s*4'): '24',
//       RegExp(r'20\s*5'): '25',
//       RegExp(r'20\s*6'): '26',
//       RegExp(r'20\s*7'): '27',
//       RegExp(r'20\s*8'): '28',
//       RegExp(r'20\s*9'): '29',
//       RegExp(r'30\s*1'): '31',
//       RegExp(r'30\s*2'): '32',
//       RegExp(r'30\s*3'): '33',
//       RegExp(r'30\s*4'): '34',
//       RegExp(r'30\s*5'): '35',
//       RegExp(r'30\s*6'): '36',
//       RegExp(r'30\s*7'): '37',
//       RegExp(r'30\s*8'): '38',
//       RegExp(r'30\s*9'): '39',
//       // Add more patterns as needed
//     };

//     String result = text;
//     patterns.forEach((pattern, replacement) {
//       result = result.replaceAll(pattern, replacement);
//     });

//     return result;
//   }

//   List<String> getExampleCommands() {
//     return [
//       "Five plus three",
//       "Ten minus two",
//       "Six times seven",
//       "Twenty divided by four",
//       "Fifty percent of hundred",
//       "Two point five plus one point five",
//     ];
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;

// class SpeechService {
//   static final SpeechService _instance = SpeechService._internal();
//   factory SpeechService() => _instance;
//   SpeechService._internal();

//   late stt.SpeechToText _speechToText;
//   bool _isInitialized = false;
//   bool _isListening = false;
//   Timer? _silenceTimer;
//   Timer? _autoTimeoutTimer;

//   // Configuration
//   static const Duration _silenceTimeout = Duration(seconds: 3);
//   static const Duration _maxListeningDuration = Duration(seconds: 15);

//   bool get isInitialized => _isInitialized;
//   bool get isListening => _isListening;

//   Future<bool> initialize() async {
//     if (_isInitialized) return true;

//     _speechToText = stt.SpeechToText();
//     _isInitialized = await _speechToText.initialize(
//       onStatus: (status) {
//         print('Speech status: $status');
//         if (status == 'done' || status == 'notListening') {
//           _handleSpeechEnd();
//         }
//       },
//       onError: (error) {
//         print('Speech error: $error');
//         _handleSpeechEnd();
//       },
//     );

//     return _isInitialized;
//   }

//   Future<void> startListening({
//     required Function(String, bool) onResult, // Added auto-calculate flag
//     required Function(String) onError,
//     required VoidCallback onTimeout,
//   }) async {
//     if (!_isInitialized) {
//       await initialize();
//     }

//     if (_isInitialized && !_isListening) {
//       _isListening = true;

//       // Start auto-timeout timer
//       _autoTimeoutTimer = Timer(_maxListeningDuration, () {
//         stopListening();
//         onTimeout();
//       });

//       await _speechToText.listen(
//         onResult: (result) {
//           _resetSilenceTimer();
//           String processedText = _processVoiceInput(result.recognizedWords);
//           bool shouldAutoCalculate = _shouldAutoCalculate(processedText);
//           onResult(processedText, shouldAutoCalculate);

//           // Start silence timer for auto-close
//           _startSilenceTimer(onTimeout);
//         },
//         listenFor: _maxListeningDuration,
//         pauseFor: const Duration(seconds: 2),
//         partialResults: true,
//         localeId: 'en_US',
//         listenMode: stt.ListenMode.confirmation,
//       );
//     }
//   }

//   void _startSilenceTimer(VoidCallback onTimeout) {
//     _silenceTimer?.cancel();
//     _silenceTimer = Timer(_silenceTimeout, () {
//       if (_isListening) {
//         stopListening();
//         onTimeout();
//       }
//     });
//   }

//   void _resetSilenceTimer() {
//     _silenceTimer?.cancel();
//   }

//   void _handleSpeechEnd() {
//     _isListening = false;
//     _silenceTimer?.cancel();
//     _autoTimeoutTimer?.cancel();
//   }

//   Future<void> stopListening() async {
//     if (_isListening) {
//       _isListening = false;
//       _silenceTimer?.cancel();
//       _autoTimeoutTimer?.cancel();
//       await _speechToText.stop();
//     }
//   }

//   Future<void> cancelListening() async {
//     if (_isListening) {
//       _isListening = false;
//       _silenceTimer?.cancel();
//       _autoTimeoutTimer?.cancel();
//       await _speechToText.cancel();
//     }
//   }

//   // Enhanced: Check if expression is complete for auto-calculation
//   bool _shouldAutoCalculate(String expression) {
//     if (expression.isEmpty) return false;

//     // Remove spaces for analysis
//     String clean = expression.replaceAll(' ', '');

//     // Check if it has a complete mathematical structure (number + operator + number)
//     RegExp completeExpression = RegExp(
//       r'^\d+(\.\d+)?\s*[+\-×÷%]\s*\d+(\.\d+)?$',
//     );
//     if (completeExpression.hasMatch(clean)) {
//       return true;
//     }

//     // Check for more complex expressions
//     RegExp multiOperation = RegExp(
//       r'^\d+(\.\d+)?(\s*[+\-×÷%]\s*\d+(\.\d+)?)+$',
//     );
//     return multiOperation.hasMatch(clean);
//   }

//   // Enhanced: Convert voice input to mathematical expression with comprehensive term recognition
//   String _processVoiceInput(String voiceText) {
//     String processed = voiceText.toLowerCase().trim();

//     // Handle compound numbers first (before individual number words)
//     processed = _handleCompoundNumbers(processed);

//     // Replace number words with digits (enhanced)
//     processed = _replaceNumberWords(processed);

//     // Replace operator words with symbols (comprehensive)
//     processed = _replaceOperatorWords(processed);

//     // Handle mathematical expressions and phrases
//     processed = _handleMathematicalPhrases(processed);

//     // Clean up the expression
//     processed = _cleanExpression(processed);

//     return processed;
//   }

//   String _replaceNumberWords(String text) {
//     final numberMap = {
//       // Basic numbers
//       'zero': '0', 'one': '1', 'two': '2', 'three': '3', 'four': '4',
//       'five': '5', 'six': '6', 'seven': '7', 'eight': '8', 'nine': '9',

//       // Teens
//       'ten': '10', 'eleven': '11', 'twelve': '12', 'thirteen': '13',
//       'fourteen': '14', 'fifteen': '15', 'sixteen': '16', 'seventeen': '17',
//       'eighteen': '18', 'nineteen': '19',

//       // Tens
//       'twenty': '20', 'thirty': '30', 'forty': '40', 'fifty': '50',
//       'sixty': '60', 'seventy': '70', 'eighty': '80', 'ninety': '90',

//       // Large numbers
//       'hundred': '100', 'thousand': '1000', 'million': '1000000',

//       // Decimal variations
//       'point': '.', 'dot': '.',

//       // Common number expressions
//       'half': '0.5', 'quarter': '0.25', 'third': '0.33',
//       'double': '×2', 'triple': '×3',
//     };

//     String result = text;

//     // Replace individual number words
//     numberMap.forEach((word, digit) {
//       result = result.replaceAll(
//         RegExp('\\b$word\\b', caseSensitive: false),
//         digit,
//       );
//     });

//     return result;
//   }

//   String _replaceOperatorWords(String text) {
//     // Create sorted map by length (longest phrases first to avoid partial matches)
//     final operatorMap = {
//       // Addition - Multiple variations (longest phrases first)
//       'added to': '+',
//       'increment': '+',
//       'increase': '+',
//       'additional': '+',
//       'together': '+',
//       'combine': '+',
//       'plus': '+',
//       'add': '+',
//       'sum': '+',
//       'total': '+',
//       'more': '+',
//       'and': '+',
//       'with': '+',

//       // Subtraction - Multiple variations
//       'subtract from': '−',
//       'take away': '−',
//       'reduce by': '−',
//       'difference': '−',
//       'decrease': '−',
//       'without': '−',
//       'deduct': '−',
//       'remove': '−',
//       'minus': '−',
//       'subtract': '−',
//       'less': '−',

//       // Multiplication - Multiple variations
//       'multiplied by': '×',
//       'multiply with': '×',
//       'product': '×',
//       'scale': '×',
//       'magnify': '×',
//       'times': '×',
//       'multiply': '×',
//       'into': '×',
//       'of': '×',
//       'by': '×',
//       'x': '×',

//       // Division - Multiple variations
//       'divided by': '÷',
//       'split by': '÷',
//       'quotient': '÷',
//       'fraction': '÷',
//       'out of': '÷',
//       'divide': '÷',
//       'over': '÷',
//       'per': '÷',
//       'ratio': '÷',
//       'share': '÷',

//       // Percentage
//       'percentage': '%',
//       'per cent': '%',
//       'percent': '%',

//       // Decimal point
//       'decimal': '.',
//       'point': '.',
//       'dot': '.',

//       // Equals (for reference, but we auto-calculate)
//       'equals': '=',
//       'equal': '=',
//       'is': '=',
//       'result': '=',
//       'answer': '=',
//       'makes': '=',
//       'gives': '=',
//     };

//     String result = text;

//     // Sort entries by length (longest first) to prevent partial replacements
//     var sortedEntries = operatorMap.entries.toList()
//       ..sort((a, b) => b.key.length.compareTo(a.key.length));

//     // Apply replacements in order of length (longest phrases first)
//     for (var entry in sortedEntries) {
//       // Use word boundaries to ensure complete word matching
//       String pattern = '\\b${RegExp.escape(entry.key)}\\b';
//       result = result.replaceAll(
//         RegExp(pattern, caseSensitive: false),
//         entry.value,
//       );
//     }

//     return result;
//   }

//   String _handleMathematicalPhrases(String text) {
//     final phraseMap = {
//       // Common mathematical phrases
//       'what is': '',
//       'what\'s': '',
//       'calculate': '',
//       'compute': '',
//       'find': '',
//       'solve': '',
//       'give me': '',
//       'tell me': '',
//       'show me': '',

//       // Question words
//       'how much is': '',
//       'how many': '',
//       'what does': '',
//       'what will': '',
//       'what would': '',

//       // Result phrases (we auto-calculate, so remove these)
//       'equals to': '',
//       'equal to': '',
//       'is equal to': '',
//       'that equals': '',
//       'which is': '',
//       'which equals': '',
//       'the answer is': '',
//       'the result is': '',
//     };

//     String result = text;
//     phraseMap.forEach((phrase, replacement) {
//       result = result.replaceAll(
//         RegExp('\\b${RegExp.escape(phrase)}\\b', caseSensitive: false),
//         replacement,
//       );
//     });

//     return result;
//   }

//   String _cleanExpression(String text) {
//     // Remove common filler words
//     final fillerWords = [
//       'the',
//       'a',
//       'an',
//       'to',
//       'from',
//       'with',
//       'please',
//       'can you',
//     ];
//     String result = text;

//     for (String word in fillerWords) {
//       // Use precise word boundary matching
//       result = result.replaceAll(
//         RegExp('\\b$word\\b', caseSensitive: false),
//         '',
//       );
//     }

//     // Clean up spaces
//     result = result.replaceAll(RegExp(r'\s+'), ' ').trim();

//     // Remove spaces around operators (be more specific)
//     result = result.replaceAll(RegExp(r'\s*([+\-×÷%=.])\s*'), r'$1');

//     return result;
//   }

//   // Fixed compound numbers method
//   String _handleCompoundNumbers(String text) {
//     String result = text;

//     // Handle specific compound number patterns first (before individual number replacement)
//     final compoundMap = {
//       // 20s
//       r'\btwenty\s+one\b': '21',
//       r'\btwenty\s+two\b': '22',
//       r'\btwenty\s+three\b': '23',
//       r'\btwenty\s+four\b': '24',
//       r'\btwenty\s+five\b': '25',
//       r'\btwenty\s+six\b': '26',
//       r'\btwenty\s+seven\b': '27',
//       r'\btwenty\s+eight\b': '28',
//       r'\btwenty\s+nine\b': '29',

//       // 30s
//       r'\bthirty\s+one\b': '31',
//       r'\bthirty\s+two\b': '32',
//       r'\bthirty\s+three\b': '33',
//       r'\bthirty\s+four\b': '34',
//       r'\bthirty\s+five\b': '35',
//       r'\bthirty\s+six\b': '36',
//       r'\bthirty\s+seven\b': '37',
//       r'\bthirty\s+eight\b': '38',
//       r'\bthirty\s+nine\b': '39',

//       // 40s
//       r'\bforty\s+one\b': '41',
//       r'\bforty\s+two\b': '42',
//       r'\bforty\s+three\b': '43',
//       r'\bforty\s+four\b': '44',
//       r'\bforty\s+five\b': '45',
//       r'\bforty\s+six\b': '46',
//       r'\bforty\s+seven\b': '47',
//       r'\bforty\s+eight\b': '48',
//       r'\bforty\s+nine\b': '49',

//       // 50s
//       r'\bfifty\s+one\b': '51',
//       r'\bfifty\s+two\b': '52',
//       r'\bfifty\s+three\b': '53',
//       r'\bfifty\s+four\b': '54',
//       r'\bfifty\s+five\b': '55',
//       r'\bfifty\s+six\b': '56',
//       r'\bfifty\s+seven\b': '57',
//       r'\bfifty\s+eight\b': '58',
//       r'\bfifty\s+nine\b': '59',

//       // 60s
//       r'\bsixty\s+one\b': '61',
//       r'\bsixty\s+two\b': '62',
//       r'\bsixty\s+three\b': '63',
//       r'\bsixty\s+four\b': '64',
//       r'\bsixty\s+five\b': '65',
//       r'\bsixty\s+six\b': '66',
//       r'\bsixty\s+seven\b': '67',
//       r'\bsixty\s+eight\b': '68',
//       r'\bsixty\s+nine\b': '69',

//       // 70s
//       r'\bseventy\s+one\b': '71',
//       r'\bseventy\s+two\b': '72',
//       r'\bseventy\s+three\b': '73',
//       r'\bseventy\s+four\b': '74',
//       r'\bseventy\s+five\b': '75',
//       r'\bseventy\s+six\b': '76',
//       r'\bseventy\s+seven\b': '77',
//       r'\bseventy\s+eight\b': '78',
//       r'\bseventy\s+nine\b': '79',

//       // 80s
//       r'\beighty\s+one\b': '81',
//       r'\beighty\s+two\b': '82',
//       r'\beighty\s+three\b': '83',
//       r'\beighty\s+four\b': '84',
//       r'\beighty\s+five\b': '85',
//       r'\beighty\s+six\b': '86',
//       r'\beighty\s+seven\b': '87',
//       r'\beighty\s+eight\b': '88',
//       r'\beighty\s+nine\b': '89',

//       // 90s
//       r'\bninety\s+one\b': '91',
//       r'\bninety\s+two\b': '92',
//       r'\bninety\s+three\b': '93',
//       r'\bninety\s+four\b': '94',
//       r'\bninety\s+five\b': '95',
//       r'\bninety\s+six\b': '96',
//       r'\bninety\s+seven\b': '97',
//       r'\bninety\s+eight\b': '98',
//       r'\bninety\s+nine\b': '99',

//       // Handle already converted numbers (20 1 -> 21, etc.)
//       r'\b20\s*1\b': '21', r'\b20\s*2\b': '22', r'\b20\s*3\b': '23',
//       r'\b20\s*4\b': '24', r'\b20\s*5\b': '25', r'\b20\s*6\b': '26',
//       r'\b20\s*7\b': '27', r'\b20\s*8\b': '28', r'\b20\s*9\b': '29',

//       r'\b30\s*1\b': '31', r'\b30\s*2\b': '32', r'\b30\s*3\b': '33',
//       r'\b30\s*4\b': '34', r'\b30\s*5\b': '35', r'\b30\s*6\b': '36',
//       r'\b30\s*7\b': '37', r'\b30\s*8\b': '38', r'\b30\s*9\b': '39',

//       r'\b40\s*1\b': '41', r'\b40\s*2\b': '42', r'\b40\s*3\b': '43',
//       r'\b40\s*4\b': '44', r'\b40\s*5\b': '45', r'\b40\s*6\b': '46',
//       r'\b40\s*7\b': '47', r'\b40\s*8\b': '48', r'\b40\s*9\b': '49',

//       r'\b50\s*1\b': '51', r'\b50\s*2\b': '52', r'\b50\s*3\b': '53',
//       r'\b50\s*4\b': '54', r'\b50\s*5\b': '55', r'\b50\s*6\b': '56',
//       r'\b50\s*7\b': '57', r'\b50\s*8\b': '58', r'\b50\s*9\b': '59',

//       r'\b60\s*1\b': '61', r'\b60\s*2\b': '62', r'\b60\s*3\b': '63',
//       r'\b60\s*4\b': '64', r'\b60\s*5\b': '65', r'\b60\s*6\b': '66',
//       r'\b60\s*7\b': '67', r'\b60\s*8\b': '68', r'\b60\s*9\b': '69',

//       r'\b70\s*1\b': '71', r'\b70\s*2\b': '72', r'\b70\s*3\b': '73',
//       r'\b70\s*4\b': '74', r'\b70\s*5\b': '75', r'\b70\s*6\b': '76',
//       r'\b70\s*7\b': '77', r'\b70\s*8\b': '78', r'\b70\s*9\b': '79',

//       r'\b80\s*1\b': '81', r'\b80\s*2\b': '82', r'\b80\s*3\b': '83',
//       r'\b80\s*4\b': '84', r'\b80\s*5\b': '85', r'\b80\s*6\b': '86',
//       r'\b80\s*7\b': '87', r'\b80\s*8\b': '88', r'\b80\s*9\b': '89',

//       r'\b90\s*1\b': '91', r'\b90\s*2\b': '92', r'\b90\s*3\b': '93',
//       r'\b90\s*4\b': '94', r'\b90\s*5\b': '95', r'\b90\s*6\b': '96',
//       r'\b90\s*7\b': '97', r'\b90\s*8\b': '98', r'\b90\s*9\b': '99',
//     };

//     compoundMap.forEach((pattern, replacement) {
//       result = result.replaceAll(
//         RegExp(pattern, caseSensitive: false),
//         replacement,
//       );
//     });

//     return result;
//   }

//   List<String> getExampleCommands() {
//     return [
//       // Basic operations
//       "Five plus three",
//       "Twenty minus eight",
//       "Six times seven",
//       "Fifteen divided by three",

//       // Alternative phrasings
//       "What is ten add four",
//       "Calculate fifty increment by five",
//       "Seven multiply with eight",
//       "Thirty split by six",

//       // More natural language
//       "What's two and three",
//       "How much is fifty less twenty",
//       "Give me forty times two",
//       "Twenty five over five",

//       // Decimal operations
//       "Two point five plus one point five",
//       "Half plus quarter",
//       "Three point seven minus one point two",

//       // Percentage
//       "Twenty percent of hundred",
//       "Fifty per cent of two hundred",
//     ];
//   }

//   void dispose() {
//     _silenceTimer?.cancel();
//     _autoTimeoutTimer?.cancel();
//   }
// }

import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:permission_handler/permission_handler.dart';

class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;
  SpeechService._internal();

  late stt.SpeechToText _speechToText;
  bool _isInitialized = false;
  bool _isListening = false;
  bool _speechAvailable = false;
  Timer? _silenceTimer;
  Timer? _autoTimeoutTimer;

  static const Duration _silenceTimeout = Duration(seconds: 3);
  static const Duration _maxListeningDuration = Duration(seconds: 15);

  bool get isInitialized => _isInitialized;
  bool get isListening => _isListening;
  bool get speechAvailable => _speechAvailable;

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    try {
      print('🎤 Initializing Speech Service...');

      // Check and request permissions first
      bool hasPermission = await _checkAndRequestPermissions();
      if (!hasPermission) {
        print('❌ Microphone permission denied');
        return false;
      }

      _speechToText = stt.SpeechToText();

      // Check if speech recognition is available
      _speechAvailable = await _speechToText.initialize(
        onStatus: (status) {
          print('🔊 Speech status: $status');
          if (status == 'done' || status == 'notListening') {
            _handleSpeechEnd();
          }
        },
        onError: (error) {
          print('❌ Speech error: ${error.errorMsg} ($error)');
          _handleSpeechEnd();
        },
      );

      if (_speechAvailable) {
        print('✅ Speech recognition initialized successfully');
        _isInitialized = true;

        // Print available locales for debugging
        var locales = await _speechToText.locales();
        print(
          '📍 Available locales: ${locales.map((l) => l.localeId).toList()}',
        );
      } else {
        print('❌ Speech recognition not available on this device');
      }

      return _speechAvailable;
    } catch (e) {
      print('💥 Speech initialization error: $e');
      return false;
    }
  }

  Future<bool> _checkAndRequestPermissions() async {
    try {
      // Check current permission status
      PermissionStatus status = await Permission.microphone.status;
      print('🎙️ Current microphone permission: $status');

      if (status.isDenied) {
        // Request permission
        status = await Permission.microphone.request();
        print('🎙️ Requested microphone permission: $status');
      }

      if (status.isPermanentlyDenied) {
        print('⚠️ Microphone permission permanently denied - opening settings');
        await openAppSettings();
        return false;
      }

      return status.isGranted;
    } catch (e) {
      print('💥 Permission check error: $e');
      return false;
    }
  }

  Future<void> startListening({
    required Function(String, bool) onResult,
    required Function(String) onError,
    required VoidCallback onTimeout,
  }) async {
    if (!_isInitialized) {
      print('🔄 Speech not initialized, initializing...');
      bool initialized = await initialize();
      if (!initialized) {
        onError('Speech recognition not available');
        return;
      }
    }

    if (!_speechAvailable) {
      onError('Speech recognition not available on this device');
      return;
    }

    if (_isListening) {
      print('⚠️ Already listening, stopping first...');
      await stopListening();
    }

    try {
      print('🎤 Starting speech recognition...');
      _isListening = true;

      // Start auto-timeout timer
      _autoTimeoutTimer = Timer(_maxListeningDuration, () {
        print('⏰ Auto-timeout reached');
        stopListening();
        onTimeout();
      });

      // FIXED: Properly handle the nullable return value from listen()
      bool? started = await _speechToText.listen(
        onResult: (result) {
          print(
            '🔊 Speech result: "${result.recognizedWords}" (confidence: ${result.confidence})',
          );
          _resetSilenceTimer();

          String processedText = _processVoiceInput(result.recognizedWords);
          bool shouldAutoCalculate = _shouldAutoCalculate(processedText);

          print(
            '✨ Processed: "$processedText" (auto-calc: $shouldAutoCalculate)',
          );
          onResult(processedText, shouldAutoCalculate);

          // Start silence timer for auto-close
          _startSilenceTimer(onTimeout);
        },
        listenFor: _maxListeningDuration,
        pauseFor: const Duration(seconds: 2),
        partialResults: true,
        localeId: _getSystemLocale(),
        listenMode: stt.ListenMode.confirmation,
        cancelOnError: false,
        onDevice: false, // Use cloud recognition for better accuracy
      );

      // FIXED: Handle null return value properly
      if (started == null || !started) {
        print(
          '❌ Failed to start listening - speech recognition returned null or false',
        );
        _isListening = false;
        onError(
          'Failed to start speech recognition. Make sure microphone is available.',
        );
      } else {
        print('✅ Speech recognition started successfully');
      }
    } catch (e) {
      print('💥 Error starting speech recognition: $e');
      _isListening = false;

      // Enhanced error handling
      if (e.toString().contains('Null') && e.toString().contains('bool')) {
        onError(
          'Speech recognition initialization failed. Please restart the app.',
        );
      } else if (e.toString().contains('permission')) {
        onError('Microphone permission required for speech recognition.');
      } else {
        onError('Error starting speech recognition: ${e.toString()}');
      }
    }
  }

  String _getSystemLocale() {
    try {
      String locale = Platform.localeName;
      print('🌐 System locale: $locale');

      // Convert to speech recognition format
      if (locale.contains('_')) {
        return locale.replaceAll('_', '-');
      }
      return locale;
    } catch (e) {
      print('⚠️ Could not get system locale, using en-US');
      return 'en-US';
    }
  }

  void _startSilenceTimer(VoidCallback onTimeout) {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(_silenceTimeout, () {
      if (_isListening) {
        print('🤫 Silence timeout reached');
        stopListening();
        onTimeout();
      }
    });
  }

  void _resetSilenceTimer() {
    _silenceTimer?.cancel();
  }

  void _handleSpeechEnd() {
    print('🔇 Speech recognition ended');
    _isListening = false;
    _silenceTimer?.cancel();
    _autoTimeoutTimer?.cancel();
  }

  Future<void> stopListening() async {
    if (_isListening) {
      print('🛑 Stopping speech recognition...');
      _isListening = false;
      _silenceTimer?.cancel();
      _autoTimeoutTimer?.cancel();

      try {
        await _speechToText.stop();
        print('✅ Speech recognition stopped');
      } catch (e) {
        print('⚠️ Error stopping speech recognition: $e');
      }
    }
  }

  Future<void> cancelListening() async {
    if (_isListening) {
      print('❌ Cancelling speech recognition...');
      _isListening = false;
      _silenceTimer?.cancel();
      _autoTimeoutTimer?.cancel();

      try {
        await _speechToText.cancel();
        print('✅ Speech recognition cancelled');
      } catch (e) {
        print('⚠️ Error cancelling speech recognition: $e');
      }
    }
  }

  // Enhanced: Check if expression is complete for auto-calculation
  bool _shouldAutoCalculate(String expression) {
    if (expression.isEmpty) return false;

    // Remove spaces for analysis
    String clean = expression.replaceAll(' ', '');

    // Check if it has a complete mathematical structure
    RegExp completeExpression = RegExp(
      r'^\d+(\.\d+)?\s*[+\-×÷%]\s*\d+(\.\d+)?$',
    );
    if (completeExpression.hasMatch(clean)) {
      return true;
    }

    // Check for more complex expressions
    RegExp multiOperation = RegExp(
      r'^\d+(\.\d+)?(\s*[+\-×÷%]\s*\d+(\.\d+)?)+$',
    );
    return multiOperation.hasMatch(clean);
  }

  // Enhanced: Convert voice input to mathematical expression
  String _processVoiceInput(String voiceText) {
    print('🔄 Processing voice input: "$voiceText"');

    String processed = voiceText.toLowerCase().trim();

    // Handle compound numbers first
    processed = _handleCompoundNumbers(processed);

    // Replace number words with digits
    processed = _replaceNumberWords(processed);

    // Replace operator words with symbols
    processed = _replaceOperatorWords(processed);

    // Handle mathematical expressions and phrases
    processed = _handleMathematicalPhrases(processed);

    // Clean up the expression
    processed = _cleanExpression(processed);

    print('✨ Processed result: "$processed"');
    return processed;
  }

  String _replaceNumberWords(String text) {
    final numberMap = {
      // Basic numbers
      'zero': '0', 'one': '1', 'two': '2', 'three': '3', 'four': '4',
      'five': '5', 'six': '6', 'seven': '7', 'eight': '8', 'nine': '9',

      // Teens
      'ten': '10', 'eleven': '11', 'twelve': '12', 'thirteen': '13',
      'fourteen': '14', 'fifteen': '15', 'sixteen': '16', 'seventeen': '17',
      'eighteen': '18', 'nineteen': '19',

      // Tens
      'twenty': '20', 'thirty': '30', 'forty': '40', 'fifty': '50',
      'sixty': '60', 'seventy': '70', 'eighty': '80', 'ninety': '90',

      // Large numbers
      'hundred': '100', 'thousand': '1000',

      // Decimal variations
      'point': '.', 'dot': '.',

      // Common fractions
      'half': '0.5', 'quarter': '0.25', 'third': '0.33',
    };

    String result = text;

    // Replace individual number words
    numberMap.forEach((word, digit) {
      result = result.replaceAll(
        RegExp('\\b$word\\b', caseSensitive: false),
        digit,
      );
    });

    return result;
  }

  String _replaceOperatorWords(String text) {
    // Sorted by length (longest first) to prevent partial matches
    final operatorMap = {
      // Addition - Multiple variations (longest phrases first)
      'added to': '+',
      'increment': '+',
      'increase': '+',
      'together': '+',
      'combine': '+',
      'plus': '+',
      'add': '+',
      'sum': '+',
      'total': '+',
      'more': '+',
      'and': '+',
      'with': '+',

      // Subtraction - Multiple variations
      'subtract from': '−',
      'take away': '−',
      'reduce by': '−',
      'difference': '−',
      'decrease': '−',
      'without': '−',
      'remove': '−',
      'minus': '−',
      'subtract': '−',
      'less': '−',

      // Multiplication - Multiple variations
      'multiplied by': '×',
      'multiply with': '×',
      'product': '×',
      'times': '×',
      'multiply': '×',
      'into': '×',
      'of': '×',
      'by': '×',

      // Division - Multiple variations
      'divided by': '÷',
      'split by': '÷',
      'quotient': '÷',
      'divide': '÷',
      'over': '÷',
      'per': '÷',
      'share': '÷',

      // Percentage
      'percentage': '%',
      'per cent': '%',
      'percent': '%',

      // Decimal point
      'decimal': '.',
      'point': '.',
      'dot': '.',
    };

    String result = text;

    // Sort entries by length (longest first) to prevent partial replacements
    var sortedEntries = operatorMap.entries.toList()
      ..sort((a, b) => b.key.length.compareTo(a.key.length));

    // Apply replacements in order of length
    for (var entry in sortedEntries) {
      String pattern = '\\b${RegExp.escape(entry.key)}\\b';
      result = result.replaceAll(
        RegExp(pattern, caseSensitive: false),
        entry.value,
      );
    }

    return result;
  }

  String _handleMathematicalPhrases(String text) {
    final phraseMap = {
      'what is': '',
      'what\'s': '',
      'calculate': '',
      'compute': '',
      'find': '',
      'solve': '',
      'give me': '',
      'tell me': '',
      'show me': '',
      'how much is': '',
      'how many': '',
    };

    String result = text;
    phraseMap.forEach((phrase, replacement) {
      result = result.replaceAll(
        RegExp('\\b${RegExp.escape(phrase)}\\b', caseSensitive: false),
        replacement,
      );
    });

    return result;
  }

  String _cleanExpression(String text) {
    // Remove filler words
    final fillerWords = ['the', 'a', 'an', 'to', 'from', 'with', 'please'];
    String result = text;

    for (String word in fillerWords) {
      result = result.replaceAll(
        RegExp('\\b$word\\b', caseSensitive: false),
        '',
      );
    }

    // Clean up spaces
    result = result.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Remove spaces around operators
    result = result.replaceAll(RegExp(r'\s*([+\-×÷%=.])\s*'), r'$1');

    return result;
  }

  String _handleCompoundNumbers(String text) {
    String result = text;

    // Handle compound numbers like "twenty five" -> "25"
    final compoundPatterns = {
      r'\btwenty\s+one\b': '21',
      r'\btwenty\s+two\b': '22',
      r'\btwenty\s+three\b': '23',
      r'\btwenty\s+four\b': '24',
      r'\btwenty\s+five\b': '25',
      r'\btwenty\s+six\b': '26',
      r'\btwenty\s+seven\b': '27',
      r'\btwenty\s+eight\b': '28',
      r'\btwenty\s+nine\b': '29',

      r'\bthirty\s+one\b': '31',
      r'\bthirty\s+two\b': '32',
      r'\bthirty\s+three\b': '33',
      r'\bthirty\s+four\b': '34',
      r'\bthirty\s+five\b': '35',
      r'\bthirty\s+six\b': '36',
      r'\bthirty\s+seven\b': '37',
      r'\bthirty\s+eight\b': '38',
      r'\bthirty\s+nine\b': '39',

      r'\bforty\s+one\b': '41',
      r'\bforty\s+two\b': '42',
      r'\bforty\s+three\b': '43',
      r'\bforty\s+four\b': '44',
      r'\bforty\s+five\b': '45',
      r'\bforty\s+six\b': '46',
      r'\bforty\s+seven\b': '47',
      r'\bforty\s+eight\b': '48',
      r'\bforty\s+nine\b': '49',

      r'\bfifty\s+one\b': '51',
      r'\bfifty\s+two\b': '52',
      r'\bfifty\s+three\b': '53',
      r'\bfifty\s+four\b': '54',
      r'\bfifty\s+five\b': '55',
      r'\bfifty\s+six\b': '56',
      r'\bfifty\s+seven\b': '57',
      r'\bfifty\s+eight\b': '58',
      r'\bfifty\s+nine\b': '59',

      // Continue patterns for 60s, 70s, 80s, 90s
      r'\bsixty\s+one\b': '61',
      r'\bsixty\s+two\b': '62',
      r'\bsixty\s+three\b': '63',
      r'\bsixty\s+four\b': '64',
      r'\bsixty\s+five\b': '65',
      r'\bsixty\s+six\b': '66',
      r'\bsixty\s+seven\b': '67',
      r'\bsixty\s+eight\b': '68',
      r'\bsixty\s+nine\b': '69',

      r'\bseventy\s+one\b': '71',
      r'\bseventy\s+two\b': '72',
      r'\bseventy\s+three\b': '73',
      r'\bseventy\s+four\b': '74',
      r'\bseventy\s+five\b': '75',
      r'\bseventy\s+six\b': '76',
      r'\bseventy\s+seven\b': '77',
      r'\bseventy\s+eight\b': '78',
      r'\bseventy\s+nine\b': '79',

      r'\beighty\s+one\b': '81',
      r'\beighty\s+two\b': '82',
      r'\beighty\s+three\b': '83',
      r'\beighty\s+four\b': '84',
      r'\beighty\s+five\b': '85',
      r'\beighty\s+six\b': '86',
      r'\beighty\s+seven\b': '87',
      r'\beighty\s+eight\b': '88',
      r'\beighty\s+nine\b': '89',

      r'\bninety\s+one\b': '91',
      r'\bninety\s+two\b': '92',
      r'\bninety\s+three\b': '93',
      r'\bninety\s+four\b': '94',
      r'\bninety\s+five\b': '95',
      r'\bninety\s+six\b': '96',
      r'\bninety\s+seven\b': '97',
      r'\bninety\s+eight\b': '98',
      r'\bninety\s+nine\b': '99',
    };

    compoundPatterns.forEach((pattern, replacement) {
      result = result.replaceAll(
        RegExp(pattern, caseSensitive: false),
        replacement,
      );
    });

    return result;
  }

  List<String> getExampleCommands() {
    return [
      "Five plus three",
      "Twenty minus eight",
      "Six times seven",
      "Fifteen divided by three",
      "What is ten add four",
      "Calculate fifty plus five",
      "Two point five plus one point five",
      "Twenty percent of hundred",
    ];
  }

  void dispose() {
    print('🗑️ Disposing Speech Service...');
    _silenceTimer?.cancel();
    _autoTimeoutTimer?.cancel();
  }
}
