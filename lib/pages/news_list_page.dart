import 'package:flutter/material.dart';
import '../theme.dart';
import 'news_detail_page.dart';

/// AI 快讯数据模型
class NewsItem {
  final String id;
  final String title;
  final String summary;
  final String content;
  final String category;
  final String source;
  final String publishTime;
  final String? imageUrl;
  final int readCount;
  bool isRead;

  NewsItem({
    required this.id,
    required this.title,
    required this.summary,
    required this.content,
    required this.category,
    required this.source,
    required this.publishTime,
    this.imageUrl,
    this.readCount = 0,
    this.isRead = false,
  });
}

/// 新闻列表页面
class NewsListPage extends StatefulWidget {
  const NewsListPage({super.key});

  @override
  State<NewsListPage> createState() => _NewsListPageState();
}

class _NewsListPageState extends State<NewsListPage> {
  bool _isLoading = true;
  List<NewsItem> _newsList = [];
  String _selectedCategory = '全部';
  final List<String> _categories = ['全部', '模型发布', '行业动态', '开源项目', '产品更新'];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  /// 模拟从网络获取数据
  Future<void> _loadNews() async {
    setState(() => _isLoading = true);
    
    // 模拟网络延迟
    await Future.delayed(const Duration(seconds: 1));
    
    // 模拟数据 - 后续可替换为真实 API
    final mockData = [
      NewsItem(
        id: '1',
        title: 'OpenAI 发布 GPT-5 预览版，多模态能力大幅提升',
        summary: '支持视频理解、实时翻译、代码生成等多项新功能，API 价格降低 50%',
        content: 'OpenAI 今日正式发布了 GPT-5 的预览版本，这是继 GPT-4 以来的又一次重大升级。新模型在视频理解、实时翻译、代码生成等方面都有显著提升...',
        category: '模型发布',
        source: 'OpenAI 官方',
        publishTime: '2小时前',
        readCount: 12580,
      ),
      NewsItem(
        id: '2',
        title: '国内大模型备案数量突破 100 家，监管框架日趋完善',
        summary: '百度、阿里、字节等头部企业均已通过备案，行业进入规范化发展阶段',
        content: '根据国家互联网信息办公室最新数据，截至目前已有超过 100 个大模型通过备案...',
        category: '行业动态',
        source: '网信办',
        publishTime: '4小时前',
        readCount: 8932,
      ),
      NewsItem(
        id: '3',
        title: 'Claude 4 即将发布，Anthropic 展示全新推理能力',
        summary: '在数学推理和代码理解测试中超越 GPT-4，支持 200K 上下文',
        content: 'Anthropic 今日公布了 Claude 4 的技术预览，新模型在复杂推理任务上表现出色...',
        category: '模型发布',
        source: 'Anthropic',
        publishTime: '5小时前',
        readCount: 15672,
      ),
      NewsItem(
        id: '4',
        title: 'Google Gemini 2.0 正式上线，免费用户可用',
        summary: '大幅提升中文理解能力，新增图像生成和视频分析功能',
        content: 'Google 宣布 Gemini 2.0 正式向所有用户开放，包括免费用户。新版本在中文理解方面进步明显...',
        category: '产品更新',
        source: 'Google Blog',
        publishTime: '6小时前',
        readCount: 22105,
      ),
      NewsItem(
        id: '5',
        title: 'AI 编程助手用户突破 1 亿，开发者效率提升显著',
        summary: 'GitHub Copilot、Cursor 等工具成为开发者标配，代码生成准确率达 85%',
        content: '根据最新统计，全球使用 AI 编程助手的开发者已超过 1 亿人...',
        category: '行业动态',
        source: 'GitHub',
        publishTime: '8小时前',
        readCount: 18920,
      ),
      NewsItem(
        id: '6',
        title: 'Meta 开源 LLaMA 4，支持 128K 上下文',
        summary: '性能对标 GPT-4，完全免费商用，社区反响热烈',
        content: 'Meta 今日在 GitHub 上开源了 LLaMA 4 系列模型，包含 7B、13B、70B 三个版本...',
        category: '开源项目',
        source: 'Meta AI',
        publishTime: '10小时前',
        readCount: 34210,
      ),
    ];
    
    setState(() {
      _newsList = mockData;
      _isLoading = false;
    });
  }

  List<NewsItem> get _filteredNews {
    if (_selectedCategory == '全部') return _newsList;
    return _newsList.where((news) => news.category == _selectedCategory).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: XiaoxiaDecorations.softGradient,
        child: SafeArea(
          child: Column(
            children: [
              // 顶部标题栏
              _buildHeader(),
              
              // 分类筛选
              _buildCategoryFilter(),
              
              // 新闻列表
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: _loadNews,
                        color: XiaoxiaTheme.primaryPink,
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredNews.length,
                          itemBuilder: (context, index) {
                            return _buildNewsCard(_filteredNews[index]);
                          },
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: XiaoxiaTheme.textDark),
          ),
          Expanded(
            child: Text(
              'AI 快讯',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () {
              // 搜索功能
              showSearch(
                context: context,
                delegate: NewsSearchDelegate(_newsList),
              );
            },
            icon: const Icon(Icons.search, color: XiaoxiaTheme.textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = category),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected 
                    ? XiaoxiaTheme.primaryPink 
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                category,
                style: TextStyle(
                  color: isSelected ? Colors.white : XiaoxiaTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewsCard(NewsItem news) {
    return GestureDetector(
      onTap: () => _openNewsDetail(news),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: XiaoxiaTheme.primaryPink.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 分类标签
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(news.category).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      news.category,
                      style: TextStyle(
                        color: _getCategoryColor(news.category),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    news.publishTime,
                    style: const TextStyle(
                      color: XiaoxiaTheme.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            
            // 标题
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                news.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.4,
                ),
              ),
            ),
            
            // 摘要
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Text(
                news.summary,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: XiaoxiaTheme.textSecondary,
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            
            // 底部信息
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: Row(
                children: [
                  Icon(
                    Icons.source_outlined,
                    size: 14,
                    color: XiaoxiaTheme.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    news.source,
                    style: const TextStyle(
                      color: XiaoxiaTheme.textTertiary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Icon(
                    Icons.remove_red_eye_outlined,
                    size: 14,
                    color: XiaoxiaTheme.textTertiary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${news.readCount}',
                    style: const TextStyle(
                      color: XiaoxiaTheme.textTertiary,
                      fontSize: 12,
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

  void _openNewsDetail(NewsItem news) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewsDetailPage(news: news),
      ),
    );
  }
}

/// 搜索代理
class NewsSearchDelegate extends SearchDelegate<String> {
  final List<NewsItem> newsList;

  NewsSearchDelegate(this.newsList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () => close(context, ''),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    final results = newsList.where(
      (news) => news.title.toLowerCase().contains(query.toLowerCase()),
    ).toList();

    return ListView.builder(
      itemCount: results.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(results[index].title),
          onTap: () => close(context, results[index].id),
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(child: Text('输入关键词搜索'));
    }
    return buildResults(context);
  }
}
