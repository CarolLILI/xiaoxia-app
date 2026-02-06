import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme.dart';
import '../../models/health_model.dart';
import '../../services/health_service.dart';
import 'bmi_calculator_page.dart';
import 'steps_record_page.dart';
import 'water_record_page.dart';
import 'sleep_record_page.dart';

/// 健康助手首页
class HealthHomePage extends StatefulWidget {
  const HealthHomePage({super.key});

  @override
  State<HealthHomePage> createState() => _HealthHomePageState();
}

class _HealthHomePageState extends State<HealthHomePage> {
  BMIRecord? _latestBMI;
  int _todaySteps = 0;
  int _todayWater = 0;
  double _todaySleep = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final bmi = await HealthService.getLatestBMIRecord();
    final steps = await HealthService.getTodaySteps();
    final water = await HealthService.getTodayWater();
    final sleep = await HealthService.getTodaySleep();

    setState(() {
      _latestBMI = bmi;
      _todaySteps = steps;
      _todayWater = water;
      _todaySleep = sleep;
      _isLoading = false;
    });
  }

  Color _getBMIColor(double bmi) {
    if (bmi < 18.5) return Colors.blue;
    if (bmi < 24) return Colors.green;
    if (bmi < 28) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: XiaoxiaDecorations.softGradient,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            // BMI计算器卡片
                            _buildBMICard(context),
                            const SizedBox(height: 16),

                            // 今日数据概览
                            _buildTodayStats(),
                            const SizedBox(height: 16),

                            // 功能网格
                            _buildFunctionGrid(context),
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

  Widget _buildHeader(BuildContext context) {
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
              '健康助手',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: _loadData,
            icon: const Icon(Icons.refresh, color: XiaoxiaTheme.textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildBMICard(BuildContext context) {
    if (_latestBMI == null) {
      return GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const BMICalculatorPage()),
        ).then((_) => _loadData()),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                XiaoxiaTheme.primaryPink,
                XiaoxiaTheme.primaryPink.withOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Column(
            children: [
              Icon(Icons.monitor_weight, color: Colors.white, size: 48),
              SizedBox(height: 12),
              Text(
                '点击计算您的BMI',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    final bmi = _latestBMI!;
    final color = _getBMIColor(bmi.bmi);
    final progress = ((bmi.bmi - 15) / 20).clamp(0.0, 1.0);

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const BMICalculatorPage()),
      ).then((_) => _loadData()),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              color,
              color.withOpacity(0.8),
            ],
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.monitor_weight, color: Colors.white, size: 24),
                const SizedBox(width: 8),
                const Text(
                  'BMI指数',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    bmi.getStatus(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Text(
                  bmi.bmi.toStringAsFixed(1),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${bmi.height.toStringAsFixed(0)}cm / ${bmi.weight.toStringAsFixed(1)}kg',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      '${bmi.date.month}月${bmi.date.day}日更新',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              height: 8,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                borderRadius: BorderRadius.circular(4),
              ),
              child: FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: progress,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayStats() {
    return Row(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const StepsRecordPage()),
            ).then((_) => _loadData()),
            child: _buildStatCard(
              icon: Icons.directions_walk,
              label: '今日步数',
              value: _todaySteps.toString(),
              unit: '步',
              color: Colors.green,
              progress: (_todaySteps / 10000).clamp(0.0, 1.0),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const WaterRecordPage()),
            ).then((_) => _loadData()),
            child: _buildStatCard(
              icon: Icons.local_drink,
              label: '饮水量',
              value: _todayWater.toString(),
              unit: 'ml',
              color: Colors.blue,
              progress: (_todayWater / 2000).clamp(0.0, 1.0),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SleepRecordPage()),
            ).then((_) => _loadData()),
            child: _buildStatCard(
              icon: Icons.bedtime,
              label: '睡眠时长',
              value: _todaySleep > 0 ? _todaySleep.toStringAsFixed(1) : '--',
              unit: '小时',
              color: Colors.purple,
              progress: (_todaySleep / 8).clamp(0.0, 1.0),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
    double progress = 0,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: XiaoxiaTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 11,
              color: XiaoxiaTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[200],
              valueColor: AlwaysStoppedAnimation(color),
              minHeight: 3,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFunctionGrid(BuildContext context) {
    final functions = [
      {
        'icon': Icons.monitor_weight,
        'label': 'BMI计算',
        'color': Colors.pink,
        'page': const BMICalculatorPage(),
      },
      {
        'icon': Icons.directions_walk,
        'label': '步数记录',
        'color': Colors.green,
        'page': const StepsRecordPage(),
      },
      {
        'icon': Icons.local_drink,
        'label': '饮水提醒',
        'color': Colors.blue,
        'page': const WaterRecordPage(),
      },
      {
        'icon': Icons.bedtime,
        'label': '睡眠记录',
        'color': Colors.purple,
        'page': const SleepRecordPage(),
      },
      {
        'icon': Icons.favorite,
        'label': '心率监测',
        'color': Colors.red,
        'page': null,
      },
      {
        'icon': Icons.restaurant,
        'label': '饮食记录',
        'color': Colors.orange,
        'page': null,
      },
      {
        'icon': Icons.fitness_center,
        'label': '运动计划',
        'color': Colors.teal,
        'page': null,
      },
      {
        'icon': Icons.insights,
        'label': '健康报告',
        'color': Colors.indigo,
        'page': null,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '健康工具',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            childAspectRatio: 0.8,
          ),
          itemCount: functions.length,
          itemBuilder: (context, index) {
            final func = functions[index];
            return GestureDetector(
              onTap: () {
                if (func['page'] != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => func['page'] as Widget),
                  ).then((_) => _loadData());
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${func['label']}功能开发中...')),
                  );
                }
              },
              child: Column(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: (func['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      func['icon'] as IconData,
                      color: func['color'] as Color,
                      size: 24,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    func['label'] as String,
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
