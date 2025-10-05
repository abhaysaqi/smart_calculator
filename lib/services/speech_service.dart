import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

// class SpeechService {
//   static final SpeechService _instance = SpeechService._internal();
//   factory SpeechService() => _instance;
//   SpeechService._internal();

//   late stt.SpeechToText _speechToText;
//   bool _isInitialized = false;
//   bool _isListening = false;
//   Timer? _autoTimeoutTimer;
//   Timer? _silenceTimer;

//   // Reduced timeouts (3-5 seconds)
//   static const Duration _silenceTimeout = Duration(seconds: 4);
//   static const Duration _maxListeningDuration = Duration(seconds: 5);

//   bool get isInitialized => _isInitialized;
//   bool get isListening => _isListening;

//   Future<bool> initialize() async {
//     if (_isInitialized) return true;

//     _speechToText = stt.SpeechToText();
//     _isInitialized = await _speechToText.initialize(
//       onStatus: (status) {
//         print('🔊 Speech status: $status');
//       },
//       onError: (error) {
//         print('❌ Speech error: ${error.errorMsg}');
//         if (error.permanent && error.errorMsg != 'error_no_match') {
//           _handleSpeechEnd();
//         }
//       },
//     );

//     return _isInitialized;
//   }

//   Future<void> startListening({
//     required Function(String, bool) onResult,
//     required Function(String) onError,
//     required VoidCallback onTimeout,
//   }) async {
//     if (!_isInitialized) {
//       await initialize();
//     }

//     if (_isInitialized && !_isListening) {
//       _isListening = true;

//       _cancelAllTimers();

//       // Auto stop after max duration (5s)
//       _autoTimeoutTimer = Timer(_maxListeningDuration, () {
//         print('⏰ Max timeout reached (${_maxListeningDuration.inSeconds}s)');
//         _stopListeningWithTimeout(onTimeout);
//       });

//       try {
//         await _speechToText.listen(
//           onResult: (result) {
//             print('🎤 Raw speech: "${result.recognizedWords}"');

//             // Reset silence timer on any speech activity
//             _resetSilenceTimer(onTimeout);

//             if (result.recognizedWords.isNotEmpty) {
//               String processedText = _processVoiceInput(result.recognizedWords);

//               // Only show if it's valid math content
//               if (_isValidMathContent(processedText)) {
//                 bool shouldAutoCalculate = _shouldAutoCalculate(processedText);

//                 print(
//                   '✨ Valid math: "$processedText" (auto-calc: $shouldAutoCalculate)',
//                 );
//                 onResult(processedText, shouldAutoCalculate);

//                 if (result.finalResult && shouldAutoCalculate) {
//                   print('🎯 Final expression - auto-calculate');
//                   Timer(const Duration(milliseconds: 300), () {
//                     if (_isListening) {
//                       _stopListeningWithTimeout(onTimeout);
//                     }
//                   });
//                 }
//               } else {
//                 print('🚫 Filtered out non-math: "${result.recognizedWords}"');
//               }
//             }
//           },
//           listenFor: const Duration(seconds: 5), // Reduced to 5s
//           pauseFor: const Duration(seconds: 3), // Reduced to 3s
//           partialResults: true,
//           localeId: 'en_US',
//           listenMode: stt.ListenMode.dictation,
//           cancelOnError: false,
//           onDevice: false,
//         );

//         _startSilenceTimer(onTimeout);
//         print('✅ Listening started (pauseFor: 3s, listenFor: 5s)');
//       } catch (e) {
//         print('💥 Error starting speech: $e');
//         _isListening = false;
//         onError('Failed to start speech recognition: $e');
//       }
//     }
//   }

//   void _startSilenceTimer(VoidCallback onTimeout) {
//     _silenceTimer?.cancel();
//     _silenceTimer = Timer(_silenceTimeout, () {
//       if (_isListening) {
//         print('🤫 Silence timeout reached - stopping');
//         _stopListeningWithTimeout(onTimeout);
//       }
//     });
//   }

//   void _resetSilenceTimer(VoidCallback onTimeout) {
//     _silenceTimer?.cancel();
//     _startSilenceTimer(onTimeout);
//   }

//   void _handleSpeechEnd() {
//     print('🔚 Speech session ending...');
//     _isListening = false;
//     _cancelAllTimers();
//   }

