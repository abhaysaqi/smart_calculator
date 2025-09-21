// lib/screens/history_screen.dart
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:smart_calculator/utils/app_colors.dart';
// import 'package:smart_calculator/utils/text_styles.dart';
// import 'package:smart_calculator/widgets/common_app_bar.dart';
// import '../services/history_service.dart';

// class HistoryScreen extends StatefulWidget {
//   const HistoryScreen({super.key});

//   @override
//   State<HistoryScreen> createState() => _HistoryScreenState();
// }

// class _HistoryScreenState extends State<HistoryScreen>
//     with TickerProviderStateMixin {
//   final HistoryService _historyService = HistoryService();
//   late AnimationController _fadeAnimationController;
//   late Animation<double> _fadeAnimation;
//   String _searchQuery = '';
//   String _selectedFilter = 'All';

//   @override
//   void initState() {
//     super.initState();
//     _setupAnimations();
//     // Add some sample data if history is empty (for demo purposes)
//     _initializeSampleData();
//   }

//   void _setupAnimations() {
//     _fadeAnimationController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     );
//     _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
//       CurvedAnimation(
//         parent: _fadeAnimationController,
//         curve: Curves.easeInOut,
//       ),
//     );
//     _fadeAnimationController.forward();
//   }

//   void _initializeSampleData() {
//     // Add sample calculations if history is empty
//     if (_historyService.history.isEmpty) {
//       // Recent calculations
//       _historyService.addCalculation('125 + 75', '200', 'Calculator');
//       _historyService.addCalculation('1500 - 300', '1200', 'Calculator');
//       _historyService.addCalculation('50 × 12', '600', 'Calculator');

//       // Conversions
//       _historyService.addCalculation('100 USD to INR', '8340 INR', 'Currency');
//       _historyService.addCalculation('10 km to mi', '6.21 mi', 'Length');
//       _historyService.addCalculation('32°C to °F', '89.6°F', 'Temperature');
//       _historyService.addCalculation('5 kg to lb', '11.02 lb', 'Weight');

//       // Some older calculations
//       Future.delayed(const Duration(milliseconds: 100), () {
//         _historyService.addCalculation('15% of 2000', '300', 'Calculator');
//         _historyService.addCalculation('√144 + 25', '37', 'Calculator');
//         _historyService.addCalculation('GST on 5000', '5900', 'Calculator');
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         decoration: const BoxDecoration(gradient: AppStyles.backgroundGradient),
//         child: Container(
//           decoration: const BoxDecoration(
//             gradient: AppStyles.containerGradient,
//           ),
//           child: Column(
//             children: [
//               CommonHeader(title: "History"),
//               _buildSearchAndFilter(),
//               Expanded(child: _buildContent()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildSearchAndFilter() {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//       child: Column(
//         children: [
//           // Search Bar
//           Container(
//             decoration: AppStyles.glassmorphicDecoration.copyWith(
//               boxShadow: [
//                 BoxShadow(
//                   color: const Color(0xFF0E0C12).withOpacity(0.2),
//                   offset: const Offset(2, 2),
//                   blurRadius: 8,
//                 ),
//               ],
//             ),
//             child: TextField(
//               onChanged: (value) => setState(() => _searchQuery = value),
//               style: const TextStyle(color: AppColors.textWhite),
//               decoration: InputDecoration(
//                 hintText: 'Search calculations...',
//                 hintStyle: TextStyle(
//                   color: AppColors.textWhite.withOpacity(0.5),
//                 ),
//                 prefixIcon: Icon(
//                   Icons.search,
//                   color: AppColors.textWhite.withOpacity(0.7),
//                 ),
//                 border: InputBorder.none,
//                 contentPadding: const EdgeInsets.all(16),
//                 suffixIcon: _searchQuery.isNotEmpty
//                     ? GestureDetector(
//                         onTap: () => setState(() => _searchQuery = ''),
//                         child: Icon(
//                           Icons.clear,
//                           color: AppColors.textWhite.withOpacity(0.7),
//                         ),
//                       )
//                     : null,
//               ),
//             ),
//           ),

