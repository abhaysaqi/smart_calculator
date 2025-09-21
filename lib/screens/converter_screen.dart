// lib/screens/converter_screen.dart
// import 'package:flutter/material.dart';
// import 'package:smart_calculator/utils/app_colors.dart';
// import 'package:smart_calculator/utils/text_styles.dart';
// import 'package:smart_calculator/widgets/common_app_bar.dart';
// import '../widgets/neumorphic_input_field.dart';

// class ConverterScreen extends StatefulWidget {
//   const ConverterScreen({super.key});

//   @override
//   State<ConverterScreen> createState() => _ConverterScreenState();
// }

// class _ConverterScreenState extends State<ConverterScreen> {
//   // Controllers for input fields
//   final TextEditingController _currencyFromController = TextEditingController(text: '100');
//   final TextEditingController _currencyToController = TextEditingController(text: '8,340');
//   final TextEditingController _tempFromController = TextEditingController(text: '32');
//   final TextEditingController _tempToController = TextEditingController(text: '89.6');
//   final TextEditingController _lengthFromController = TextEditingController(text: '10');
//   final TextEditingController _lengthToController = TextEditingController(text: '6.21');
//   final TextEditingController _weightFromController = TextEditingController(text: '5');
//   final TextEditingController _weightToController = TextEditingController(text: '11.02');

//   // Selected units
//   String _currencyFrom = 'USD';
//   String _currencyTo = 'INR';
//   String _tempFrom = '°C';
//   String _tempTo = '°F';
//   String _lengthFrom = 'km';
//   String _lengthTo = 'mi';
//   String _weightFrom = 'kg';
//   String _weightTo = 'lb';

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(gradient: AppStyles.backgroundGradient),
//         child: Container(
//           decoration: const BoxDecoration(gradient: AppStyles.containerGradient),
//           child: Column(
//             children: [
//               CommonHeader(title: "Converter"),
              
//               // Content
//               Expanded(
//                 child: SingleChildScrollView(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Column(
//                     children: [
//                       const SizedBox(height: 24),

//                       // Currency Section
//                       _buildSection('💰 Currency', _buildCurrencyConverter()),
//                       const SizedBox(height: 24),

//                       // Temperature Section
//                       _buildSection('🌡️ Temperature', _buildTemperatureConverter()),
//                       const SizedBox(height: 24),

//                       // Length Section
//                       _buildSection('📏 Length', _buildLengthConverter()),
//                       const SizedBox(height: 24),

//                       // Weight Section
//                       _buildSection('⚖️ Weight', _buildWeightConverter()),
//                       const SizedBox(height: 32),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSection(String title, Widget content) {
//     return Container(
//       padding: const EdgeInsets.all(20),
//       decoration: AppStyles.glassmorphicDecoration,
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             title,
//             style: const TextStyle(
//               color: AppColors.textWhite,
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//               letterSpacing: -0.5,
//             ),
//           ),
//           const SizedBox(height: 16),
//           content,
//         ],
//       ),
//     );
//   }

