import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme.dart';
import '../../models/health_model.dart';
import '../../services/health_service.dart';

/// 步数记录页面
class StepsRecordPage extends StatefulWidget {
  const StepsRecordPage({super.key});

  @override
  State<StepsRecordPage> createState() => _StepsRecordPageState();
}

class _StepsRecordPageState extends State<StepsRecordPage> {
  final TextEditingController _stepsController = TextEditingController();
  int _todaySteps = 0;
  List<HealthData> _weeklyData = [];
  bool _isLoading = true;

  final int _goalSteps = 10000; // 每日目标步数

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final today = await HealthService.getTodaySteps();
    final weekly = await HealthService.getHealthDataByType('steps', limit: 7);
    
    setState(() {
      _todaySteps = today;
      _weeklyData = weekly;
      _isLoading = false;
    });
  }

  Future<void> _addSteps() async {
    final steps = int.tryParse(_stepsController.text);
    if (steps == null || steps <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入有效的步数')),
      );
      return;
    }

    final data = HealthData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'steps',
      value: steps.toDouble(),
      unit: '步',
      date: DateTime.now(),
    );

    await HealthService.saveHealthData(data);
    _stepsController.clear();
    _loadData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('步数已记录')),
      );
    }
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
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          children: [
                            _buildTodayCard(),
                            const SizedBox(height: 20),
                            _buildInputCard(),
                            const SizedBox(height: 20),
                            _buildWeeklyChart(),
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
              '步数记录',
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

  Widget _buildTodayCard() {
    final progress = _todaySteps / _goalSteps;
    final percentage = (progress * 100).clamp(0, 100);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.green,
            Colors.green.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.directions_walk, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                '今日步数',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _todaySteps.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            '步',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0.0, 1.0),
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '目标: $_goalSteps步 (${percentage.toInt()}%)',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildInputCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '记录步数',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _stepsController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: '输入步数',
                    suffixText: '步',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _addSteps,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.add),
                label: const Text('添加'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyChart() {
    if (_weeklyData.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Text('暂无数据'),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '近7天步数',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: _weeklyData.map((d) => d.value).reduce((a, b) => a > b ? a : b) * 1.2,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: TextStyle(fontSize: 10, color: XiaoxiaTheme.textTertiary),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() >= 0 && value.toInt() < _weeklyData.length) {
                          final date = _weeklyData[value.toInt()].date;
                          return Text(
                            '${date.month}/${date.day}',
                            style: TextStyle(fontSize: 10, color: XiaoxiaTheme.textTertiary),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                barGroups: List.generate(
                  _weeklyData.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: _weeklyData[index].value,
                        color: Colors.green,
                        width: 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
