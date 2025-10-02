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
  Timer? _silenceTimer;
  Timer? _autoTimeoutTimer;

  static const Duration _silenceTimeout = Duration(seconds: 10);
  static const Duration _maxListeningDuration = Duration(seconds: 30);

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

      _autoTimeoutTimer = Timer(_maxListeningDuration, () {
        print('⏰ Our timeout reached (${_maxListeningDuration.inSeconds}s)');
        _stopListeningWithTimeout(onTimeout);
      });

      try {
        await _speechToText.listen(
          onResult: (result) {
            print(
              '🎤 Speech: "${result.recognizedWords}" (confidence: ${result.confidence})',
            );

            _resetOurSilenceTimer(onTimeout);

            if (result.recognizedWords.isNotEmpty) {
              String processedText = _processVoiceInput(result.recognizedWords);
              bool shouldAutoCalculate = _shouldAutoCalculate(processedText);

              print(
                '✨ Processed: "$processedText" (auto-calc: $shouldAutoCalculate)',
              );
              onResult(processedText, shouldAutoCalculate);

              if (result.finalResult && shouldAutoCalculate) {
                print('🎯 Final complete expression - will auto-calculate');

                Timer(const Duration(milliseconds: 500), () {
                  if (_isListening) {
                    _stopListeningWithTimeout(onTimeout);
                  }
                });
              }
            }
          },

          listenFor: const Duration(seconds: 30),
          pauseFor: const Duration(seconds: 15),
          partialResults: true,
          localeId: 'en_US',
          listenMode: stt.ListenMode.dictation,
          cancelOnError: false,
          onDevice: false,
        );

        _startOurSilenceTimer(onTimeout);

        print(
          '✅ Speech started with AGGRESSIVE settings (pauseFor: 15s, listenFor: 30s)',
        );
      } catch (e) {
        print('💥 Error starting speech: $e');
        _isListening = false;
        onError('Failed to start speech recognition: $e');
      }
    }
  }

  void _startOurSilenceTimer(VoidCallback onTimeout) {
    _silenceTimer?.cancel();
    print('⏰ Starting OUR silence timer (${_silenceTimeout.inSeconds}s)');
    _silenceTimer = Timer(_silenceTimeout, () {
      if (_isListening) {
        print('🤫 OUR silence timeout reached - stopping');
        _stopListeningWithTimeout(onTimeout);
      }
    });
  }

  void _resetOurSilenceTimer(VoidCallback onTimeout) {
    _silenceTimer?.cancel();
    print('🔄 OUR silence timer reset - speech detected');

    _startOurSilenceTimer(onTimeout);
  }

  void _handleSpeechEnd() {
    print('🔚 Speech session ending...');
    _isListening = false;
    _cancelAllTimers();
  }

  void _stopListeningWithTimeout(VoidCallback onTimeout) {
    print('⏹️ Manually stopping speech recognition');
    _handleSpeechEnd();
    _speechToText.stop();
    onTimeout();
  }

  void _cancelAllTimers() {
    _silenceTimer?.cancel();
    _autoTimeoutTimer?.cancel();
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

  bool _shouldAutoCalculate(String expression) {
    if (expression.isEmpty) return false;
    if (_isClearCommand(expression)) return false;

    String clean = expression.replaceAll(' ', '');

    RegExp completeExpression = RegExp(r'^\d+(\.\d+)?[+\-×÷%]\d+(\.\d+)?$');
    if (completeExpression.hasMatch(clean)) {
      print('✅ Complete expression: "$clean"');
      return true;
    }

    RegExp multiOperation = RegExp(r'^\d+(\.\d+)?([+\-×÷%]\d+(\.\d+)?)+$');
    if (multiOperation.hasMatch(clean)) {
      print('✅ Complex expression: "$clean"');
      return true;
    }

    return false;
  }

  bool _isClearCommand(String text) {
    final clearCommands = ['clear', 'reset', 'delete', 'remove'];
    String lowerText = text.toLowerCase();
    return clearCommands.any((command) => lowerText.contains(command));
  }

  String _processVoiceInput(String voiceText) {
    print('🔄 Processing: "$voiceText"');

    String result = voiceText.toLowerCase().trim();

    if (_isClearCommand(result)) {
      return 'CLEAR_ALL';
    }

    if (_isAlreadyMathFormat(result)) {
      result = _cleanMathExpression(result);
      return result;
    }

    result = _convertWordsToMath(result);
    return result;
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

    result = result.replaceAll(' + ', '+');
    result = result.replaceAll('+ ', '+');
    result = result.replaceAll(' +', '+');

    result = result.replaceAll(' - ', '−');
    result = result.replaceAll('- ', '−');
    result = result.replaceAll(' -', '−');

    result = result.replaceAll(' * ', '×');
    result = result.replaceAll('* ', '×');
    result = result.replaceAll(' *', '×');

    result = result.replaceAll(' / ', '÷');
    result = result.replaceAll('/ ', '÷');
    result = result.replaceAll(' /', '÷');

    result = result.replaceAll(' × ', '×');
    result = result.replaceAll('× ', '×');
    result = result.replaceAll(' ×', '×');

    result = result.replaceAll(' ÷ ', '÷');
    result = result.replaceAll('÷ ', '÷');
    result = result.replaceAll(' ÷', '÷');

    while (result.contains('  ')) {
      result = result.replaceAll('  ', ' ');
    }

    return result.trim();
  }

  String _convertWordsToMath(String text) {
    String result = text;

    final questionPhrases = [
      'what is ',
      'what\'s ',
      'calculate ',
      'compute ',
      'find ',
      'solve ',
      'give me ',
      'tell me ',
      'show me ',
      'how much is ',
      'how many ',
    ];

    for (String phrase in questionPhrases) {
      result = result.replaceAll(phrase, '');
    }

    final compoundNumbers = {
      'twenty one': '21',
      'twenty two': '22',
      'twenty three': '23',
      'twenty four': '24',
      'twenty five': '25',
      'twenty six': '26',
      'twenty seven': '27',
      'twenty eight': '28',
      'twenty nine': '29',
      'thirty one': '31',
      'thirty two': '32',
      'thirty three': '33',
      'thirty four': '34',
      'thirty five': '35',
      'thirty six': '36',
      'thirty seven': '37',
      'thirty eight': '38',
      'thirty nine': '39',
    };

    for (var entry in compoundNumbers.entries) {
      result = result.replaceAll(entry.key, entry.value);
    }

    final individualNumbers = {
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

    for (var entry in individualNumbers.entries) {
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

    result = result.replaceAll(' plus ', '+');
    result = result.replaceAll(' add ', '+');
    result = result.replaceAll(' minus ', '−');
    result = result.replaceAll(' subtract ', '−');
    result = result.replaceAll(' times ', '×');
    result = result.replaceAll(' multiply ', '×');
    result = result.replaceAll(' divided by ', '÷');
    result = result.replaceAll(' divide ', '÷');
    result = result.replaceAll(' over ', '÷');

    if (result.endsWith(' plus')) result = result.replaceAll(' plus', '+');
    if (result.endsWith(' add')) result = result.replaceAll(' add', '+');
    if (result.endsWith(' minus')) result = result.replaceAll(' minus', '−');
    if (result.endsWith(' subtract'))
      result = result.replaceAll(' subtract', '−');
    if (result.endsWith(' times')) result = result.replaceAll(' times', '×');
    if (result.endsWith(' multiply'))
      result = result.replaceAll(' multiply', '×');

    if (result.startsWith('plus ')) result = result.replaceAll('plus ', '+');
    if (result.startsWith('add ')) result = result.replaceAll('add ', '+');
    if (result.startsWith('minus ')) result = result.replaceAll('minus ', '−');
    if (result.startsWith('subtract '))
      result = result.replaceAll('subtract ', '−');
    if (result.startsWith('times ')) result = result.replaceAll('times ', '×');
    if (result.startsWith('multiply '))
      result = result.replaceAll('multiply ', '×');

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
      "Ten divided by two",
      "Three minus... (pause) ...two",
      "Clear all",
    ];
  }

  void dispose() {
    _cancelAllTimers();
  }
}
