import 'package:flutter/material.dart';
import '../theme.dart';
import 'about/privacy_policy_page.dart';

/// 关于页面
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: XiaoxiaDecorations.softGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // 应用图标
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        XiaoxiaTheme.primaryPink,
                        XiaoxiaTheme.accentPurple,
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: XiaoxiaTheme.primaryPink.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      '🦐',
                      style: TextStyle(fontSize: 50),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // 应用名称
                Text(
                  '小虾助手',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),

                // 版本号
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: XiaoxiaTheme.lightPink.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'v1.0.0',
                    style: TextStyle(
                      color: XiaoxiaTheme.deepPink,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // 简介卡片
                Card(
                  elevation: 2,
                  shadowColor: XiaoxiaTheme.primaryPink.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '关于小虾',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          '小虾是你的AI助手，可以帮助你完成代码开发、日常助手、数据分析、学习辅导和创意写作等各种任务。',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: XiaoxiaTheme.textSecondary,
                            height: 1.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 联系信息卡片
                Card(
                  elevation: 2,
                  shadowColor: XiaoxiaTheme.primaryPink.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '联系我们',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 16),
                        _buildContactItem(
                          icon: Icons.email,
                          title: '邮箱',
                          content: 'support@xiaoxia.ai',
                        ),
                        const Divider(height: 24),
                        _buildContactItem(
                          icon: Icons.language,
                          title: '网站',
                          content: 'https://openclaw.ai',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 隐私政策
                Card(
                  elevation: 2,
                  shadowColor: XiaoxiaTheme.primaryPink.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: XiaoxiaTheme.lightPink.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.privacy_tip,
                        color: XiaoxiaTheme.primaryPink,
                      ),
                    ),
                    title: const Text('隐私政策'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyPage(),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),

                // 版权信息
                Text(
                  '© 2026 小虾助手 All Rights Reserved',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: XiaoxiaTheme.textTertiary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: XiaoxiaTheme.lightPink.withOpacity(0.5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: XiaoxiaTheme.primaryPink,
            size: 20,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: XiaoxiaTheme.textTertiary,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                content,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: XiaoxiaTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
