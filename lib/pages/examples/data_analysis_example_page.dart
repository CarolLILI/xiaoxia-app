import 'package:flutter/material.dart';
import '../../theme.dart';

/// 数据分析示例页面
class DataAnalysisExamplePage extends StatefulWidget {
  const DataAnalysisExamplePage({super.key});

  @override
  State<DataAnalysisExamplePage> createState() => _DataAnalysisExamplePageState();
}

class _DataAnalysisExamplePageState extends State<DataAnalysisExamplePage> {
  String _selectedPeriod = '本周';
  final List<String> _periods = ['今日', '本周', '本月', '本年'];

  final List<Map<String, dynamic>> _chartData = [
    {'label': '周一', 'value': 65, 'color': Colors.blue},
    {'label': '周二', 'value': 78, 'color': Colors.blue},
    {'label': '周三', 'value': 92, 'color': XiaoxiaTheme.primaryPink},
    {'label': '周四', 'value': 85, 'color': Colors.blue},
    {'label': '周五', 'value': 70, 'color': Colors.blue},
    {'label': '周六', 'value': 55, 'color': Colors.orange},
    {'label': '周日', 'value': 48, 'color': Colors.orange},
  ];

  final List<Map<String, dynamic>> _pieData = [
    {'label': '直接访问', 'value': 35, 'color': Colors.blue},
    {'label': '搜索引擎', 'value': 28, 'color': Colors.green},
    {'label': '社交媒体', 'value': 22, 'color': XiaoxiaTheme.primaryPink},
    {'label': '邮件营销', 'value': 15, 'color': Colors.orange},
  ];

  final List<Map<String, dynamic>> _trends = [
    {
      'title': '访问量峰值',
      'value': '+23%',
      'description': '相比上周增长',
      'isPositive': true,
    },
    {
      'title': '用户留存',
      'value': '-5%',
      'description': '需关注用户粘性',
      'isPositive': false,
    },
    {
      'title': '转化率',
      'value': '+12%',
      'description': '优化效果显著',
      'isPositive': true,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XiaoxiaTheme.softPink,
      appBar: AppBar(
        title: const Text('智能数据分析'),
        backgroundColor: XiaoxiaTheme.primaryPink,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
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
                // 时间选择器
                SizedBox(
                  height: 40,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: _periods.length,
                    itemBuilder: (context, index) {
                      final period = _periods[index];
                      final isSelected = _selectedPeriod == period;
                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedPeriod = period;
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? XiaoxiaTheme.primaryPink
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Text(
                            period,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : XiaoxiaTheme.textSecondary,
                              fontSize: 14,
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
                const SizedBox(height: 24),

                // 关键指标卡片
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        '总访问量',
                        '12,458',
                        '+15.3%',
                        Icons.visibility,
                        Colors.blue,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        '活跃用户',
                        '3,892',
                        '+8.7%',
                        Icons.people,
                        Colors.green,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                        '平均时长',
                        '5:32',
                        '+22.1%',
                        Icons.timer,
                        Colors.orange,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricCard(
                        '转化率',
                        '4.2%',
                        '-2.1%',
                        Icons.trending_up,
                        Colors.red,
                        isNegative: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // 柱状图
                Text(
                  '每日访问量趋势',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
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
                    children: [
                      SizedBox(
                        height: 200,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: _chartData.map((data) {
                            return Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Container(
                                      height: (data['value'] as int) * 1.8,
                                      decoration: BoxDecoration(
                                        color: data['color'] as Color,
                                        borderRadius: const BorderRadius.vertical(
                                          top: Radius.circular(8),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      data['label'] as String,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: XiaoxiaTheme.textTertiary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _buildLegend('工作日', Colors.blue),
                          const SizedBox(width: 16),
                          _buildLegend('周末', Colors.orange),
                          const SizedBox(width: 16),
                          _buildLegend('峰值', XiaoxiaTheme.primaryPink),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // 饼图和趋势分析
                Row(
                  children: [
                    Expanded(
                      child: _buildPieChartCard(),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTrendCard(),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // AI 洞察
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        XiaoxiaTheme.primaryPink.withOpacity(0.1),
                        XiaoxiaTheme.accentBlue.withOpacity(0.1),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: XiaoxiaTheme.primaryPink.withOpacity(0.2),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.auto_awesome,
                            color: XiaoxiaTheme.primaryPink,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'AI 数据洞察',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: XiaoxiaTheme.primaryPink,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Text(
                        '• 周三访问量达到峰值，建议在此时段发布重要内容\n'
                        '• 周末活跃度下降，可考虑推出周末专属活动\n'
                        '• 社交媒体流量增长显著，建议加大社交推广力度',
                        style: TextStyle(
                          height: 1.8,
                          color: XiaoxiaTheme.textSecondary,
                        ),
                      ),
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

  Widget _buildMetricCard(
    String title,
    String value,
    String change,
    IconData icon,
    Color color, {
    bool isNegative = false,
  }) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: isNegative
                      ? Colors.red.withOpacity(0.1)
                      : Colors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  change,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isNegative ? Colors.red : Colors.green,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
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

  Widget _buildLegend(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: XiaoxiaTheme.textTertiary,
          ),
        ),
      ],
    );
  }

  Widget _buildPieChartCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          const Text(
            '流量来源',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 120,
            child: CustomPaint(
              size: const Size(120, 120),
              painter: PieChartPainter(_pieData),
            ),
          ),
          const SizedBox(height: 16),
          ..._pieData.map((data) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: data['color'] as Color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    data['label'] as String,
                    style: const TextStyle(fontSize: 12),
                  ),
                  const Spacer(),
                  Text(
                    '${data['value']}%',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTrendCard() {
    return Container(
      padding: const EdgeInsets.all(16),
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
          const Text(
            '关键趋势',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 16),
          ..._trends.map((trend) {
            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (trend['isPositive'] as bool)
                    ? Colors.green.withOpacity(0.05)
                    : Colors.red.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        trend['title'] as String,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        trend['value'] as String,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: (trend['isPositive'] as bool)
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    trend['description'] as String,
                    style: TextStyle(
                      fontSize: 11,
                      color: XiaoxiaTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

// 简单的饼图画笔
class PieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    double startAngle = -90 * 3.14159265359 / 180;
    final total = data.fold<int>(
      0,
      (sum, item) => sum + (item['value'] as int),
    );

    for (final item in data) {
      final sweepAngle = (item['value'] as int) / total * 2 * 3.14159265359;

      final paint = Paint()
        ..color = item['color'] as Color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // 画中心圆
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.5, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
