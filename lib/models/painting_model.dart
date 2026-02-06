import 'package:flutter/material.dart';

/// 绘画风格模型
class PaintingStyle {
  final String id;
  final String name;
  final String icon;
  final Color color;
  final String description;

  const PaintingStyle({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
    required this.description,
  });

  /// 获取图标名称（用于映射到 IconData）
  String get iconName => id;
}

/// 绘画作品模型
class Painting {
  final String id;
  final String prompt;
  final String style;
  final String imageUrl;
  final DateTime createdAt;
  final bool isGenerated;
  final double? aspectRatio;
  final int? seed;

  Painting({
    required this.id,
    required this.prompt,
    required this.style,
    required this.imageUrl,
    required this.createdAt,
    this.isGenerated = true,
    this.aspectRatio,
    this.seed,
  });
}
