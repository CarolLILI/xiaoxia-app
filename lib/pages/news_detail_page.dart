import 'package:flutter/material.dart';
import '../theme.dart';
import 'news_list_page.dart';

/// 新闻详情页面
class NewsDetailPage extends StatelessWidget {
  final NewsItem news;

  const NewsDetailPage({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: XiaoxiaDecorations.softGradient,
        child: SafeArea(
          child: Column(
            children: [
              // 顶部导航栏
              _buildAppBar(context),
              
              // 内容区域
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 分类和时间
                      _buildMetaInfo(),
                      
                      const SizedBox(height: 16),
                      
                      // 标题
                      Text(
                        news.title,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          height: 1.4,
                        ),
                      ),
                      
                      const SizedBox(height: 16),
                      
                      // 来源和阅读量
                      _buildSourceInfo(),
                      
                      const SizedBox(height: 24),
                      
                      // 正文内容
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: XiaoxiaTheme.primaryPink.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          news.content,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.8,
                            color: XiaoxiaTheme.textDark,
                          ),
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // 操作按钮
                      _buildActionButtons(),
                      
                      const SizedBox(height: 32),
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

  Widget _buildAppBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: XiaoxiaTheme.textDark),
          ),
          const Spacer(),
          // 分享按钮
          IconButton(
            onPressed: () {
              _showShareSheet(context);
            },
            icon: const Icon(Icons.share_outlined, color: XiaoxiaTheme.textDark),
          ),
          // 收藏按钮
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('已收藏'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
            icon: const Icon(Icons.bookmark_border, color: XiaoxiaTheme.textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildMetaInfo() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: _getCategoryColor(news.category).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            news.category,
            style: TextStyle(
              color: _getCategoryColor(news.category),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Icon(
          Icons.access_time,
          size: 14,
          color: XiaoxiaTheme.textTertiary,
        ),
        const SizedBox(width: 4),
        Text(
          news.publishTime,
          style: const TextStyle(
            color: XiaoxiaTheme.textTertiary,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildSourceInfo() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: XiaoxiaTheme.softPink.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
                  blurRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.article,
              color: XiaoxiaTheme.primaryPink,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '来源：${news.source}',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '阅读 ${news.readCount} 次',
                  style: const TextStyle(
                    color: XiaoxiaTheme.textTertiary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            icon: Icons.thumb_up_outlined,
            label: '有用',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.comment_outlined,
            label: '评论',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionButton(
            icon: Icons.share_outlined,
            label: '分享',
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: XiaoxiaTheme.primaryPink.withOpacity(0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: XiaoxiaTheme.primaryPink,
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: const TextStyle(
                color: XiaoxiaTheme.textSecondary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case '模型发布':
        return Colors.purple;
      case '行业动态':
        return Colors.blue;
      case '开源项目':
        return Colors.green;
      case '产品更新':
        return Colors.orange;
      default:
        return XiaoxiaTheme.primaryPink;
    }
  }

  void _showShareSheet(BuildContext context) {
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
                '分享到',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildShareItem(Icons.chat_bubble, '微信', Colors.green),
                _buildShareItem(Icons.camera_alt, '朋友圈', Colors.green),
                _buildShareItem(Icons.link, '复制链接', Colors.blue),
                _buildShareItem(Icons.more_horiz, '更多', Colors.grey),
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
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
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