//           const SizedBox(height: 12),

//           // Filter Chips
//           SingleChildScrollView(
//             scrollDirection: Axis.horizontal,
//             child: Row(
//               children: [
//                 _buildFilterChip('All'),
//                 _buildFilterChip('Calculator'),
//                 _buildFilterChip('Currency'),
//                 _buildFilterChip('Temperature'),
//                 _buildFilterChip('Length'),
//                 _buildFilterChip('Weight'),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildFilterChip(String filter) {
//     final isSelected = _selectedFilter == filter;
//     return GestureDetector(
//       onTap: () {
//         HapticFeedback.selectionClick();
//         setState(() => _selectedFilter = filter);
//       },
//       child: Container(
//         margin: const EdgeInsets.only(right: 8),
//         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//         decoration: BoxDecoration(
//           gradient: isSelected
//               ? const LinearGradient(
//                   colors: [AppColors.primaryColor, AppColors.textPurple],
//                 )
//               : const LinearGradient(
//                   colors: [Color(0xFF1A1820), Color(0xFF131118)],
//                 ),
//           borderRadius: BorderRadius.circular(20),
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF0E0C12).withOpacity(0.3),
//               offset: const Offset(2, 2),
//               blurRadius: 4,
//             ),
//           ],
//         ),
//         child: Text(
//           filter,
//           style: TextStyle(
//             color: isSelected
//                 ? Colors.white
//                 : AppColors.textWhite.withOpacity(0.7),
//             fontSize: 14,
//             fontWeight: FontWeight.w500,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildContent() {
//     final filteredHistory = _getFilteredHistory();

//     if (filteredHistory.isEmpty && _historyService.history.isEmpty) {
//       return _buildEmptyState();
//     }

//     if (filteredHistory.isEmpty) {
//       return _buildNoResultsState();
//     }

//     // Group by date
//     final groupedHistory = _groupHistoryByDate(filteredHistory);

//     return RefreshIndicator(
//       onRefresh: () async {
//         await Future.delayed(const Duration(milliseconds: 500));
//         setState(() {});
//       },
//       backgroundColor: const Color(0xFF1A1820),
//       color: AppColors.primaryColor,
//       child: SingleChildScrollView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         padding: const EdgeInsets.symmetric(horizontal: 16.0),
//         child: FadeTransition(
//           opacity: _fadeAnimation,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const SizedBox(height: 8),

//               // Clear History Button
//               if (_historyService.history.isNotEmpty)
//                 _buildClearHistoryButton(),

//               // History Sections
//               ...groupedHistory.entries.map((entry) {
//                 return Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     _buildSectionHeader(entry.key, entry.value.length),
//                     const SizedBox(height: 12),
//                     ...entry.value.asMap().entries.map(
//                       (item) => _buildAnimatedHistoryItem(item.value, item.key),
//                     ),
//                     const SizedBox(height: 24),
//                   ],
//                 );
//               }),

//               const SizedBox(height: 100),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildEmptyState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Container(
//             width: 120,
//             height: 120,
//             decoration: BoxDecoration(
//               gradient: LinearGradient(
//                 colors: [
//                   AppColors.primaryColor.withOpacity(0.1),
//                   AppColors.textPurple.withOpacity(0.1),
//                 ],
//               ),
//               shape: BoxShape.circle,
//             ),
//             child: Icon(
//               Icons.history,
//               size: 60,
//               color: AppColors.textWhite.withOpacity(0.3),
//             ),
//           ),
//           const SizedBox(height: 24),
//           Text(
//             'No calculations yet',
//             style: TextStyle(
//               color: AppColors.textWhite.withOpacity(0.8),
//               fontSize: 20,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'Start calculating to see your history here',
//             style: TextStyle(
//               color: AppColors.textWhite.withOpacity(0.5),
//               fontSize: 16,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           const SizedBox(height: 32),
//           _buildGetStartedButton(),
//         ],
//       ),
//     );
//   }

