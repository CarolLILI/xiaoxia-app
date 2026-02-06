import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../theme.dart';

/// 翻译服务
class TranslationService {
  static const String _baseUrl = 'https://api.mymemory.translated.net/get';
  
  /// 支持的语言
  static final Map<String, String> languages = {
    'auto': '自动检测',
    'zh-CN': '中文（简体）',
    'zh-TW': '中文（繁体）',
    'en': '英语',
    'ja': '日语',
    'ko': '韩语',
    'fr': '法语',
    'de': '德语',
    'es': '西班牙语',
    'ru': '俄语',
    'it': '意大利语',
    'pt': '葡萄牙语',
    'ar': '阿拉伯语',
    'th': '泰语',
    'vi': '越南语',
  };

  /// 翻译文本
  static Future<String> translate(String text, String from, String to) async {
    if (text.trim().isEmpty) return '';
    
    try {
      // 使用 MyMemory Translation API（免费，有额度限制）
      final response = await http.get(
        Uri.parse('$_baseUrl?q=${Uri.encodeComponent(text)}&langpair=$from|$to'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['responseData'] != null) {
          return data['responseData']['translatedText'] ?? '翻译失败';
        }
      }
      
      // API 失败时返回模拟翻译
      return _mockTranslate(text, from, to);
    } catch (e) {
      // 网络错误或超时，返回模拟翻译
      return _mockTranslate(text, from, to);
    }
  }

  /// 模拟翻译（离线备用）
  static String _mockTranslate(String text, String from, String to) {
    // 如果是中文到英文
    if ((from.startsWith('zh') || from == 'auto') && to == 'en') {
      return _chineseToEnglish(text);
    }
    // 英文到中文
    if (from == 'en' && to.startsWith('zh')) {
      return _englishToChinese(text);
    }
    // 日语到中文
    if (from == 'ja' && to.startsWith('zh')) {
      return _japaneseToChinese(text);
    }
    // 默认：返回原文 + 翻译标记
    return '[翻译] $text';
  }

  static String _chineseToEnglish(String text) {
    final Map<String, String> common = {
      '你好': 'Hello',
      '谢谢': 'Thank you',
      '再见': 'Goodbye',
      '我爱你': 'I love you',
      '早上好': 'Good morning',
      '晚上好': 'Good evening',
      '对不起': 'Sorry',
      '没关系': 'It\'s okay',
      '请': 'Please',
      '是': 'Yes',
      '不是': 'No',
    };
    
    String result = text;
    common.forEach((cn, en) {
      result = result.replaceAll(cn, en);
    });
    
    if (result == text) {
      return 'Translated: $text';
    }
    return result;
  }

  static String _englishToChinese(String text) {
    final Map<String, String> common = {
      'hello': '你好',
      'hi': '嗨',
      'thank you': '谢谢',
      'thanks': '谢谢',
      'goodbye': '再见',
      'bye': '拜拜',
      'i love you': '我爱你',
      'good morning': '早上好',
      'good evening': '晚上好',
      'sorry': '对不起',
      'please': '请',
      'yes': '是',
      'no': '不是',
    };
    
    String lowerText = text.toLowerCase();
    if (common.containsKey(lowerText)) {
      return common[lowerText]!;
    }
    
    return '翻译：$text';
  }

  static String _japaneseToChinese(String text) {
    final Map<String, String> common = {
      'こんにちは': '你好',
      'ありがとう': '谢谢',
      'さようなら': '再见',
      '愛してる': '我爱你',
      'おはよう': '早上好',
    };
    
    if (common.containsKey(text)) {
      return common[text]!;
    }
    return '翻译：$text';
  }
}

/// 翻译历史记录
class TranslationHistory {
  final String id;
  final String sourceText;
  final String translatedText;
  final String fromLang;
  final String toLang;
  final DateTime timestamp;

  TranslationHistory({
    required this.id,
    required this.sourceText,
    required this.translatedText,
    required this.fromLang,
    required this.toLang,
    required this.timestamp,
  });
}

/// 翻译历史服务
class TranslationHistoryService {
  static final List<TranslationHistory> _history = [];

  static List<TranslationHistory> getHistory() {
    return List.unmodifiable(_history);
  }

  static void addHistory(TranslationHistory item) {
    _history.insert(0, item);
    // 只保留最近50条
    if (_history.length > 50) {
      _history.removeLast();
    }
  }

  static void clearHistory() {
    _history.clear();
  }

  static void deleteHistory(String id) {
    _history.removeWhere((item) => item.id == id);
  }
}