//   void _stopListeningWithTimeout(VoidCallback onTimeout) {
//     print('⏹️ Stopping speech recognition');
//     _handleSpeechEnd();
//     _speechToText.stop();
//     onTimeout();
//   }

//   void _cancelAllTimers() {
//     _autoTimeoutTimer?.cancel();
//     _silenceTimer?.cancel();
//   }

//   Future<void> stopListening() async {
//     if (_isListening) {
//       print('🛑 Manual stop requested');
//       _handleSpeechEnd();
//       await _speechToText.stop();
//     }
//   }

//   Future<void> cancelListening() async {
//     if (_isListening) {
//       print('❌ Cancel listening requested');
//       _handleSpeechEnd();
//       await _speechToText.cancel();
//     }
//   }

//   // Check if the content is valid math (filters out table, spoon, etc.)
//   bool _isValidMathContent(String text) {
//     if (text.isEmpty) return false;
//     if (text == 'CLEAR_ALL') return true;

//     // Check for math-related words
//     final mathWords = [
//       // Numbers
//       'zero',
//       'one',
//       'two',
//       'three',
//       'four',
//       'five',
//       'six',
//       'seven',
//       'eight',
//       'nine',
//       'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen',
//       'seventeen', 'eighteen', 'nineteen', 'twenty', 'thirty', 'forty', 'fifty',
//       'sixty', 'seventy', 'eighty', 'ninety', 'hundred',
//       // Operations
//       'plus', 'add', 'increment', 'increase', 'sum', 'total',
//       'minus', 'subtract', 'decrease', 'less', 'take', 'remove',
//       'times', 'multiply', 'into', 'by',
//       'divide', 'divided', 'over', 'split',
//       'percent', 'percentage',
//       'point', 'dot', 'decimal',
//       // Clear commands
//       'clear', 'reset', 'delete', 'remove',
//     ];

//     String lowerText = text.toLowerCase();

//     // Check if contains any math words
//     bool hasMathWords = mathWords.any((word) => lowerText.contains(word));

//     // Check if contains digits
//     bool hasDigits = RegExp(r'\d').hasMatch(text);

//     // Check if contains math symbols
//     bool hasMathSymbols = RegExp(r'[+\-×÷%]').hasMatch(text);

//     return hasMathWords || hasDigits || hasMathSymbols;
//   }

//   bool _shouldAutoCalculate(String expression) {
//     if (expression.isEmpty) return false;
//     if (_isClearCommand(expression)) return false;

//     String clean = expression.replaceAll(' ', '');

//     RegExp completeExpression = RegExp(r'^\d+(\.\d+)?[+\-×÷%]\d+(\.\d+)?$');
//     if (completeExpression.hasMatch(clean)) return true;

//     RegExp multiOperation = RegExp(r'^\d+(\.\d+)?([+\-×÷%]\d+(\.\d+)?)+$');
//     if (multiOperation.hasMatch(clean)) return true;

//     return false;
//   }

//   bool _isClearCommand(String text) {
//     final clearCommands = ['clear', 'reset', 'delete', 'remove'];
//     String lowerText = text.toLowerCase();
//     return clearCommands.any((command) => lowerText.contains(command));
//   }

//   String _processVoiceInput(String voiceText) {
//     String result = voiceText.toLowerCase().trim();

//     if (_isClearCommand(result)) {
//       return 'CLEAR_ALL';
//     }

//     if (_isAlreadyMathFormat(result)) {
//       result = _cleanMathExpression(result);
//       return result;
//     }

//     result = _convertWordsToMath(result);
//     return result;
//   }

//   bool _isAlreadyMathFormat(String text) {
//     return text.contains('+') ||
//         text.contains('-') ||
//         text.contains('*') ||
//         text.contains('/') ||
//         text.contains('×') ||
//         text.contains('÷') ||
//         text.contains('%');
//   }

//   String _cleanMathExpression(String text) {
//     String result = text;
//     result = result.replaceAll('*', '×').replaceAll('/', '÷').trim();
//     return result;
//   }

//   String _convertWordsToMath(String text) {
//     String result = text;

//     // Remove question phrases
//     final questionPhrases = [
//       'what is ',
//       'what\'s ',
//       'calculate ',
//       'compute ',
//       'find ',
//       'solve ',
//       'give me ',
//       'tell me ',
//       'show me ',
//       'how much is ',
//       'how many ',
//     ];
//     for (String phrase in questionPhrases) {
//       result = result.replaceAll(phrase, '');
//     }

