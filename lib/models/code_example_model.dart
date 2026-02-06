import 'package:flutter/material.dart';

/// 代码示例模型
class CodeExample {
  final String id;
  final String title;
  final String description;
  final String language;
  final String code;
  final String category;
  final DateTime createdAt;

  CodeExample({
    required this.id,
    required this.title,
    required this.description,
    required this.language,
    required this.code,
    required this.category,
    required this.createdAt,
  });

  /// 从映射创建
  factory CodeExample.fromMap(Map<String, dynamic> map) {
    return CodeExample(
      id: map['id'],
      title: map['title'],
      description: map['description'],
      language: map['language'],
      code: map['code'],
      category: map['category'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }

  /// 转为映射
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'language': language,
      'code': code,
      'category': category,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

/// 编程语言配置
class CodeLanguage {
  final String name;
  final String displayName;
  final Color color;
  final IconData icon;

  const CodeLanguage({
    required this.name,
    required this.displayName,
    required this.color,
    required this.icon,
  });

  static const List<CodeLanguage> languages = [
    CodeLanguage(
      name: 'flutter',
      displayName: 'Flutter',
      color: Color(0xFF54C5F8),
      icon: Icons.flutter_dash,
    ),
    CodeLanguage(
      name: 'python',
      displayName: 'Python',
      color: Color(0xFF3776AB),
      icon: Icons.code,
    ),
    CodeLanguage(
      name: 'javascript',
      displayName: 'JavaScript',
      color: Color(0xFFF7DF1E),
      icon: Icons.javascript,
    ),
    CodeLanguage(
      name: 'dart',
      displayName: 'Dart',
      color: Color(0xFF00B4AB),
      icon: Icons.code,
    ),
  ];

  static CodeLanguage getByName(String name) {
    return languages.firstWhere(
      (l) => l.name == name,
      orElse: () => languages.first,
    );
  }
}
