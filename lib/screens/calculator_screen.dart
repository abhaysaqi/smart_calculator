import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_calculator/utils/app_colors.dart';
import 'package:smart_calculator/utils/app_strings.dart';
import 'package:smart_calculator/utils/text_styles.dart';
import 'package:smart_calculator/widgets/common_app_bar.dart';
import '../widgets/neumorphic_button.dart';
import '../services/calculation_service.dart';
import '../services/history_service.dart';
import '../services/speech_service.dart';
import 'dart:math' as math;

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen>
    with TickerProviderStateMixin {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();

  String calculation = '';
  String _currentResult = '0';
  bool _isCalculated = false;

  // Speech recognition variables
  bool _isListening = false;
  bool _speechEnabled = false;
  String _speechText = '';

  final CalculationService _calculationService = CalculationService();
  final HistoryService _historyService = HistoryService();
  final SpeechService _speechService = SpeechService();

  // Animation controllers
  late AnimationController _micAnimationController;
  late Animation<double> _micScaleAnimation;
  late AnimationController _pulseAnimationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_onInputChanged);
    _initSpeech();
    _setupAnimations();
  }

  void _setupAnimations() {
    _micAnimationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _micScaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _micAnimationController, curve: Curves.easeInOut),
    );

    _pulseAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(
        parent: _pulseAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  void _initSpeech() async {
    _speechEnabled = await _speechService.initialize();
    setState(() {});
  }

  void _onInputChanged() {
    setState(() {
      calculation = _inputController.text;
      _evaluateLiveResult();
    });
  }

  void _evaluateLiveResult() {
    if (calculation.isNotEmpty && calculation.length > 1) {
      try {
        if (_hasValidExpression(calculation)) {
          double resultValue = _evaluateExpression(calculation);
          _currentResult = _formatResult(resultValue);
        } else {
          _currentResult = '0';
        }
      } catch (e) {
        _currentResult = '0';
      }
    } else {
      _currentResult = '0';
    }
  }

  bool _hasValidExpression(String expression) {
    final operators = ['+', '−', '×', '÷', '-', '*', '/'];
    bool hasOperator = false;
    bool hasNumberBeforeOperator = false;
    bool hasNumberAfterOperator = false;

    for (int i = 0; i < expression.length; i++) {
      String char = expression[i];

      if (operators.contains(char)) {
        if (i > 0 && _isNumeric(expression[i - 1])) {
          hasNumberBeforeOperator = true;
          hasOperator = true;
        }
      } else if (_isNumeric(char) && hasOperator) {
        hasNumberAfterOperator = true;
      }
    }

    return hasOperator && hasNumberBeforeOperator && hasNumberAfterOperator;
  }

  bool _isNumeric(String char) {
    return '0123456789.'.contains(char);
  }

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double screenWidth = screenSize.width;
    final double screenHeight = screenSize.height;
    final EdgeInsets safeArea = MediaQuery.of(context).padding;
    final Orientation orientation = MediaQuery.of(context).orientation;

    final bool isSmallScreen = screenWidth < 350;
    final bool isLargeScreen = screenWidth > 450;
    final bool isTablet = screenWidth > 600;
    final bool isLandscape = orientation == Orientation.landscape;

    final double availableHeight =
        screenHeight - safeArea.top - safeArea.bottom;
    final double headerHeight = _getResponsiveHeaderHeight(
      screenSize,
      isTablet,
    );
    final double displayHeight = _getResponsiveDisplayHeight(
      screenSize,
      isTablet,
      isLandscape,
    );
    final double bottomNavHeight = isTablet ? 120.0 : 100.0;

    final double buttonGridHeight =
        availableHeight - headerHeight - displayHeight - bottomNavHeight;
    final double buttonHeight = _getResponsiveButtonHeight(
      buttonGridHeight,
      isSmallScreen,
      isLargeScreen,
      isTablet,
    );

    return Scaffold(
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _buildVoiceButton(buttonHeight, screenWidth, false),
          SizedBox(height: displayHeight * 0.4),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endContained,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppStyles.backgroundGradient,
          ),
          child: Container(
            decoration: const BoxDecoration(
              gradient: AppStyles.containerGradient,
            ),
            child: Column(
              children: [
                CommonHeader(title: "Calculator"),
                _buildResponsiveDisplay(
                  screenSize,
                  isSmallScreen,
                  isLargeScreen,
                  isTablet,
                ),
                Expanded(
                  child: _buildResponsiveButtonGrid(
                    buttonHeight,
                    screenWidth,
                    isSmallScreen,
                    isLargeScreen,
                    isTablet,
                    isLandscape,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  double _getResponsiveHeaderHeight(Size screenSize, bool isTablet) {
    if (isTablet) return 100.0;
    return 80.0;
  }

  double _getResponsiveDisplayHeight(
    Size screenSize,
    bool isTablet,
    bool isLandscape,
  ) {
    if (isTablet) {
      return isLandscape ? 120.0 : 200.0;
    }
    if (isLandscape) {
      return math.max(100.0, screenSize.height * 0.25);
    }
    return math.max(140.0, math.min(220.0, screenSize.height * 0.22));
  }

  double _getResponsiveButtonHeight(
    double buttonGridHeight,
    bool isSmallScreen,
    bool isLargeScreen,
    bool isTablet,
  ) {
    final double calculatedHeight =
        (buttonGridHeight - (5 * 16)) / 6; // 6 rows now (added voice row)

    if (isTablet) {
      return calculatedHeight.clamp(70.0, 100.0);
    } else if (isSmallScreen) {
      return calculatedHeight.clamp(40.0, 60.0);
    } else if (isLargeScreen) {
      return calculatedHeight.clamp(55.0, 80.0);
    } else {
      return calculatedHeight.clamp(45.0, 70.0);
    }
  }

  Widget _buildResponsiveDisplay(
    Size screenSize,
    bool isSmallScreen,
    bool isLargeScreen,
    bool isTablet,
  ) {
    final double displayHeight = _getResponsiveDisplayHeight(
      screenSize,
      isTablet,
      false,
    );
    final double horizontalPadding = isTablet ? 32.0 : 16.0;
    final double verticalPadding = isSmallScreen ? 6.0 : 8.0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Container(
        width: double.infinity,
        height: displayHeight,
        padding: EdgeInsets.all(isTablet ? 32.0 : 24.0),
        decoration: AppStyles.glassmorphicDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Voice Input Status
            if (_isListening)
              Container(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    AnimatedBuilder(
                      animation: _pulseAnimation,
                      child: Icon(Icons.mic, color: Colors.red, size: 16),
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _pulseAnimation.value,
                          child: child,
                        );
                      },
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Listening...',
                      style: TextStyle(
                        color: Colors.red,
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),

            // Responsive Input Field
            Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  _inputFocusNode.requestFocus();
                  _inputController.selection = TextSelection.fromPosition(
                    TextPosition(offset: _inputController.text.length),
                  );
                },
                child: TextField(
                  controller: _inputController,
                  focusNode: _inputFocusNode,
                  style: TextStyle(
                    color: AppColors.textWhite.withOpacity(0.9),
                    fontSize: _getResponsiveInputFontSize(screenSize, isTablet),
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: _speechEnabled
                        ? (_isListening
                              ? 'Listening for speech...'
                              : 'Enter calculation or speak...')
                        : 'Enter calculation...',
                    hintStyle: TextStyle(
                      color: AppColors.textWhite.withOpacity(0.3),
                      fontSize:
                          _getResponsiveInputFontSize(screenSize, isTablet) *
                          0.9,
                    ),
                  ),
                  textAlign: TextAlign.right,
                  keyboardType: TextInputType.none,
                  showCursor: true,
                  cursorColor: AppColors.primaryColor,
                  maxLines: isTablet ? 2 : 1,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ),

            SizedBox(height: isTablet ? 20 : 16),

            // Responsive Result Display
            Expanded(
              flex: 2,
              child: Container(
                alignment: Alignment.centerRight,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontSize: _getResponsiveResultFontSize(
                      screenSize,
                      isTablet,
                      _isCalculated,
                    ),
                    fontWeight: _isCalculated
                        ? FontWeight.bold
                        : FontWeight.w500,
                    fontStyle: _isCalculated
                        ? FontStyle.normal
                        : FontStyle.italic,
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      _currentResult == '0' && calculation.isEmpty
                          ? '0'
                          : _currentResult,
                      maxLines: 1,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getResponsiveInputFontSize(Size screenSize, bool isTablet) {
    if (isTablet) return 28.0;
    return math.max(18.0, math.min(24.0, screenSize.width * 0.055));
  }

  double _getResponsiveResultFontSize(
    Size screenSize,
    bool isTablet,
    bool isCalculated,
  ) {
    final double baseFontSize = isTablet ? 48.0 : 32.0;
    final double previewSize = isTablet ? 24.0 : 18.0;

    if (isCalculated) {
      return math.max(28.0, math.min(baseFontSize, screenSize.width * 0.08));
    } else {
      return math.max(16.0, math.min(previewSize, screenSize.width * 0.05));
    }
  }

  Widget _buildResponsiveButtonGrid(
    double buttonHeight,
    double screenWidth,
    bool isSmallScreen,
    bool isLargeScreen,
    bool isTablet,
    bool isLandscape,
  ) {
    final double horizontalPadding = isTablet ? 32.0 : 16.0;
    final double verticalPadding = isLandscape ? 4.0 : 8.0;
    final double buttonSpacing = isTablet
        ? 20.0
        : (isSmallScreen ? 12.0 : 16.0);

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Row 1: C, ⌫, %, ÷
          _buildResponsiveButtonRow([
            _buildResponsiveButton(
              AppStrings.clear,
              AppColors.textPurple,
              _clearAll,
              buttonHeight,
              screenWidth,
              isTablet,
            ),
            _buildResponsiveButton(
              "⌫",
              AppColors.textPurple,
              _backspace,
              buttonHeight,
              screenWidth,
              isTablet,
            ),
            _buildResponsiveButton(
              AppStrings.percent,
              AppColors.textPurple,
              () => _appendToInput('%'),
              buttonHeight,
              screenWidth,
              isTablet,
            ),
            _buildResponsiveButton(
              AppStrings.divide,
              AppColors.primaryColor,
              () => _appendToInput('÷'),
              buttonHeight,
              screenWidth,
              isTablet,
            ),
          ], buttonSpacing),

          // Row 2: 7, 8, 9, ×
          _buildResponsiveButtonRow([
            _buildResponsiveButton(
              AppStrings.seven,
              AppColors.textWhite,
              () => _appendToInput('7'),
              buttonHeight,
              screenWidth,
              isTablet,
            ),
            _buildResponsiveButton(
              AppStrings.eight,
              AppColors.textWhite,
              () => _appendToInput('8'),
              buttonHeight,
              screenWidth,
              isTablet,
            ),
            _buildResponsiveButton(
              AppStrings.nine,
              AppColors.textWhite,
              () => _appendToInput('9'),
              buttonHeight,
              screenWidth,
              isTablet,
            ),
            _buildResponsiveButton(
              AppStrings.multiply,
              AppColors.primaryColor,
              () => _appendToInput('×'),
              buttonHeight,
              screenWidth,
              isTablet,
            ),
          ], buttonSpacing),

          // Row 3: 4, 5, 6, −
          _buildResponsiveButtonRow([
            _buildResponsiveButton(
              AppStrings.four,
              AppColors.textWhite,
              () => _appendToInput('4'),
              buttonHeight,
              screenWidth,
              isTablet,
            ),
            _buildResponsiveButton(
              AppStrings.five,
              AppColors.textWhite,
              () => _appendToInput('5'),
              buttonHeight,
              screenWidth,
              isTablet,
            ),
            _buildResponsiveButton(
              AppStrings.six,
              AppColors.textWhite,
              () => _appendToInput('6'),
              buttonHeight,
              screenWidth,
              isTablet,
            ),
            _buildResponsiveButton(
              AppStrings.subtract,
              AppColors.primaryColor,
              () => _appendToInput('−'),
              buttonHeight,
              screenWidth,
              isTablet,
            ),
          ], buttonSpacing),

          // Row 4: 1, 2, 3, +
          _buildResponsiveButtonRow([
            _buildResponsiveButton(
              AppStrings.one,
              AppColors.textWhite,
              () => _appendToInput('1'),
              buttonHeight,
              screenWidth,
              isTablet,
            ),
            _buildResponsiveButton(
              AppStrings.two,
              AppColors.textWhite,
              () => _appendToInput('2'),
              buttonHeight,
              screenWidth,
              isTablet,
            ),
            _buildResponsiveButton(
              AppStrings.three,
              AppColors.textWhite,
              () => _appendToInput('3'),
              buttonHeight,
              screenWidth,
              isTablet,
            ),
            _buildResponsiveButton(
              AppStrings.add,
              AppColors.primaryColor,
              () => _appendToInput('+'),
              buttonHeight,
              screenWidth,
              isTablet,
            ),
          ], buttonSpacing),

          // Row 5: 0, ., =
          _buildResponsiveButtonRow([
            _buildResponsiveWideButton(
              AppStrings.zero,
              AppColors.textWhite,
              () => _appendToInput('0'),
              buttonHeight,
              screenWidth,
              isTablet,
            ),
            _buildResponsiveButton(
              AppStrings.decimal,
              AppColors.textWhite,
              () => _appendToInput('.'),
              buttonHeight,
              screenWidth,
              isTablet,
            ),
            _buildResponsiveButton(
              AppStrings.equals,
              AppColors.textWhite,
              _calculate,
              buttonHeight,
              screenWidth,
              isTablet,
              isEqual: true,
            ),
          ], buttonSpacing),

          // // Row 6: Voice Button
          // _buildResponsiveButtonRow([
          //   _buildVoiceButton(buttonHeight, screenWidth, isTablet),
          // ], buttonSpacing),
        ],
      ),
    );
  }

  Widget _buildVoiceButton(
    double buttonHeight,
    double screenWidth,
    bool isTablet,
  ) {
    return AnimatedBuilder(
      animation: _micScaleAnimation,
      child: GestureDetector(
        onTap: _speechEnabled ? _toggleListening : _showSpeechUnavailable,
        onLongPress: _speechEnabled ? _showVoiceHelp : null,
        child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _isListening
                  ? [Colors.red.withOpacity(0.8), Colors.red.withOpacity(0.6)]
                  : _speechEnabled
                  ? [
                      AppColors.primaryColor.withOpacity(0.8),
                      AppColors.textPurple.withOpacity(0.8),
                    ]
                  : [
                      Colors.grey.withOpacity(0.5),
                      Colors.grey.withOpacity(0.3),
                    ],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Color(0xFF0E0C12),
                offset: Offset(4, 4),
                blurRadius: 8,
              ),
              BoxShadow(
                color: Color(0xFF18161E),
                offset: Offset(-4, -4),
                blurRadius: 8,
              ),
            ],
          ),
          child: Icon(
            _isListening ? Icons.mic : Icons.mic_none,
            color: Colors.white,
            size: isTablet ? 28 : 24,
          ),
        ),
      ),
      builder: (context, child) {
        return Transform.scale(
          scale: _isListening ? _micScaleAnimation.value : 1.0,
          child: child,
        );
      },
    );
  }

  Widget _buildResponsiveButtonRow(List<Widget> buttons, double spacing) {
    return Expanded(
      child: Row(
        children: buttons
            .expand((widget) => [widget, SizedBox(width: spacing)])
            .take(buttons.length * 2 - 1)
            .toList(),
      ),
    );
  }

  Widget _buildResponsiveButton(
    String text,
    Color textColor,
    VoidCallback onPressed,
    double buttonHeight,
    double screenWidth,
    bool isTablet, {
    bool isEqual = false,
  }) {
    return Expanded(
      child: NeumorphicButton(
        text: text,
        textColor: textColor,
        onPressed: onPressed,
        buttonHeight: buttonHeight,
        isEqual: isEqual,
      ),
    );
  }

  Widget _buildResponsiveWideButton(
    String text,
    Color textColor,
    VoidCallback onPressed,
    double buttonHeight,
    double screenWidth,
    bool isTablet,
  ) {
    return Expanded(
      flex: 2,
      child: NeumorphicButton(
        text: text,
        textColor: textColor,
        onPressed: onPressed,
        buttonHeight: buttonHeight,
        isWide: true,
      ),
    );
  }

  // Voice Input Methods
  void _toggleListening() {
    if (_isListening) {
      _stopListening();
    } else {
      _startListening();
    }
  }

  // Enhanced Voice Input Methods
  // Enhanced Voice Input Methods with better error handling
  void _startListening() async {
    if (!_speechEnabled) {
      _showSpeechError('Speech recognition not enabled');
      return;
    }

    setState(() {
      _isListening = true;
      _speechText = '';
    });

    _micAnimationController.forward();
    _pulseAnimationController.repeat(reverse: true);

    HapticFeedback.mediumImpact();

    await _speechService.startListening(
      onResult: (recognizedText, shouldAutoCalculate) {
        print(
          '📱 Received: "$recognizedText" (auto-calc: $shouldAutoCalculate)',
        );

        if (recognizedText == 'CLEAR_ALL') {
          // Handle clear command
          _clearAll();
          _stopListening();
          _showSuccessMessage('Calculator cleared by voice');
          return;
        }

        if (recognizedText.isNotEmpty) {
          setState(() {
            _speechText = recognizedText;
            _inputController.text = recognizedText;
            calculation = recognizedText;
            _isCalculated = false;
          });

          _evaluateLiveResult();

          // Auto-calculate complete expressions (no need to say "equals")
          if (shouldAutoCalculate) {
            Future.delayed(const Duration(milliseconds: 800), () {
              if (mounted && calculation == recognizedText) {
                _calculate();
                _stopListening();
              }
            });
          }
        }
      },
      onError: (error) {
        _stopListening();
        // Only show user-friendly errors, not technical ones
        if (error.contains('permission')) {
          _showSpeechError('Microphone permission required');
        } else if (error.contains('not available')) {
          _showSpeechError('Speech recognition not available');
        } else {
          // For other errors, just show a generic message
          _showSpeechError('Speech recognition temporarily unavailable');
        }
      },
      onTimeout: () {
        // This is called when auto-timeout occurs (normal behavior)
        _stopListening();
        // Don't show error for normal timeout
        print('🔇 Voice input completed (timeout)');
      },
    );
  }

  void _stopListening() async {
    if (!_isListening) return;

    await _speechService.stopListening();

    setState(() {
      _isListening = false;
    });

    _micAnimationController.reverse();
    _pulseAnimationController.stop();

    HapticFeedback.lightImpact();
  }

  // Remove the _showVoiceTimeout method since normal timeouts shouldn't show error messages

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showVoiceTimeout() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.timer_off, color: Colors.white, size: 16),
            const SizedBox(width: 8),
            const Text('Voice input stopped (timeout)'),
          ],
        ),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _showVoiceHelp() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1820),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textWhite.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '🎤 Voice Commands',
              style: const TextStyle(
                color: AppColors.textWhite,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 20),
            ...SpeechService().getExampleCommands().map(
              (command) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.mic, color: AppColors.primaryColor, size: 16),
                    const SizedBox(width: 12),
                    Text(
                      '"$command"',
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Tip: Long press voice button to see this help',
              style: TextStyle(
                color: AppColors.textWhite.withOpacity(0.6),
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showSpeechUnavailable() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Speech recognition not available'),
        backgroundColor: Colors.orange,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showSpeechError(String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Speech error: $error'),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // Existing calculation methods remain the same...
  void _appendToInput(String value) {
    HapticFeedback.selectionClick();
    setState(() {
      final currentText = _inputController.text;
      final selection = _inputController.selection;

      _isCalculated = false;

      if (selection.isValid) {
        final newText = currentText.replaceRange(
          selection.start,
          selection.end,
          value,
        );
        _inputController.text = newText;

        final newCursorPosition = selection.start + value.length;
        _inputController.selection = TextSelection.fromPosition(
          TextPosition(offset: newCursorPosition),
        );
      } else {
        _inputController.text = currentText + value;
        _inputController.selection = TextSelection.fromPosition(
          TextPosition(offset: _inputController.text.length),
        );
      }
    });
  }

  void _backspace() {
    HapticFeedback.selectionClick();
    setState(() {
      final currentText = _inputController.text;
      final selection = _inputController.selection;

      _isCalculated = false;

      if (selection.isValid && selection.start > 0) {
        if (selection.isCollapsed) {
          final newText = currentText.replaceRange(
            selection.start - 1,
            selection.start,
            '',
          );
          _inputController.text = newText;
          _inputController.selection = TextSelection.fromPosition(
            TextPosition(offset: selection.start - 1),
          );
        } else {
          final newText = currentText.replaceRange(
            selection.start,
            selection.end,
            '',
          );
          _inputController.text = newText;
          _inputController.selection = TextSelection.fromPosition(
            TextPosition(offset: selection.start),
          );
        }
      }
    });
  }

  void _clearAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      _inputController.clear();
      calculation = '';
      _currentResult = '0';
      _isCalculated = false;
      _speechText = '';
    });
  }

  void _calculate() {
    if (_inputController.text.isNotEmpty) {
      try {
        double calculatedResult = _evaluateExpression(_inputController.text);

        setState(() {
          _currentResult = _formatResult(calculatedResult);
          _isCalculated = true;
        });

        _historyService.addCalculation(
          _inputController.text,
          _currentResult,
          'Calculator',
        );
        HapticFeedback.mediumImpact();
      } catch (e) {
        setState(() {
          _currentResult = 'Error';
          _isCalculated = true;
        });
        HapticFeedback.heavyImpact();
      }
    }
  }

  // Keep all your existing calculation methods...
  double _evaluateExpression(String expression) {
    try {
      expression = expression.replaceAll(' ', '');
      expression = expression.replaceAll('×', '*');
      expression = expression.replaceAll('÷', '/');
      expression = expression.replaceAll('−', '-');

      if (expression.contains('%')) {
        expression = expression.replaceAll('%', '/100');
      }

      return _parseExpression(expression);
    } catch (e) {
      throw Exception('Invalid expression');
    }
  }

  double _parseExpression(String expression) {
    while (expression.contains('(')) {
      int start = expression.lastIndexOf('(');
      int end = expression.indexOf(')', start);
      if (end == -1) throw Exception('Mismatched parentheses');

      String subExpr = expression.substring(start + 1, end);
      double subResult = _parseExpression(subExpr);
      expression = expression.replaceRange(
        start,
        end + 1,
        subResult.toString(),
      );
    }

    expression = _handleOperations(expression, ['*', '/']);
    expression = _handleOperations(expression, ['+', '-']);

    return double.parse(expression);
  }

  String _handleOperations(String expression, List<String> operators) {
    for (String op in operators) {
      while (expression.contains(op)) {
        int opIndex = -1;

        for (int i = 1; i < expression.length; i++) {
          if (expression[i] == op &&
              (op != '-' ||
                  (i > 0 && '0123456789)'.contains(expression[i - 1])))) {
            opIndex = i;
            break;
          }
        }

        if (opIndex == -1) break;

        int leftStart = 0;
        for (int i = opIndex - 1; i >= 0; i--) {
          if ('+-*/'.contains(expression[i]) && i != 0) {
            leftStart = i + 1;
            break;
          }
        }

        int rightEnd = expression.length;
        for (int i = opIndex + 1; i < expression.length; i++) {
          if ('+-*/'.contains(expression[i])) {
            rightEnd = i;
            break;
          }
        }

        String leftStr = expression.substring(leftStart, opIndex);
        String rightStr = expression.substring(opIndex + 1, rightEnd);

        double left = double.parse(leftStr);
        double right = double.parse(rightStr);
        double result;

        switch (op) {
          case '+':
            result = left + right;
            break;
          case '-':
            result = left - right;
            break;
          case '*':
            result = left * right;
            break;
          case '/':
            if (right == 0) throw Exception('Division by zero');
            result = left / right;
            break;
          default:
            throw Exception('Unknown operator');
        }

        expression = expression.replaceRange(
          leftStart,
          rightEnd,
          result.toString(),
        );
      }
    }

    return expression;
  }

  String _formatResult(double value) {
    if (value == value.toInt() && value.abs() < 1e15) {
      return value.toInt().toString();
    } else {
      String formatted = value.toStringAsFixed(8);
      formatted = formatted.replaceAll(RegExp(r'0*$'), '');
      formatted = formatted.replaceAll(RegExp(r'\.$'), '');
      return formatted;
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _inputFocusNode.dispose();
    _micAnimationController.dispose();
    _pulseAnimationController.dispose();
    super.dispose();
  }
}