//     // Convert compound numbers first
//     final compoundNumbers = {
//       'twenty one': '21',
//       'twenty two': '22',
//       'twenty three': '23',
//       'twenty four': '24',
//       'twenty five': '25',
//       'twenty six': '26',
//       'twenty seven': '27',
//       'twenty eight': '28',
//       'twenty nine': '29',
//       'thirty one': '31',
//       'thirty two': '32',
//       'thirty three': '33',
//       'one hundred': '100',
//       'two hundred': '200',
//     };

//     for (var entry in compoundNumbers.entries) {
//       result = result.replaceAll(entry.key, entry.value);
//     }

//     // Convert individual numbers
//     final numbers = {
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
//       'point': '.',
//       'dot': '.',
//     };

//     for (var entry in numbers.entries) {
//       result = result.replaceAll(' ${entry.key} ', ' ${entry.value} ');
//       if (result.startsWith('${entry.key} ')) {
//         result = result.replaceFirst('${entry.key} ', '${entry.value} ');
//       }
//       if (result.endsWith(' ${entry.key}')) {
//         result =
//             '${result.substring(0, result.length - entry.key.length - 1)} ${entry.value}';
//       }
//       if (result == entry.key) {
//         result = entry.value;
//       }
//     }

//     // Extended operators - multiple words for each operation
//     // Addition operators
//     result = result.replaceAll(' plus ', '+');
//     result = result.replaceAll(' add ', '+');
//     result = result.replaceAll(' increment ', '+');
//     result = result.replaceAll(' increase ', '+');
//     result = result.replaceAll(' sum ', '+');
//     result = result.replaceAll(' total ', '+');

//     // Subtraction operators
//     result = result.replaceAll(' minus ', '−');
//     result = result.replaceAll(' subtract ', '−');
//     result = result.replaceAll(' decrease ', '−');
//     result = result.replaceAll(' less ', '−');
//     result = result.replaceAll(' take ', '−');

//     // Multiplication operators
//     result = result.replaceAll(' times ', '×');
//     result = result.replaceAll(' multiply ', '×');
//     result = result.replaceAll(' into ', '×');
//     result = result.replaceAll(' by ', '×');

//     // Division operators
//     result = result.replaceAll(' divided by ', '÷');
//     result = result.replaceAll(' divide ', '÷');
//     result = result.replaceAll(' over ', '÷');
//     result = result.replaceAll(' split ', '÷');

//     // Handle operations at word boundaries
//     if (result.endsWith(' plus')) result = result.replaceAll(' plus', '+');
//     if (result.endsWith(' add')) result = result.replaceAll(' add', '+');
//     if (result.endsWith(' increment'))
//       result = result.replaceAll(' increment', '+');
//     if (result.endsWith(' minus')) result = result.replaceAll(' minus', '−');
//     if (result.endsWith(' subtract'))
//       result = result.replaceAll(' subtract', '−');
//     if (result.endsWith(' times')) result = result.replaceAll(' times', '×');
//     if (result.endsWith(' multiply'))
//       result = result.replaceAll(' multiply', '×');
//     if (result.endsWith(' into')) result = result.replaceAll(' into', '×');

//     // Clean up multiple spaces
//     while (result.contains('  ')) {
//       result = result.replaceAll('  ', ' ');
//     }

//     return result.trim();
//   }

//   List<String> getExampleCommands() {
//     return [
//       "Three plus two",
//       "Five add one",
//       "Four times six",
//       "Ten into five",
//       "Eight subtract three",
//       "Clear all",
//     ];
//   }

