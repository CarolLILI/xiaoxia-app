import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'theme.dart';
import 'pages/home_page.dart';
import 'pages/abilities_page.dart';
import 'pages/examples_page.dart';
import 'pages/about_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const XiaoxiaApp());
}

class XiaoxiaApp extends StatelessWidget {
  const XiaoxiaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '小虾助手',
      debugShowCheckedModeBanner: false,
      theme: XiaoxiaTheme.lightTheme,
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    AbilitiesPage(),
    ExamplesPage(),
    AboutPage(),
  ];

  final List<String> _titles = const [
    '小虾助手',
    '我的能力',
    '使用示例',
    '关于',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(Icons.home_rounded, '首页', 0),
                _buildNavItem(Icons.auto_awesome_rounded, '能力', 1),
                _buildNavItem(Icons.lightbulb_outline, '示例', 2),
                _buildNavItem(Icons.person_outline, '关于', 3),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? XiaoxiaTheme.primaryPink.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isSelected ? 1.1 : 1.0,
              duration: const Duration(milliseconds: 200),
              child: Icon(
                icon,
                color: isSelected
                    ? XiaoxiaTheme.primaryPink
                    : XiaoxiaTheme.textTertiary,
                size: 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                color: isSelected
                    ? XiaoxiaTheme.primaryPink
                    : XiaoxiaTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
