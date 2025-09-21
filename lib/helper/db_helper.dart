import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String path = join(await getDatabasesPath(), 'calculator_history.db');
    
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDatabase,
    );
  }

  Future<void> _createDatabase(Database db, int version) async {
    await db.execute('''
      CREATE TABLE history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        input TEXT NOT NULL,
        result TEXT NOT NULL,
        category TEXT NOT NULL,
        icon TEXT NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');
  }

  // Insert calculation
  Future<int> insertCalculation({
    required String input,
    required String result,
    required String category,
    required String icon,
  }) async {
    final db = await database;
    return await db.insert('history', {
      'input': input,
      'result': result,
      'category': category,
      'icon': icon,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    });
  }

  // Get all history
  Future<List<Map<String, dynamic>>> getAllHistory() async {
    final db = await database;
    return await db.query(
      'history',
      orderBy: 'timestamp DESC',
    );
  }

  // Get history by category
  Future<List<Map<String, dynamic>>> getHistoryByCategory(String category) async {
    final db = await database;
    return await db.query(
      'history',
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'timestamp DESC',
    );
  }

  // Search history
  Future<List<Map<String, dynamic>>> searchHistory(String query) async {
    final db = await database;
    return await db.query(
      'history',
      where: 'input LIKE ? OR result LIKE ?',
      whereArgs: ['%$query%', '%$query%'],
      orderBy: 'timestamp DESC',
    );
  }

  // Delete specific calculation
  Future<int> deleteCalculation(int id) async {
    final db = await database;
    return await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }

  // Clear all history
  Future<int> clearAllHistory() async {
    final db = await database;
    return await db.delete('history');
  }

  // Update calculation
  Future<int> updateCalculation({
    required int id,
    required String input,
    required String result,
  }) async {
    final db = await database;
    return await db.update(
      'history',
      {
        'input': input,
        'result': result,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
