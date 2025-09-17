// // lib/screens/converter_screen.dart
// import 'package:flutter/material.dart';
// import 'package:smart_calculator/utils/app_colors.dart';
// import 'package:smart_calculator/widgets/common_app_bar.dart';
// import '../widgets/neumorphic_input_field.dart';

// class ConverterScreen extends StatefulWidget {
//   const ConverterScreen({super.key});

//   @override
//   State<ConverterScreen> createState() => _ConverterScreenState();
// }

// class _ConverterScreenState extends State<ConverterScreen> {
//   // Controllers for input fields
//   final TextEditingController _currencyFromController = TextEditingController(
//     text: '100',
//   );
//   final TextEditingController _currencyToController = TextEditingController(
//     text: '8,340',
//   );
//   final TextEditingController _tempFromController = TextEditingController(
//     text: '32',
//   );
//   final TextEditingController _tempToController = TextEditingController(
//     text: '89.6',
//   );
//   final TextEditingController _lengthFromController = TextEditingController(
//     text: '10',
//   );
//   final TextEditingController _lengthToController = TextEditingController(
//     text: '6.21',
//   );
//   final TextEditingController _weightFromController = TextEditingController(
//     text: '5',
//   );
//   final TextEditingController _weightToController = TextEditingController(
//     text: '11.02',
//   );

//   // Selected units
//   String _currencyFrom = 'USD';
//   String _currencyTo = 'INR';
//   String _lengthFrom = 'km';
//   String _lengthTo = 'mi';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF11111A),
//       body: SafeArea(
//         child: Column(
//           children: [
//             CommonHeader(title: "Converter"),
//             // Content
//             Expanded(
//               child: SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   children: [
//                     const SizedBox(height: 32),

//                     // Currency Section
//                     _buildSection('Currency', _buildCurrencyConverter()),

//                     const SizedBox(height: 32),

//                     // Temperature Section
//                     _buildSection('Temperature', _buildTemperatureConverter()),

//                     const SizedBox(height: 32),

//                     // Length Section
//                     _buildSection('Length', _buildLengthConverter()),

//                     const SizedBox(height: 32),

//                     // Weight Section
//                     _buildSection('Weight', _buildWeightConverter()),

//                     const SizedBox(height: 32),
//                   ],
//                 ),
//               ),
//             ),

//             // Home Indicator
//             // _buildHomeIndicator(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildSection(String title, Widget content) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(left: 16.0, bottom: 24.0),
//           child: Text(
//             title,
//             style: const TextStyle(
//               color: AppColors.textWhite,
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               letterSpacing: -0.015,
//             ),
//           ),
//         ),
//         content,
//       ],
//     );
//   }

