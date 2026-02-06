import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme.dart';
import '../../models/health_model.dart';
import '../../services/health_service.dart';

/// BMI历史记录页面
class BMIHistoryPage extends StatefulWidget {
  const BMIHistoryPage({super.key});

  @override
  State<BMIHistoryPage> createState() => _BMIHistoryPageState();
}

class _BMIHistoryPageState extends State<BMIHistoryPage> {
  List<BMIRecord> _records = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecords();
  }

  Future<void> _loadRecords() async {
    final records = await HealthService.getBMIRecords();
    setState(() {
      _records = records;
      _isLoading = false;
    });
  }

  Future<void> _deleteRecord(String id) async {
    await HealthService.deleteBMIRecord(id);
    _loadRecords();
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
              _buildHeader(),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _records.isEmpty
                        ? _buildEmptyView()
                        : _buildContent(),
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
              'BMI历史',
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

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.show_chart,
            size: 80,
            color: XiaoxiaTheme.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无记录',
            style: TextStyle(
              fontSize: 18,
              color: XiaoxiaTheme.textTertiary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '快去记录您的第一条BMI数据吧',
            style: TextStyle(
              fontSize: 14,
              color: XiaoxiaTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 图表
          _buildChart(),
          const SizedBox(height: 20),
          
          // 统计信息
          _buildStats(),
          const SizedBox(height: 20),
          
          // 历史列表
          _buildHistoryList(),
        ],
      ),
    );
  }

  Widget _buildChart() {
    // 反转记录以便图表按时间顺序显示
    final chartRecords = _records.reversed.take(7).toList();
    
    return Container(
      height: 200,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, meta) {
                  return Text(
                    value.toStringAsFixed(1),
                    style: TextStyle(fontSize: 10, color: XiaoxiaTheme.textTertiary),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  if (value.toInt() >= 0 && value.toInt() < chartRecords.length) {
                    final date = chartRecords[value.toInt()].date;
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
                chartRecords.length,
                (index) => FlSpot(index.toDouble(), chartRecords[index].bmi),
              ),
              isCurved: true,
              color: XiaoxiaTheme.primaryPink,
              barWidth: 3,
              dotData: FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStats() {
    final bmis = _records.map((r) => r.bmi).toList();
    final avgBMI = bmis.reduce((a, b) => a + b) / bmis.length;
    final minBMI = bmis.reduce((a, b) => a < b ? a : b);
    final maxBMI = bmis.reduce((a, b) => a > b ? a : b);

    return Row(
      children: [
        Expanded(
          child: _buildStatCard('平均BMI', avgBMI.toStringAsFixed(1), XiaoxiaTheme.primaryPink),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('最低BMI', minBMI.toStringAsFixed(1), Colors.green),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard('最高BMI', maxBMI.toStringAsFixed(1), Colors.orange),
        ),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: XiaoxiaTheme.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '历史记录',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _records.length,
          itemBuilder: (context, index) {
            final record = _records[index];
            return _buildHistoryItem(record);
          },
        ),
      ],
    );
  }

  Widget _buildHistoryItem(BMIRecord record) {
    final color = _getBMIColor(record.bmi);
    
    return Dismissible(
      key: Key(record.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _deleteRecord(record.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(
                child: Text(
                  record.bmi.toStringAsFixed(1),
                  style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${record.height.toStringAsFixed(1)}cm / ${record.weight.toStringAsFixed(1)}kg',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${record.date.year}-${record.date.month.toString().padLeft(2, '0')}-${record.date.day.toString().padLeft(2, '0')}',
                    style: TextStyle(
                      fontSize: 12,
                      color: XiaoxiaTheme.textTertiary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                record.getStatus(),
                style: TextStyle(
                  color: color,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
