import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../theme.dart';
import '../../models/health_model.dart';
import '../../services/health_service.dart';

/// 饮水记录页面
class WaterRecordPage extends StatefulWidget {
  const WaterRecordPage({super.key});

  @override
  State<WaterRecordPage> createState() => _WaterRecordPageState();
}

class _WaterRecordPageState extends State<WaterRecordPage> {
  int _todayWater = 0;
  List<HealthData> _todayRecords = [];
  bool _isLoading = true;

  final int _goalWater = 2000; // 每日目标饮水量 ml
  final List<int> _quickAmounts = [100, 200, 250, 500]; // 快捷水量

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final today = await HealthService.getTodayWater();
    final records = await HealthService.getTodayHealthData('water');
    
    setState(() {
      _todayWater = today;
      _todayRecords = records;
      _isLoading = false;
    });
  }

  Future<void> _addWater(int amount) async {
    final data = HealthData(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: 'water',
      value: amount.toDouble(),
      unit: 'ml',
      date: DateTime.now(),
    );

    await HealthService.saveHealthData(data);
    _loadData();

    if (mounted) {
      // 达成目标提示
      if (_todayWater + amount >= _goalWater && _todayWater < _goalWater) {
        _showGoalReachedDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('已记录 +$amount ml')),
        );
      }
    }
  }

  void _showGoalReachedDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.emoji_events, size: 64, color: Colors.amber),
            const SizedBox(height: 16),
            const Text(
              '恭喜达成目标！',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              '您已完成今日 $_goalWater ml 的饮水目标',
              textAlign: TextAlign.center,
              style: TextStyle(color: XiaoxiaTheme.textSecondary),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: XiaoxiaTheme.primaryPink,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text('太棒了！'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteRecord(String id) async {
    await HealthService.deleteHealthData(id);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    final progress = _todayWater / _goalWater;

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
                            _buildWaterCard(progress),
                            const SizedBox(height: 20),
                            _buildQuickAddButtons(),
                            const SizedBox(height: 20),
                            _buildTodayRecords(),
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
              '饮水记录',
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

  Widget _buildWaterCard(double progress) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue,
            Colors.blue.shade400,
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: 150,
                height: 150,
                child: CircularProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  strokeWidth: 12,
                  backgroundColor: Colors.white.withOpacity(0.3),
                  valueColor: const AlwaysStoppedAnimation(Colors.white),
                ),
              ),
              Column(
                children: [
                  Icon(
                    Icons.water_drop,
                    size: 40,
                    color: Colors.white.withOpacity(0.9),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${(progress * 100).toInt()}%',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            '$_todayWater ml',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '目标: $_goalWater ml',
            style: const TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAddButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '快速添加',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        Row(
          children: _quickAmounts.map((amount) {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ElevatedButton(
                  onPressed: () => _addWater(amount),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.withOpacity(0.1),
                    foregroundColor: Colors.blue,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('+${amount}ml'),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildTodayRecords() {
    if (_todayRecords.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: const Center(
          child: Column(
            children: [
              Icon(Icons.local_drink, size: 48, color: Colors.grey),
              SizedBox(height: 12),
              Text('今天还没有饮水记录'),
            ],
          ),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '今日记录',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '${_todayRecords.length} 次',
                style: TextStyle(color: XiaoxiaTheme.textTertiary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _todayRecords.length,
            itemBuilder: (context, index) {
              final record = _todayRecords[index];
              return Dismissible(
                key: Key(record.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) => _deleteRecord(record.id),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.water_drop, color: Colors.blue, size: 20),
                  ),
                  title: Text('+${record.value.toInt()} ml'),
                  subtitle: Text(
                    '${record.date.hour.toString().padLeft(2, '0')}:${record.date.minute.toString().padLeft(2, '0')}',
                    style: TextStyle(color: XiaoxiaTheme.textTertiary, fontSize: 12),
                  ),
                  trailing: const Icon(Icons.swipe_left, color: Colors.grey, size: 16),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
