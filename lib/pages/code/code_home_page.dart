import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme.dart';
import '../../models/code_example_model.dart';
import '../../services/code_service.dart';
import 'code_detail_page.dart';

/// 代码库首页
class CodeHomePage extends StatefulWidget {
  const CodeHomePage({super.key});

  @override
  State<CodeHomePage> createState() => _CodeHomePageState();
}

class _CodeHomePageState extends State<CodeHomePage> {
  List<CodeExample> _examples = [];
  String _selectedLanguage = 'all';
  String _searchQuery = '';

  final List<Map<String, dynamic>> _languages = [
    {'name': 'all', 'display': '全部', 'color': XiaoxiaTheme.primaryPink},
    {'name': 'flutter', 'display': 'Flutter', 'color': const Color(0xFF54C5F8)},
    {'name': 'python', 'display': 'Python', 'color': const Color(0xFF3776AB)},
    {'name': 'javascript', 'display': 'JavaScript', 'color': const Color(0xFFF7DF1E)},
    {'name': 'dart', 'display': 'Dart', 'color': const Color(0xFF00B4AB)},
  ];

  @override
  void initState() {
    super.initState();
    _loadExamples();
  }

  void _loadExamples() {
    if (_searchQuery.isNotEmpty) {
      _examples = CodeService.searchExamples(_searchQuery);
    } else if (_selectedLanguage != 'all') {
      _examples = CodeService.getExamplesByLanguage(_selectedLanguage);
    } else {
      _examples = CodeService.getAllExamples();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: XiaoxiaDecorations.softGradient,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildSearchBar(),
              _buildLanguageFilter(),
              Expanded(
                child: _examples.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _examples.length,
                        itemBuilder: (context, index) {
                          return _buildCodeCard(_examples[index]);
                        },
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
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: XiaoxiaTheme.textDark),
          ),
          Expanded(
            child: Text(
              '代码示例库',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: (value) {
          _searchQuery = value;
          _loadExamples();
        },
        decoration: InputDecoration(
          hintText: '搜索代码...',
          hintStyle: TextStyle(color: XiaoxiaTheme.textTertiary),
          prefixIcon: const Icon(Icons.search, color: XiaoxiaTheme.textTertiary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      ),
    );
  }

  Widget _buildLanguageFilter() {
    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _languages.length,
        itemBuilder: (context, index) {
          final lang = _languages[index];
          final isSelected = lang['name'] == _selectedLanguage;

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedLanguage = lang['name'];
                _searchQuery = '';
              });
              _loadExamples();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? lang['color'] : Colors.white,
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
                lang['display'],
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

  Widget _buildCodeCard(CodeExample example) {
    final language = CodeLanguage.getByName(example.language);

    return GestureDetector(
      onTap: () => _openCodeDetail(example),
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
            // 顶部语言标签
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: language.color.withOpacity(0.1),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomRight: Radius.circular(12),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(language.icon, size: 16, color: language.color),
                  const SizedBox(width: 4),
                  Text(
                    language.displayName,
                    style: TextStyle(
                      color: language.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // 内容区域
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    example.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    example.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: XiaoxiaTheme.textSecondary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 12),

                  // 代码预览
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E1E1E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      example.code.split('\n').take(3).join('\n') + '\n...',
                      style: const TextStyle(
                        color: Color(0xFF4EC9B0),
                        fontSize: 11,
                        fontFamily: 'monospace',
                      ),
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  const SizedBox(height: 12),

                  // 分类标签
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: XiaoxiaTheme.softPink,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          example.category,
                          style: const TextStyle(
                            color: XiaoxiaTheme.primaryPink,
                            fontSize: 11,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: XiaoxiaTheme.textTertiary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.code_off_outlined,
            size: 64,
            color: XiaoxiaTheme.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无代码示例',
            style: TextStyle(
              color: XiaoxiaTheme.textTertiary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  void _openCodeDetail(CodeExample example) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CodeDetailPage(example: example),
      ),
    );
  }
}
