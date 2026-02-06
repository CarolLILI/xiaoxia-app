import 'package:flutter/material.dart';
import '../../theme.dart';

/// 智能写作页面
class WritingPage extends StatefulWidget {
  const WritingPage({super.key});

  @override
  State<WritingPage> createState() => _WritingPageState();
}

class _WritingPageState extends State<WritingPage> {
  final TextEditingController _topicController = TextEditingController();
  String _selectedType = '文章';
  String _selectedTone = '专业';
  bool _isGenerating = false;
  String _generatedContent = '';

  final List<String> _types = ['文章', '邮件', '报告', '故事', '诗歌', '代码注释'];
  final List<String> _tones = ['专业', ' casual', '幽默', '正式', '亲切'];

  final List<Map<String, dynamic>> _templates = [
    {
      'title': '科技博客',
      'topic': '人工智能发展趋势',
      'icon': Icons.computer,
      'color': Colors.blue,
    },
    {
      'title': '产品介绍',
      'topic': '新款智能手机功能介绍',
      'icon': Icons.phone_android,
      'color': Colors.green,
    },
    {
      'title': '工作邮件',
      'topic': '项目进度汇报',
      'icon': Icons.email,
      'color': Colors.orange,
    },
    {
      'title': '创意故事',
      'topic': '未来的智能城市',
      'icon': Icons.auto_stories,
      'color': Colors.purple,
    },
  ];

  Future<void> _generate() async {
    if (_topicController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入写作主题')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
    });

    // 模拟生成
    await Future.delayed(const Duration(seconds: 2));

    final content = '''
${_topicController.text}

随着科技的不断进步，${_topicController.text}正在深刻改变我们的生活方式。从日常工作到娱乐休闲，这项技术已经渗透到了我们生活的方方面面。

首先，在效率提升方面，${_topicController.text}展现出了巨大的潜力。它不仅能够自动化处理繁琐的任务，还能通过智能分析为用户提供个性化的解决方案。这意味着我们可以将更多时间投入到创造性的工作中。

其次，在用户体验方面，${_topicController.text}带来了前所未有的便捷。无论是学习、工作还是生活，用户都能享受到更加流畅、智能的服务体验。

展望未来，${_topicController.text}将继续 evolve，为人类社会带来更多积极的变化。我们有理由相信，这项技术将成为推动社会进步的重要力量。

总之，${_topicController.text}不仅仅是一项技术创新，更是人类智慧的结晶。它正在，也必将持续地改变我们的世界。
    ''';

    setState(() {
      _generatedContent = content.trim();
      _isGenerating = false;
    });
  }

  void _useTemplate(Map<String, dynamic> template) {
    setState(() {
      _topicController.text = template['topic'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XiaoxiaTheme.softPink,
      appBar: AppBar(
        title: const Text('AI 智能写作'),
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
                // 类型选择
                Text(
                  '写作类型',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _types.length,
                    itemBuilder: (context, index) {
                      final type = _types[index];
                      final isSelected = _selectedType == type;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedType = type;
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
                            type,
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

                // 风格选择
                Text(
                  '写作风格',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _tones.length,
                    itemBuilder: (context, index) {
                      final tone = _tones[index];
                      final isSelected = _selectedTone == tone;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedTone = tone;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? XiaoxiaTheme.accentBlue
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            tone,
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

                // 快速模板
                Text(
                  '快速模板',
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
                    childAspectRatio: 2,
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
                            Text(
                              template['topic'] as String,
                              style: TextStyle(
                                fontSize: 12,
                                color: XiaoxiaTheme.textTertiary,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // 主题输入
                Text(
                  '写作主题',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _topicController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: '请输入你想要写作的主题或关键词...',
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

                // 生成按钮
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _isGenerating ? null : _generate,
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
                    label: Text(_isGenerating ? '创作中...' : '开始创作'),
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

                // 生成结果
                if (_generatedContent.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '创作结果',
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
                                const SnackBar(content: Text('内容已复制')),
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
                            '$_selectedType · $_selectedTone',
                            style: TextStyle(
                              fontSize: 12,
                              color: XiaoxiaTheme.primaryPink,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        SelectableText(
                          _generatedContent,
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
                              _generatedContent = '';
                              _topicController.clear();
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('重新创作'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: XiaoxiaTheme.primaryPink,
                            side: const BorderSide(color: XiaoxiaTheme.primaryPink),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.save),
                          label: const Text('保存文档'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: XiaoxiaTheme.primaryPink,
                            foregroundColor: Colors.white,
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
