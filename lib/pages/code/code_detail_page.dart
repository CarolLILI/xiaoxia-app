import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme.dart';
import '../../models/code_example_model.dart';

/// 代码详情页面
class CodeDetailPage extends StatelessWidget {
  final CodeExample example;

  const CodeDetailPage({super.key, required this.example});

  @override
  Widget build(BuildContext context) {
    final language = CodeLanguage.getByName(example.language);

    return Scaffold(
      body: Container(
        decoration: XiaoxiaDecorations.softGradient,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 标题和描述
                      _buildTitleSection(language),
                      const SizedBox(height: 20),

                      // 代码区域
                      _buildCodeSection(),
                      const SizedBox(height: 20),

                      // 操作按钮
                      _buildActionButtons(context),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: XiaoxiaTheme.textDark),
          ),
          Expanded(
            child: Text(
              '代码详情',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () => _copyCode(context),
            icon: const Icon(Icons.copy, color: XiaoxiaTheme.textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection(CodeLanguage language) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 语言标签
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: language.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(language.icon, size: 18, color: language.color),
              const SizedBox(width: 6),
              Text(
                language.displayName,
                style: TextStyle(
                  color: language.color,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // 标题
        Text(
          example.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: XiaoxiaTheme.textDark,
          ),
        ),
        const SizedBox(height: 8),

        // 描述
        Text(
          example.description,
          style: const TextStyle(
            fontSize: 16,
            color: XiaoxiaTheme.textSecondary,
            height: 1.5,
          ),
        ),
        const SizedBox(height: 8),

        // 分类标签
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: XiaoxiaTheme.softPink,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Text(
            example.category,
            style: const TextStyle(
              color: XiaoxiaTheme.primaryPink,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题栏
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
            ),
            child: Row(
              children: [
                // 窗口按钮
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.yellow,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                const Spacer(),
                Text(
                  example.language,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // 代码内容
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: SelectableText(
              example.code,
              style: const TextStyle(
                color: Color(0xFFD4D4D4),
                fontSize: 13,
                fontFamily: 'monospace',
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => _copyCode(context),
            icon: const Icon(Icons.copy),
            label: const Text('复制代码'),
            style: ElevatedButton.styleFrom(
              backgroundColor: XiaoxiaTheme.primaryPink,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _shareCode(context),
            icon: const Icon(Icons.share),
            label: const Text('分享'),
            style: OutlinedButton.styleFrom(
              foregroundColor: XiaoxiaTheme.primaryPink,
              side: const BorderSide(color: XiaoxiaTheme.primaryPink),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _copyCode(BuildContext context) {
    Clipboard.setData(ClipboardData(text: example.code));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('代码已复制到剪贴板'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _shareCode(BuildContext context) {
    // 分享功能
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '分享代码',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareItem(Icons.message, '微信', Colors.green),
                _buildShareItem(Icons.link, '复制链接', Colors.blue),
                _buildShareItem(Icons.email, '邮件', Colors.orange),
              ],
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildShareItem(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: color, size: 28),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: XiaoxiaTheme.textSecondary,
          ),
        ),
      ],
    );
  }
}
