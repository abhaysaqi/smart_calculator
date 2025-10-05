import 'package:flutter/material.dart';

class CommonHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onSettingsTap;
  final bool showSettings;
  final Color? backgroundColor;
  final Color? textColor;
  final Color? iconColor;

  const CommonHeader({
    super.key,
    required this.title,
    this.onSettingsTap,
    this.showSettings = false,
    this.backgroundColor,
    this.textColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? Colors.transparent,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              SizedBox(width: showSettings ? 48 : 0),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: textColor ?? Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              if (showSettings)
                IconButton(
                  onPressed: onSettingsTap ?? () => _showSettingsDialog(context),
                  icon: Icon(
                    Icons.settings,
                    color: iconColor ?? Colors.white,
                    size: 32,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Settings'),
        content: Text('Settings functionality coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}
