import 'package:flutter/material.dart';
import '../../theme.dart';

/// 做规划示例页面
class PlanningExamplePage extends StatefulWidget {
  const PlanningExamplePage({super.key});

  @override
  State<PlanningExamplePage> createState() => _PlanningExamplePageState();
}

class _PlanningExamplePageState extends State<PlanningExamplePage> {
  final List<Map<String, dynamic>> _goals = [
    {
      'title': '学习 Flutter 开发',
      'progress': 0.75,
      'deadline': '2026-03-01',
      'tasks': 12,
      'completed': 9,
      'color': Colors.blue,
    },
    {
      'title': '健身计划',
      'progress': 0.45,
      'deadline': '2026-06-01',
      'tasks': 20,
      'completed': 9,
      'color': Colors.green,
    },
    {
      'title': '读书目标',
      'progress': 0.30,
      'deadline': '2026-12-31',
      'tasks': 10,
      'completed': 3,
      'color': Colors.orange,
    },
  ];

  final List<Map<String, dynamic>> _todayTasks = [
    {
      'title': '完成 Flutter 项目首页',
      'time': '09:00',
      'completed': true,
      'priority': 'high',
    },
    {
      'title': '阅读技术文档30分钟',
      'time': '14:00',
      'completed': false,
      'priority': 'medium',
    },
    {
      'title': '健身运动45分钟',
      'time': '18:00',
      'completed': false,
      'priority': 'high',
    },
    {
      'title': '整理学习笔记',
      'time': '20:00',
      'completed': false,
      'priority': 'low',
    },
  ];

  String _selectedFilter = '全部';
  final List<String> _filters = ['全部', '工作', '学习', '生活', '健康'];

  @override
  Widget build(BuildContext context) {
    final completedTasks = _todayTasks.where((t) => t['completed'] as bool).length;
    final totalTasks = _todayTasks.length;

    return Scaffold(
      backgroundColor: XiaoxiaTheme.softPink,
      appBar: AppBar(
        title: const Text('智能规划'),
        backgroundColor: XiaoxiaTheme.primaryPink,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddTaskDialog(),
          ),
        ],
      ),
      body: Container(
        decoration: XiaoxiaDecorations.softGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 今日概览卡片
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                '今日进度',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '$completedTasks/$totalTasks',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 36,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text(
                                '任务完成',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 100,
                            height: 100,
                            child: CircularProgressIndicator(
                              value: completedTasks / totalTasks,
                              strokeWidth: 10,
                              backgroundColor: Colors.white.withOpacity(0.3),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.lightbulb,
                              color: Colors.yellow,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            const Expanded(
                              child: Text(
                                'AI 建议：下午有2个高优先级任务，建议提前准备',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 长期目标
                Text(
                  '长期目标',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                ..._goals.map((goal) => _buildGoalCard(goal)),
                const SizedBox(height: 24),

                // 今日任务
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '今日任务',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('查看全部'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // 过滤器
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final filter = _filters[index];
                      final isSelected = _selectedFilter == filter;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? XiaoxiaTheme.primaryPink
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            filter,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : XiaoxiaTheme.textSecondary,
                              fontSize: 13,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // 任务列表
                ..._todayTasks.map((task) => _buildTaskItem(task)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalCard(Map<String, dynamic> goal) {
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: goal['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    goal['title'] as String,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              Text(
                '${(goal['progress'] * 100).toInt()}%',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: goal['color'] as Color,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: goal['progress'] as double,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation<Color>(goal['color'] as Color),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${goal['completed']}/${goal['tasks']} 任务',
                style: TextStyle(
                  fontSize: 13,
                  color: XiaoxiaTheme.textTertiary,
                ),
              ),
              Text(
                '截止: ${goal['deadline']}',
                style: TextStyle(
                  fontSize: 13,
                  color: XiaoxiaTheme.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTaskItem(Map<String, dynamic> task) {
    final isCompleted = task['completed'] as bool;
    final priority = task['priority'] as String;

    Color priorityColor;
    switch (priority) {
      case 'high':
        priorityColor = Colors.red;
        break;
      case 'medium':
        priorityColor = Colors.orange;
        break;
      default:
        priorityColor = Colors.green;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isCompleted ? Colors.grey[50] : Colors.white,
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
          GestureDetector(
            onTap: () {
              setState(() {
                task['completed'] = !isCompleted;
              });
            },
            child: Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: isCompleted ? Colors.green : Colors.transparent,
                border: Border.all(
                  color: isCompleted ? Colors.green : Colors.grey[400]!,
                  width: 2,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : null,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task['title'] as String,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    decoration: isCompleted
                        ? TextDecoration.lineThrough
                        : null,
                    color: isCompleted
                        ? XiaoxiaTheme.textTertiary
                        : XiaoxiaTheme.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: XiaoxiaTheme.textTertiary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task['time'] as String,
                      style: TextStyle(
                        fontSize: 12,
                        color: XiaoxiaTheme.textTertiary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: priorityColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        priority == 'high'
                            ? '高'
                            : priority == 'medium'
                                ? '中'
                                : '低',
                        style: TextStyle(
                          fontSize: 10,
                          color: priorityColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.grey),
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'edit',
                child: Row(
                  children: [
                    Icon(Icons.edit, size: 18),
                    SizedBox(width: 8),
                    Text('编辑'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'delete',
                child: Row(
                  children: [
                    Icon(Icons.delete, size: 18, color: Colors.red),
                    SizedBox(width: 8),
                    Text('删除', style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddTaskDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '添加新任务',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: '任务名称',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '时间',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.access_time),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        hint: const Text('优先级'),
                        items: ['高', '中', '低']
                            .map((e) => DropdownMenuItem(
                                  value: e,
                                  child: Text(e),
                                ))
                            .toList(),
                        onChanged: (value) {},
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
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
                    child: const Text('添加任务'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
