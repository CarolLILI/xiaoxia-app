import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme.dart';
import '../../services/translation_service.dart';

/// 翻译助手首页
class TranslateHomePage extends StatefulWidget {
  const TranslateHomePage({super.key});

  @override
  State<TranslateHomePage> createState() => _TranslateHomePageState();
}

class _TranslateHomePageState extends State<TranslateHomePage> {
  final TextEditingController _sourceController = TextEditingController();
  final TextEditingController _resultController = TextEditingController();
  
  String _fromLang = 'auto';
  String _toLang = 'en';
  bool _isTranslating = false;
  bool _isSpeaking = false;
  
  List<TranslationHistory> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    _sourceController.dispose();
    _resultController.dispose();
    super.dispose();
  }

  void _loadHistory() {
    setState(() {
      _history = TranslationHistoryService.getHistory();
    });
  }

  Future<void> _translate() async {
    final text = _sourceController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入要翻译的文本')),
      );
      return;
    }

    setState(() => _isTranslating = true);

    try {
      final result = await TranslationService.translate(text, _fromLang, _toLang);
      
      setState(() {
        _resultController.text = result;
        _isTranslating = false;
      });

      // 保存到历史
      final historyItem = TranslationHistory(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sourceText: text,
        translatedText: result,
        fromLang: _fromLang,
        toLang: _toLang,
        timestamp: DateTime.now(),
      );
      TranslationHistoryService.addHistory(historyItem);
      _loadHistory();
    } catch (e) {
      setState(() => _isTranslating = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('翻译失败: $e')),
      );
    }
  }

  void _swapLanguages() {
    if (_fromLang == 'auto') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('自动检测语言无法互换')),
      );
      return;
    }
    setState(() {
      final temp = _fromLang;
      _fromLang = _toLang;
      _toLang = temp;
      
      // 同时交换文本
      final sourceText = _sourceController.text;
      _sourceController.text = _resultController.text;
      _resultController.text = sourceText;
    });
  }

  void _clearAll() {
    setState(() {
      _sourceController.clear();
      _resultController.clear();
    });
  }

  void _copyResult() {
    final text = _resultController.text;
    if (text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('已复制到剪贴板')),
      );
    }
  }

  Future<void> _speakText(String text) async {
    if (text.isEmpty) return;
    
    setState(() => _isSpeaking = true);
    
    // 模拟语音播放
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isSpeaking = false);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('语音播放（模拟）')),
    );
  }

  void _showLanguageSelector(bool isFrom) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
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
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                isFrom ? '选择源语言' : '选择目标语言',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: TranslationService.languages.length,
                itemBuilder: (context, index) {
                  final entry = TranslationService.languages.entries.elementAt(index);
                  final isSelected = isFrom 
                      ? _fromLang == entry.key 
                      : _toLang == entry.key;
                  
                  // 目标语言不能选自动检测
                  if (!isFrom && entry.key == 'auto') {
                    return const SizedBox.shrink();
                  }
                  
                  return ListTile(
                    title: Text(entry.value),
                    trailing: isSelected 
                        ? const Icon(Icons.check, color: XiaoxiaTheme.primaryPink)
                        : null,
                    onTap: () {
                      setState(() {
                        if (isFrom) {
                          _fromLang = entry.key;
                        } else {
                          _toLang = entry.key;
                        }
                      });
                      Navigator.pop(context);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
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
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // 语言选择器
                      _buildLanguageSelector(),
                      const SizedBox(height: 20),
                      
                      // 输入区域
                      _buildInputArea(),
                      const SizedBox(height: 16),
                      
                      // 翻译按钮
                      _buildTranslateButton(),
                      const SizedBox(height: 20),
                      
                      // 结果区域
                      _buildResultArea(),
                      const SizedBox(height: 24),
                      
                      // 历史记录
                      _buildHistorySection(),
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
              '翻译助手',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: _clearAll,
            icon: const Icon(Icons.clear_all, color: XiaoxiaTheme.textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
      child: Row(
        children: [
          // 源语言
          Expanded(
            child: GestureDetector(
              onTap: () => _showLanguageSelector(true),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: XiaoxiaTheme.softPink,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  TranslationService.languages[_fromLang] ?? '自动检测',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: XiaoxiaTheme.primaryPink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          
          // 交换按钮
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: GestureDetector(
              onTap: _swapLanguages,
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.swap_horiz,
                  color: XiaoxiaTheme.primaryPink,
                ),
              ),
            ),
          ),
          
          // 目标语言
          Expanded(
            child: GestureDetector(
              onTap: () => _showLanguageSelector(false),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: XiaoxiaTheme.softPink,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  TranslationService.languages[_toLang] ?? '英语',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: XiaoxiaTheme.primaryPink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
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
          TextField(
            controller: _sourceController,
            maxLines: 5,
            maxLength: 1000,
            decoration: InputDecoration(
              hintText: '请输入要翻译的文本...',
              hintStyle: TextStyle(color: XiaoxiaTheme.textTertiary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterText: '',
            ),
          ),
          Divider(height: 1, color: Colors.grey[200]),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => _sourceController.clear(),
                  icon: const Icon(Icons.clear, size: 20),
                  color: XiaoxiaTheme.textTertiary,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => _speakText(_sourceController.text),
                  icon: const Icon(Icons.volume_up, size: 20),
                  color: XiaoxiaTheme.textTertiary,
                ),
                IconButton(
                  onPressed: () {
                    // 语音输入（模拟）
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('语音输入（模拟）')),
                    );
                  },
                  icon: const Icon(Icons.mic, size: 20),
                  color: XiaoxiaTheme.primaryPink,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTranslateButton() {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton.icon(
        onPressed: _isTranslating ? null : _translate,
        style: ElevatedButton.styleFrom(
          backgroundColor: XiaoxiaTheme.primaryPink,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: _isTranslating ? 0 : 2,
        ),
        icon: _isTranslating
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : const Icon(Icons.translate),
        label: Text(
          _isTranslating ? '翻译中...' : '翻译',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildResultArea() {
    return Container(
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
          TextField(
            controller: _resultController,
            maxLines: 5,
            readOnly: true,
            decoration: InputDecoration(
              hintText: '翻译结果将显示在这里...',
              hintStyle: TextStyle(color: XiaoxiaTheme.textTertiary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
            ),
          ),
          if (_resultController.text.isNotEmpty)
            Divider(height: 1, color: Colors.grey[200]),
          if (_resultController.text.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: _copyResult,
                    icon: const Icon(Icons.copy, size: 20),
                    color: XiaoxiaTheme.textTertiary,
                  ),
                  IconButton(
                    onPressed: () => _speakText(_resultController.text),
                    icon: _isSpeaking
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.volume_up, size: 20),
                    color: XiaoxiaTheme.textTertiary,
                  ),
                  IconButton(
                    onPressed: () {
                      // 分享
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('分享功能（模拟）')),
                      );
                    },
                    icon: const Icon(Icons.share, size: 20),
                    color: XiaoxiaTheme.textTertiary,
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {
                      setState(() {
                        _sourceController.text = _resultController.text;
                        _resultController.clear();
                      });
                    },
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    label: const Text('继续翻译'),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHistorySection() {
    if (_history.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '翻译历史',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            TextButton(
              onPressed: () {
                TranslationHistoryService.clearHistory();
                _loadHistory();
              },
              child: const Text('清空'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: min(_history.length, 5),
          itemBuilder: (context, index) {
            final item = _history[index];
            return _buildHistoryItem(item);
          },
        ),
      ],
    );
  }

  Widget _buildHistoryItem(TranslationHistory item) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _sourceController.text = item.sourceText;
          _resultController.text = item.translatedText;
          _fromLang = item.fromLang;
          _toLang = item.toLang;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${TranslationService.languages[item.fromLang] ?? '自动'} → ${TranslationService.languages[item.toLang] ?? '英语'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: XiaoxiaTheme.primaryPink,
                  ),
                ),
                const Spacer(),
                Text(
                  '${item.timestamp.hour}:${item.timestamp.minute.toString().padLeft(2, '0')}',
                  style: TextStyle(
                    fontSize: 12,
                    color: XiaoxiaTheme.textTertiary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              item.sourceText,
              style: const TextStyle(fontSize: 14),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              item.translatedText,
              style: TextStyle(
                fontSize: 13,
                color: XiaoxiaTheme.textSecondary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
