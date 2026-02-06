import 'package:flutter/material.dart';
import '../../theme.dart';

/// 智能日程页面
class SchedulePage extends StatefulWidget {
  const SchedulePage({super.key});

  @override
  State<SchedulePage> createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  DateTime _selectedDate = DateTime.now();
  int _selectedDayIndex = DateTime.now().weekday - 1;

  final List<Map<String, dynamic>> _weekDays = [
    {'label': '周一', 'date': '2/3'},
    {'label': '周二', 'date': '2/4'},
    {'label': '周三', 'date': '2/5'},
    {'label': '周四', 'date': '2/6'},
    {'label': '周五', 'date': '2/7'},
    {'label': '周六', 'date': '2/8'},
    {'label': '周日', 'date': '2/9'},
  ];

  final List<Map<String, dynamic>> _schedules = [
    {
      'time': '09:00',
      'title': '团队晨会',
      'location': '会议室 A',
      'type': '工作',
      'color': Colors.blue,
      'completed': true,
    },
    {
      'time': '10:30',
      'title': '产品评审',
      'location': '线上会议',
      'type': '会议',
      'color': Colors.orange,
      'completed': false,
    },
    {
      'time': '12:00',
      'title': '午餐休息',
      'location': '员工餐厅',
      'type': '生活',
      'color': Colors.green,
      'completed': false,
    },
    {
      'time': '14:00',
      'title': '客户演示',
      'location': '演示厅',
      'type': '重要',
      'color': Colors.red,
      'completed': false,
    },
    {
      'time': '16:00',
      'title': '代码审查',
      'location': '工位',
      'type': '工作',
      'color': Colors.blue,
      'completed': false,
    },
    {
      'time': '18:30',
      'title': '健身运动',
      'location': '健身房',
      'type': '健康',
      'color': Colors.purple,
      'completed': false,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XiaoxiaTheme.softPink,
      appBar: AppBar(
        title: const Text('智能日程'),
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
            onPressed: () => _showAddScheduleDialog(),
          ),
        ],
      ),
      body: Container(
        decoration: XiaoxiaDecorations.softGradient,
        child: Column(
          children: [
            // 日期选择器
            Container(
              padding: const EdgeInsets.symmetric(vertical: 20),
              decoration: BoxDecoration(
                color: XiaoxiaTheme.primaryPink,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(24),
                  bottomRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // 月份显示
                  Text(
                    '2026年2月',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // 星期选择
                  SizedBox(
                    height: 80,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: _weekDays.length,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemBuilder: (context, index) {
                        final day = _weekDays[index];
                        final isSelected = index == _selectedDayIndex;
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedDayIndex = index;
                            });
                          },
                          child: Container(
                            width: 60,
                            margin: const EdgeInsets.only(right: 12),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  day['label']!,
                                  style: TextStyle(
                                    color: isSelected
                                        ? XiaoxiaTheme.primaryPink
                                        : Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  day['date']!,
                                  style: TextStyle(
                                    color: isSelected
                                        ? XiaoxiaTheme.primaryPink
                                        : Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // AI 建议卡片
            Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    XiaoxiaTheme.lightPink.withOpacity(0.3),
                  ],
                ),
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.auto_awesome,
                      color: XiaoxiaTheme.primaryPink,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'AI 智能建议',
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '下午有重要会议，建议提前15分钟准备',
                          style: TextStyle(
                            fontSize: 13,
                            color: XiaoxiaTheme.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 今日概览
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '今日日程',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Row(
                    children: [
                      _buildFilterChip('全部', true),
                      const SizedBox(width: 8),
                      _buildFilterChip('未完成', false),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 日程列表
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: _schedules.length,
                itemBuilder: (context, index) {
                  return _buildScheduleItem(_schedules[index]);
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddScheduleDialog(),
        backgroundColor: XiaoxiaTheme.primaryPink,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildFilterChip(String label, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isSelected ? XiaoxiaTheme.primaryPink : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: isSelected ? Colors.white : XiaoxiaTheme.textSecondary,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildScheduleItem(Map<String, dynamic> schedule) {
    final isCompleted = schedule['completed'] as bool;
    final color = schedule['color'] as Color;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          // 时间
          SizedBox(
            width: 60,
            child: Column(
              children: [
                Text(
                  schedule['time']!,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Container(
                  width: 4,
                  height: 40,
                  decoration: BoxDecoration(
                    color: isCompleted ? Colors.grey[300] : color,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // 内容卡片
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  schedule['completed'] = !isCompleted;
                });
              },
              child: Container(
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
                  border: Border.all(
                    color: isCompleted
                        ? Colors.grey[300]!
                        : color.withOpacity(0.3),
                    width: 1,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: color.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  schedule['type']!,
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: color,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (isCompleted)
                                const Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            schedule['title']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
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
                                Icons.location_on_outlined,
                                size: 14,
                                color: XiaoxiaTheme.textTertiary,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                schedule['location']!,
                                style: TextStyle(
                                  fontSize: 13,
                                  color: XiaoxiaTheme.textTertiary,
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
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddScheduleDialog() {
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
                  '添加新日程',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: InputDecoration(
                    hintText: '日程标题',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    prefixIcon: const Icon(Icons.title),
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
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: '地点',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: const Icon(Icons.location_on),
                        ),
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
                    child: const Text('添加日程'),
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