//   Widget _buildNoResultsState() {
//     return Center(
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Icon(
//             Icons.search_off,
//             size: 60,
//             color: AppColors.textWhite.withOpacity(0.3),
//           ),
//           const SizedBox(height: 20),
//           Text(
//             'No results found',
//             style: TextStyle(
//               color: AppColors.textWhite.withOpacity(0.8),
//               fontSize: 18,
//               fontWeight: FontWeight.w600,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Text(
//             'Try adjusting your search or filter',
//             style: TextStyle(
//               color: AppColors.textWhite.withOpacity(0.5),
//               fontSize: 14,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGetStartedButton() {
//     return GestureDetector(
//       onTap: () {
//         if (Navigator.of(context).canPop()) {
//           Navigator.of(context).pop();
//         }
//       },

//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//         decoration: BoxDecoration(
//           gradient: const LinearGradient(
//             colors: [AppColors.primaryColor, AppColors.textPurple],
//           ),
//           borderRadius: BorderRadius.circular(25),
//           boxShadow: [
//             BoxShadow(
//               color: AppColors.primaryColor.withOpacity(0.3),
//               offset: const Offset(0, 4),
//               blurRadius: 12,
//             ),
//           ],
//         ),
//         child: const Text(
//           'Start Calculating',
//           style: TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildClearHistoryButton() {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 20),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(
//             '${_historyService.history.length} calculations',
//             style: TextStyle(
//               color: AppColors.textWhite.withOpacity(0.6),
//               fontSize: 14,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           GestureDetector(
//             onTap: _showClearDialog,
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF1A1820), Color(0xFF131118)],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Color(0xFF0E0C12),
//                     offset: Offset(2, 2),
//                     blurRadius: 4,
//                   ),
//                 ],
//               ),
//               child: Row(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Icon(
//                     Icons.clear_all,
//                     color: Colors.red.withOpacity(0.8),
//                     size: 16,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'Clear All',
//                     style: TextStyle(
//                       color: Colors.red.withOpacity(0.8),
//                       fontSize: 14,
//                       fontWeight: FontWeight.w500,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSectionHeader(String title, int count) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//       decoration: AppStyles.glassmorphicDecoration.copyWith(
//         boxShadow: [
//           BoxShadow(
//             color: const Color(0xFF0E0C12).withOpacity(0.3),
//             offset: const Offset(2, 2),
//             blurRadius: 4,
//           ),
//         ],
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Row(
//             children: [
//               Container(
//                 width: 4,
//                 height: 20,
//                 decoration: BoxDecoration(
//                   gradient: const LinearGradient(
//                     begin: Alignment.topCenter,
//                     end: Alignment.bottomCenter,
//                     colors: [AppColors.primaryColor, AppColors.textPurple],
//                   ),
//                   borderRadius: BorderRadius.circular(2),
//                 ),
//               ),
//               const SizedBox(width: 12),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   color: AppColors.textWhite,
//                   fontSize: 18,
//                   fontWeight: FontWeight.w600,
//                   letterSpacing: -0.5,
//                 ),
//               ),
//             ],
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//             decoration: BoxDecoration(
//               color: AppColors.primaryColor.withOpacity(0.2),
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(
//                 color: AppColors.primaryColor.withOpacity(0.3),
//               ),
//             ),
//             child: Text(
//               count.toString(),
//               style: const TextStyle(
//                 color: AppColors.primaryColor,
//                 fontSize: 12,
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildAnimatedHistoryItem(Map<String, dynamic> item, int index) {
//     return TweenAnimationBuilder<double>(
//       duration: Duration(milliseconds: 300 + (index * 100)),
//       tween: Tween<double>(begin: 0.0, end: 1.0),
//       builder: (context, value, child) {
//         return Transform.translate(
//           offset: Offset(0, (1 - value) * 50),
//           child: Opacity(
//             opacity: value,
//             child: _buildHistoryItem(
//               icon: item['icon'],
//               category: item['category'],
//               expression: item['input'],
//               result: item['result'],
//               time: _formatTime(item['timestamp']),
//               onTap: () => _onHistoryItemTap(item),
//               onLongPress: () => _onHistoryItemLongPress(item),
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _buildHistoryItem({
//     required String icon,
//     required String category,
//     required String expression,
//     required String result,
//     required String time,
//     required VoidCallback onTap,
//     required VoidCallback onLongPress,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       onLongPress: onLongPress,
//       child: Container(
//         margin: const EdgeInsets.only(bottom: 12),
//         padding: const EdgeInsets.all(20),
//         decoration: AppStyles.glassmorphicDecoration.copyWith(
//           boxShadow: [
//             BoxShadow(
//               color: const Color(0xFF0E0C12).withOpacity(0.4),
//               offset: const Offset(4, 4),
//               blurRadius: 8,
//             ),
//             BoxShadow(
//               color: const Color(0xFF18161E).withOpacity(0.4),
//               offset: const Offset(-4, -4),
//               blurRadius: 8,
//             ),
//           ],
//         ),
//         child: Row(
//           children: [
//             Container(
//               width: 48,
//               height: 48,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.topLeft,
//                   end: Alignment.bottomRight,
//                   colors: [
//                     _getCategoryColor(category).withOpacity(0.2),
//                     _getCategoryColor(category).withOpacity(0.1),
//                   ],
//                 ),
//                 borderRadius: BorderRadius.circular(12),
//                 border: Border.all(
//                   color: _getCategoryColor(category).withOpacity(0.3),
//                   width: 1,
//                 ),
//               ),
//               child: Center(
//                 child: Text(icon, style: const TextStyle(fontSize: 20)),
//               ),
//             ),
//             const SizedBox(width: 16),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 2,
//                         ),
//                         decoration: BoxDecoration(
//                           color: _getCategoryColor(category).withOpacity(0.1),
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(
//                             color: _getCategoryColor(category).withOpacity(0.3),
//                           ),
//                         ),
//                         child: Text(
//                           category,
//                           style: TextStyle(
//                             color: _getCategoryColor(category),
//                             fontSize: 12,
//                             fontWeight: FontWeight.w600,
//                           ),
//                         ),
//                       ),
//                       Text(
//                         time,
//                         style: TextStyle(
//                           color: AppColors.textWhite.withOpacity(0.5),
//                           fontSize: 12,
//                           fontWeight: FontWeight.w500,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     expression,
//                     style: const TextStyle(
//                       color: AppColors.textWhite,
//                       fontSize: 16,
//                       fontWeight: FontWeight.w500,
//                       letterSpacing: 0.3,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     result,
//                     style: const TextStyle(
//                       color: AppColors.textWhite,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       letterSpacing: 0.5,
//                     ),
//                     maxLines: 1,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                 ],
//               ),
//             ),
//             const SizedBox(width: 8),
//             Container(
//               width: 32,
//               height: 32,
//               decoration: BoxDecoration(
//                 gradient: const LinearGradient(
//                   colors: [Color(0xFF1A1820), Color(0xFF131118)],
//                 ),
//                 borderRadius: BorderRadius.circular(8),
//                 boxShadow: const [
//                   BoxShadow(
//                     color: Color(0xFF0E0C12),
//                     offset: Offset(2, 2),
//                     blurRadius: 4,
//                   ),
//                 ],
//               ),
//               child: Icon(
//                 Icons.more_vert,
//                 color: AppColors.textWhite.withOpacity(0.6),
//                 size: 16,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   List<Map<String, dynamic>> _getFilteredHistory() {
//     var history = _historyService.history;

//     // Filter by category
//     if (_selectedFilter != 'All') {
//       history = history
//           .where((item) => item['category'] == _selectedFilter)
//           .toList();
//     }

//     // Filter by search query
//     if (_searchQuery.isNotEmpty) {
//       history = history.where((item) {
//         final input = item['input'].toString().toLowerCase();
//         final result = item['result'].toString().toLowerCase();
//         final category = item['category'].toString().toLowerCase();
//         final query = _searchQuery.toLowerCase();

//         return input.contains(query) ||
//             result.contains(query) ||
//             category.contains(query);
//       }).toList();
//     }

//     return history;
//   }

//   Map<String, List<Map<String, dynamic>>> _groupHistoryByDate(
//     List<Map<String, dynamic>> history,
//   ) {
//     final Map<String, List<Map<String, dynamic>>> grouped = {};

//     for (var item in history) {
//       final dateKey = _getDateKey(item['timestamp']);
//       if (!grouped.containsKey(dateKey)) {
//         grouped[dateKey] = [];
//       }
//       grouped[dateKey]!.add(item);
//     }

//     return grouped;
//   }

//   String _getDateKey(DateTime dateTime) {
//     final now = DateTime.now();
//     final today = DateTime(now.year, now.month, now.day);
//     final yesterday = today.subtract(const Duration(days: 1));
//     final itemDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

//     if (itemDate == today) {
//       return 'Today';
//     } else if (itemDate == yesterday) {
//       return 'Yesterday';
//     } else if (now.difference(itemDate).inDays < 7) {
//       return 'This Week';
//     } else if (now.difference(itemDate).inDays < 30) {
//       return 'This Month';
//     } else {
//       return '${_getMonthName(dateTime.month)} ${dateTime.year}';
//     }
//   }

//   String _getMonthName(int month) {
//     const months = [
//       '',
//       'January',
//       'February',
//       'March',
//       'April',
//       'May',
//       'June',
//       'July',
//       'August',
//       'September',
//       'October',
//       'November',
//       'December',
//     ];
//     return months[month];
//   }

//   String _formatTime(DateTime dateTime) {
//     final now = DateTime.now();
//     final difference = now.difference(dateTime);

//     if (difference.inMinutes < 1) {
//       return 'Just now';
//     } else if (difference.inHours < 1) {
//       return '${difference.inMinutes}m ago';
//     } else if (difference.inDays < 1) {
//       return '${difference.inHours}h ago';
//     } else if (difference.inDays < 7) {
//       return '${difference.inDays}d ago';
//     } else {
//       return '${dateTime.day}/${dateTime.month}';
//     }
//   }

//   Color _getCategoryColor(String category) {
//     switch (category.toLowerCase()) {
//       case 'calculator':
//         return AppColors.primaryColor;
//       case 'currency':
//         return Colors.green;
//       case 'temperature':
//         return Colors.orange;
//       case 'length':
//         return Colors.blue;
//       case 'weight':
//         return Colors.purple;
//       default:
//         return AppColors.textPurple;
//     }
//   }

//   void _onHistoryItemTap(Map<String, dynamic> item) {
//     HapticFeedback.lightImpact();
//     // Copy result to clipboard
//     Clipboard.setData(ClipboardData(text: item['result']));

//     // Show snackbar
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text('Copied "${item['result']}" to clipboard'),
//         backgroundColor: AppColors.primaryColor,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   void _onHistoryItemLongPress(Map<String, dynamic> item) {
//     HapticFeedback.mediumImpact();
//     _showItemOptions(item);
//   }

//   void _showItemOptions(Map<String, dynamic> item) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         padding: const EdgeInsets.all(20),
//         decoration: const BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Color(0xFF1A1820), Color(0xFF131118)],
//           ),
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               width: 40,
//               height: 4,
//               decoration: BoxDecoration(
//                 color: AppColors.textWhite.withOpacity(0.3),
//                 borderRadius: BorderRadius.circular(2),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ListTile(
//               leading: const Icon(Icons.copy, color: AppColors.primaryColor),
//               title: const Text(
//                 'Copy Result',
//                 style: TextStyle(color: AppColors.textWhite),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 Clipboard.setData(ClipboardData(text: item['result']));
//                 _showCopiedSnackbar('Result copied');
//               },
//             ),
//             ListTile(
//               leading: const Icon(
//                 Icons.content_copy,
//                 color: AppColors.textPurple,
//               ),
//               title: const Text(
//                 'Copy Expression',
//                 style: TextStyle(color: AppColors.textWhite),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 Clipboard.setData(ClipboardData(text: item['input']));
//                 _showCopiedSnackbar('Expression copied');
//               },
//             ),
//             ListTile(
//               leading: const Icon(Icons.share, color: Colors.blue),
//               title: const Text(
//                 'Share',
//                 style: TextStyle(color: AppColors.textWhite),
//               ),
//               onTap: () {
//                 Navigator.pop(context);
//                 // Implement share functionality
//                 _showCopiedSnackbar('Share functionality coming soon');
//               },
//             ),
//             const SizedBox(height: 20),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showCopiedSnackbar(String message) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(
//         content: Text(message),
//         backgroundColor: AppColors.primaryColor,
//         behavior: SnackBarBehavior.floating,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         duration: const Duration(seconds: 2),
//       ),
//     );
//   }

//   void _showClearDialog() {
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         backgroundColor: const Color(0xFF1A1820),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
//         title: const Text(
//           'Clear History',
//           style: TextStyle(
//             color: AppColors.textWhite,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//         content: Text(
//           'Are you sure you want to clear all ${_historyService.history.length} calculations?',
//           style: TextStyle(color: AppColors.textWhite.withOpacity(0.8)),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context),
//             child: const Text(
//               'Cancel',
//               style: TextStyle(color: AppColors.textPurple),
//             ),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 _historyService.clearHistory();
//               });
//               Navigator.pop(context);
//               _showCopiedSnackbar('History cleared');
//             },
//             child: Text(
//               'Clear All',
//               style: TextStyle(color: Colors.red.shade400),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   @override
//   void dispose() {
//     _fadeAnimationController.dispose();
//     super.dispose();
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smart_calculator/utils/app_colors.dart';
import 'package:smart_calculator/utils/text_styles.dart';
import 'package:smart_calculator/widgets/common_app_bar.dart';
import '../services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final HistoryService _historyService = HistoryService();
  List<Map<String, dynamic>> _history = [];
  List<Map<String, dynamic>> _filteredHistory = [];
  String _searchQuery = '';
  String _selectedFilter = 'All';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    try {
      final history = await _historyService.getHistory();
      setState(() {
        _history = history;
        _filteredHistory = history;
        _isLoading = false;
      });
      _applyFilters();
    } catch (e) {
      setState(() => _isLoading = false);
      _showErrorSnackbar('Failed to load history');
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredHistory = _history;

      // Apply category filter
      if (_selectedFilter != 'All') {
        _filteredHistory = _filteredHistory
            .where((item) => item['category'] == _selectedFilter)
            .toList();
      }

      // Apply search filter
      if (_searchQuery.isNotEmpty) {
        _filteredHistory = _filteredHistory.where((item) {
          final input = item['input'].toString().toLowerCase();
          final result = item['result'].toString().toLowerCase();
          final query = _searchQuery.toLowerCase();
          return input.contains(query) || result.contains(query);
        }).toList();
      }
    });
  }

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
              _buildSearchAndFilter(),
              Expanded(child: _buildContent()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primaryColor),
      );
    }

    if (_filteredHistory.isEmpty) {
      return _buildEmptyState();
    }

    return RefreshIndicator(
      onRefresh: _loadHistory,
      backgroundColor: const Color(0xFF1A1820),
      color: AppColors.primaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _filteredHistory.length + 1, // +1 for clear button
        itemBuilder: (context, index) {
          if (index == 0) {
            return _buildClearHistoryButton();
          }

          final item = _filteredHistory[index - 1];
          return _buildHistoryItem(item);
        },
      ),
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> item) {
    return Dismissible(
      key: Key(item['id'].toString()),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) => _confirmDelete(item),
      background: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.red.withOpacity(0.8),
          borderRadius: BorderRadius.circular(16),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white, size: 24),
      ),
      child: GestureDetector(
        onTap: () => _onHistoryItemTap(item),
        onLongPress: () => _showItemOptions(item),
        child: Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(20),
          decoration: AppStyles.glassmorphicDecoration,
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      _getCategoryColor(item['category']).withOpacity(0.2),
                      _getCategoryColor(item['category']).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _getCategoryColor(item['category']).withOpacity(0.3),
                  ),
                ),
                child: Center(
                  child: Text(
                    item['icon'],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: _getCategoryColor(
                              item['category'],
                            ).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getCategoryColor(
                                item['category'],
                              ).withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            item['category'],
                            style: TextStyle(
                              color: _getCategoryColor(item['category']),
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        Text(
                          _formatTime(item['timestamp']),
                          style: TextStyle(
                            color: AppColors.textWhite.withOpacity(0.5),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      item['input'],
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item['result'],
                      style: const TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Rest of the methods remain the same as previous implementation
  Widget _buildSearchAndFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        children: [
          Container(
            decoration: AppStyles.glassmorphicDecoration,
            child: TextField(
              onChanged: (value) {
                setState(() => _searchQuery = value);
                _applyFilters();
              },
              style: const TextStyle(color: AppColors.textWhite),
              decoration: InputDecoration(
                hintText: 'Search calculations...',
                hintStyle: TextStyle(
                  color: AppColors.textWhite.withOpacity(0.5),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textWhite.withOpacity(0.7),
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                'All',
                'Calculator',
                'Currency',
                'Temperature',
                'Length',
                'Weight',
              ].map((filter) => _buildFilterChip(filter)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String filter) {
    final isSelected = _selectedFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedFilter = filter);
        _applyFilters();
      },
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected
              ? const LinearGradient(
                  colors: [AppColors.primaryColor, AppColors.textPurple],
                )
              : const LinearGradient(
                  colors: [Color(0xFF1A1820), Color(0xFF131118)],
                ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          filter,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : AppColors.textWhite.withOpacity(0.7),
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: AppColors.textWhite.withOpacity(0.3),
          ),
          const SizedBox(height: 20),
          Text(
            'No calculations found',
            style: TextStyle(
              color: AppColors.textWhite.withOpacity(0.8),
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildClearHistoryButton() {
    if (_history.isEmpty) return const SizedBox();

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${_history.length} calculations',
            style: TextStyle(
              color: AppColors.textWhite.withOpacity(0.6),
              fontSize: 14,
            ),
          ),
          GestureDetector(
            onTap: _confirmClearAll,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.clear_all, color: Colors.red, size: 16),
                  const SizedBox(width: 8),
                  const Text(
                    'Clear All',
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<bool?> _confirmDelete(Map<String, dynamic> item) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1820),
        title: const Text(
          'Delete Calculation',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Delete "${item['input']}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmClearAll() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1A1820),
        title: const Text(
          'Clear All History',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This will permanently delete all calculations.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _historyService.clearHistory();
              _loadHistory();
              _showSuccessSnackbar('History cleared');
            },
            child: const Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _onHistoryItemTap(Map<String, dynamic> item) {
    Clipboard.setData(ClipboardData(text: item['result']));
    _showSuccessSnackbar('Copied "${item['result']}" to clipboard');
  }

  void _showItemOptions(Map<String, dynamic> item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Color(0xFF1A1820),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.copy, color: AppColors.primaryColor),
              title: const Text(
                'Copy Result',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Clipboard.setData(ClipboardData(text: item['result']));
                _showSuccessSnackbar('Result copied');
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete, color: Colors.red),
              title: const Text(
                'Delete',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () async {
                Navigator.pop(context);
                await _historyService.deleteCalculation(item['id']);
                _loadHistory();
                _showSuccessSnackbar('Calculation deleted');
              },
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'calculator':
        return AppColors.primaryColor;
      case 'currency':
        return Colors.green;
      case 'temperature':
        return Colors.orange;
      case 'length':
        return Colors.blue;
      case 'weight':
        return Colors.purple;
      default:
        return AppColors.textPurple;
    }
  }

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    return '${difference.inDays}d ago';
  }

  void _showSuccessSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.primaryColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
