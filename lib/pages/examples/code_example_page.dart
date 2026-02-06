import 'package:flutter/material.dart';
import '../../theme.dart';

/// 写代码示例页面
class CodeExamplePage extends StatefulWidget {
  const CodeExamplePage({super.key});

  @override
  State<CodeExamplePage> createState() => _CodeExamplePageState();
}

class _CodeExamplePageState extends State<CodeExamplePage> {
  final TextEditingController _promptController = TextEditingController();
  String _generatedCode = '';
  String _selectedLanguage = 'Python';
  bool _isGenerating = false;

  final List<Map<String, dynamic>> _languages = [
    {'name': 'Python', 'icon': Icons.code, 'color': Colors.blue},
    {'name': 'JavaScript', 'icon': Icons.javascript, 'color': Colors.yellow},
    {'name': 'Dart', 'icon': Icons.flutter_dash, 'color': Colors.cyan},
    {'name': 'Java', 'icon': Icons.coffee, 'color': Colors.orange},
    {'name': 'Swift', 'icon': Icons.apple, 'color': Colors.grey},
  ];

  final List<Map<String, String>> _codeTemplates = [
    {
      'title': '快速排序算法',
      'prompt': '写一个Python快速排序算法',
    },
    {
      'title': 'HTTP请求',
      'prompt': '用JavaScript写一个简单的fetch请求',
    },
    {
      'title': 'Flutter列表',
      'prompt': '写一个Flutter的ListView.builder示例',
    },
    {
      'title': '类定义',
      'prompt': '用Java定义一个简单的用户类',
    },
  ];

  void _generateCode() {
    if (_promptController.text.isEmpty) return;

    setState(() {
      _isGenerating = true;
    });

    // 模拟代码生成
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isGenerating = false;
        _generatedCode = _getExampleCode(_selectedLanguage);
      });
    });
  }

  String _getExampleCode(String language) {
    switch (language) {
      case 'Python':
        return '''def quick_sort(arr):
    if len(arr) <= 1:
        return arr
    pivot = arr[len(arr) // 2]
    left = [x for x in arr if x < pivot]
    middle = [x for x in arr if x == pivot]
    right = [x for x in arr if x > pivot]
    return quick_sort(left) + middle + quick_sort(right)

# 测试
numbers = [3, 6, 8, 10, 1, 2, 1]
print(quick_sort(numbers))'''
      ;
      case 'JavaScript':
        return '''async function fetchData() {
  try {
    const response = await fetch('https://api.example.com/data');
    const data = await response.json();
    console.log(data);
    return data;
  } catch (error) {
    console.error('Error:', error);
  }
}

fetchData();'''
      ;
      case 'Dart':
        return '''class User {
  final String name;
  final int age;
  
  User({required this.name, required this.age});
  
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'],
      age: json['age'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'age': age,
    };
  }
}'''
      ;
      default:
        return '// 生成的代码将显示在这里';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XiaoxiaTheme.softPink,
      appBar: AppBar(
        title: const Text('AI 写代码'),
        backgroundColor: XiaoxiaTheme.primaryPink,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: XiaoxiaDecorations.softGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 语言选择
                Text(
                  '选择编程语言',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 80,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _languages.length,
                    itemBuilder: (context, index) {
                      final lang = _languages[index];
                      final isSelected = _selectedLanguage == lang['name'];
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedLanguage = lang['name'];
                          });
                        },
                        child: Container(
                          width: 80,
                          margin: const EdgeInsets.only(right: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (lang['color'] as Color).withOpacity(0.2)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isSelected
                                  ? lang['color'] as Color
                                  : Colors.grey[300]!,
                              width: 2,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                lang['icon'] as IconData,
                                color: lang['color'] as Color,
                                size: 28,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                lang['name'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w600
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? lang['color'] as Color
                                      : XiaoxiaTheme.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),

                // 快速模板
                Text(
                  '快速模板',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _codeTemplates.map((template) {
                    return ActionChip(
                      label: Text(template['title']!),
                      backgroundColor: XiaoxiaTheme.lightPink.withOpacity(0.3),
                      side: BorderSide.none,
                      onPressed: () {
                        setState(() {
                          _promptController.text = template['prompt']!;
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),

                // 输入框
                Text(
                  '描述你的需求',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _promptController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: '例如：写一个计算斐波那契数列的Python函数',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: XiaoxiaTheme.primaryPink,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 生成按钮
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isGenerating ? null : _generateCode,
                    icon: _isGenerating
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.auto_awesome),
                    label: Text(_isGenerating ? '生成中...' : '生成代码'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: XiaoxiaTheme.primaryPink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                // 代码展示
                if (_generatedCode.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '生成结果',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: () {
                              // 复制代码
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('代码已复制到剪贴板'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.share, size: 20),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: SelectableText(
                      _generatedCode,
                      style: const TextStyle(
                        color: Colors.green,
                        fontFamily: 'monospace',
                        fontSize: 13,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }
}
