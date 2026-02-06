import 'package:flutter/material.dart';
import '../theme.dart';
import 'news_list_page.dart';
import 'news_detail_page.dart';
import 'accounting/accounting_home_page.dart';
import 'code/code_home_page.dart';
import 'ai_assistant_page.dart';
import 'copywriting_page.dart';

/// 首页
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: XiaoxiaDecorations.softGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 页面标题
                Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Text(
                    '首页',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),

                // AI 助手卡片（新增）
                const _AIAssistantCard(),

                const SizedBox(height: 16),

                // AI 快讯卡片
                const _AINewsCard(),

                const SizedBox(height: 16),

                // 快捷入口标题
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    '快捷入口',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),

                // 快捷入口卡片
                const _QuickEntryCards(),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// AI 助手卡片
class _AIAssistantCard extends StatelessWidget {
  const _AIAssistantCard();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AIAssistantPage(),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shadowColor: XiaoxiaTheme.primaryPink.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                XiaoxiaTheme.primaryPink,
                XiaoxiaTheme.accentPurple,
              ],
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // 头像
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: const Center(
                  child: Text(
                    '🦐',
                    style: TextStyle(fontSize: 32),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // 文字信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          '小虾助手',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'AI',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '点击开始对话',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.2),
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.chat_bubble_outline,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(width: 6),
                          Text(
                            '随时为你解答问题',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // 箭头
              const Icon(
                Icons.arrow_forward_ios,
                color: Colors.white70,
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// AI 快讯卡片
class _AINewsCard extends StatelessWidget {
  const _AINewsCard();

  @override
  Widget build(BuildContext context) {
    final newsList = [
      _NewsItem(
        title: 'Claude 4 发布，多模态能力大幅提升',
        tag: '模型发布',
        tagColor: XiaoxiaTheme.deepPink,
      ),
      _NewsItem(
        title: '国内大模型备案数量突破100家',
        tag: '行业动态',
        tagColor: XiaoxiaTheme.accentPurple,
      ),
      _NewsItem(
        title: 'AI编程助手用户突破1亿',
        tag: '行业动态',
        tagColor: XiaoxiaTheme.accentBlue,
      ),
    ];

    return Card(
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
            // 卡片标题
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: XiaoxiaTheme.lightPink.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.newspaper,
                    color: XiaoxiaTheme.primaryPink,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'AI 快讯',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const Spacer(),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewsListPage(),
                      ),
                    );
                  },
                  child: const Text(
                    '查看更多',
                    style: TextStyle(
                      color: XiaoxiaTheme.primaryPink,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1),
            const SizedBox(height: 8),

            // 新闻列表
            ...newsList.map((news) => _buildNewsItem(context, news)),
          ],
        ),
      ),
    );
  }

  Widget _buildNewsItem(BuildContext context, _NewsItem news) {
    return GestureDetector(
      onTap: () {
        // 跳转到新闻详情页
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => NewsDetailPage(
              news: NewsItem(
                id: '1',
                title: news.title,
                summary: news.title,
                content: '${news.title}\n\n这是一篇关于AI领域的最新资讯，展示了人工智能技术的快速发展和广泛应用。更多详细内容敬请期待...',
                category: news.tag,
                source: 'AI资讯中心',
                publishTime: '刚刚',
                readCount: 1234,
              ),
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                news.title,
                style: Theme.of(context).textTheme.bodyLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: news.tagColor.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                news.tag,
                style: TextStyle(
                  color: news.tagColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 新闻项数据模型
class _NewsItem {
  final String title;
  final String tag;
  final Color tagColor;

  _NewsItem({
    required this.title,
    required this.tag,
    required this.tagColor,
  });
}

/// 小虾介绍卡片
class _XiaoxiaIntroCard extends StatelessWidget {
  const _XiaoxiaIntroCard();

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: XiaoxiaTheme.primaryPink.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              XiaoxiaTheme.softPink.withOpacity(0.5),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            // 头像占位
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    XiaoxiaTheme.primaryPink,
                    XiaoxiaTheme.accentPurple,
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: XiaoxiaTheme.primaryPink.withOpacity(0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Center(
                child: Text(
                  '🦐',
                  style: TextStyle(fontSize: 36),
                ),
              ),
            ),
            const SizedBox(width: 16),

            // 文字信息
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        '小虾',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: XiaoxiaTheme.lightPink,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'AI',
                          style: TextStyle(
                            color: XiaoxiaTheme.deepPink,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '你的AI助手',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: XiaoxiaTheme.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: XiaoxiaTheme.lightPink,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      '你好呀！我是小虾，很高兴见到你！有什么我可以帮助你的吗？',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: XiaoxiaTheme.textDark,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 快捷入口卡片
class _QuickEntryCards extends StatelessWidget {
  const _QuickEntryCards();

  @override
  Widget build(BuildContext context) {
    final entries = [
      _QuickEntry(
        title: '写代码',
        subtitle: '智能编程助手',
        icon: Icons.code,
        color: XiaoxiaTheme.accentBlue,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CodeHomePage(),
            ),
          );
        },
      ),
      _QuickEntry(
        title: '做分析',
        subtitle: '记账统计分析',
        icon: Icons.analytics,
        color: XiaoxiaTheme.accentPurple,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AccountingHomePage(),
            ),
          );
        },
      ),
      _QuickEntry(
        title: '改文案',
        subtitle: '文案优化润色',
        icon: Icons.edit_note,
        color: XiaoxiaTheme.primaryPink,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CopywritingPage(),
            ),
          );
        },
      ),
    ];

    return Row(
      children: entries.map((entry) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: entries.indexOf(entry) == 0 ? 0 : 6,
              right: entries.indexOf(entry) == entries.length - 1 ? 0 : 6,
            ),
            child: _buildEntryCard(context, entry),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEntryCard(BuildContext context, _QuickEntry entry) {
    return Card(
      elevation: 2,
      shadowColor: entry.color.withOpacity(0.2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: entry.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 图标容器
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: entry.color.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  entry.icon,
                  color: entry.color,
                  size: 24,
                ),
              ),
              const SizedBox(height: 12),

              // 标题
              Text(
                entry.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),

              // 副标题
              Text(
                entry.subtitle,
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 快捷入口数据模型
class _QuickEntry {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  _QuickEntry({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
