import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/health_model.dart';

/// 健康数据服务
class HealthService {
  static Database? _database;
  
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  static Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'health_database.db');
    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // BMI记录表
        await db.execute('''
          CREATE TABLE bmi_records(
            id TEXT PRIMARY KEY,
            height REAL,
            weight REAL,
            bmi REAL,
            date TEXT
          )
        ''');
        
        // 健康数据表（步数、饮水、睡眠等）
        await db.execute('''
          CREATE TABLE health_data(
            id TEXT PRIMARY KEY,
            type TEXT,
            value REAL,
            unit TEXT,
            date TEXT,
            note TEXT
          )
        ''');
      },
    );
  }
  
  // ========== BMI 操作 ==========
  
  /// 保存BMI记录
  static Future<void> saveBMIRecord(BMIRecord record) async {
    final db = await database;
    await db.insert(
      'bmi_records',
      record.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  /// 获取所有BMI记录
  static Future<List<BMIRecord>> getBMIRecords() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bmi_records',
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => BMIRecord.fromMap(maps[i]));
  }
  
  /// 获取最新的BMI记录
  static Future<BMIRecord?> getLatestBMIRecord() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'bmi_records',
      orderBy: 'date DESC',
      limit: 1,
    );
    if (maps.isEmpty) return null;
    return BMIRecord.fromMap(maps.first);
  }
  
  /// 删除BMI记录
  static Future<void> deleteBMIRecord(String id) async {
    final db = await database;
    await db.delete('bmi_records', where: 'id = ?', whereArgs: [id]);
  }
  
  // ========== 健康数据操作 ==========
  
  /// 保存健康数据
  static Future<void> saveHealthData(HealthData data) async {
    final db = await database;
    await db.insert(
      'health_data',
      data.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  
  /// 获取某类型的健康数据
  static Future<List<HealthData>> getHealthDataByType(String type, {int limit = 30}) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'health_data',
      where: 'type = ?',
      whereArgs: [type],
      orderBy: 'date DESC',
      limit: limit,
    );
    return List.generate(maps.length, (i) => HealthData.fromMap(maps[i]));
  }
  
  /// 获取今日的健康数据
  static Future<List<HealthData>> getTodayHealthData(String type) async {
    final db = await database;
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day).toIso8601String();
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59).toIso8601String();
    
    final List<Map<String, dynamic>> maps = await db.query(
      'health_data',
      where: 'type = ? AND date >= ? AND date <= ?',
      whereArgs: [type, startOfDay, endOfDay],
      orderBy: 'date DESC',
    );
    return List.generate(maps.length, (i) => HealthData.fromMap(maps[i]));
  }
  
  /// 获取今日步数总和
  static Future<int> getTodaySteps() async {
    final data = await getTodayHealthData('steps');
    if (data.isEmpty) return 0;
    int total = 0;
    for (var item in data) {
      total += item.value.toInt();
    }
    return total;
  }
  
  /// 获取今日饮水总量
  static Future<int> getTodayWater() async {
    final data = await getTodayHealthData('water');
    if (data.isEmpty) return 0;
    int total = 0;
    for (var item in data) {
      total += item.value.toInt();
    }
    return total;
  }
  
  /// 获取今日睡眠时长
  static Future<double> getTodaySleep() async {
    final data = await getTodayHealthData('sleep');
    if (data.isEmpty) return 0;
    // 返回最新的睡眠记录
    return data.first.value;
  }
  
  /// 删除健康数据
  static Future<void> deleteHealthData(String id) async {
    final db = await database;
    await db.delete('health_data', where: 'id = ?', whereArgs: [id]);
  }
  
  /// 获取最近7天的数据（用于图表）
  static Future<Map<String, List<HealthData>>> getWeeklyData() async {
    final db = await database;
    final result = <String, List<HealthData>>{};
    
    for (final type in ['steps', 'water', 'sleep']) {
      final List<Map<String, dynamic>> maps = await db.query(
        'health_data',
        where: 'type = ? AND date >= ?',
        whereArgs: [type, DateTime.now().subtract(const Duration(days: 7)).toIso8601String()],
        orderBy: 'date ASC',
      );
      result[type] = List.generate(maps.length, (i) => HealthData.fromMap(maps[i]));
    }
    
    return result;
  }
}
