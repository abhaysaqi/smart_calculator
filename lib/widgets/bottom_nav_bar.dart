// lib/widgets/common_bottom_navigation.dart
import 'package:flutter/material.dart';
import 'package:smart_calculator/utils/app_colors.dart';
import 'package:smart_calculator/utils/app_strings.dart';

class CommonBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CommonBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassWhite.withOpacity(0.05),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        border: Border(
          top: BorderSide(
            color: AppColors.glassBorder.withOpacity(0.1),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.calculate, AppStrings.calculator),
              _buildNavItem(1, Icons.history, AppStrings.history),
              _buildNavItem(2, Icons.swap_horiz, AppStrings.converter),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isActive = currentIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isActive)
            // Circular background for active tab
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(50),
                boxShadow: const [
                  BoxShadow(
                    color: AppColors.neumorphicDark,
                    offset: Offset(3, 3),
                    blurRadius: 6,
                  ),
                  BoxShadow(
                    color: AppColors.neumorphicLight,
                    offset: Offset(-3, -3),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Icon(icon, color: AppColors.textWhite, size: 30),
            )
          else
            // Regular inactive icon
            Icon(icon, color: AppColors.textMuted, size: 28),

          // Labels (only when inactive, to match your design)
          if (!isActive) ...[
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
