import 'package:flutter/material.dart';
import '../../theme.dart';

/// 查资料示例页面
class SearchExamplePage extends StatefulWidget {
  const SearchExamplePage({super.key});

  @override
  State<SearchExamplePage> createState() => _SearchExamplePageState();
}

class _SearchExamplePageState extends State<SearchExamplePage> {
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;
  List<Map<String, dynamic>> _searchResults = [];

  final List<Map<String, dynamic>> _hotTopics = [
    {
      'title': 'Flutter 3.0 新特性',
      'category': '技术',
      'icon': Icons.flutter_dash,
      'color': Colors.blue,
    },
    {
      'title': '2026年AI发展趋势',
      'category': '科技',
      'icon': Icons.psychology,
      'color': Colors.purple,
    },
    {
      'title': '如何学习编程',
      'category': '教育',
      'icon': Icons.school,
      'color': Colors.green,
    },
    {
      'title': '健康生活方式',
      'category': '生活',
      'icon': Icons.favorite,
      'color': Colors.red,
    },
  ];

  final List<Map<String, dynamic>> _searchHistory = [
    {'query': 'Flutter 状态管理', 'time': '2小时前'},
    {'query': 'Python 爬虫教程', 'time': '昨天'},
    {'query': 'AI绘画工具推荐', 'time': '3天前'},
  ];

  void _performSearch(String query) {
    if (query.isEmpty) return;

    setState(() {
      _isSearching = true;
    });

    // 模拟搜索
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _isSearching = false;
        _searchResults = [
          {
            'title': '$query - 完整教程',
            'source': '官方文档',
            'snippet': '这是一份关于$query的详细教程，包含了基础概念、进阶技巧和最佳实践...',
            'time': '刚刚',
            'icon': Icons.article,
            'color': Colors.blue,
          },
          {
            'title': '$query 常见问题解答',
            'source': 'Stack Overflow',
            'snippet': '在学习和使用$query过程中，你可能会遇到以下常见问题...',
            'time': '1小时前',
            'icon': Icons.question_answer,
            'color': Colors.orange,
          },
          {
            'title': '$query 实战案例',
            'source': 'GitHub',
            'snippet': '这个开源项目展示了如何在实际项目中应用$query...',
            'time': '2天前',
            'icon': Icons.code,
            'color': Colors.green,
          },
          {
            'title': '$query 视频教程',
            'source': 'YouTube',
            'snippet': '由资深开发者录制的$query入门到精通系列教程...',
            'time': '1周前',
            'icon': Icons.play_circle,
            'color': Colors.red,
          },
        ];
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XiaoxiaTheme.softPink,
      appBar: AppBar(
        title: const Text('智能查资料'),
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
          child: Column(
            children: [
              // 搜索框
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: XiaoxiaTheme.primaryPink,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                ),
                child: TextField(
                  controller: _searchController,
                  onSubmitted: _performSearch,
                  decoration: InputDecoration(
                    hintText: '输入关键词搜索...',
                    hintStyle: const TextStyle(color: Colors.white70),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.white70),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                                _searchResults = [];
                              });
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                ),
              ),

              // 搜索结果或推荐内容
              Expanded(
                child: _isSearching
                    ? const Center(child: CircularProgressIndicator())
                    : _searchResults.isNotEmpty
                        ? _buildSearchResults()
                        : _buildRecommendations(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecommendations() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 热门话题
          Text(
            '热门话题',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.5,
            ),
            itemCount: _hotTopics.length,
            itemBuilder: (context, index) {
              final topic = _hotTopics[index];
              return GestureDetector(
                onTap: () {
                  _searchController.text = topic['title'];
                  _performSearch(topic['title']);
                },
                child: Container(
                  padding: const EdgeInsets.all(16),
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
                      Icon(
                        topic['icon'] as IconData,
                        color: topic['color'] as Color,
                        size: 32,
                      ),
                      const Spacer(),
                      Text(
                        topic['title'] as String,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        topic['category'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: XiaoxiaTheme.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 24),

          // 搜索历史
          if (_searchHistory.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '搜索历史',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      _searchHistory.clear();
                    });
                  },
                  child: const Text('清空'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ..._searchHistory.map((history) {
              return ListTile(
                leading: const Icon(Icons.history, color: Colors.grey),
                title: Text(history['query']!),
                trailing: Text(
                  history['time']!,
                  style: TextStyle(
                    fontSize: 12,
                    color: XiaoxiaTheme.textTertiary,
                  ),
                ),
                onTap: () {
                  _searchController.text = history['query']!;
                  _performSearch(history['query']!);
                },
              );
            }),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchResults() {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: _searchResults.length,
      itemBuilder: (context, index) {
        final result = _searchResults[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          elevation: 2,
          shadowColor: Colors.black.withOpacity(0.05),
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
                        color: (result['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        result['icon'] as IconData,
                        color: result['color'] as Color,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            result['title'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                result['source'] as String,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: XiaoxiaTheme.textTertiary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                '· ${result['time']}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: XiaoxiaTheme.textTertiary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  result['snippet'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    color: XiaoxiaTheme.textSecondary,
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildActionButton(Icons.open_in_new, '打开'),
                    const SizedBox(width: 12),
                    _buildActionButton(Icons.bookmark_border, '收藏'),
                    const SizedBox(width: 12),
                    _buildActionButton(Icons.share, '分享'),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return GestureDetector(
      onTap: () {},
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: XiaoxiaTheme.textTertiary),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: XiaoxiaTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
