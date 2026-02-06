import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme.dart';
import '../../models/health_model.dart';
import '../../services/health_service.dart';

/// 睡眠记录页面
class SleepRecordPage extends StatefulWidget {
  const SleepRecordPage({super.key});

  @override
  State<SleepRecordPage> createState() => _SleepRecordPageState();
}

class _SleepRecordPageState extends State<SleepRecordPage> {
  double _todaySleep = 0;
  List<HealthData> _weeklyData = [];
  bool _isLoading = true;

  final double _goalSleep = 8.0; // 每日目标睡眠时长

  // 时间选择器
  TimeOfDay _bedTime = const TimeOfDay(hour: 23, minute: 0);
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final today = await HealthService.getTodaySleep();
    final weekly = await HealthService.getHealthDataByType('sleep', limit: 7);
    
    setState(() {
      _todaySleep = today;
      _weeklyData = weekly;
      _isLoading = false;
    });
  }

  Future<void> _selectBedTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _bedTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: XiaoxiaTheme.primaryPink,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() => _bedTime = time);
    }
  }

  Future<void> _selectWakeTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: _wakeTime,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: XiaoxiaTheme.primaryPink,
            ),
          ),
          child: child!,
        );
      },
    );
    if (time != null) {
      setState(() => _wakeTime = time);
    }
  }

  double _calculateSleepDuration() {
    int bedMinutes = _bedTime.hour * 60 + _bedTime.minute;
    int wakeMinutes = _wakeTime.hour * 60 + _wakeTime.minute;
    
    // 如果醒来时间早于入睡时间，说明跨天了
    if (wakeMinutes < bedMinutes) {
      wakeMinutes += 24 * 60;
    }
    
    int durationMinutes = wakeMinutes - bedMinutes;
    return durationMinutes / 60.0;
  }

  Future<void> _saveSleep() async {
    final duration = _calculateSleepDuration();
    
    if (duration < 0 || duration > 24) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('无效的睡眠时间')),
      );
      return;
    }

    final data = HealthData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'sleep',
      value: duration,
      unit: '小时',
      date: DateTime.now(),
      note: '${_bedTime.format(context)} - ${_wakeTime.format(context)}',
    );

    await HealthService.saveHealthData(data);
    _loadData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('睡眠时长已记录: ${duration.toStringAsFixed(1)}小时')),
      );
    }
  }

  String _getSleepQuality(double hours) {
    if (hours < 5) return '睡眠不足';
    if (hours < 7) return '睡眠偏少';
    if (hours <= 9) return '睡眠良好';
    return '睡眠过多';
  }

  Color _getSleepColor(double hours) {
    if (hours < 5) return Colors.red;
    if (hours < 7) return Colors.orange;
    if (hours <= 9) return Colors.green;
    return Colors.blue;
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
                            _buildSleepCard(),
                            const SizedBox(height: 20),
                            _buildTimeSelector(),
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
              '睡眠记录',
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

  Widget _buildSleepCard() {
    final progress = (_todaySleep / _goalSleep).clamp(0.0, 1.0);
    final quality = _getSleepQuality(_todaySleep);
    final color = _getSleepColor(_todaySleep);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.purple,
            Colors.purple.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.purple.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.bedtime, color: Colors.white, size: 24),
              SizedBox(width: 8),
              Text(
                '今日睡眠',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            _todaySleep > 0 ? '${_todaySleep.toStringAsFixed(1)}' : '--',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Text(
            '小时',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 16),
          if (_todaySleep > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                quality,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.white.withOpacity(0.3),
              valueColor: const AlwaysStoppedAnimation(Colors.white),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '目标: $_goalSleep小时',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelector() {
    final sleepDuration = _calculateSleepDuration();

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
            '记录睡眠',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildTimeCard(
                  label: '入睡时间',
                  time: _bedTime,
                  icon: Icons.bedtime,
                  onTap: _selectBedTime,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Icon(Icons.arrow_forward, color: Colors.grey),
              ),
              Expanded(
                child: _buildTimeCard(
                  label: '醒来时间',
                  time: _wakeTime,
                  icon: Icons.wb_sunny,
                  onTap: _selectWakeTime,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.timer, color: Colors.purple),
                const SizedBox(width: 8),
                Text(
                  '预计睡眠时长: ${sleepDuration.toStringAsFixed(1)} 小时',
                  style: const TextStyle(
                    color: Colors.purple,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saveSleep,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              icon: const Icon(Icons.save),
              label: const Text('保存记录'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeCard({
    required String label,
    required TimeOfDay time,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: XiaoxiaTheme.primaryPink),
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
              time.format(context),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
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
          child: Text('暂无睡眠数据'),
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
            '近7天睡眠趋势',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 30,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}h',
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
                lineBarsData: [
                  LineChartBarData(
                    spots: List.generate(
                      _weeklyData.length,
                      (index) => FlSpot(index.toDouble(), _weeklyData[index].value),
                    ),
                    isCurved: true,
                    color: Colors.purple,
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.purple.withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
