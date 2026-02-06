import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme.dart';
import '../../models/expense_model.dart';
import '../../services/expense_service.dart';

/// 分析页面
class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  ExpenseStatistics? _statistics;
  Map<String, double> _last7Days = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    final stats = await ExpenseService.getStatistics(startOfMonth, endOfMonth);
    final last7Days = await ExpenseService.getLast7DaysData();

    setState(() {
      _statistics = stats;
      _last7Days = last7Days;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: XiaoxiaDecorations.softGradient,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadData,
            color: XiaoxiaTheme.primaryPink,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 20),

                  // 月度概览
                  _buildMonthOverview(),
                  const SizedBox(height: 20),

                  // 分类饼图
                  _buildCategoryChart(),
                  const SizedBox(height: 20),

                  // 趋势图
                  _buildTrendChart(),
                  const SizedBox(height: 20),

                  // 分类排行
                  _buildCategoryRanking(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: XiaoxiaTheme.textDark),
        ),
        Expanded(
          child: Text(
            '支出分析',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 48),
      ],
    );
  }

  Widget _buildMonthOverview() {
    return Container(
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
        boxShadow: [
          BoxShadow(
            color: XiaoxiaTheme.primaryPink.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _buildOverviewItem(
                  '本月支出',
                  _isLoading
                      ? '-'
                      : '¥${_statistics?.totalAmount.toStringAsFixed(2) ?? '0.00'}',
                ),
              ),
              Container(
                width: 1,
                height: 50,
                color: Colors.white.withOpacity(0.3),
              ),
              Expanded(
                child: _buildOverviewItem(
                  '记账笔数',
                  _isLoading ? '-' : '${_statistics?.count ?? 0}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewItem(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withOpacity(0.8),
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryChart() {
    if (_isLoading) {
      return _buildLoadingCard();
    }

    if (_statistics == null || _statistics!.categoryAmounts.isEmpty) {
      return _buildEmptyCard('暂无分类数据');
    }

    final entries = _statistics!.categoryAmounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '支出分类',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: entries.asMap().entries.map((e) {
                  final index = e.key;
                  final entry = e.value;
                  final category = ExpenseCategory.getByName(entry.key);
                  final percentage = _statistics!.totalAmount > 0
                      ? (entry.value / _statistics!.totalAmount * 100)
                      : 0;

                  return PieChartSectionData(
                    color: Color(category.color),
                    value: entry.value,
                    title: '${percentage.toStringAsFixed(1)}%',
                    radius: index == 0 ? 60 : 50,
                    titleStyle: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart() {
    if (_isLoading) {
      return _buildLoadingCard();
    }

    if (_last7Days.isEmpty) {
      return _buildEmptyCard('暂无趋势数据');
    }

    final sortedEntries = _last7Days.entries.toList();
    final maxValue = sortedEntries.map((e) => e.value).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '近7天趋势',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        final index = value.toInt();
                        if (index >= 0 && index < sortedEntries.length) {
                          return Text(
                            sortedEntries[index].key,
                            style: const TextStyle(
                              fontSize: 10,
                              color: XiaoxiaTheme.textTertiary,
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                minX: 0,
                maxX: sortedEntries.length - 1.0,
                minY: 0,
                maxY: maxValue * 1.2,
                lineBarsData: [
                  LineChartBarData(
                    spots: sortedEntries.asMap().entries.map((e) {
                      final entry = e.value;
                      return FlSpot(e.key.toDouble(), entry.value);
                    }).toList(),
                    isCurved: true,
                    color: XiaoxiaTheme.primaryPink,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: XiaoxiaTheme.primaryPink,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
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

  Widget _buildCategoryRanking() {
    if (_isLoading) {
      return _buildLoadingCard();
    }

    if (_statistics == null || _statistics!.categoryAmounts.isEmpty) {
      return _buildEmptyCard('暂无排行数据');
    }

    final entries = _statistics!.categoryAmounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '支出排行',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          ...entries.take(5).map((entry) => _buildRankingItem(entry)),
        ],
      ),
    );
  }

  Widget _buildRankingItem(MapEntry<String, double> entry) {
    final category = ExpenseCategory.getByName(entry.key);
    final percentage = _statistics!.totalAmount > 0
        ? (entry.value / _statistics!.totalAmount * 100)
        : 0;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Color(category.color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(category.icon, style: const TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 4),
                LinearProgressIndicator(
                  value: percentage / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(Color(category.color)),
                  minHeight: 4,
                  borderRadius: BorderRadius.circular(2),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '¥${entry.value.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              Text(
                '${percentage.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 12,
                  color: XiaoxiaTheme.textTertiary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      height: 200,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget _buildEmptyCard(String message) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.bar_chart_outlined,
              size: 48,
              color: XiaoxiaTheme.textTertiary,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: TextStyle(color: XiaoxiaTheme.textTertiary),
            ),
          ],
        ),
      ),
    );
  }
}
