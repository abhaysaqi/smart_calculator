// lib/screens/calculator_screen.dart
import 'package:flutter/material.dart';
import 'package:smart_calculator/utils/app_colors.dart';
import 'package:smart_calculator/utils/app_strings.dart';
import 'package:smart_calculator/utils/text_styles.dart';
import 'package:smart_calculator/widgets/common_app_bar.dart';
import '../widgets/neumorphic_button.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String calculation = AppStrings.sampleCalculation;
  String result = AppStrings.sampleResult;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final safeAreaTop = MediaQuery.of(context).padding.top;
    final safeAreaBottom = MediaQuery.of(context).padding.bottom;

    // Calculate available height for button grid
    final availableHeight = screenHeight - safeAreaTop - safeAreaBottom;
    final headerHeight = 80.0; // Approximate header height
    final displayHeight = 160.0; // Approximate display height
    final bottomNavHeight = 100.0; // Approximate bottom nav height
    final buttonGridHeight =
        availableHeight - headerHeight - displayHeight - bottomNavHeight;

    // Calculate button height (5 rows with 4 gaps of 16px each)
    final buttonHeight = (buttonGridHeight - (4 * 16)) / 5;
    final finalButtonHeight = buttonHeight.clamp(50.0, 80.0); // Min 50, Max 80

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppStyles.backgroundGradient),
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppStyles.containerGradient,
          ),
          child: Column(
            children: [
              // Header
              CommonHeader(title: "Calculator"),

              // Display
              _buildDisplay(),

              // Button Grid
              Expanded(child: _buildButtonGrid(finalButtonHeight)),

              
            ],
          ),
        ),
      ),
    );
  }

  

  Widget _buildDisplay() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: AppStyles.glassmorphicDecoration,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(calculation, style: AppStyles.calculationStyle),
            const SizedBox(height: 8),
            Text(result, style: AppStyles.resultStyle),
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
          // Row 1
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicButton(
                text: AppStrings.clear,
                textColor: AppColors.textPurple,
                onPressed: () {},
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.plusMinus,
                textColor: AppColors.textPurple,
                onPressed: () {},
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.percent,
                textColor: AppColors.textPurple,
                onPressed: () {},
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.divide,
                textColor: AppColors.primaryColor,
                onPressed: () {},
                buttonHeight: buttonHeight,
              ),
            ],
          ),

          // Row 2
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicButton(
                text: AppStrings.seven,
                textColor: AppColors.textWhite,
                onPressed: () {},
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.eight,
                textColor: AppColors.textWhite,
                onPressed: () {},
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.nine,
                textColor: AppColors.textWhite,
                onPressed: () {},
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.multiply,
                textColor: AppColors.primaryColor,
                onPressed: () {},
                buttonHeight: buttonHeight,
              ),
            ],
          ),

          // Row 3
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicButton(
                text: AppStrings.four,
                textColor: AppColors.textWhite,
                onPressed: () {},
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.five,
                textColor: AppColors.textWhite,
                onPressed: () {},
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.six,
                textColor: AppColors.textWhite,
                onPressed: () {},
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.subtract,
                textColor: AppColors.primaryColor,
                onPressed: () {},
                buttonHeight: buttonHeight,
              ),
            ],
          ),

          // Row 4
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicButton(
                text: AppStrings.one,
                textColor: AppColors.textWhite,
                onPressed: () {},
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.two,
                textColor: AppColors.textWhite,
                onPressed: () {},
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.three,
                textColor: AppColors.textWhite,
                onPressed: () {},
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.add,
                textColor: AppColors.primaryColor,
                onPressed: () {},
                buttonHeight: buttonHeight,
              ),
            ],
          ),

          // Row 5
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              NeumorphicButton(
                text: AppStrings.zero,
                textColor: AppColors.textWhite,
                onPressed: () {},
                isWide: true,
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.decimal,
                textColor: AppColors.textWhite,
                onPressed: () {},
                buttonHeight: buttonHeight,
              ),
              NeumorphicButton(
                text: AppStrings.equals,
                textColor: AppColors.textWhite,
                onPressed: () {},
                isEqual: true,
                buttonHeight: buttonHeight,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
