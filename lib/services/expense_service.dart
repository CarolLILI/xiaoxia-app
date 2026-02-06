import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/expense_model.dart';

/// 支出数据服务
class ExpenseService {
  static Database? _database;
  static const String tableName = 'expenses';

  /// 获取数据库实例
  static Future<Database> get database async {
    _database ??= await _initDatabase();
    return _database!;
  }

  /// 初始化数据库
  static Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'accounting.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $tableName (
            id TEXT PRIMARY KEY,
            amount REAL NOT NULL,
            category TEXT NOT NULL,
            note TEXT NOT NULL,
            date TEXT NOT NULL,
            createdAt TEXT NOT NULL
          )
        ''');
      },
    );
  }

  /// 添加支出记录
  static Future<void> addExpense(Expense expense) async {
    final db = await database;
    await db.insert(
      tableName,
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 更新支出记录
  static Future<void> updateExpense(Expense expense) async {
    final db = await database;
    await db.update(
      tableName,
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  /// 删除支出记录
  static Future<void> deleteExpense(String id) async {
    final db = await database;
    await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// 获取所有记录
  static Future<List<Expense>> getAllExpenses() async {
    final db = await database;
    final maps = await db.query(
      tableName,
      orderBy: 'date DESC',
    );
    return maps.map((map) => Expense.fromMap(map)).toList();
  }

  /// 按日期范围查询
  static Future<List<Expense>> getExpensesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'date >= ? AND date <= ?',
      whereArgs: [
        start.toIso8601String(),
        end.toIso8601String(),
      ],
      orderBy: 'date DESC',
    );
    return maps.map((map) => Expense.fromMap(map)).toList();
  }

  /// 按分类查询
  static Future<List<Expense>> getExpensesByCategory(String category) async {
    final db = await database;
    final maps = await db.query(
      tableName,
      where: 'category = ?',
      whereArgs: [category],
      orderBy: 'date DESC',
    );
    return maps.map((map) => Expense.fromMap(map)).toList();
  }

  /// 获取今日支出
  static Future<double> getTodayTotal() async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(days: 1));
    
    final expenses = await getExpensesByDateRange(startOfDay, endOfDay);
    return expenses.fold<double>(0.0, (sum, e) => sum + e.amount);
  }

  /// 获取本月支出
  static Future<double> getMonthTotal() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);
    
    final expenses = await getExpensesByDateRange(startOfMonth, endOfMonth);
    return expenses.fold<double>(0.0, (sum, e) => sum + e.amount);
  }

  /// 获取统计数据
  static Future<ExpenseStatistics> getStatistics(
    DateTime start,
    DateTime end,
  ) async {
    final expenses = await getExpensesByDateRange(start, end);
    
    final categoryAmounts = <String, double>{};
    final categoryCounts = <String, int>{};
    
    for (final expense in expenses) {
      categoryAmounts[expense.category] = 
          (categoryAmounts[expense.category] ?? 0) + expense.amount;
      categoryCounts[expense.category] = 
          (categoryCounts[expense.category] ?? 0) + 1;
    }
    
    return ExpenseStatistics(
      totalAmount: expenses.fold(0, (sum, e) => sum + e.amount),
      count: expenses.length,
      categoryAmounts: categoryAmounts,
      categoryCounts: categoryCounts,
    );
  }

  /// 获取最近7天每日支出
  static Future<Map<String, double>> getLast7DaysData() async {
    final result = <String, double>{};
    final now = DateTime.now();
    
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final start = DateTime(date.year, date.month, date.day);
      final end = start.add(const Duration(days: 1));
      
      final expenses = await getExpensesByDateRange(start, end);
      final total = expenses.fold(0.0, (sum, e) => sum + e.amount);
      
      result['${date.month}/${date.day}'] = total;
    }
    
    return result;
  }
}
