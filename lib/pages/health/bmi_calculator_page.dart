import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../models/health_model.dart';
import '../../services/health_service.dart';
import 'bmi_history_page.dart';

/// BMI计算页面
class BMICalculatorPage extends StatefulWidget {
  const BMICalculatorPage({super.key});

  @override
  State<BMICalculatorPage> createState() => _BMICalculatorPageState();
}

class _BMICalculatorPageState extends State<BMICalculatorPage> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  
  double? _bmi;
  String _status = '';
  Color _statusColor = Colors.grey;
  
  bool _isLoading = true;
  BMIRecord? _latestRecord;

  @override
  void initState() {
    super.initState();
    _loadLatestRecord();
  }

  Future<void> _loadLatestRecord() async {
    final record = await HealthService.getLatestBMIRecord();
    if (record != null) {
      setState(() {
        _latestRecord = record;
        _heightController.text = record.height.toString();
        _weightController.text = record.weight.toString();
        _bmi = record.bmi;
        _updateStatus(record.bmi);
      });
    }
    setState(() => _isLoading = false);
  }

  void _calculateBMI() {
    final height = double.tryParse(_heightController.text);
    final weight = double.tryParse(_weightController.text);
    
    if (height == null || weight == null || height <= 0 || weight <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入有效的身高和体重')),
      );
      return;
    }
    
    // BMI = 体重(kg) / 身高(m)²
    final heightInMeter = height / 100;
    final bmi = weight / (heightInMeter * heightInMeter);
    
    setState(() {
      _bmi = double.parse(bmi.toStringAsFixed(1));
      _updateStatus(_bmi!);
    });
  }

  void _updateStatus(double bmi) {
    if (bmi < 18.5) {
      _status = '偏瘦';
      _statusColor = Colors.blue;
    } else if (bmi < 24) {
      _status = '正常';
      _statusColor = Colors.green;
    } else if (bmi < 28) {
      _status = '偏胖';
      _statusColor = Colors.orange;
    } else {
      _status = '肥胖';
      _statusColor = Colors.red;
    }
  }

  Future<void> _saveRecord() async {
    if (_bmi == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先计算BMI')),
      );
      return;
    }
    
    final record = BMIRecord(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      height: double.parse(_heightController.text),
      weight: double.parse(_weightController.text),
      bmi: _bmi!,
      date: DateTime.now(),
    );
    
    await HealthService.saveBMIRecord(record);
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('记录已保存'),
          backgroundColor: Colors.green,
        ),
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // 输入区域
                      _buildInputCard(),
                      const SizedBox(height: 20),
                      
                      // 计算按钮
                      _buildCalculateButton(),
                      const SizedBox(height: 20),
                      
                      // 结果显示
                      if (_bmi != null) _buildResultCard(),
                      const SizedBox(height: 20),
                      
                      // BMI标准参考
                      _buildBMIReference(),
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
              'BMI计算器',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const BMIHistoryPage()),
            ),
            child: const Text('历史'),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          _buildInputField(
            controller: _heightController,
            label: '身高',
            unit: 'cm',
            icon: Icons.height,
          ),
          const SizedBox(height: 16),
          _buildInputField(
            controller: _weightController,
            label: '体重',
            unit: 'kg',
            icon: Icons.monitor_weight,
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String unit,
    required IconData icon,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: XiaoxiaTheme.softPink,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: XiaoxiaTheme.primaryPink),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: label,
              suffixText: unit,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              fillColor: Colors.grey[100],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalculateButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: _calculateBMI,
        style: ElevatedButton.styleFrom(
          backgroundColor: XiaoxiaTheme.primaryPink,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        icon: const Icon(Icons.calculate),
        label: const Text(
          '计算BMI',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildResultCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _statusColor,
            _statusColor.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: _statusColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '您的BMI指数',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _bmi!.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 56,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              _status,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: _saveRecord,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: _statusColor,
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

  Widget _buildBMIReference() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'BMI参考标准',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          const SizedBox(height: 12),
          _buildReferenceItem('偏瘦', '< 18.5', Colors.blue),
          _buildReferenceItem('正常', '18.5 - 23.9', Colors.green),
          _buildReferenceItem('偏胖', '24.0 - 27.9', Colors.orange),
          _buildReferenceItem('肥胖', '≥ 28.0', Colors.red),
        ],
      ),
    );
  }

  Widget _buildReferenceItem(String label, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(range, style: TextStyle(color: Colors.grey[600])),
        ],
      ),
    );
  }
}
