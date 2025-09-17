// lib/widgets/neumorphic_button.dart
import 'package:flutter/material.dart';
import 'package:smart_calculator/utils/text_styles.dart';

class NeumorphicButton extends StatefulWidget {
  final String text;
  final Color textColor;
  final VoidCallback onPressed;
  final bool isWide;
  final bool isEqual;
  final bool isOperator;
  final double buttonHeight;

  const NeumorphicButton({
    super.key,
    required this.text,
    required this.textColor,
    required this.onPressed,
    this.isWide = false,
    this.isEqual = false,
    this.isOperator = false,
    required this.buttonHeight,
  });

  @override
  State<NeumorphicButton> createState() => _NeumorphicButtonState();
}

class _NeumorphicButtonState extends State<NeumorphicButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => isPressed = true),
      onTapUp: (_) => setState(() => isPressed = false),
      onTapCancel: () => setState(() => isPressed = false),
      onTap: widget.onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: widget.buttonHeight,
        width: widget.isWide ? 150 : 70,
        decoration: _getDecoration(),
        transform: Matrix4.identity()..scale(isPressed ? 0.95 : 1.0),
        child: Center(
          child: Text(
            widget.text,
            style: AppStyles.buttonTextStyle.copyWith(color: widget.textColor),
          ),
        ),
      ),
    );
  }

  BoxDecoration _getDecoration() {
    if (widget.isEqual) {
      return AppStyles.equalButtonDecoration;
    }

    return AppStyles.neumorphicDecoration;
  }
}
