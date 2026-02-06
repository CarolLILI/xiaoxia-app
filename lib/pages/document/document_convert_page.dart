import 'package:flutter/material.dart';
import '../../theme.dart';

/// 文档格式转换页面
class DocumentConvertPage extends StatefulWidget {
  const DocumentConvertPage({super.key});

  @override
  State<DocumentConvertPage> createState() => _DocumentConvertPageState();
}

class _DocumentConvertPageState extends State<DocumentConvertPage> {
  String? _selectedFile;
  String _sourceFormat = 'PDF';
  String _targetFormat = 'Word';
  bool _isConverting = false;
  double _progress = 0;

  final List<String> _formats = ['PDF', 'Word', 'Excel', 'PPT', '图片'];

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
                      // 文件选择区域
                      _buildFileSelector(),
                      const SizedBox(height: 24),

                      // 格式选择
                      _buildFormatSelector(),
                      const SizedBox(height: 24),

                      // 转换按钮
                      _buildConvertButton(),

                      // 进度显示
                      if (_isConverting) _buildProgressIndicator(),
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
              '格式转换',
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

  Widget _buildFileSelector() {
    return GestureDetector(
      onTap: _selectFile,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: XiaoxiaTheme.primaryPink.withOpacity(0.3),
            width: 2,
            style: BorderStyle.solid,
          ),
          boxShadow: [
            BoxShadow(
              color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
              blurRadius: 10,
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: XiaoxiaTheme.softPink,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.cloud_upload,
                size: 48,
                color: XiaoxiaTheme.primaryPink,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              _selectedFile ?? '点击选择文件',
              style: TextStyle(
                fontSize: 16,
                color: _selectedFile != null 
                    ? XiaoxiaTheme.textDark 
                    : XiaoxiaTheme.textTertiary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '支持 PDF、Word、Excel、PPT、图片',
              style: TextStyle(
                fontSize: 12,
                color: XiaoxiaTheme.textTertiary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormatSelector() {
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
        children: [
          // 源格式
          Row(
            children: [
              Expanded(
                child: _buildFormatDropdown(
                  label: '源格式',
                  value: _sourceFormat,
                  onChanged: (value) => setState(() => _sourceFormat = value!),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: XiaoxiaTheme.softPink,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.arrow_forward,
                  color: XiaoxiaTheme.primaryPink,
                ),
              ),
              Expanded(
                child: _buildFormatDropdown(
                  label: '目标格式',
                  value: _targetFormat,
                  onChanged: (value) => setState(() => _targetFormat = value!),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFormatDropdown({
    required String label,
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: XiaoxiaTheme.textTertiary,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: XiaoxiaTheme.softPink,
            borderRadius: BorderRadius.circular(8),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              items: _formats.map((format) {
                return DropdownMenuItem(
                  value: format,
                  child: Text(format),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildConvertButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: _selectedFile == null || _isConverting ? null : _startConvert,
        style: ElevatedButton.styleFrom(
          backgroundColor: XiaoxiaTheme.primaryPink,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.transform),
        label: const Text(
          '开始转换',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      margin: const EdgeInsets.only(top: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(XiaoxiaTheme.primaryPink),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  '正在转换中...',
                  style: TextStyle(
                    color: XiaoxiaTheme.textSecondary,
                  ),
                ),
              ),
              Text(
                '${(_progress * 100).toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  color: XiaoxiaTheme.primaryPink,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: _progress,
            backgroundColor: XiaoxiaTheme.softPink,
            valueColor: const AlwaysStoppedAnimation(XiaoxiaTheme.primaryPink),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  void _selectFile() {
    // 模拟选择文件
    setState(() {
      _selectedFile = '项目合同.pdf';
    });
  }

  void _startConvert() async {
    setState(() {
      _isConverting = true;
      _progress = 0;
    });

    // 模拟转换进度
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _progress = i / 10;
      });
    }

    setState(() {
      _isConverting = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('转换完成！'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
