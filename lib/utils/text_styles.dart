// lib/constants/app_styles.dart
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppStyles {
  // Text Styles
  static const TextStyle headerStyle = TextStyle(
    color: AppColors.textWhite,
    fontSize: 18,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.015,
  );

  static const TextStyle calculationStyle = TextStyle(
    color: AppColors.textGray,
    fontSize: 24,
    fontWeight: FontWeight.w500,
  );

  static const TextStyle resultStyle = TextStyle(
    color: AppColors.textWhite,
    fontSize: 60,
    fontWeight: FontWeight.bold,
    letterSpacing: -0.015,
  );

  static const TextStyle buttonTextStyle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.015,
  );

  static const TextStyle navLabelStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    letterSpacing: 0.015,
  );

  static const TextStyle navLabelMutedStyle = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    letterSpacing: 0.015,
  );

  // Box Decorations
  static BoxDecoration neumorphicDecoration = BoxDecoration(
    color: AppColors.buttonBackground,
    borderRadius: BorderRadius.circular(40),
    boxShadow: const [
      BoxShadow(
        color: AppColors.neumorphicDark,
        offset: Offset(8, 8),
        blurRadius: 16,
      ),
      BoxShadow(
        color: AppColors.neumorphicLight,
        offset: Offset(-8, -8),
        blurRadius: 16,
      ),
    ],
  );

  static BoxDecoration neumorphicPressedDecoration = BoxDecoration(
    color: AppColors.buttonBackground,
    borderRadius: BorderRadius.circular(40),
    boxShadow: const [
      BoxShadow(
        color: AppColors.neumorphicDark,
        offset: Offset(4, 4),
        blurRadius: 8,
      ),
      BoxShadow(
        color: AppColors.neumorphicLight,
        offset: Offset(-4, -4),
        blurRadius: 8,
      ),
    ],
  );

  static BoxDecoration glassmorphicDecoration = BoxDecoration(
    color: AppColors.glassWhite.withOpacity(0.05),
    borderRadius: BorderRadius.circular(24),
    border: Border.all(color: AppColors.glassBorder.withOpacity(0.1), width: 1),
    boxShadow: [
      BoxShadow(
        color: AppColors.primaryColor.withOpacity(0.3),
        blurRadius: 100,
      ),
    ],
  );

  static BoxDecoration equalButtonDecoration = BoxDecoration(
    color: AppColors.primaryColor,
    borderRadius: BorderRadius.circular(40),
    boxShadow: const [
      BoxShadow(
        color: AppColors.neumorphicDark,
        offset: Offset(8, 8),
        blurRadius: 16,
      ),
      BoxShadow(
        color: AppColors.neumorphicLight,
        offset: Offset(-8, -8),
        blurRadius: 16,
      ),
    ],
  );

  static BoxDecoration equalButtonPressedDecoration = BoxDecoration(
    color: AppColors.primaryColor,
    borderRadius: BorderRadius.circular(40),
    boxShadow: const [
      BoxShadow(color: Color(0xFF4A0FB9), offset: Offset(4, 4), blurRadius: 8),
      BoxShadow(
        color: Color(0xFF6C17FF),
        offset: Offset(-4, -4),
        blurRadius: 8,
      ),
    ],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      AppColors.gradientStart,
      AppColors.gradientMiddle,
      AppColors.gradientEnd,
    ],
  );

  static const LinearGradient containerGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [AppColors.backgroundColor1, AppColors.backgroundColor2],
  );
}
