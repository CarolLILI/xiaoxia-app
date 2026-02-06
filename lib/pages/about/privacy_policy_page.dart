import 'package:flutter/material.dart';
import '../../theme.dart';

/// 隐私政策页面
class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XiaoxiaTheme.softPink,
      appBar: AppBar(
        title: const Text('隐私政策'),
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
                // 标题区域
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.shield_outlined,
                        size: 64,
                        color: XiaoxiaTheme.primaryPink,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        '隐私政策',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '最后更新：2026年2月6日',
                        style: TextStyle(
                          fontSize: 14,
                          color: XiaoxiaTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // 隐私政策内容
                _buildSection(
                  '1. 信息收集',
                  '我们非常重视您的隐私保护。小虾助手可能会收集以下信息：\n\n'
                  '• 账户信息：当您注册账户时，我们收集您的用户名、邮箱地址等基本信息\n'
                  '• 使用数据：我们收集您使用应用时的操作记录，以改进服务质量\n'
                  '• 设备信息：包括设备型号、操作系统版本等，用于优化应用性能\n'
                  '• 日志信息：应用运行过程中产生的日志，用于故障排查',
                ),

                _buildSection(
                  '2. 信息使用',
                  '我们收集的信息将用于以下目的：\n\n'
                  '• 提供、维护和改进我们的服务\n'
                  '• 处理您的请求和反馈\n'
                  '• 发送服务通知和更新信息\n'
                  '• 防止欺诈和滥用行为\n'
                  '• 进行数据分析和研究，以改善用户体验',
                ),

                _buildSection(
                  '3. 信息保护',
                  '我们采取多种安全措施保护您的个人信息：\n\n'
                  '• 数据加密：所有敏感数据均采用行业标准加密技术\n'
                  '• 访问控制：严格限制内部人员对用户数据的访问权限\n'
                  '• 安全审计：定期进行安全审计，确保系统安全性\n'
                  '• 数据备份：定期备份数据，防止数据丢失',
                ),

                _buildSection(
                  '4. 信息共享',
                  '我们不会将您的个人信息出售给第三方。但在以下情况下可能会共享：\n\n'
                  '• 经您明确同意的情况下\n'
                  '• 法律法规要求或政府机关的合法要求\n'
                  '• 为保护我们的合法权益或用户安全所必需\n'
                  '• 与服务提供商合作时（仅限于提供服务所必需）',
                ),

                _buildSection(
                  '5. 您的权利',
                  '您对自己的个人信息拥有以下权利：\n\n'
                  '• 访问权：您有权查看我们持有的关于您的个人信息\n'
                  '• 更正权：您有权更正不准确或不完整的个人信息\n'
                  '• 删除权：您有权要求删除您的个人信息\n'
                  '• 限制处理权：在特定情况下，您有权限制我们处理您的信息\n'
                  '• 数据可携带权：您有权以结构化格式获取您的数据',
                ),

                _buildSection(
                  '6. Cookie 和类似技术',
                  '我们可能使用 Cookie 和类似技术来：\n\n'
                  '• 记住您的偏好设置\n'
                  '• 了解用户如何使用我们的服务\n'
                  '• 改善用户体验\n'
                  '• 提供个性化内容\n\n'
                  '您可以通过浏览器设置管理 Cookie 偏好。',
                ),

                _buildSection(
                  '7. 第三方链接',
                  '我们的服务可能包含指向第三方网站或服务的链接。请注意：\n\n'
                  '• 我们无法控制这些第三方的隐私实践\n'
                  '• 建议您阅读相关第三方的隐私政策\n'
                  '• 我们不对第三方网站的内容或隐私做法负责',
                ),

                _buildSection(
                  '8. 儿童隐私',
                  '我们的服务不面向13岁以下的儿童。如果我们发现收集了13岁以下儿童的个人信息，我们将立即删除。如果您认为我们可能收集了此类信息，请联系我们。',
                ),

                _buildSection(
                  '9. 政策更新',
                  '我们可能会不时更新本隐私政策。更新后的政策将在应用内公布，重大变更我们会通过适当方式通知您。建议您定期查看本政策以了解最新信息。',
                ),

                _buildSection(
                  '10. 联系我们',
                  '如果您对本隐私政策有任何疑问、意见或请求，请通过以下方式联系我们：\n\n'
                  '• 邮箱：privacy@xiaoxia.app\n'
                  '• 地址：中国上海市浦东新区\n'
                  '• 客服热线：400-123-4567\n\n'
                  '我们将在收到您的请求后15个工作日内予以回复。',
                ),

                const SizedBox(height: 32),

                // 同意按钮
                Container(
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
                    children: [
                      const Text(
                        '感谢您阅读我们的隐私政策',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: XiaoxiaTheme.primaryPink,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('我已阅读并同意'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: XiaoxiaTheme.primaryPink,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 14,
              color: XiaoxiaTheme.textSecondary,
              height: 1.8,
            ),
          ),
        ],
      ),
    );
  }
}
