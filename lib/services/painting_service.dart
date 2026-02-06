import 'package:flutter/material.dart';
import '../models/painting_model.dart';

/// AI绘画服务
class PaintingService {
  /// 获取所有绘画风格
  static List<PaintingStyle> getStyles() {
    return [
      PaintingStyle(
        id: 'anime',
        name: '动漫风格',
        icon: '🎌',
        color: Colors.pink,
        description: '日系动漫风格，色彩鲜艳',
      ),
      PaintingStyle(
        id: 'realistic',
        name: '写实风格',
        icon: '📷',
        color: Colors.blue,
        description: '照片级真实感，细节丰富',
      ),
      PaintingStyle(
        id: 'oil',
        name: '油画风格',
        icon: '🎨',
        color: Colors.orange,
        description: '古典油画质感，艺术气息',
      ),
      PaintingStyle(
        id: 'watercolor',
        name: '水彩风格',
        icon: '💧',
        color: Colors.cyan,
        description: '清新水彩，柔和透明',
      ),
      PaintingStyle(
        id: 'sketch',
        name: '素描风格',
        icon: '✏️',
        color: Colors.grey,
        description: '铅笔素描，线条简洁',
      ),
      PaintingStyle(
        id: 'cyberpunk',
        name: '赛博朋克',
        icon: '🌃',
        color: Colors.purple,
        description: '未来科幻，霓虹光影',
      ),
    ];
  }

  /// 获取所有绘画风格（用于生成页面）
  static List<PaintingStyle> getAllStyles() {
    return getStyles();
  }

  /// 保存绘画作品
  Future<void> savePainting(Painting painting) async {
    // TODO: 实现本地存储（SharedPreferences 或 SQLite）
    // 目前只是模拟保存
    await Future.delayed(const Duration(milliseconds: 100));
  }

  /// 获取历史作品
  static List<Painting> getHistory() {
    return [
      Painting(
        id: '1',
        prompt: '一只可爱的猫咪在樱花树下',
        style: 'anime',
        imageUrl: '',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      Painting(
        id: '2',
        prompt: '未来城市的夜景',
        style: 'cyberpunk',
        imageUrl: '',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      Painting(
        id: '3',
        prompt: '山间小屋的油画',
        style: 'oil',
        imageUrl: '',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
    ];
  }

  /// 模拟生成图片
  static Future<Painting> generateImage(String prompt, String style) async {
    await Future.delayed(const Duration(seconds: 3));
    
    return Painting(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      prompt: prompt,
      style: style,
      imageUrl: '',
      createdAt: DateTime.now(),
    );
  }
}