//   void dispose() {
//     _cancelAllTimers();
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class SpeechService {
  static final SpeechService _instance = SpeechService._internal();
  factory SpeechService() => _instance;
  SpeechService._internal();

  late stt.SpeechToText _speechToText;
  bool _isInitialized = false;
  bool _isListening = false;
  Timer? _autoTimeoutTimer;
  Timer? _silenceTimer;

  // Reduced timeouts (3-5 seconds)
  static const Duration _silenceTimeout = Duration(seconds: 4);
  static const Duration _maxListeningDuration = Duration(seconds: 5);

  bool get isInitialized => _isInitialized;
  bool get isListening => _isListening;

  Future<bool> initialize() async {
    if (_isInitialized) return true;

    _speechToText = stt.SpeechToText();
    _isInitialized = await _speechToText.initialize(
      onStatus: (status) {
        print('🔊 Speech status: $status');
      },
      onError: (error) {
        print('❌ Speech error: ${error.errorMsg}');
        if (error.permanent && error.errorMsg != 'error_no_match') {
          _handleSpeechEnd();
        }
      },
    );

    return _isInitialized;
  }

  Future<void> startListening({
    required Function(String, bool) onResult,
    required Function(String) onError,
    required VoidCallback onTimeout,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    if (_isInitialized && !_isListening) {
      _isListening = true;

      _cancelAllTimers();

      // Auto stop after max duration (5s)
      _autoTimeoutTimer = Timer(_maxListeningDuration, () {
        print('⏰ Max timeout reached (${_maxListeningDuration.inSeconds}s)');
        _stopListeningWithTimeout(onTimeout);
      });

      try {
        await _speechToText.listen(
          onResult: (result) {
            print('🎤 Raw speech: "${result.recognizedWords}"');

            // Reset silence timer on any speech activity
            _resetSilenceTimer(onTimeout);

            if (result.recognizedWords.isNotEmpty) {
              // Pre-filter before processing
              if (_isValidMathInput(result.recognizedWords)) {
                String processedText = _processVoiceInput(
                  result.recognizedWords,
                );

                // Final check after processing
                if (processedText.isNotEmpty && processedText != 'INVALID') {
                  bool shouldAutoCalculate = _shouldAutoCalculate(
                    processedText,
                  );

                  print(
                    '✨ Valid math: "$processedText" (auto-calc: $shouldAutoCalculate)',
                  );
                  onResult(processedText, shouldAutoCalculate);

                  if (result.finalResult && shouldAutoCalculate) {
                    print('🎯 Final expression - auto-calculate');
                    Timer(const Duration(milliseconds: 300), () {
                      if (_isListening) {
                        _stopListeningWithTimeout(onTimeout);
                      }
                    });
                  }
                } else {
                  print(
                    '🚫 Invalid after processing: "${result.recognizedWords}"',
                  );
                }
              } else {
                print('🚫 Filtered out non-math: "${result.recognizedWords}"');
              }
            }
          },
          listenFor: const Duration(seconds: 5), // Reduced to 5s
          pauseFor: const Duration(seconds: 3), // Reduced to 3s
          partialResults: true,
          localeId: 'en_US',
          listenMode: stt.ListenMode.dictation,
          cancelOnError: false,
          onDevice: false,
        );

        _startSilenceTimer(onTimeout);
        print('✅ Listening started (pauseFor: 3s, listenFor: 5s)');
      } catch (e) {
        print('💥 Error starting speech: $e');
        _isListening = false;
        onError('Failed to start speech recognition: $e');
      }
    }
  }

  void _startSilenceTimer(VoidCallback onTimeout) {
    _silenceTimer?.cancel();
    _silenceTimer = Timer(_silenceTimeout, () {
      if (_isListening) {
        print('🤫 Silence timeout reached - stopping');
        _stopListeningWithTimeout(onTimeout);
      }
    });
  }

  void _resetSilenceTimer(VoidCallback onTimeout) {
    _silenceTimer?.cancel();
    _startSilenceTimer(onTimeout);
  }

  void _handleSpeechEnd() {
    print('🔚 Speech session ending...');
    _isListening = false;
    _cancelAllTimers();
  }

  void _stopListeningWithTimeout(VoidCallback onTimeout) {
    print('⏹️ Stopping speech recognition');
    _handleSpeechEnd();
    _speechToText.stop();
    onTimeout();
  }

  void _cancelAllTimers() {
    _autoTimeoutTimer?.cancel();
    _silenceTimer?.cancel();
  }

  Future<void> stopListening() async {
    if (_isListening) {
      print('🛑 Manual stop requested');
      _handleSpeechEnd();
      await _speechToText.stop();
    }
  }

  Future<void> cancelListening() async {
    if (_isListening) {
      print('❌ Cancel listening requested');
      _handleSpeechEnd();
      await _speechToText.cancel();
    }
  }

  // STRICT FILTER: Only allow pure math content
  bool _isValidMathInput(String text) {
    if (text.isEmpty) return false;

    String lowerText = text.toLowerCase().trim();

    // Allow clear commands
    final clearCommands = ['clear', 'reset', 'delete', 'remove'];
    if (clearCommands.any((command) => lowerText.contains(command))) {
      return true;
    }

    // Define ONLY allowed math words
    final allowedMathWords = {
      // Numbers only
      'zero',
      'one',
      'two',
      'three',
      'four',
      'five',
      'six',
      'seven',
      'eight',
      'nine',
      'ten', 'eleven', 'twelve', 'thirteen', 'fourteen', 'fifteen', 'sixteen',
      'seventeen', 'eighteen', 'nineteen', 'twenty', 'thirty', 'forty', 'fifty',
      'sixty', 'seventy', 'eighty', 'ninety', 'hundred',
      // Operations only
      'plus', 'add', 'minus', 'subtract', 'times', 'multiply', 'into', 'by',
      'divide', 'divided', 'over',
      // Compound numbers
      'twenty-one', 'twenty-two', 'twenty-three', 'twenty-four', 'twenty-five',
      'twenty-six', 'twenty-seven', 'twenty-eight', 'twenty-nine',
      'thirty-one', 'thirty-two', 'thirty-three', 'thirty-four', 'thirty-five',
      'thirty-six', 'thirty-seven', 'thirty-eight', 'thirty-nine',
      // Decimal
      'point', 'dot',
    };

    // Split text into words
    List<String> words = lowerText
        .split(' ')
        .where((word) => word.isNotEmpty)
        .toList();

    // Check each word - ALL must be allowed
    for (String word in words) {
      // Allow digits
      if (RegExp(r'^\d+\.?\d*$').hasMatch(word)) continue;

      // Allow math symbols
      if (RegExp(r'^[+\-×÷%]+$').hasMatch(word)) continue;

      // Check if word is in allowed list
      if (!allowedMathWords.contains(word)) {
        print('🚫 Rejected word: "$word" in "$text"');
        return false;
      }
    }

    // Must contain at least one number or number word
    bool hasNumbers = words.any(
      (word) =>
          RegExp(r'\d').hasMatch(word) ||
          [
            'zero',
            'one',
            'two',
            'three',
            'four',
            'five',
            'six',
            'seven',
            'eight',
            'nine',
            'ten',
            'eleven',
            'twelve',
            'thirteen',
            'fourteen',
            'fifteen',
            'sixteen',
            'seventeen',
            'eighteen',
            'nineteen',
            'twenty',
            'thirty',
            'forty',
            'fifty',
            'sixty',
            'seventy',
            'eighty',
            'ninety',
            'hundred',
          ].contains(word),
    );

    if (!hasNumbers) {
      print('🚫 No numbers found in: "$text"');
      return false;
    }

    print('✅ Valid math input: "$text"');
    return true;
  }

  bool _shouldAutoCalculate(String expression) {
    if (expression.isEmpty) return false;
    if (_isClearCommand(expression)) return false;

    String clean = expression.replaceAll(' ', '');

    RegExp completeExpression = RegExp(r'^\d+(\.\d+)?[+\-×÷%]\d+(\.\d+)?$');
    if (completeExpression.hasMatch(clean)) return true;

    RegExp multiOperation = RegExp(r'^\d+(\.\d+)?([+\-×÷%]\d+(\.\d+)?)+$');
    if (multiOperation.hasMatch(clean)) return true;

    return false;
  }

  bool _isClearCommand(String text) {
    final clearCommands = ['clear', 'reset', 'delete', 'remove'];
    String lowerText = text.toLowerCase();
    return clearCommands.any((command) => lowerText.contains(command));
  }

  String _processVoiceInput(String voiceText) {
    String result = voiceText.toLowerCase().trim();

    if (_isClearCommand(result)) {
      return 'CLEAR_ALL';
    }

    if (_isAlreadyMathFormat(result)) {
      result = _cleanMathExpression(result);
      return result;
    }

    result = _convertWordsToMath(result);

    // Final validation - ensure only math characters remain
    if (_containsInvalidCharacters(result)) {
      return 'INVALID';
    }

    return result;
  }

  // Check if result contains any non-math characters after processing
  bool _containsInvalidCharacters(String text) {
    // Remove all valid math characters
    String cleaned = text.replaceAll(RegExp(r'[0-9+\-×÷%\.\s]'), '');

    // If anything remains, it's invalid
    if (cleaned.isNotEmpty) {
      print('🚫 Invalid characters remaining: "$cleaned" in "$text"');
      return true;
    }

    return false;
  }

  bool _isAlreadyMathFormat(String text) {
    return text.contains('+') ||
        text.contains('-') ||
        text.contains('*') ||
        text.contains('/') ||
        text.contains('×') ||
        text.contains('÷') ||
        text.contains('%');
  }

  String _cleanMathExpression(String text) {
    String result = text;
    result = result.replaceAll('*', '×').replaceAll('/', '÷').trim();
    return result;
  }

  String _convertWordsToMath(String text) {
    String result = text;

    // Convert compound numbers first (with and without hyphens)
    final compoundNumbers = {
      'twenty one': '21',
      'twenty-one': '21',
      'twenty two': '22',
      'twenty-two': '22',
      'twenty three': '23',
      'twenty-three': '23',
      'twenty four': '24',
      'twenty-four': '24',
      'twenty five': '25',
      'twenty-five': '25',
      'twenty six': '26',
      'twenty-six': '26',
      'twenty seven': '27',
      'twenty-seven': '27',
      'twenty eight': '28',
      'twenty-eight': '28',
      'twenty nine': '29',
      'twenty-nine': '29',
      'thirty one': '31',
      'thirty-one': '31',
      'thirty two': '32',
      'thirty-two': '32',
      'thirty three': '33',
      'thirty-three': '33',
      'thirty four': '34',
      'thirty-four': '34',
      'thirty five': '35',
      'thirty-five': '35',
      'thirty six': '36',
      'thirty-six': '36',
      'thirty seven': '37',
      'thirty-seven': '37',
      'thirty eight': '38',
      'thirty-eight': '38',
      'thirty nine': '39',
      'thirty-nine': '39',
      'one hundred': '100',
      'two hundred': '200',
    };

    for (var entry in compoundNumbers.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }

    // Convert individual numbers
    final numbers = {
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
      'point': '.',
      'dot': '.',
    };

    for (var entry in numbers.entries) {
      result = result.replaceAll(' ${entry.key} ', ' ${entry.value} ');
      if (result.startsWith('${entry.key} ')) {
        result = result.replaceFirst('${entry.key} ', '${entry.value} ');
      }
      if (result.endsWith(' ${entry.key}')) {
        result =
            '${result.substring(0, result.length - entry.key.length - 1)} ${entry.value}';
      }
      if (result == entry.key) {
        result = entry.value;
      }
    }

    // Convert ONLY basic operation words (no synonyms to avoid confusion)
    result = result.replaceAll(' plus ', ' + ');
    result = result.replaceAll(' add ', ' + ');
    result = result.replaceAll(' minus ', ' − ');
    result = result.replaceAll(' subtract ', ' − ');
    result = result.replaceAll(' times ', ' × ');
    result = result.replaceAll(' multiply ', ' × ');
    result = result.replaceAll(' into ', ' × ');
    result = result.replaceAll(' by ', ' × ');
    result = result.replaceAll(' divided by ', ' ÷ ');
    result = result.replaceAll(' divide ', ' ÷ ');
    result = result.replaceAll(' over ', ' ÷ ');

    // Handle operations at word boundaries
    if (result.endsWith(' plus')) result = result.replaceAll(' plus', ' +');
    if (result.endsWith(' add')) result = result.replaceAll(' add', ' +');
    if (result.endsWith(' minus')) result = result.replaceAll(' minus', ' −');
    if (result.endsWith(' subtract'))
      result = result.replaceAll(' subtract', ' −');
    if (result.endsWith(' times')) result = result.replaceAll(' times', ' ×');
    if (result.endsWith(' multiply'))
      result = result.replaceAll(' multiply', ' ×');
    if (result.endsWith(' into')) result = result.replaceAll(' into', ' ×');
    if (result.endsWith(' divide')) result = result.replaceAll(' divide', ' ÷');

    // Clean up spacing
    while (result.contains('  ')) {
      result = result.replaceAll('  ', ' ');
    }

    return result.trim();
  }

  List<String> getExampleCommands() {
    return [
      "Three plus two",
      "Five minus one",
      "Four times six",
      "Ten divided by five",
      "Eight subtract three",
      "Clear all",
    ];
  }

  void dispose() {
    _cancelAllTimers();
  }
}
