// lib/widgets/neumorphic_input_field.dart
import 'package:flutter/material.dart';

class NeumorphicInputField extends StatelessWidget {
  final TextEditingController controller;
  final String placeholder;
  final Widget? suffix;

  const NeumorphicInputField({
    super.key,
    required this.controller,
    required this.placeholder,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A2E),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Color(0xFF111122),
            offset: Offset(4, 4),
            blurRadius: 8,
          ),
          BoxShadow(
            color: Color(0xFF23233A),
            offset: Offset(-4, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              style: const TextStyle(height: 1,
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.normal,
              ),
              decoration: InputDecoration(
                hintText: placeholder,
                hintStyle: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 24,
                  fontWeight: FontWeight.normal,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
              ),
              keyboardType: TextInputType.number,
            ),
          ),
          if (suffix != null)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: suffix!,
            ),
        ],
      ),
    );
  }
}
