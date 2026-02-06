import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme.dart';

/// AI助手聊天页面
class AIAssistantPage extends StatefulWidget {
  const AIAssistantPage({super.key});

  @override
  State<AIAssistantPage> createState() => _AIAssistantPageState();
}

class _AIAssistantPageState extends State<AIAssistantPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<ChatMessage> _messages = [];
  bool _isTyping = false;

  // 快捷功能
  final List<Map<String, dynamic>> _quickActions = [
    {'icon': Icons.code, 'label': '写代码', 'prompt': '帮我写一段代码'},
    {'icon': Icons.edit, 'label': '改文案', 'prompt': '帮我优化这段文案'},
    {'icon': Icons.translate, 'label': '翻译', 'prompt': '帮我翻译这段话'},
    {'icon': Icons.lightbulb, 'label': '创意', 'prompt': '给我一些创意建议'},
    {'icon': Icons.calculate, 'label': '计算', 'prompt': '帮我计算一下'},
    {'icon': Icons.summarize, 'label': '总结', 'prompt': '帮我总结这段话'},
  ];

  // 预设回复
  final Map<String, List<String>> _responses = {
    '写代码': [
      '我来帮你写代码！请告诉我你需要什么功能的代码？',
      '好的，我来为你编写代码。请描述一下具体需求...',
    ],
    '改文案': [
      '我可以帮你优化文案！请把需要修改的内容发给我。',
      '文案优化是我的强项，请发送你的文案...',
    ],
    '翻译': [
      '我来帮你翻译！请发送需要翻译的内容和目标语言。',
      '翻译功能已准备好，请输入你要翻译的文本...',
    ],
    '创意': [
      '创意时间到！你想在哪个领域获得灵感？',
      '我很乐意帮你 brainstorm！请告诉我主题...',
    ],
    '计算': [
      '计算器模式启动！请告诉我计算公式...',
      '我来帮你算一算，请描述计算需求...',
    ],
    '总结': [
      '总结小助手在此！请发送需要总结的长文本。',
      '我可以帮你提炼重点，请发送原文...',
    ],
    'default': [
      '收到！我来帮你处理这个问题。',
      '好的，让我想想...',
      '明白了，这是我的建议：',
      '很有趣的问题！我是这样看的：',
      '收到你的消息啦！让我为你解答...',
    ],
  };

  @override
  void initState() {
    super.initState();
    // 添加欢迎消息
    _addBotMessage('你好呀！我是小虾 🦐\n\n我是你的AI助手，可以帮你：\n• 写代码、改文案\n• 翻译、总结\n• 提供创意灵感\n• 回答各种问题\n\n有什么我可以帮你的吗？');
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _addBotMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: false,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _addUserMessage(String text) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: true,
        timestamp: DateTime.now(),
      ));
    });
    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    _addUserMessage(text);
    _messageController.clear();

    setState(() => _isTyping = true);

    // 模拟思考时间
    await Future.delayed(const Duration(milliseconds: 800));

    // 根据内容生成回复
    final response = _generateResponse(text);
    
    setState(() => _isTyping = false);
    _addBotMessage(response);
  }

  String _generateResponse(String userMessage) {
    // 检查是否匹配快捷功能
    for (var action in _quickActions) {
      if (userMessage.contains(action['label']) || 
          userMessage.contains(action['prompt'])) {
        final responses = _responses[action['label']] ?? _responses['default']!;
        return responses[Random().nextInt(responses.length)];
      }
    }

    // 检查关键词
    if (userMessage.contains('你好') || userMessage.contains('嗨')) {
      return '你好呀！很高兴见到你 😊 有什么我可以帮你的吗？';
    }
    if (userMessage.contains('谢谢') || userMessage.contains('感谢')) {
      return '不客气！很高兴能帮到你 😊 有其他问题随时问我~';
    }
    if (userMessage.contains('再见') || userMessage.contains('拜拜')) {
      return '再见！有需要随时找我哦 👋';
    }
    if (userMessage.contains('时间') || userMessage.contains('几点')) {
      final now = DateTime.now();
      return '现在是 ${now.hour}:${now.minute.toString().padLeft(2, '0')} ⏰';
    }
    if (userMessage.contains('日期') || userMessage.contains('今天')) {
      final now = DateTime.now();
      return '今天是 ${now.year}年${now.month}月${now.day}日 📅';
    }

    // 默认回复
    final defaultResponses = _responses['default']!;
    return defaultResponses[Random().nextInt(defaultResponses.length)];
  }

  void _useQuickAction(Map<String, dynamic> action) {
    _messageController.text = action['prompt'];
    _addUserMessage(action['prompt']);
    
    setState(() => _isTyping = true);
    
    Future.delayed(const Duration(milliseconds: 800), () {
      final responses = _responses[action['label']] ?? _responses['default']!;
      final response = responses[Random().nextInt(responses.length)];
      
      setState(() => _isTyping = false);
      _addBotMessage(response);
    });
  }

  void _copyMessage(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('已复制到剪贴板')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        body: Container(
          decoration: XiaoxiaDecorations.softGradient,
          child: SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                Expanded(
                  child: Column(
                    children: [
                      // 快捷功能栏
                      _buildQuickActions(),
                      // 聊天列表
                      Expanded(
                        child: _buildMessageList(),
                      ),
                      // 输入框
                      _buildInputArea(),
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

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: XiaoxiaTheme.textDark),
          ),
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [XiaoxiaTheme.primaryPink, XiaoxiaTheme.accentPurple],
              ),
            ),
            child: const Center(
              child: Text('🦐', style: TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '小虾助手',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '在线',
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
          IconButton(
            onPressed: () {
              // 清空对话
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('清空对话'),
                  content: const Text('确定要清空所有对话记录吗？'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('取消'),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() => _messages.clear());
                        Navigator.pop(context);
                        _addBotMessage('对话已清空，有什么可以帮你的吗？');
                      },
                      child: const Text('确定', style: TextStyle(color: Colors.red)),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.delete_outline),
            color: XiaoxiaTheme.textTertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[200]!),
        ),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Row(
          children: _quickActions.map((action) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ActionChip(
                avatar: Icon(action['icon'] as IconData, size: 18),
                label: Text(action['label'] as String),
                backgroundColor: XiaoxiaTheme.softPink,
                side: BorderSide.none,
                onPressed: () => _useQuickAction(action),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final message = _messages[index];
        return _buildMessageBubble(message);
      },
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (!message.isUser) ...[
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [XiaoxiaTheme.primaryPink, XiaoxiaTheme.accentPurple],
                  ),
                ),
                child: const Center(
                  child: Text('🦐', style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(width: 8),
            ],
            Flexible(
              child: GestureDetector(
                onLongPress: () => _copyMessage(message.text),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: message.isUser 
                        ? XiaoxiaTheme.primaryPink 
                        : Colors.white,
                    borderRadius: BorderRadius.circular(20).copyWith(
                      bottomLeft: message.isUser ? const Radius.circular(20) : const Radius.circular(4),
                      bottomRight: message.isUser ? const Radius.circular(4) : const Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Text(
                    message.text,
                    style: TextStyle(
                      color: message.isUser ? Colors.white : XiaoxiaTheme.textDark,
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ),
            if (message.isUser) ...[
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: const Icon(Icons.person, size: 18, color: Colors.white),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_isTyping)
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation(XiaoxiaTheme.primaryPink),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '小虾正在思考...',
                            style: TextStyle(
                              fontSize: 12,
                              color: XiaoxiaTheme.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    // 语音输入（模拟）
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('语音输入功能开发中')),
                    );
                  },
                  icon: const Icon(Icons.mic),
                  color: XiaoxiaTheme.textTertiary,
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: TextField(
                      controller: _messageController,
                      decoration: InputDecoration(
                        hintText: '输入消息...',
                        hintStyle: TextStyle(color: XiaoxiaTheme.textTertiary),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                      ),
                      maxLines: null,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [XiaoxiaTheme.primaryPink, XiaoxiaTheme.accentPurple],
                      ),
                    ),
                    child: const Icon(
                      Icons.send,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 聊天消息模型
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    required this.timestamp,
  });
}
