// // lib/services/history_service.dart
// class HistoryService {
//   static final HistoryService _instance = HistoryService._internal();
//   factory HistoryService() => _instance;
//   HistoryService._internal();

//   final List<Map<String, dynamic>> _history = [];

//   List<Map<String, dynamic>> get history => _history;

//   void addCalculation(String input, String result, String category) {
//     _history.insert(0, {
//       'input': input,
//       'result': result,
//       'category': category,
//       'timestamp': DateTime.now(),
//       'icon': _getCategoryIcon(category),
//     });
    
//     // Keep only last 100 calculations
//     if (_history.length > 100) {
//       _history.removeRange(100, _history.length);
//     }
//   }

//   void clearHistory() {
//     _history.clear();
//   }

//   String _getCategoryIcon(String category) {
//     switch (category.toLowerCase()) {
//       case 'calculator':
//         return '🧮';
//       case 'currency':
//         return '💰';
//       case 'temperature':
//         return '🌡️';
//       case 'length':
//         return '📏';
//       case 'weight':
//         return '⚖️';
//       default:
//         return '📝';
//     }
//   }
// }



import 'package:smart_calculator/helper/db_helper.dart';

class HistoryService {
  static final HistoryService _instance = HistoryService._internal();
  factory HistoryService() => _instance;
  HistoryService._internal();

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  Future<void> addCalculation(String input, String result, String category) async {
    String icon = _getCategoryIcon(category);
    await _databaseHelper.insertCalculation(
      input: input,
      result: result,
      category: category,
      icon: icon,
    );
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final historyData = await _databaseHelper.getAllHistory();
    return historyData.map((item) {
      return {
        ...item,
        'timestamp': DateTime.fromMillisecondsSinceEpoch(item['timestamp']),
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> getHistoryByCategory(String category) async {
    final historyData = await _databaseHelper.getHistoryByCategory(category);
    return historyData.map((item) {
      return {
        ...item,
        'timestamp': DateTime.fromMillisecondsSinceEpoch(item['timestamp']),
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> searchHistory(String query) async {
    final historyData = await _databaseHelper.searchHistory(query);
    return historyData.map((item) {
      return {
        ...item,
        'timestamp': DateTime.fromMillisecondsSinceEpoch(item['timestamp']),
      };
    }).toList();
  }

  Future<void> clearHistory() async {
    await _databaseHelper.clearAllHistory();
  }

  Future<void> deleteCalculation(int id) async {
    await _databaseHelper.deleteCalculation(id);
  }

  String _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'calculator':
        return '🧮';
      case 'currency':
        return '💰';
      case 'temperature':
        return '🌡️';
      case 'length':
        return '📏';
      case 'weight':
        return '⚖️';
      default:
        return '📝';
    }
  }
}
