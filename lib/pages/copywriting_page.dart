import 'package:flutter/material.dart';
import '../../theme.dart';

/// 改文案页面 - 文案优化润色
class CopywritingPage extends StatefulWidget {
  const CopywritingPage({super.key});

  @override
  State<CopywritingPage> createState() => _CopywritingPageState();
}

class _CopywritingPageState extends State<CopywritingPage> {
  final TextEditingController _inputController = TextEditingController();
  String _optimizedText = '';
  String _selectedStyle = '专业';
  bool _isOptimizing = false;

  final List<String> _styles = ['专业', '简洁', '生动', '正式', '幽默'];

  final List<Map<String, dynamic>> _templates = [
    {
      'title': '产品推广',
      'content': '这款手机拍照效果非常好，电池也很耐用',
      'icon': Icons.phone_android,
      'color': Colors.blue,
    },
    {
      'title': '活动邀请',
      'content': '欢迎大家来参加我们的年会，有很多好吃的',
      'icon': Icons.celebration,
      'color': Colors.orange,
    },
    {
      'title': '工作汇报',
      'content': '这个月完成了项目，下周开始新任务',
      'icon': Icons.work,
      'color': Colors.green,
    },
    {
      'title': '社交媒体',
      'content': '今天天气不错，心情很好',
      'icon': Icons.tag,
      'color': Colors.purple,
    },
  ];

  Future<void> _optimize() async {
    if (_inputController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入需要优化的文案')),
      );
      return;
    }

    setState(() {
      _isOptimizing = true;
    });

    // 模拟优化
    await Future.delayed(const Duration(seconds: 1));

    final String original = _inputController.text;
    String optimized = '';

    switch (_selectedStyle) {
      case '专业':
        optimized = '【专业版】\n\n$original\n\n优化后：\n\n本文案经过专业润色，用词更加精准，逻辑更加清晰，更能体现专业形象。建议在实际使用时根据具体场景进行微调。';
        break;
      case '简洁':
        optimized = '【简洁版】\n\n$original\n\n优化后：\n\n精简核心信息，去除冗余表达，让文案更加直接有力，读者能在最短时间内获取关键内容。';
        break;
      case '生动':
        optimized = '【生动版】\n\n$original\n\n优化后：\n\n运用形象化表达，增加情感共鸣，让文案更具感染力，能够吸引读者注意力并产生共鸣。';
        break;
      case '正式':
        optimized = '【正式版】\n\n$original\n\n优化后：\n\n采用规范的书面语，措辞严谨得体，适合正式场合使用，体现专业性和权威性。';
        break;
      case '幽默':
        optimized = '【幽默版】\n\n$original\n\n优化后：\n\n融入轻松幽默的元素，让文案更加有趣味性，能够拉近与读者的距离，提升阅读体验。';
        break;
      default:
        optimized = '【优化版】\n\n$original\n\n优化后：\n\n本文案经过AI智能优化，表达更加流畅自然，更符合目标受众的阅读习惯。';
    }

    setState(() {
      _optimizedText = optimized;
      _isOptimizing = false;
    });
  }

  void _useTemplate(Map<String, dynamic> template) {
    setState(() {
      _inputController.text = template['content'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XiaoxiaTheme.softPink,
      appBar: AppBar(
        title: const Text('AI 改文案'),
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
                // 风格选择
                Text(
                  '优化风格',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _styles.length,
                    itemBuilder: (context, index) {
                      final style = _styles[index];
                      final isSelected = _selectedStyle == style;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedStyle = style;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? XiaoxiaTheme.primaryPink
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            style,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : XiaoxiaTheme.textSecondary,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 20),

                // 快捷模板
                Text(
                  '快捷模板',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 2.2,
                  ),
                  itemCount: _templates.length,
                  itemBuilder: (context, index) {
                    final template = _templates[index];
                    return GestureDetector(
                      onTap: () => _useTemplate(template),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              template['icon'] as IconData,
                              color: template['color'] as Color,
                              size: 24,
                            ),
                            const Spacer(),
                            Text(
                              template['title'] as String,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // 原文输入
                Text(
                  '原文案',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _inputController,
                  maxLines: 5,
                  decoration: InputDecoration(
                    hintText: '请输入需要优化的文案...',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.all(16),
                  ),
                ),
                const SizedBox(height: 20),

                // 优化按钮
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isOptimizing ? null : _optimize,
                    icon: _isOptimizing
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.auto_fix_high),
                    label: Text(_isOptimizing ? '优化中...' : '开始优化'),
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

                // 优化结果
                if (_optimizedText.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '优化结果',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.copy, size: 20),
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('已复制到剪贴板')),
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
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            '风格：$_selectedStyle',
                            style: TextStyle(
                              fontSize: 12,
                              color: XiaoxiaTheme.primaryPink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SelectableText(
                          _optimizedText,
                          style: const TextStyle(
                            fontSize: 15,
                            height: 1.8,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            setState(() {
                              _optimizedText = '';
                              _inputController.clear();
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('重新优化'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: XiaoxiaTheme.primaryPink,
                            side: const BorderSide(color: XiaoxiaTheme.primaryPink),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
