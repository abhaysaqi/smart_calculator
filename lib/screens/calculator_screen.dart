// lib/screens/calculator_screen.dart
// import 'package:flutter/material.dart';
// import 'package:smart_calculator/utils/app_colors.dart';
// import 'package:smart_calculator/utils/app_strings.dart';
// import 'package:smart_calculator/utils/text_styles.dart';
// import 'package:smart_calculator/widgets/common_app_bar.dart';
// import '../widgets/neumorphic_button.dart';
// import '../services/calculation_service.dart';
// import '../services/history_service.dart';

// class CalculatorScreen extends StatefulWidget {
//   const CalculatorScreen({super.key});

//   @override
//   State<CalculatorScreen> createState() => _CalculatorScreenState();
// }

// class _CalculatorScreenState extends State<CalculatorScreen> {
//   String calculation = '';
//   String result = '0';
//   String _currentNumber = '';
//   String _operation = '';
//   double _previousNumber = 0;
//   bool _isOperatorPressed = false;
//   bool _isCalculated = false;

//   final CalculationService _calculationService = CalculationService();
//   final HistoryService _historyService = HistoryService();

//   @override
//   Widget build(BuildContext context) {
//     final screenHeight = MediaQuery.of(context).size.height;
//     final safeAreaTop = MediaQuery.of(context).padding.top;
//     final safeAreaBottom = MediaQuery.of(context).padding.bottom;

//     final availableHeight = screenHeight - safeAreaTop - safeAreaBottom;
//     final headerHeight = 80.0;
//     final displayHeight = 160.0;
//     final bottomNavHeight = 100.0;
//     final buttonGridHeight =
//         availableHeight - headerHeight - displayHeight - bottomNavHeight;
//     final buttonHeight = (buttonGridHeight - (4 * 16)) / 5;
//     final finalButtonHeight = buttonHeight.clamp(50.0, 80.0);

