import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

/// 支出记录模型
class Expense {
  final String id;
  final double amount;
  final String category;
  final String note;
  final DateTime date;
  final DateTime createdAt;

  Expense({
    required this.id,
    required this.amount,
    required this.category,
    required this.note,
    required this.date,
    required this.createdAt,
  });

  /// 从数据库映射
  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      amount: map['amount'],
      category: map['category'],
      note: map['note'],
      date: DateTime.parse(map['date']),
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  /// 转为数据库映射
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'amount': amount,
      'category': category,
      'note': note,
      'date': date.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// 复制并修改
  Expense copyWith({
    String? id,
    double? amount,
    String? category,
    String? note,
    DateTime? date,
    DateTime? createdAt,
  }) {
    return Expense(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      note: note ?? this.note,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

/// 支出分类配置
class ExpenseCategory {
  final String name;
  final String icon;
  final int color;

  const ExpenseCategory({
    required this.name,
    required this.icon,
    required this.color,
  });

  /// 预定义分类
  static const List<ExpenseCategory> categories = [
    ExpenseCategory(name: '餐饮', icon: '🍔', color: 0xFFFF6B6B),
    ExpenseCategory(name: '交通', icon: '🚗', color: 0xFF4ECDC4),
    ExpenseCategory(name: '购物', icon: '🛍️', color: 0xFFFFE66D),
    ExpenseCategory(name: '娱乐', icon: '🎮', color: 0xFF9B59B6),
    ExpenseCategory(name: '居住', icon: '🏠', color: 0xFF3498DB),
    ExpenseCategory(name: '医疗', icon: '💊', color: 0xFFE74C3C),
    ExpenseCategory(name: '教育', icon: '📚', color: 0xFF2ECC71),
    ExpenseCategory(name: '其他', icon: '📝', color: 0xFF95A5A6),
  ];

  static ExpenseCategory getByName(String name) {
    return categories.firstWhere(
      (c) => c.name == name,
      orElse: () => categories.last,
    );
  }
}

/// 统计数据模型
class ExpenseStatistics {
  final double totalAmount;
  final int count;
  final Map<String, double> categoryAmounts;
  final Map<String, int> categoryCounts;

  ExpenseStatistics({
    required this.totalAmount,
    required this.count,
    required this.categoryAmounts,
    required this.categoryCounts,
  });
}