//   Widget _buildCurrencyConverter() {
//     return Row(
//       children: [
//         Expanded(
//           child: NeumorphicInputField(
//             controller: _currencyFromController,
//             placeholder: '100',
//             suffix: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: _currencyFrom,
//                 dropdownColor: const Color(0xFF1A1A2E),
//                 style: const TextStyle(
//                   color: Colors.white60,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 icon: const Icon(
//                   Icons.keyboard_arrow_down,
//                   color: Colors.white60,
//                   size: 20,
//                 ),
//                 items: ['USD', 'EUR', 'GBP', 'JPY'].map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _currencyFrom = newValue!;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: NeumorphicInputField(
//             controller: _currencyToController,
//             placeholder: '8,340',
//             suffix: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: _currencyTo,
//                 dropdownColor: const Color(0xFF1A1A2E),
//                 style: const TextStyle(
//                   color: Colors.white60,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 icon: const Icon(
//                   Icons.keyboard_arrow_down,
//                   color: Colors.white60,
//                   size: 20,
//                 ),
//                 items: ['INR', 'USD', 'EUR', 'GBP', 'JPY'].map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _currencyTo = newValue!;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTemperatureConverter() {
//     return Row(
//       children: [
//         Expanded(
//           child: NeumorphicInputField(
//             controller: _tempFromController,
//             placeholder: '32',
//             suffix: const Text(
//               '°C',
//               style: TextStyle(
//                 color: Colors.white60,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: NeumorphicInputField(
//             controller: _tempToController,
//             placeholder: '89.6',
//             suffix: const Text(
//               '°F',
//               style: TextStyle(
//                 color: Colors.white60,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildLengthConverter() {
//     return Row(
//       children: [
//         Expanded(
//           child: NeumorphicInputField(
//             controller: _lengthFromController,
//             placeholder: '10',
//             suffix: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: _lengthFrom,
//                 dropdownColor: const Color(0xFF1A1A2E),
//                 style: const TextStyle(
//                   color: Colors.white60,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 icon: const Icon(
//                   Icons.keyboard_arrow_down,
//                   color: Colors.white60,
//                   size: 20,
//                 ),
//                 items: ['km', 'm', 'in', 'ft'].map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _lengthFrom = newValue!;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: NeumorphicInputField(
//             controller: _lengthToController,
//             placeholder: '6.21',
//             suffix: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: _lengthTo,
//                 dropdownColor: const Color(0xFF1A1A2E),
//                 style: const TextStyle(
//                   color: Colors.white60,
//                   fontWeight: FontWeight.w600,
//                 ),
//                 icon: const Icon(
//                   Icons.keyboard_arrow_down,
//                   color: Colors.white60,
//                   size: 20,
//                 ),
//                 items: ['mi', 'km', 'm', 'in', 'ft'].map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: (String? newValue) {
//                   setState(() {
//                     _lengthTo = newValue!;
//                   });
//                 },
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildWeightConverter() {
//     return Row(
//       children: [
//         Expanded(
//           child: NeumorphicInputField(
//             controller: _weightFromController,
//             placeholder: '5',
//             suffix: const Text(
//               'kg',
//               style: TextStyle(
//                 color: Colors.white60,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//         const SizedBox(width: 16),
//         Expanded(
//           child: NeumorphicInputField(
//             controller: _weightToController,
//             placeholder: '11.02',
//             suffix: const Text(
//               'lb',
//               style: TextStyle(
//                 color: Colors.white60,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   @override
//   void dispose() {
//     _currencyFromController.dispose();
//     _currencyToController.dispose();
//     _tempFromController.dispose();
//     _tempToController.dispose();
//     _lengthFromController.dispose();
//     _lengthToController.dispose();
//     _weightFromController.dispose();
//     _weightToController.dispose();
//     super.dispose();
//   }
// }



// lib/screens/converter_screen.dart
import 'package:flutter/material.dart';
import 'package:smart_calculator/utils/app_colors.dart';
import 'package:smart_calculator/utils/text_styles.dart';
import 'package:smart_calculator/widgets/common_app_bar.dart';
import '../widgets/neumorphic_input_field.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  // Controllers for input fields
  final TextEditingController _currencyFromController = TextEditingController(text: '100');
  final TextEditingController _currencyToController = TextEditingController(text: '8,340');
  final TextEditingController _tempFromController = TextEditingController(text: '32');
  final TextEditingController _tempToController = TextEditingController(text: '89.6');
  final TextEditingController _lengthFromController = TextEditingController(text: '10');
  final TextEditingController _lengthToController = TextEditingController(text: '6.21');
  final TextEditingController _weightFromController = TextEditingController(text: '5');
  final TextEditingController _weightToController = TextEditingController(text: '11.02');

  // Selected units
  String _currencyFrom = 'USD';
  String _currencyTo = 'INR';
  String _tempFrom = '°C';
  String _tempTo = '°F';
  String _lengthFrom = 'km';
  String _lengthTo = 'mi';
  String _weightFrom = 'kg';
  String _weightTo = 'lb';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppStyles.backgroundGradient),
        child: Container(
          decoration: const BoxDecoration(gradient: AppStyles.containerGradient),
          child: Column(
            children: [
              CommonHeader(title: "Converter"),
              
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),

                      // Currency Section
                      _buildSection('💰 Currency', _buildCurrencyConverter()),
                      const SizedBox(height: 24),

                      // Temperature Section
                      _buildSection('🌡️ Temperature', _buildTemperatureConverter()),
                      const SizedBox(height: 24),

                      // Length Section
                      _buildSection('📏 Length', _buildLengthConverter()),
                      const SizedBox(height: 24),

                      // Weight Section
                      _buildSection('⚖️ Weight', _buildWeightConverter()),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget content) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: AppStyles.glassmorphicDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 16),
          content,
        ],
      ),
    );
  }

  Widget _buildCurrencyConverter() {
    return Row(
      children: [
        Expanded(
          child: _buildConverterInput(
            controller: _currencyFromController,
            placeholder: '100',
            unit: _currencyFrom,
            units: ['USD', 'EUR', 'GBP', 'JPY', 'INR'],
            onUnitChanged: (value) => setState(() => _currencyFrom = value!),
          ),
        ),
        _buildSwapButton(),
        Expanded(
          child: _buildConverterInput(
            controller: _currencyToController,
            placeholder: '8,340',
            unit: _currencyTo,
            units: ['INR', 'USD', 'EUR', 'GBP', 'JPY'],
            onUnitChanged: (value) => setState(() => _currencyTo = value!),
          ),
        ),
      ],
    );
  }

  Widget _buildTemperatureConverter() {
    return Row(
      children: [
        Expanded(
          child: _buildConverterInput(
            controller: _tempFromController,
            placeholder: '32',
            unit: _tempFrom,
            units: ['°C', '°F', 'K'],
            onUnitChanged: (value) => setState(() => _tempFrom = value!),
          ),
        ),
        _buildSwapButton(),
        Expanded(
          child: _buildConverterInput(
            controller: _tempToController,
            placeholder: '89.6',
            unit: _tempTo,
            units: ['°F', '°C', 'K'],
            onUnitChanged: (value) => setState(() => _tempTo = value!),
          ),
        ),
      ],
    );
  }

  Widget _buildLengthConverter() {
    return Row(
      children: [
        Expanded(
          child: _buildConverterInput(
            controller: _lengthFromController,
            placeholder: '10',
            unit: _lengthFrom,
            units: ['km', 'm', 'cm', 'in', 'ft', 'yd', 'mi'],
            onUnitChanged: (value) => setState(() => _lengthFrom = value!),
          ),
        ),
        _buildSwapButton(),
        Expanded(
          child: _buildConverterInput(
            controller: _lengthToController,
            placeholder: '6.21',
            unit: _lengthTo,
            units: ['mi', 'km', 'm', 'cm', 'in', 'ft', 'yd'],
            onUnitChanged: (value) => setState(() => _lengthTo = value!),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightConverter() {
    return Row(
      children: [
        Expanded(
          child: _buildConverterInput(
            controller: _weightFromController,
            placeholder: '5',
            unit: _weightFrom,
            units: ['kg', 'g', 'lb', 'oz', 'ton', 'stone'],
            onUnitChanged: (value) => setState(() => _weightFrom = value!),
          ),
        ),
        _buildSwapButton(),
        Expanded(
          child: _buildConverterInput(
            controller: _weightToController,
            placeholder: '11.02',
            unit: _weightTo,
            units: ['lb', 'kg', 'g', 'oz', 'ton', 'stone'],
            onUnitChanged: (value) => setState(() => _weightTo = value!),
          ),
        ),
      ],
    );
  }

  Widget _buildConverterInput({
    required TextEditingController controller,
    required String placeholder,
    required String unit,
    required List<String> units,
    required ValueChanged<String?> onUnitChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1820), Color(0xFF131118)],
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
      child: TextField(
        controller: controller,
        style: const TextStyle(
          color: AppColors.textWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: placeholder,
          hintStyle: TextStyle(
            color: AppColors.textWhite.withOpacity(0.5),
            fontSize: 18,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(16),
          suffixIcon: Container(
            padding: const EdgeInsets.only(right: 8),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: unit,
                dropdownColor: const Color(0xFF1A1820),
                style: const TextStyle(
                  color: AppColors.textPurple,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.textPurple,
                  size: 20,
                ),
                items: units.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: onUnitChanged,
              ),
            ),
          ),
        ),
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildSwapButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFF1A1820), Color(0xFF131118)],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: const [
            BoxShadow(
              color: Color(0xFF0E0C12),
              offset: Offset(3, 3),
              blurRadius: 6,
            ),
            BoxShadow(
              color: Color(0xFF18161E),
              offset: Offset(-3, -3),
              blurRadius: 6,
            ),
          ],
        ),
        child: const Icon(
          Icons.swap_horiz,
          color: AppColors.primaryColor,
          size: 20,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _currencyFromController.dispose();
    _currencyToController.dispose();
    _tempFromController.dispose();
    _tempToController.dispose();
    _lengthFromController.dispose();
    _lengthToController.dispose();
    _weightFromController.dispose();
    _weightToController.dispose();
    super.dispose();
  }
}
