import 'package:flutter/material.dart';
import '../theme.dart';
import 'examples/examples_export.dart';

/// 使用示例页面
class ExamplesPage extends StatelessWidget {
  const ExamplesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: XiaoxiaDecorations.softGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 页面标题
                Text(
                  '使用示例',
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  '看看小虾能帮你做什么',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: XiaoxiaTheme.textSecondary,
                  ),
                ),
                const SizedBox(height: 24),

                // 写代码示例
                _buildExampleCard(
                  context,
                  icon: Icons.code,
                  title: '写代码',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CodeExamplePage(),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text(
                      'def hello_world():\n    print("Hello, 小虾!")\n    return "完成"',
                      style: TextStyle(
                        color: Colors.green,
                        fontFamily: 'monospace',
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 查资料示例
                _buildExampleCard(
                  context,
                  icon: Icons.search,
                  title: '查资料',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SearchExamplePage(),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchResult('Flutter 入门教程', '官方文档 · 10分钟前'),
                      const Divider(height: 16),
                      _buildSearchResult('Dart 语言基础', '开发者博客 · 2小时前'),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 做规划示例
                _buildExampleCard(
                  context,
                  icon: Icons.check_circle_outline,
                  title: '做规划',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PlanningExamplePage(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      _buildTodoItem('完成 Flutter 项目', true),
                      _buildTodoItem('学习 AI 基础知识', false),
                      _buildTodoItem('整理读书笔记', false),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 学外语示例
                _buildExampleCard(
                  context,
                  icon: Icons.chat_bubble_outline,
                  title: '学外语',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LanguageExamplePage(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      _buildChatBubble(
                        'Hello! How can I help you?',
                        false,
                      ),
                      _buildChatBubble(
                        'I want to learn English.',
                        true,
                      ),
                      _buildChatBubble(
                        'Great! Let\'s start with basics.',
                        false,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 数据分析示例
                _buildExampleCard(
                  context,
                  icon: Icons.bar_chart,
                  title: '数据分析',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const DataAnalysisExamplePage(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      _buildChartBar('一月', 0.7, Colors.blue),
                      _buildChartBar('二月', 0.5, Colors.green),
                      _buildChartBar('三月', 0.9, XiaoxiaTheme.primaryPink),
                      _buildChartBar('四月', 0.6, Colors.orange),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: XiaoxiaTheme.lightPink.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.trending_up,
                              color: XiaoxiaTheme.primaryPink,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                '三月销量最高，建议增加库存',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: XiaoxiaTheme.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 图像识别示例
                _buildExampleCard(
                  context,
                  icon: Icons.image_search,
                  title: '图像识别',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ImageRecognitionPage(),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(12),
                          image: const DecorationImage(
                            image: NetworkImage(
                              'https://images.unsplash.com/photo-1558618666-fcd25c85cd64?w=400',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  '📷 咖啡杯',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _buildTag('咖啡', Colors.brown),
                          _buildTag('杯子', Colors.blue),
                          _buildTag('热饮', Colors.orange),
                          _buildTag('早晨', Colors.green),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 智能日程示例
                _buildExampleCard(
                  context,
                  icon: Icons.calendar_today,
                  title: '智能日程',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SchedulePage(),
                      ),
                    );
                  },
                  child: Column(
                    children: [
                      _buildScheduleItem(
                        '09:00',
                        '团队早会',
                        Colors.blue,
                        true,
                      ),
                      _buildScheduleItem(
                        '10:30',
                        '项目评审',
                        Colors.orange,
                        false,
                      ),
                      _buildScheduleItem(
                        '14:00',
                        '客户会议',
                        XiaoxiaTheme.primaryPink,
                        false,
                      ),
                      _buildScheduleItem(
                        '16:00',
                        '代码审查',
                        Colors.green,
                        false,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              XiaoxiaTheme.primaryPink.withOpacity(0.1),
                              XiaoxiaTheme.accentBlue.withOpacity(0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.auto_awesome,
                              color: XiaoxiaTheme.primaryPink,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            const Expanded(
                              child: Text(
                                'AI 建议：下午会议较多，建议提前准备午餐',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: XiaoxiaTheme.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 智能写作示例
                _buildExampleCard(
                  context,
                  icon: Icons.edit_note,
                  title: '智能写作',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WritingPage(),
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.grey[200]!,
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              '主题：人工智能的未来发展',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: XiaoxiaTheme.textDark,
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              '人工智能正在深刻改变我们的生活方式。从智能家居到自动驾驶，从医疗诊断到教育辅助，AI 技术正在各个领域发挥着越来越重要的作用...',
                              style: TextStyle(
                                fontSize: 13,
                                color: XiaoxiaTheme.textSecondary,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                _buildWritingTag('科技', Colors.blue),
                                const SizedBox(width: 8),
                                _buildWritingTag('AI', XiaoxiaTheme.primaryPink),
                                const SizedBox(width: 8),
                                _buildWritingTag('未来', Colors.green),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildActionButton(
                              Icons.refresh,
                              '重新生成',
                              Colors.grey,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildActionButton(
                              Icons.copy,
                              '复制文本',
                              XiaoxiaTheme.primaryPink,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _buildActionButton(
                              Icons.share,
                              '分享',
                              Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildExampleCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget child,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shadowColor: XiaoxiaTheme.primaryPink.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: XiaoxiaTheme.lightPink.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: XiaoxiaTheme.primaryPink,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                  if (onTap != null)
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 16,
                      color: XiaoxiaTheme.textTertiary,
                    ),
                ],
              ),
              const SizedBox(height: 16),
              child,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchResult(String title, String subtitle) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: XiaoxiaTheme.accentBlue.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.article,
            color: XiaoxiaTheme.accentBlue,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: XiaoxiaTheme.textTertiary,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTodoItem(String text, bool completed) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(
            completed ? Icons.check_box : Icons.check_box_outline_blank,
            color: completed ? Colors.green : XiaoxiaTheme.textTertiary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              decoration: completed ? TextDecoration.lineThrough : null,
              color: completed ? XiaoxiaTheme.textTertiary : XiaoxiaTheme.textDark,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChatBubble(String text, bool isUser) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isUser
              ? XiaoxiaTheme.primaryPink
              : XiaoxiaTheme.softPink.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: isUser ? Colors.white : XiaoxiaTheme.textDark,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  Widget _buildChartBar(String label, double value, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: XiaoxiaTheme.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Container(
              height: 24,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: value,
                child: Container(
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      '${(value * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color.withOpacity(0.9),
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildScheduleItem(
    String time,
    String title,
    Color color,
    bool isCompleted,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.grey[100] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isCompleted ? Colors.grey[300]! : color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: isCompleted ? Colors.grey : color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            time,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isCompleted ? Colors.grey : XiaoxiaTheme.textDark,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                decoration: isCompleted ? TextDecoration.lineThrough : null,
                color: isCompleted
                    ? XiaoxiaTheme.textTertiary
                    : XiaoxiaTheme.textDark,
              ),
            ),
          ),
          if (isCompleted)
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 20,
            ),
        ],
      ),
    );
  }

  Widget _buildTranslationCard(String language, String text, Color color) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            language,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 15,
              color: XiaoxiaTheme.textDark,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageButton(String text, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: isSelected ? XiaoxiaTheme.primaryPink : Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: isSelected ? Colors.white : XiaoxiaTheme.textSecondary,
        ),
      ),
    );
  }

  Widget _buildWritingTag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 11,
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
