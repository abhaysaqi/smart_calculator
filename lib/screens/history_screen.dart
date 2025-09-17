// // lib/screens/history_screen.dart
// import 'package:flutter/material.dart';
// import 'package:smart_calculator/utils/app_colors.dart';
// import 'package:smart_calculator/widgets/common_app_bar.dart';

// class HistoryScreen extends StatefulWidget {
//   const HistoryScreen({super.key});

//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }

// class _HistoryScreenState extends State<HistoryScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.backgroundColor2,
//       body: Column(
//         children: [
//           // Header
//          CommonHeader(title: "History"),

//           // Content
//           Expanded(child: _buildContent()),

//         ],
//       ),
//     );
//   }

//   Widget _buildContent() {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const SizedBox(height: 16),

//           // Today Section
//           _buildSectionHeader('Today'),
//           const SizedBox(height: 8),
//           _buildHistoryItem(
//             icon: '💸',
//             category: 'Expenses',
//             expression: '1200 + 300',
//             result: '= 1500',
//             color: AppColors.textPurple,
//           ),
//           const SizedBox(height: 16),
//           _buildHistoryItem(
//             icon: '📏',
//             category: 'Conversion',
//             expression: '150 USD to EUR',
//             result: '= 138.50',
//             color: AppColors.textPurple,
//           ),
//           const SizedBox(height: 16),
//           _buildHistoryItem(
//             icon: '📊',
//             category: 'Graph',
//             expression: 'sin(90)',
//             result: '= 1',
//             color: AppColors.textPurple,
//           ),

//           const SizedBox(height: 32),

//           // Yesterday Section
//           _buildSectionHeader('Yesterday'),
//           const SizedBox(height: 8),
//           _buildHistoryItem(
//             icon: '💸',
//             category: 'Expenses',
//             expression: '50 × 5',
//             result: '= 250',
//             color: AppColors.textPurple,
//           ),
//           const SizedBox(height: 16),
//           _buildHistoryItem(
//             icon: '📏',
//             category: 'Conversion',
//             expression: '10km to miles',
//             result: '= 6.21',
//             color: AppColors.textPurple,
//           ),

//           const SizedBox(height: 100), // Space for bottom nav
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0),
//       child: Text(
//         title,
//         style: const TextStyle(
//           color: AppColors.textWhite,
//           fontSize: 18,
//           fontWeight: FontWeight.w600,
//         ),
//       ),
//     );
//   }

//   Widget _buildHistoryItem({
//     required String icon,
//     required String category,
//     required String expression,
//     required String result,
//     required Color color,
//   }) {
//     return Container(
//       padding: const EdgeInsets.all(16),
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
//             offset: Offset(6, 6),
//             blurRadius: 12,
//           ),
//           BoxShadow(
//             color: Color(0xFF18161E),
//             offset: Offset(-6, -6),
//             blurRadius: 12,
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Content
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(icon, style: const TextStyle(fontSize: 16)),
//                     const SizedBox(width: 8),
//                     Text(
//                       category,
//                       style: const TextStyle(
//                         color: AppColors.textMuted,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 6),
//                 Text(
//                   expression,
//                   style: const TextStyle(
//                     color: AppColors.textWhite,
//                     fontSize: 18,
//                     fontWeight: FontWeight.w600,
//                     letterSpacing: 0.5,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   result,
//                   style: const TextStyle(
//                     color: AppColors.textWhite,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           // Thumbnail placeholder
//           Container(
//             width: 96,
//             height: 96,
//             decoration: BoxDecoration(
//               color: color.withOpacity(0.1),
//               borderRadius: BorderRadius.circular(12),
//               border: Border.all(color: color.withOpacity(0.2), width: 1),
//             ),
//             child: Icon(_getCategoryIcon(category), color: color, size: 40),
//           ),
//         ],
//       ),
//     );
//   }

//   IconData _getCategoryIcon(String category) {
//     switch (category.toLowerCase()) {
//       case 'expenses':
//         return Icons.account_balance_wallet;
//       case 'conversion':
//         return Icons.swap_horiz;
//       case 'graph':
//         return Icons.show_chart;
//       default:
//         return Icons.calculate;
//     }
//   }
// }