//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(gradient: AppStyles.backgroundGradient),
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: AppStyles.containerGradient,
//           ),
//           child: Column(
//             children: [
//               CommonHeader(title: "Calculator"),
//               _buildDisplay(),
//               Expanded(child: _buildButtonGrid(finalButtonHeight)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDisplay() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Container(
//         width: double.infinity,
//         padding: const EdgeInsets.all(24),
//         decoration: AppStyles.glassmorphicDecoration,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           children: [
//             Text(
//               calculation.isEmpty ? ' ' : calculation,
//               style: AppStyles.calculationStyle.copyWith(
//                 color: AppColors.textWhite.withOpacity(0.7),
//               ),
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//             const SizedBox(height: 8),
//             Text(
//               result,
//               style: AppStyles.resultStyle,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildButtonGrid(double buttonHeight) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           // Row 1: C, +/-, %, ÷
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               NeumorphicButton(
//                 text: AppStrings.clear,
//                 textColor: AppColors.textPurple,
//                 onPressed: _clear,
//                 buttonHeight: buttonHeight,
//               ),
//               NeumorphicButton(
//                 text: AppStrings.plusMinus,
//                 textColor: AppColors.textPurple,
//                 onPressed: _toggleSign,
//                 buttonHeight: buttonHeight,
//               ),
//               NeumorphicButton(
//                 text: AppStrings.percent,
//                 textColor: AppColors.textPurple,
//                 onPressed: () => _onOperatorPressed('%'),
//                 buttonHeight: buttonHeight,
//               ),
//               NeumorphicButton(
//                 text: AppStrings.divide,
//                 textColor: AppColors.primaryColor,
//                 onPressed: () => _onOperatorPressed('÷'),
//                 buttonHeight: buttonHeight,
//               ),
//             ],
//           ),
//           // Row 2: 7, 8, 9, ×
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               NeumorphicButton(
//                 text: AppStrings.seven,
//                 textColor: AppColors.textWhite,
//                 onPressed: () => _onNumberPressed('7'),
//                 buttonHeight: buttonHeight,
//               ),
//               NeumorphicButton(
//                 text: AppStrings.eight,
//                 textColor: AppColors.textWhite,
//                 onPressed: () => _onNumberPressed('8'),
//                 buttonHeight: buttonHeight,
//               ),
//               NeumorphicButton(
//                 text: AppStrings.nine,
//                 textColor: AppColors.textWhite,
//                 onPressed: () => _onNumberPressed('9'),
//                 buttonHeight: buttonHeight,
//               ),
//               NeumorphicButton(
//                 text: AppStrings.multiply,
//                 textColor: AppColors.primaryColor,
//                 onPressed: () => _onOperatorPressed('×'),
//                 buttonHeight: buttonHeight,
//               ),
//             ],
//           ),
//           // Row 3: 4, 5, 6, −
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               NeumorphicButton(
//                 text: AppStrings.four,
//                 textColor: AppColors.textWhite,
//                 onPressed: () => _onNumberPressed('4'),
//                 buttonHeight: buttonHeight,
//               ),
//               NeumorphicButton(
//                 text: AppStrings.five,
//                 textColor: AppColors.textWhite,
//                 onPressed: () => _onNumberPressed('5'),
//                 buttonHeight: buttonHeight,
//               ),
//               NeumorphicButton(
//                 text: AppStrings.six,
//                 textColor: AppColors.textWhite,
//                 onPressed: () => _onNumberPressed('6'),
//                 buttonHeight: buttonHeight,
//               ),
//               NeumorphicButton(
//                 text: AppStrings.subtract,
//                 textColor: AppColors.primaryColor,
//                 onPressed: () => _onOperatorPressed('−'),
//                 buttonHeight: buttonHeight,
//               ),
//             ],
//           ),
//           // Row 4: 1, 2, 3, +
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               NeumorphicButton(
//                 text: AppStrings.one,
//                 textColor: AppColors.textWhite,
//                 onPressed: () => _onNumberPressed('1'),
//                 buttonHeight: buttonHeight,
//               ),
//               NeumorphicButton(
//                 text: AppStrings.two,
//                 textColor: AppColors.textWhite,
//                 onPressed: () => _onNumberPressed('2'),
//                 buttonHeight: buttonHeight,
//               ),
//               NeumorphicButton(
//                 text: AppStrings.three,
//                 textColor: AppColors.textWhite,
//                 onPressed: () => _onNumberPressed('3'),
//                 buttonHeight: buttonHeight,
//               ),
//               NeumorphicButton(
//                 text: AppStrings.add,
//                 textColor: AppColors.primaryColor,
//                 onPressed: () => _onOperatorPressed('+'),
//                 buttonHeight: buttonHeight,
//               ),
//             ],
//           ),
//           // Row 5: 0, ., =
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//             children: [
//               NeumorphicButton(
//                 text: AppStrings.zero,
//                 textColor: AppColors.textWhite,
//                 onPressed: () => _onNumberPressed('0'),
//                 isWide: true,
//                 buttonHeight: buttonHeight,
//               ),
//               NeumorphicButton(
//                 text: AppStrings.decimal,
//                 textColor: AppColors.textWhite,
//                 onPressed: _onDecimalPressed,
//                 buttonHeight: buttonHeight,
//               ),
//               NeumorphicButton(
//                 text: AppStrings.equals,
//                 textColor: AppColors.textWhite,
//                 onPressed: _calculate,
//                 isEqual: true,
//                 buttonHeight: buttonHeight,
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   void _onNumberPressed(String number) {
//     setState(() {
//       if (_isCalculated) {
//         // Start fresh after calculation
//         calculation = '';
//         result = '0';
//         _isCalculated = false;
//       }

//       if (_isOperatorPressed) {
//         _currentNumber = '';
//         _isOperatorPressed = false;
//       }

//       if (_currentNumber == '0' && number != '.') {
//         _currentNumber = number;
//       } else {
//         _currentNumber += number;
//       }

//       result = _currentNumber;
//     });
//   }

//   void _onOperatorPressed(String operator) {
//     if (_currentNumber.isNotEmpty) {
//       if (_operation.isNotEmpty && !_isOperatorPressed) {
//         _calculate();
//       }

//       setState(() {
//         _previousNumber = double.parse(_currentNumber);
//         _operation = operator;
//         calculation = '$_currentNumber $operator';
//         _isOperatorPressed = true;
//         _isCalculated = false;
//       });
//     }
//   }

//   void _calculate() {
//     if (_operation.isNotEmpty &&
//         _currentNumber.isNotEmpty &&
//         _previousNumber != 0) {
//       double currentValue = double.parse(_currentNumber);
//       double calculatedResult = 0;

//       switch (_operation) {
//         case '+':
//           calculatedResult = _previousNumber + currentValue;
//           break;
//         case '−':
//           calculatedResult = _previousNumber - currentValue;
//           break;
//         case '×':
//           calculatedResult = _previousNumber * currentValue;
//           break;
//         case '÷':
//           if (currentValue != 0) {
//             calculatedResult = _previousNumber / currentValue;
//           } else {
//             setState(() {
//               result = 'Error';
//               calculation = '';
//             });
//             return;
//           }
//           break;
//         case '%':
//           calculatedResult = _previousNumber % currentValue;
//           break;
//       }

//       setState(() {
//         String fullCalculation = '$_previousNumber $_operation $_currentNumber';
//         result = _formatResult(calculatedResult);
//         calculation = fullCalculation;
//         _currentNumber = result;
//         _operation = '';
//         _isCalculated = true;

//         // Add to history
//         _historyService.addCalculation(fullCalculation, result, 'Calculator');
//       });
//     }
//   }

//   void _clear() {
//     setState(() {
//       calculation = '';
//       result = '0';
//       _currentNumber = '';
//       _operation = '';
//       _previousNumber = 0;
//       _isOperatorPressed = false;
//       _isCalculated = false;
//     });
//   }

//   void _toggleSign() {
//     if (_currentNumber.isNotEmpty && _currentNumber != '0') {
//       setState(() {
//         if (_currentNumber.startsWith('-')) {
//           _currentNumber = _currentNumber.substring(1);
//         } else {
//           _currentNumber = '-$_currentNumber';
//         }
//         result = _currentNumber;
//       });
//     }
//   }

//   void _onDecimalPressed() {
//     setState(() {
//       if (_isCalculated) {
//         calculation = '';
//         result = '0';
//         _currentNumber = '0';
//         _isCalculated = false;
//       }

//       if (_isOperatorPressed) {
//         _currentNumber = '0';
//         _isOperatorPressed = false;
//       }

//       if (!_currentNumber.contains('.')) {
//         if (_currentNumber.isEmpty) {
//           _currentNumber = '0.';
//         } else {
//           _currentNumber += '.';
//         }
//         result = _currentNumber;
//       }
//     });
//   }

//   String _formatResult(double value) {
//     if (value == value.toInt()) {
//       return value.toInt().toString();
//     } else {
//       return value
//           .toStringAsFixed(8)
//           .replaceAll(RegExp(r'0*$'), '')
//           .replaceAll(RegExp(r'\.$'), '');
//     }
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_calculator/utils/app_colors.dart';
import 'package:smart_calculator/utils/app_strings.dart';
import 'package:smart_calculator/utils/text_styles.dart';
import 'package:smart_calculator/widgets/common_app_bar.dart';
import '../widgets/neumorphic_button.dart';
import '../services/calculation_service.dart';
import '../services/history_service.dart';
import 'dart:math' as math;

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _inputController = TextEditingController();
  final FocusNode _inputFocusNode = FocusNode();

  String calculation = '';
  String result = '0';
  String _currentNumber = '';
  String _operation = '';
  double _previousNumber = 0;
  bool _isOperatorPressed = false;
  bool _isCalculated = false;

  final CalculationService _calculationService = CalculationService();
  final HistoryService _historyService = HistoryService();

  @override
  void initState() {
    super.initState();
    _inputController.addListener(_onInputChanged);
  }

  void _onInputChanged() {
    setState(() {
      calculation = _inputController.text;
      // Try to evaluate the expression for live preview
      _evaluateExpression();
    });
  }

  void _evaluateExpression() {
    if (calculation.isNotEmpty) {
      try {
        // Simple evaluation for preview (you can enhance this)
        String expression = calculation
            .replaceAll('×', '*')
            .replaceAll('÷', '/')
            .replaceAll('−', '-');
        // For now, just show the input as preview
        // You can add a proper math expression evaluator here
      } catch (e) {
        // Invalid expression
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    final availableHeight = screenHeight - safeAreaTop - safeAreaBottom;
    final headerHeight = 80.0;
    final displayHeight = 160.0;
    final bottomNavHeight = 100.0;
    final buttonGridHeight =
        availableHeight - headerHeight - displayHeight - bottomNavHeight;
    final buttonHeight = (buttonGridHeight - (4 * 16)) / 5;
    final finalButtonHeight = buttonHeight.clamp(50.0, 80.0);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppStyles.backgroundGradient),
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppStyles.containerGradient,
          ),
          child: Column(
            children: [
              CommonHeader(title: "Calculator"),
              _buildEditableDisplay(),
              Expanded(child: _buildButtonGrid(finalButtonHeight)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditableDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: AppStyles.glassmorphicDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // Editable Input Field
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      _inputFocusNode.requestFocus();
                      // Move cursor to end
                      _inputController.selection = TextSelection.fromPosition(
                        TextPosition(offset: _inputController.text.length),
                      );
                    },
                    child: TextField(
                      controller: _inputController,
                      focusNode: _inputFocusNode,
                      style: AppStyles.calculationStyle.copyWith(
                        color: AppColors.textWhite.withOpacity(0.9),
                        fontSize: 20,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter calculation...',
                        hintStyle: AppStyles.calculationStyle.copyWith(
                          color: AppColors.textWhite.withOpacity(0.3),
                          fontSize: 18,
                        ),
                      ),
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.none, // Disable keyboard
                      showCursor: true,
                      cursorColor: AppColors.primaryColor,
                      maxLines: 1,
                      textInputAction: TextInputAction.done,
                    ),
                  ),
                ),
                // Clear/Cross Button
                if (_inputController.text.isNotEmpty)
                  GestureDetector(
                    onTap: _clearInput,
                    child: Container(
                      margin: const EdgeInsets.only(left: 12),
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF1A1820), Color(0xFF131118)],
                        ),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF0E0C12),
                            offset: Offset(2, 2),
                            blurRadius: 4,
                          ),
                          BoxShadow(
                            color: Color(0xFF18161E),
                            offset: Offset(-2, -2),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.red.withOpacity(0.8),
                        size: 20,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            // Result Display
            Text(
              result,
              style: AppStyles.resultStyle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonGrid(double buttonHeight) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Row 1: C, +/-, %, ÷
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicButton(
                text: AppStrings.clear,
                textColor: AppColors.textPurple,
                onPressed: _clearAll,
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.removx,
                textColor: AppColors.textPurple,
                onPressed: _backspace,
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.percent,
                textColor: AppColors.textPurple,
                onPressed: () => _appendToInput('%'),
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.divide,
                textColor: AppColors.primaryColor,
                onPressed: () => _appendToInput('÷'),
                buttonHeight: buttonHeight,
              ),
            ],
          ),
          // Row 2: 7, 8, 9, ×
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicButton(
                text: AppStrings.seven,
                textColor: AppColors.textWhite,
                onPressed: () => _appendToInput('7'),
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.eight,
                textColor: AppColors.textWhite,
                onPressed: () => _appendToInput('8'),
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.nine,
                textColor: AppColors.textWhite,
                onPressed: () => _appendToInput('9'),
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.multiply,
                textColor: AppColors.primaryColor,
                onPressed: () => _appendToInput('×'),
                buttonHeight: buttonHeight,
              ),
            ],
          ),
          // Row 3: 4, 5, 6, −
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicButton(
                text: AppStrings.four,
                textColor: AppColors.textWhite,
                onPressed: () => _appendToInput('4'),
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.five,
                textColor: AppColors.textWhite,
                onPressed: () => _appendToInput('5'),
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.six,
                textColor: AppColors.textWhite,
                onPressed: () => _appendToInput('6'),
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.subtract,
                textColor: AppColors.primaryColor,
                onPressed: () => _appendToInput('−'),
                buttonHeight: buttonHeight,
              ),
            ],
          ),
          // Row 4: 1, 2, 3, +
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicButton(
                text: AppStrings.one,
                textColor: AppColors.textWhite,
                onPressed: () => _appendToInput('1'),
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.two,
                textColor: AppColors.textWhite,
                onPressed: () => _appendToInput('2'),
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.three,
                textColor: AppColors.textWhite,
                onPressed: () => _appendToInput('3'),
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.add,
                textColor: AppColors.primaryColor,
                onPressed: () => _appendToInput('+'),
                buttonHeight: buttonHeight,
              ),
            ],
          ),
          // Row 5: 0, ., =
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicButton(
                text: AppStrings.zero,
                textColor: AppColors.textWhite,
                onPressed: () => _appendToInput('0'),
                isWide: true,
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.decimal,
                textColor: AppColors.textWhite,
                onPressed: () => _appendToInput('.'),
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.equals,
                textColor: AppColors.textWhite,
                onPressed: _calculate,
                isEqual: true,
                buttonHeight: buttonHeight,
              ),
            ],
          ),
          // // Row 6: Backspace
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: [
          //     Expanded(
          //       child: NeumorphicButton(
          //         text: "⌫",
          //         textColor: AppColors.textPurple,
          //         onPressed: _backspace,
          //         buttonHeight: buttonHeight * 0.7,
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }

  void _appendToInput(String value) {
    HapticFeedback.selectionClick();
    setState(() {
      final currentText = _inputController.text;
      final selection = _inputController.selection;

      if (selection.isValid) {
        // Insert at cursor position
        final newText = currentText.replaceRange(
          selection.start,
          selection.end,
          value,
        );
        _inputController.text = newText;

        // Move cursor after inserted text
        final newCursorPosition = selection.start + value.length;
        _inputController.selection = TextSelection.fromPosition(
          TextPosition(offset: newCursorPosition),
        );
      } else {
        // Append to end
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

      if (selection.isValid && selection.start > 0) {
        if (selection.isCollapsed) {
          // Delete character before cursor
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
          // Delete selected text
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

  void _clearInput() {
    HapticFeedback.mediumImpact();
    setState(() {
      _inputController.clear();
      result = '0';
    });
  }

  void _clearAll() {
    HapticFeedback.mediumImpact();
    setState(() {
      _inputController.clear();
      calculation = '';
      result = '0';
      _currentNumber = '';
      _operation = '';
      _previousNumber = 0;
      _isOperatorPressed = false;
      _isCalculated = false;
    });
  }

  void _toggleSign() {
    HapticFeedback.selectionClick();
    // Toggle sign of current number at cursor position
    // This is a simplified implementation
    final currentText = _inputController.text;
    if (currentText.isNotEmpty) {
      if (currentText.startsWith('-')) {
        _inputController.text = currentText.substring(1);
      } else {
        _inputController.text = '-$currentText';
      }
    }
  }

  void _calculate() {
    if (_inputController.text.isNotEmpty) {
      try {
        // Enhanced expression evaluation
        String expression = _inputController.text
            .replaceAll('×', '*')
            .replaceAll('÷', '/')
            .replaceAll('−', '-');

        // Use a proper math expression evaluator here
        // For now, simple calculation
        double calculatedResult = _evaluateSimpleExpression(expression);

        setState(() {
          result = _formatResult(calculatedResult);
          _isCalculated = true;

          // Save to history
          _historyService.addCalculation(
            _inputController.text,
            result,
            'Calculator',
          );
        });

        HapticFeedback.mediumImpact();

        // Show success feedback
        _showCalculationFeedback();
      } catch (e) {
        setState(() {
          result = 'Error';
        });
        HapticFeedback.heavyImpact();
      }
    }
  }

  double _evaluateSimpleExpression(String expression) {
    // This is a simplified evaluator
    // In production, use a proper math expression parser
    try {
      // Remove spaces
      expression = expression.replaceAll(' ', '');

      // Handle basic operations (simplified)
      if (expression.contains('+')) {
        List<String> parts = expression.split('+');
        return double.parse(parts[0]) + double.parse(parts[1]);
      } else if (expression.contains('-')) {
        List<String> parts = expression.split('-');
        if (parts.length == 2 && parts[0].isNotEmpty) {
          return double.parse(parts[0]) - double.parse(parts[1]);
        }
      } else if (expression.contains('*')) {
        List<String> parts = expression.split('*');
        return double.parse(parts[0]) * double.parse(parts[1]);
      } else if (expression.contains('/')) {
        List<String> parts = expression.split('/');
        if (double.parse(parts[1]) != 0) {
          return double.parse(parts[0]) / double.parse(parts[1]);
        }
      }

      // Single number
      return double.parse(expression);
    } catch (e) {
      throw Exception('Invalid expression');
    }
  }

  void _showCalculationFeedback() {
    // Show a subtle animation or feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved to history: ${_inputController.text} = $result'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.primaryColor.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  String _formatResult(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    } else {
      return value
          .toStringAsFixed(8)
          .replaceAll(RegExp(r'0*$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }
  }

  @override
  void dispose() {
    _inputController.dispose();
    _inputFocusNode.dispose();
    super.dispose();
  }
}
