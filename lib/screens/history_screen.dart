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