// lib/screens/history_screen.dart
import 'package:flutter/material.dart';
import 'package:smart_calculator/utils/app_colors.dart';
import 'package:smart_calculator/utils/text_styles.dart';
import 'package:smart_calculator/widgets/common_app_bar.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppStyles.backgroundGradient),
        child: Container(
          decoration: const BoxDecoration(
            gradient: AppStyles.containerGradient,
          ),
          child: Column(
            children: [
              CommonHeader(title: "History"),

              // Content
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Today Section
          _buildSectionHeader('Today'),
          const SizedBox(height: 12),
          _buildHistoryItem(
            icon: '💸',
            category: 'Expenses',
            expression: '1200 + 300',
            result: '= 1500',
            time: '2 hours ago',
          ),
          const SizedBox(height: 12),
          _buildHistoryItem(
            icon: '📏',
            category: 'Conversion',
            expression: '150 USD to EUR',
            result: '= 138.50',
            time: '4 hours ago',
          ),
          const SizedBox(height: 12),
          _buildHistoryItem(
            icon: '📊',
            category: 'Graph',
            expression: 'sin(90)',
            result: '= 1',
            time: '6 hours ago',
          ),

          const SizedBox(height: 32),

          // Yesterday Section
          _buildSectionHeader('Yesterday'),
          const SizedBox(height: 12),
          _buildHistoryItem(
            icon: '💸',
            category: 'Expenses',
            expression: '50 × 5',
            result: '= 250',
            time: 'Yesterday',
          ),
          const SizedBox(height: 12),
          _buildHistoryItem(
            icon: '📏',
            category: 'Conversion',
            expression: '10km to miles',
            result: '= 6.21',
            time: 'Yesterday',
          ),

          const SizedBox(height: 32),

          // This Week Section
          _buildSectionHeader('This Week'),
          const SizedBox(height: 12),
          _buildHistoryItem(
            icon: '🧮',
            category: 'Calculation',
            expression: '√(144) + 25%',
            result: '= 15',
            time: '3 days ago',
          ),
          const SizedBox(height: 12),
          _buildHistoryItem(
            icon: '💰',
            category: 'Finance',
            expression: 'GST on 5000',
            result: '= 5900',
            time: '5 days ago',
          ),

          const SizedBox(height: 100), // Space for bottom nav
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: AppStyles.glassmorphicDecoration.copyWith(
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0E0C12).withOpacity(0.3),
            offset: const Offset(2, 2),
            blurRadius: 4,
          ),
          BoxShadow(
            color: const Color(0xFF18161E).withOpacity(0.3),
            offset: const Offset(-2, -2),
            blurRadius: 4,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.primaryColor, AppColors.textPurple],
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem({
    required String icon,
    required String category,
    required String expression,
    required String result,
    required String time,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(20),
      decoration: AppStyles.glassmorphicDecoration,
      child: Row(
        children: [
          // Icon and Category
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.primaryColor.withOpacity(0.2),
                  AppColors.textPurple.withOpacity(0.2),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Center(
              child: Text(icon, style: const TextStyle(fontSize: 20)),
            ),
          ),

          const SizedBox(width: 16),

          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category,
                      style: const TextStyle(
                        color: AppColors.textPurple,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      time,
                      style: TextStyle(
                        color: AppColors.textWhite.withOpacity(0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  expression,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  result,
                  style: const TextStyle(
                    color: AppColors.textWhite,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),

          // // Action Button
          // Container(
          //   width: 32,
          //   height: 32,
          //   decoration: BoxDecoration(
          //     gradient: const LinearGradient(
          //       begin: Alignment.topLeft,
          //       end: Alignment.bottomRight,
          //       colors: [Color(0xFF1A1820), Color(0xFF131118)],
          //     ),
          //     borderRadius: BorderRadius.circular(8),
          //     boxShadow: const [
          //       BoxShadow(
          //         color: Color(0xFF0E0C12),
          //         offset: Offset(2, 2),
          //         blurRadius: 4,
          //       ),
          //       BoxShadow(
          //         color: Color(0xFF18161E),
          //         offset: Offset(-2, -2),
          //         blurRadius: 4,
          //       ),
          //     ],
          //   ),
          //   child: Icon(
          //     Icons.more_vert,
          //     color: AppColors.textWhite.withOpacity(0.7),
          //     size: 18,
          //   ),
          // ),
        ],
      ),
    );
  }
}
