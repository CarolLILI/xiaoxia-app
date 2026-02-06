import 'package:flutter/material.dart';
import '../../theme.dart';

/// 学外语示例页面
class LanguageExamplePage extends StatefulWidget {
  const LanguageExamplePage({super.key});

  @override
  State<LanguageExamplePage> createState() => _LanguageExamplePageState();
}

class _LanguageExamplePageState extends State<LanguageExamplePage> {
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! 👋 Welcome to your English practice session. How are you feeling today?',
      'isUser': false,
      'timestamp': '09:00',
    },
    {
      'text': 'I\'m feeling great! Ready to learn some new words.',
      'isUser': true,
      'timestamp': '09:01',
    },
    {
      'text': 'Wonderful! Let\'s start with today\'s vocabulary. 📚',
      'isUser': false,
      'timestamp': '09:01',
    },
    {
      'text': 'Today we\'ll learn 5 new words about technology. First word: "Artificial Intelligence" - it means machines that can think and learn like humans.',
      'isUser': false,
      'timestamp': '09:02',
    },
    {
      'text': 'Can you use it in a sentence?',
      'isUser': true,
      'timestamp': '09:03',
    },
    {
      'text': 'Great question! Here\'s an example: "Artificial intelligence is changing the way we work and live." 🎯',
      'isUser': false,
      'timestamp': '09:03',
    },
  ];

  final TextEditingController _messageController = TextEditingController();
  String _selectedLanguage = '英语';
  int _dailyGoal = 20;
  int _learnedToday = 12;

  final List<Map<String, dynamic>> _languages = [
    {
      'name': '英语',
      'flag': '🇺🇸',
      'level': '中级',
      'progress': 0.65,
      'color': Colors.blue,
    },
    {
      'name': '日语',
      'flag': '🇯🇵',
      'level': '初级',
      'progress': 0.25,
      'color': Colors.red,
    },
    {
      'name': '韩语',
      'flag': '🇰🇷',
      'level': '入门',
      'progress': 0.10,
      'color': Colors.purple,
    },
  ];

  final List<Map<String, dynamic>> _vocabulary = [
    {
      'word': 'Serendipity',
      'pronunciation': '/ˌser.ənˈdɪp.ə.ti/',
      'meaning': '意外发现珍宝的运气',
      'example': 'Finding this restaurant was pure serendipity.',
    },
    {
      'word': 'Ephemeral',
      'pronunciation': '/ɪˈfem.ər.əl/',
      'meaning': '短暂的，转瞬即逝的',
      'example': 'Fashion is ephemeral, changing with every season.',
    },
    {
      'word': 'Resilience',
      'pronunciation': '/rɪˈzɪl.jəns/',
      'meaning': '韧性，恢复力',
      'example': 'Her resilience helped her overcome many challenges.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: XiaoxiaTheme.softPink,
        appBar: AppBar(
          title: const Text('AI 学外语'),
          backgroundColor: XiaoxiaTheme.primaryPink,
          foregroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: const TabBar(
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            tabs: [
              Tab(icon: Icon(Icons.chat), text: '对话'),
              Tab(icon: Icon(Icons.menu_book), text: '单词'),
              Tab(icon: Icon(Icons.emoji_events), text: '进度'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildChatTab(),
            _buildVocabularyTab(),
            _buildProgressTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildChatTab() {
    return Column(
      children: [
        // 语言选择器
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
              Text(
                '当前语言:',
                style: TextStyle(
                  color: XiaoxiaTheme.textSecondary,
                  fontSize: 14,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: XiaoxiaTheme.lightPink.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('🇺🇸', style: TextStyle(fontSize: 16)),
                    const SizedBox(width: 4),
                    Text(
                      _selectedLanguage,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.translate, size: 18),
                label: const Text('翻译'),
              ),
            ],
          ),
        ),

        // 消息列表
        Expanded(
          child: Container(
            decoration: XiaoxiaDecorations.softGradient,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                return _buildMessageBubble(message);
              },
            ),
          ),
        ),

        // 输入框
        Container(
          padding: const EdgeInsets.all(16),
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
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.mic, color: XiaoxiaTheme.primaryPink),
                onPressed: () {},
              ),
              Expanded(
                child: TextField(
                  controller: _messageController,
                  decoration: InputDecoration(
                    hintText: '输入消息或点击麦克风说话...',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(24),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              GestureDetector(
                onTap: () {
                  if (_messageController.text.isNotEmpty) {
                    setState(() {
                      _messages.add({
                        'text': _messageController.text,
                        'isUser': true,
                        'timestamp': '09:04',
                      });
                      _messageController.clear();
                    });

                    // 模拟 AI 回复
                    Future.delayed(const Duration(seconds: 1), () {
                      setState(() {
                        _messages.add({
                          'text': 'Excellent! Your English is improving. Keep practicing! 🌟',
                          'isUser': false,
                          'timestamp': '09:04',
                        });
                      });
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                    color: XiaoxiaTheme.primaryPink,
                    shape: BoxShape.circle,
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
        ),
      ],
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message) {
    final isUser = message['isUser'] as bool;

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        child: Column(
          crossAxisAlignment:
              isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: isUser
                    ? XiaoxiaTheme.primaryPink
                    : Colors.white,
                borderRadius: BorderRadius.circular(20).copyWith(
                  bottomRight: isUser ? const Radius.circular(4) : null,
                  bottomLeft: !isUser ? const Radius.circular(4) : null,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Text(
                message['text'] as String,
                style: TextStyle(
                  color: isUser ? Colors.white : XiaoxiaTheme.textDark,
                  fontSize: 15,
                  height: 1.4,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              message['timestamp'] as String,
              style: TextStyle(
                fontSize: 11,
                color: XiaoxiaTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVocabularyTab() {
    return Container(
      decoration: XiaoxiaDecorations.softGradient,
      child: ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: _vocabulary.length,
        itemBuilder: (context, index) {
          final word = _vocabulary[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      word['word'] as String,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: XiaoxiaTheme.textDark,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.volume_up),
                          onPressed: () {},
                        ),
                        IconButton(
                          icon: const Icon(Icons.bookmark_border),
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  word['pronunciation'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    color: XiaoxiaTheme.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                const Divider(height: 24),
                Text(
                  '中文释义',
                  style: TextStyle(
                    fontSize: 12,
                    color: XiaoxiaTheme.textTertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  word['meaning'] as String,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '例句',
                  style: TextStyle(
                    fontSize: 12,
                    color: XiaoxiaTheme.textTertiary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  word['example'] as String,
                  style: TextStyle(
                    fontSize: 14,
                    color: XiaoxiaTheme.textSecondary,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildProgressTab() {
    return Container(
      decoration: XiaoxiaDecorations.softGradient,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 今日目标
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    XiaoxiaTheme.primaryPink,
                    XiaoxiaTheme.accentBlue,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text(
                    '今日学习进度',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '$_learnedToday',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        ' / $_dailyGoal',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    '单词已掌握',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _learnedToday / _dailyGoal,
                      backgroundColor: Colors.white.withOpacity(0.3),
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 10,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 学习语言列表
            Text(
              '我的语言',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            ..._languages.map((lang) => _buildLanguageProgressCard(lang)),
            const SizedBox(height: 24),

            // 学习统计
            Text(
              '学习统计',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('连续学习', '12天', Icons.local_fire_department, Colors.orange),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('总词汇量', '256', Icons.menu_book, Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('对话次数', '48', Icons.chat, Colors.green),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('学习时长', '36h', Icons.timer, Colors.purple),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageProgressCard(Map<String, dynamic> lang) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
      child: Row(
        children: [
          Text(
            lang['flag'] as String,
            style: const TextStyle(fontSize: 32),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      lang['name'] as String,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: (lang['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        lang['level'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          color: lang['color'] as Color,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: lang['progress'] as double,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      lang['color'] as Color,
                    ),
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
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
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
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
    _messageController.dispose();
    super.dispose();
  }
}
