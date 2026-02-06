import 'package:flutter/material.dart';
import '../../theme.dart';

/// 文档压缩页面
class DocumentCompressPage extends StatefulWidget {
  const DocumentCompressPage({super.key});

  @override
  State<DocumentCompressPage> createState() => _DocumentCompressPageState();
}

class _DocumentCompressPageState extends State<DocumentCompressPage> {
  String? _selectedFile;
  int _originalSize = 0; // KB
  int _compressedSize = 0; // KB
  String _compressionLevel = '中等';
  bool _isCompressing = false;
  double _progress = 0;

  final List<Map<String, dynamic>> _levels = [
    {'name': '低', 'ratio': 0.8, 'color': Colors.green, 'desc': '画质优先'},
    {'name': '中等', 'ratio': 0.6, 'color': Colors.orange, 'desc': '平衡'},
    {'name': '高', 'ratio': 0.4, 'color': Colors.red, 'desc': '体积优先'},
  ];

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
                      // 文件选择
                      _buildFileSelector(),
                      const SizedBox(height: 24),

                      // 压缩级别选择
                      _buildCompressionLevel(),
                      const SizedBox(height: 24),

                      // 大小对比
                      if (_selectedFile != null) _buildSizeComparison(),
                      const SizedBox(height: 24),

                      // 压缩按钮
                      _buildCompressButton(),

                      // 进度
                      if (_isCompressing) _buildProgressIndicator(),
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
              '文档压缩',
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
        padding: const EdgeInsets.all(24),
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
        child: _selectedFile == null
            ? Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: XiaoxiaTheme.softPink,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.folder_open,
                      size: 40,
                      color: XiaoxiaTheme.primaryPink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '选择PDF文件',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '支持 PDF 格式',
                    style: TextStyle(
                      fontSize: 12,
                      color: XiaoxiaTheme.textTertiary,
                    ),
                  ),
                ],
              )
            : Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(
                      Icons.picture_as_pdf,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _selectedFile!,
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '原始大小: ${_formatSize(_originalSize)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: XiaoxiaTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => setState(() => _selectedFile = null),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
      ),
    );
  }

  Widget _buildCompressionLevel() {
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
            '压缩级别',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: _levels.map((level) {
              final isSelected = level['name'] == _compressionLevel;
              return Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _compressionLevel = level['name'];
                      _updateEstimatedSize();
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? (level['color'] as Color).withOpacity(0.1)
                          : Colors.grey[100],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? level['color'] as Color
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                    child: Column(
                      children: [
                        Text(
                          level['name'],
                          style: TextStyle(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected ? level['color'] : XiaoxiaTheme.textSecondary,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          level['desc'],
                          style: TextStyle(
                            fontSize: 10,
                            color: XiaoxiaTheme.textTertiary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeComparison() {
    final ratio = _levels.firstWhere((l) => l['name'] == _compressionLevel)['ratio'] as double;
    _compressedSize = (_originalSize * ratio).toInt();
    final saved = _originalSize - _compressedSize;

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
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildSizeItem('原始大小', _originalSize, Colors.white70),
              const Icon(Icons.arrow_forward, color: Colors.white),
              _buildSizeItem('预估大小', _compressedSize, Colors.white),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '预计节省 ${_formatSize(saved)} (${((1 - ratio) * 100).toInt()}%)',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSizeItem(String label, int size, Color textColor) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            color: textColor.withOpacity(0.8),
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _formatSize(size),
          style: TextStyle(
            color: textColor,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCompressButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton.icon(
        onPressed: _selectedFile == null || _isCompressing ? null : _startCompress,
        style: ElevatedButton.styleFrom(
          backgroundColor: XiaoxiaTheme.primaryPink,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        icon: const Icon(Icons.compress),
        label: const Text(
          '开始压缩',
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
                  '正在压缩中...',
                  style: TextStyle(color: XiaoxiaTheme.textSecondary),
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

  String _formatSize(int kb) {
    if (kb >= 1024) {
      return '${(kb / 1024).toStringAsFixed(2)} MB';
    }
    return '$kb KB';
  }

  void _selectFile() {
    setState(() {
      _selectedFile = '大型文档.pdf';
      _originalSize = 5120; // 5MB
    });
  }

  void _updateEstimatedSize() {
    // 预估大小会在 build 中自动更新
    setState(() {});
  }

  void _startCompress() async {
    setState(() {
      _isCompressing = true;
      _progress = 0;
    });

    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _progress = i / 10;
      });
    }

    setState(() {
      _isCompressing = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('压缩完成！'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
