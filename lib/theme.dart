import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

/// 小虾助手主题配置
/// 使用玫瑰粉色系，Material Design 3 风格
/// 字体采用系统默认字体（iOS: SF Pro + PingFang SC, Android: Roboto + Noto Sans）
class XiaoxiaTheme {
  // 主色调
  static const Color primaryPink = Color(0xFFFF6B9D);
  static const Color lightPink = Color(0xFFFFB3C6);
  static const Color softPink = Color(0xFFFFF0F3);
  static const Color deepPink = Color(0xFFE91E63);

  // 辅助色
  static const Color accentPurple = Color(0xFFB388FF);
  static const Color accentBlue = Color(0xFF82B1FF);
  static const Color warmWhite = Color(0xFFFFFBFE);

  // 文字颜色
  static const Color textDark = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color textTertiary = Color(0xFF999999);

  /// 获取亮色主题
  static ThemeData get lightTheme {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: primaryPink,
      brightness: Brightness.light,
      primary: primaryPink,
      secondary: accentPurple,
      surface: warmWhite,
      background: softPink,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: softPink,

      // AppBar 主题
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: textDark,
          letterSpacing: -0.4,
        ),
        iconTheme: IconThemeData(color: primaryPink),
      ),

      // 卡片主题
      cardTheme: CardThemeData(
        elevation: 0,
        shadowColor: primaryPink.withOpacity(0.15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        color: Colors.white,
      ),

      // 底部导航栏主题
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryPink,
        unselectedItemColor: textTertiary,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        selectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: -0.2,
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          letterSpacing: -0.2,
        ),
      ),

      // 文字主题 - 参考 Apple Human Interface Guidelines
      textTheme: const TextTheme(
        // 大标题 - 用于页面主标题
        headlineLarge: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w700,
          color: textDark,
          letterSpacing: -0.5,
          height: 1.2,
        ),
        // 中标题 - 用于区块标题
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w600,
          color: textDark,
          letterSpacing: -0.4,
          height: 1.25,
        ),
        // 小标题 - 用于卡片标题
        headlineSmall: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: textDark,
          letterSpacing: -0.3,
          height: 1.3,
        ),
        // 大号标题文字
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textDark,
          letterSpacing: -0.3,
          height: 1.3,
        ),
        // 中号标题文字 - 列表项标题
        titleMedium: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w600,
          color: textDark,
          letterSpacing: -0.4,
          height: 1.4,
        ),
        // 小号标题文字
        titleSmall: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: textDark,
          letterSpacing: -0.2,
          height: 1.4,
        ),
        // 大号正文 - 主要阅读文字
        bodyLarge: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: textDark,
          letterSpacing: -0.4,
          height: 1.5,
        ),
        // 中号正文 - 次要文字
        bodyMedium: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          letterSpacing: -0.2,
          height: 1.5,
        ),
        // 小号正文 - 辅助说明
        bodySmall: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: textTertiary,
          letterSpacing: -0.1,
          height: 1.4,
        ),
        // 标签文字
        labelLarge: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w500,
          color: textDark,
          letterSpacing: -0.2,
          height: 1.3,
        ),
        labelMedium: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: textSecondary,
          letterSpacing: -0.1,
          height: 1.3,
        ),
        labelSmall: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w500,
          color: textTertiary,
          letterSpacing: 0,
          height: 1.3,
        ),
      ),

      // 按钮主题
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryPink,
          foregroundColor: Colors.white,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
          ),
        ),
      ),

      // 文字按钮主题
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryPink,
          textStyle: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w600,
            letterSpacing: -0.4,
          ),
        ),
      ),

      // Chip 主题
      chipTheme: ChipThemeData(
        backgroundColor: lightPink.withOpacity(0.4),
        labelStyle: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: deepPink,
          letterSpacing: -0.1,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),

      // 输入框主题
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: const TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: textTertiary,
          letterSpacing: -0.4,
        ),
        labelStyle: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          letterSpacing: -0.2,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: Colors.white,
      ),

      // 图标主题
      iconTheme: const IconThemeData(
        color: primaryPink,
        size: 24,
      ),

      // 分割线主题
      dividerTheme: DividerThemeData(
        color: textTertiary.withOpacity(0.2),
        thickness: 0.5,
        space: 1,
      ),

      // 列表瓦片主题
      listTileTheme: const ListTileThemeData(
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        titleTextStyle: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w400,
          color: textDark,
          letterSpacing: -0.4,
        ),
        subtitleTextStyle: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w400,
          color: textSecondary,
          letterSpacing: -0.2,
        ),
      ),
    );
  }
}

/// 渐变装饰器
class XiaoxiaDecorations {
  static BoxDecoration get pinkGradient => const BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        XiaoxiaTheme.primaryPink,
        XiaoxiaTheme.accentPurple,
      ],
    ),
  );

  static BoxDecoration get softGradient => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        XiaoxiaTheme.softPink,
        XiaoxiaTheme.warmWhite,
      ],
    ),
  );

  static BoxDecoration cardDecoration({Color? color}) => BoxDecoration(
    color: color ?? Colors.white,
    borderRadius: BorderRadius.circular(16),
    boxShadow: [
      BoxShadow(
        color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );
}
