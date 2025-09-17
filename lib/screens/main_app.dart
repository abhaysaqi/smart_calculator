// In your main app, you can use it like this:
import 'package:flutter/material.dart';
import 'package:smart_calculator/screens/calculator_screen.dart';
import 'package:smart_calculator/screens/converter_screen.dart';
import 'package:smart_calculator/screens/history_screen.dart';
import 'package:smart_calculator/widgets/bottom_nav_bar.dart';

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int currentIndex = 0;

  final List<Widget> screens = [
    const CalculatorScreen(),
    const HistoryScreen(),
    const ConverterScreen(), // You'll need to create this
    // const GraphScreen(), // You'll need to create this
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: CommonBottomNavigation(
        currentIndex: currentIndex,
        onTap: (index) => setState(() => currentIndex = index),
      ),
    );
  }
}