//   Widget _buildCurrencyConverter() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildConverterInput(
//             controller: _currencyFromController,
//             placeholder: '100',
//             unit: _currencyFrom,
//             units: ['USD', 'EUR', 'GBP', 'JPY', 'INR'],
//             onUnitChanged: (value) => setState(() => _currencyFrom = value!),
//           ),
//         ),
//         _buildSwapButton(),
//         Expanded(
//           child: _buildConverterInput(
//             controller: _currencyToController,
//             placeholder: '8,340',
//             unit: _currencyTo,
//             units: ['INR', 'USD', 'EUR', 'GBP', 'JPY'],
//             onUnitChanged: (value) => setState(() => _currencyTo = value!),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTemperatureConverter() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildConverterInput(
//             controller: _tempFromController,
//             placeholder: '32',
//             unit: _tempFrom,
//             units: ['°C', '°F', 'K'],
//             onUnitChanged: (value) => setState(() => _tempFrom = value!),
//           ),
//         ),
//         _buildSwapButton(),
//         Expanded(
//           child: _buildConverterInput(
//             controller: _tempToController,
//             placeholder: '89.6',
//             unit: _tempTo,
//             units: ['°F', '°C', 'K'],
//             onUnitChanged: (value) => setState(() => _tempTo = value!),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildLengthConverter() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildConverterInput(
//             controller: _lengthFromController,
//             placeholder: '10',
//             unit: _lengthFrom,
//             units: ['km', 'm', 'cm', 'in', 'ft', 'yd', 'mi'],
//             onUnitChanged: (value) => setState(() => _lengthFrom = value!),
//           ),
//         ),
//         _buildSwapButton(),
//         Expanded(
//           child: _buildConverterInput(
//             controller: _lengthToController,
//             placeholder: '6.21',
//             unit: _lengthTo,
//             units: ['mi', 'km', 'm', 'cm', 'in', 'ft', 'yd'],
//             onUnitChanged: (value) => setState(() => _lengthTo = value!),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildWeightConverter() {
//     return Row(
//       children: [
//         Expanded(
//           child: _buildConverterInput(
//             controller: _weightFromController,
//             placeholder: '5',
//             unit: _weightFrom,
//             units: ['kg', 'g', 'lb', 'oz', 'ton', 'stone'],
//             onUnitChanged: (value) => setState(() => _weightFrom = value!),
//           ),
//         ),
//         _buildSwapButton(),
//         Expanded(
//           child: _buildConverterInput(
//             controller: _weightToController,
//             placeholder: '11.02',
//             unit: _weightTo,
//             units: ['lb', 'kg', 'g', 'oz', 'ton', 'stone'],
//             onUnitChanged: (value) => setState(() => _weightTo = value!),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildConverterInput({
//     required TextEditingController controller,
//     required String placeholder,
//     required String unit,
//     required List<String> units,
//     required ValueChanged<String?> onUnitChanged,
//   }) {
//     return Container(
//       decoration: BoxDecoration(
//         gradient: const LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF1A1820), Color(0xFF131118)],
//         ),
//         borderRadius: BorderRadius.circular(16),
//         boxShadow: const [
//           BoxShadow(
//             color: Color(0xFF0E0C12),
//             offset: Offset(4, 4),
//             blurRadius: 8,
//           ),
//           BoxShadow(
//             color: Color(0xFF18161E),
//             offset: Offset(-4, -4),
//             blurRadius: 8,
//           ),
//         ],
//       ),
//       child: TextField(
//         controller: controller,
//         style: const TextStyle(
//           color: AppColors.textWhite,
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//         ),
//         decoration: InputDecoration(
//           hintText: placeholder,
//           hintStyle: TextStyle(
//             color: AppColors.textWhite.withOpacity(0.5),
//             fontSize: 18,
//           ),
//           border: InputBorder.none,
//           contentPadding: const EdgeInsets.all(16),
//           suffixIcon: Container(
//             padding: const EdgeInsets.only(right: 8),
//             child: DropdownButtonHideUnderline(
//               child: DropdownButton<String>(
//                 value: unit,
//                 dropdownColor: const Color(0xFF1A1820),
//                 style: const TextStyle(
//                   color: AppColors.textPurple,
//                   fontWeight: FontWeight.w600,
//                   fontSize: 14,
//                 ),
//                 icon: const Icon(
//                   Icons.keyboard_arrow_down,
//                   color: AppColors.textPurple,
//                   size: 20,
//                 ),
//                 items: units.map((String value) {
//                   return DropdownMenuItem<String>(
//                     value: value,
//                     child: Text(value),
//                   );
//                 }).toList(),
//                 onChanged: onUnitChanged,
//               ),
//             ),
//           ),
//         ),
//         keyboardType: TextInputType.number,
//       ),
//     );
//   }

//   Widget _buildSwapButton() {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 12),
//       child: Container(
//         width: 40,
//         height: 40,
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [Color(0xFF1A1820), Color(0xFF131118)],
//           ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: const [
//             BoxShadow(
//               color: Color(0xFF0E0C12),
//               offset: Offset(3, 3),
//               blurRadius: 6,
//             ),
//             BoxShadow(
//               color: Color(0xFF18161E),
//               offset: Offset(-3, -3),
//               blurRadius: 6,
//             ),
//           ],
//         ),
//         child: const Icon(
//           Icons.swap_horiz,
//           color: AppColors.primaryColor,
//           size: 20,
//         ),
//       ),
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
import '../services/conversion_service.dart';
import '../services/history_service.dart';

class ConverterScreen extends StatefulWidget {
  const ConverterScreen({super.key});

  @override
  State<ConverterScreen> createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  final ConversionService _conversionService = ConversionService();
  final HistoryService _historyService = HistoryService();

  // Controllers
  final TextEditingController _currencyFromController = TextEditingController(text: '100');
  final TextEditingController _currencyToController = TextEditingController();
  final TextEditingController _tempFromController = TextEditingController(text: '32');
  final TextEditingController _tempToController = TextEditingController();
  final TextEditingController _lengthFromController = TextEditingController(text: '10');
  final TextEditingController _lengthToController = TextEditingController();
  final TextEditingController _weightFromController = TextEditingController(text: '5');
  final TextEditingController _weightToController = TextEditingController();

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
  void initState() {
    super.initState();
    _setupInitialConversions();
  }

  void _setupInitialConversions() {
    _convertCurrency();
    _convertTemperature();
    _convertLength();
    _convertWeight();
  }

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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildSection('💰 Currency', _buildCurrencyConverter()),
                      const SizedBox(height: 24),
                      _buildSection('🌡️ Temperature', _buildTemperatureConverter()),
                      const SizedBox(height: 24),
                      _buildSection('📏 Length', _buildLengthConverter()),
                      const SizedBox(height: 24),
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
            onUnitChanged: (value) {
              setState(() => _currencyFrom = value!);
              _convertCurrency();
            },
            onTextChanged: (value) => _convertCurrency(),
          ),
        ),
        _buildSwapButton(() => _swapCurrency()),
        Expanded(
          child: _buildConverterInput(
            controller: _currencyToController,
            placeholder: '8,340',
            unit: _currencyTo,
            units: ['INR', 'USD', 'EUR', 'GBP', 'JPY'],
            onUnitChanged: (value) {
              setState(() => _currencyTo = value!);
              _convertCurrency();
            },
            onTextChanged: (value) => _convertCurrencyReverse(),
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
            onUnitChanged: (value) {
              setState(() => _tempFrom = value!);
              _convertTemperature();
            },
            onTextChanged: (value) => _convertTemperature(),
          ),
        ),
        _buildSwapButton(() => _swapTemperature()),
        Expanded(
          child: _buildConverterInput(
            controller: _tempToController,
            placeholder: '89.6',
            unit: _tempTo,
            units: ['°F', '°C', 'K'],
            onUnitChanged: (value) {
              setState(() => _tempTo = value!);
              _convertTemperature();
            },
            onTextChanged: (value) => _convertTemperatureReverse(),
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
            onUnitChanged: (value) {
              setState(() => _lengthFrom = value!);
              _convertLength();
            },
            onTextChanged: (value) => _convertLength(),
          ),
        ),
        _buildSwapButton(() => _swapLength()),
        Expanded(
          child: _buildConverterInput(
            controller: _lengthToController,
            placeholder: '6.21',
            unit: _lengthTo,
            units: ['mi', 'km', 'm', 'cm', 'in', 'ft', 'yd'],
            onUnitChanged: (value) {
              setState(() => _lengthTo = value!);
              _convertLength();
            },
            onTextChanged: (value) => _convertLengthReverse(),
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
            onUnitChanged: (value) {
              setState(() => _weightFrom = value!);
              _convertWeight();
            },
            onTextChanged: (value) => _convertWeight(),
          ),
        ),
        _buildSwapButton(() => _swapWeight()),
        Expanded(
          child: _buildConverterInput(
            controller: _weightToController,
            placeholder: '11.02',
            unit: _weightTo,
            units: ['lb', 'kg', 'g', 'oz', 'ton', 'stone'],
            onUnitChanged: (value) {
              setState(() => _weightTo = value!);
              _convertWeight();
            },
            onTextChanged: (value) => _convertWeightReverse(),
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
    required ValueChanged<String> onTextChanged,
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
        onChanged: onTextChanged,
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

  Widget _buildSwapButton(VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      child: GestureDetector(
        onTap: onPressed,
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
      ),
    );
  }

  // Conversion Methods
  void _convertCurrency() {
    if (_currencyFromController.text.isNotEmpty) {
      double value = double.tryParse(_currencyFromController.text) ?? 0;
      double result = _conversionService.convertCurrency(value, _currencyFrom, _currencyTo);
      _currencyToController.text = _formatNumber(result);
      _addToHistory('$value $_currencyFrom to $_currencyTo', '${_formatNumber(result)} $_currencyTo', 'Currency');
    }
  }

  void _convertCurrencyReverse() {
    if (_currencyToController.text.isNotEmpty) {
      double value = double.tryParse(_currencyToController.text) ?? 0;
      double result = _conversionService.convertCurrency(value, _currencyTo, _currencyFrom);
      _currencyFromController.text = _formatNumber(result);
    }
  }

  void _convertTemperature() {
    if (_tempFromController.text.isNotEmpty) {
      double value = double.tryParse(_tempFromController.text) ?? 0;
      double result = _conversionService.convertTemperature(value, _tempFrom, _tempTo);
      _tempToController.text = _formatNumber(result);
      _addToHistory('$value$_tempFrom to $_tempTo', '${_formatNumber(result)}$_tempTo', 'Temperature');
    }
  }

  void _convertTemperatureReverse() {
    if (_tempToController.text.isNotEmpty) {
      double value = double.tryParse(_tempToController.text) ?? 0;
      double result = _conversionService.convertTemperature(value, _tempTo, _tempFrom);
      _tempFromController.text = _formatNumber(result);
    }
  }

  void _convertLength() {
    if (_lengthFromController.text.isNotEmpty) {
      double value = double.tryParse(_lengthFromController.text) ?? 0;
      double result = _conversionService.convertLength(value, _lengthFrom, _lengthTo);
      _lengthToController.text = _formatNumber(result);
      _addToHistory('$value $_lengthFrom to $_lengthTo', '${_formatNumber(result)} $_lengthTo', 'Length');
    }
  }

  void _convertLengthReverse() {
    if (_lengthToController.text.isNotEmpty) {
      double value = double.tryParse(_lengthToController.text) ?? 0;
      double result = _conversionService.convertLength(value, _lengthTo, _lengthFrom);
      _lengthFromController.text = _formatNumber(result);
    }
  }

  void _convertWeight() {
    if (_weightFromController.text.isNotEmpty) {
      double value = double.tryParse(_weightFromController.text) ?? 0;
      double result = _conversionService.convertWeight(value, _weightFrom, _weightTo);
      _weightToController.text = _formatNumber(result);
      _addToHistory('$value $_weightFrom to $_weightTo', '${_formatNumber(result)} $_weightTo', 'Weight');
    }
  }

  void _convertWeightReverse() {
    if (_weightToController.text.isNotEmpty) {
      double value = double.tryParse(_weightToController.text) ?? 0;
      double result = _conversionService.convertWeight(value, _weightTo, _weightFrom);
      _weightFromController.text = _formatNumber(result);
    }
  }

  // Swap Methods
  void _swapCurrency() {
    setState(() {
      String tempUnit = _currencyFrom;
      _currencyFrom = _currencyTo;
      _currencyTo = tempUnit;
      
      String tempValue = _currencyFromController.text;
      _currencyFromController.text = _currencyToController.text;
      _currencyToController.text = tempValue;
    });
  }

  void _swapTemperature() {
    setState(() {
      String tempUnit = _tempFrom;
      _tempFrom = _tempTo;
      _tempTo = tempUnit;
      
      String tempValue = _tempFromController.text;
      _tempFromController.text = _tempToController.text;
      _tempToController.text = tempValue;
    });
  }

  void _swapLength() {
    setState(() {
      String tempUnit = _lengthFrom;
      _lengthFrom = _lengthTo;
      _lengthTo = tempUnit;
      
      String tempValue = _lengthFromController.text;
      _lengthFromController.text = _lengthToController.text;
      _lengthToController.text = tempValue;
    });
  }

  void _swapWeight() {
    setState(() {
      String tempUnit = _weightFrom;
      _weightFrom = _weightTo;
      _weightTo = tempUnit;
      
      String tempValue = _weightFromController.text;
      _weightFromController.text = _weightToController.text;
      _weightToController.text = tempValue;
    });
  }

  String _formatNumber(double value) {
    if (value == value.toInt()) {
      return value.toInt().toString();
    } else {
      return value.toStringAsFixed(2).replaceAll(RegExp(r'\.?0*$'), '');
    }
  }

  void _addToHistory(String input, String result, String category) {
    _historyService.addCalculation(input, result, category);
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
