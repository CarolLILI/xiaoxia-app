import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../theme.dart';

/// 文档合并拆分页面
class DocumentMergePage extends StatefulWidget {
  const DocumentMergePage({super.key});

  @override
  State<DocumentMergePage> createState() => _DocumentMergePageState();
}

class _DocumentMergePageState extends State<DocumentMergePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // 合并相关
  List<Map<String, dynamic>> _mergeFiles = [];
  bool _isMerging = false;
  double _mergeProgress = 0;
  
  // 拆分相关
  String? _splitFile;
  int _splitFilePages = 10; // 模拟总页数
  int _splitStartPage = 1;
  int _splitEndPage = 5;
  bool _isSplitting = false;
  double _splitProgress = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<bool> _checkPermission() async {
    var status = await Permission.storage.status;
    if (status.isDenied) {
      status = await Permission.storage.request();
    }
    return status.isGranted;
  }

  // 添加合并文件
  Future<void> _addMergeFile() async {
    if (!await _checkPermission()) return;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
      allowMultiple: true,
    );

    if (result != null) {
      for (var file in result.files) {
        if (file.path != null) {
          setState(() {
            _mergeFiles.add({
              'name': file.name,
              'path': file.path,
              'size': _formatSize(file.size),
            });
          });
        }
      }
    }
  }

  // 选择拆分文件
  Future<void> _selectSplitFile() async {
    if (!await _checkPermission()) return;

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.single.path != null) {
      setState(() {
        _splitFile = result.files.single.name;
        // 模拟获取PDF页数
        _splitFilePages = 20 + (DateTime.now().millisecond % 30);
        _splitEndPage = _splitFilePages ~/ 2;
      });
    }
  }

  String _formatSize(int? bytes) {
    if (bytes == null) return '0 B';
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '$bytes B';
  }

  // 执行合并
  Future<void> _startMerge() async {
    if (_mergeFiles.isEmpty) return;

    setState(() {
      _isMerging = true;
      _mergeProgress = 0;
    });

    // 模拟合并进度
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 300));
      setState(() {
        _mergeProgress = i / 10;
      });
    }

    setState(() {
      _isMerging = false;
      _mergeFiles.clear();
    });

    if (mounted) {
      _showSuccessDialog('合并完成', '已生成合并后的PDF文件');
    }
  }

  // 执行拆分
  Future<void> _startSplit() async {
    if (_splitFile == null) return;

    setState(() {
      _isSplitting = true;
      _splitProgress = 0;
    });

    // 模拟拆分进度
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 200));
      setState(() {
        _splitProgress = i / 10;
      });
    }

    setState(() {
      _isSplitting = false;
      _splitFile = null;
    });

    if (mounted) {
      _showSuccessDialog('拆分完成', '已生成拆分后的PDF文件');
    }
  }

  void _showSuccessDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.green.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.check_circle, color: Colors.green, size: 48),
            ),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: XiaoxiaTheme.primaryPink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('确定'),
              ),
            ),
          ],
        ),
      ),
    );
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
              _buildTabBar(),
              Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    _buildMergeView(),
                    _buildSplitView(),
                  ],
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
              '合并拆分',
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

  Widget _buildTabBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: TabBar(
        controller: _tabController,
        indicator: BoxDecoration(
          color: XiaoxiaTheme.primaryPink,
          borderRadius: BorderRadius.circular(10),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: XiaoxiaTheme.textSecondary,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        tabs: const [
          Tab(icon: Icon(Icons.merge_type), text: '合并文档'),
          Tab(icon: Icon(Icons.splitscreen), text: '拆分文档'),
        ],
      ),
    );
  }

  // ========== 合并视图 ==========
  Widget _buildMergeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 添加文件按钮
          GestureDetector(
            onTap: _isMerging ? null : _addMergeFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: XiaoxiaTheme.primaryPink.withOpacity(0.3),
                  width: 2,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.add_circle_outline,
                    size: 48,
                    color: XiaoxiaTheme.primaryPink,
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    '添加PDF文件',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '支持多选',
                    style: TextStyle(fontSize: 12, color: XiaoxiaTheme.textTertiary),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),

          // 文件列表
          if (_mergeFiles.isNotEmpty) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '待合并文件 (${_mergeFiles.length})',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                TextButton(
                  onPressed: _isMerging ? null : () => setState(() => _mergeFiles.clear()),
                  child: const Text('清空'),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (newIndex > oldIndex) newIndex--;
                  final item = _mergeFiles.removeAt(oldIndex);
                  _mergeFiles.insert(newIndex, item);
                });
              },
              children: [
                for (int i = 0; i < _mergeFiles.length; i++)
                  _buildMergeFileItem(i, _mergeFiles[i]),
              ],
            ),
            const SizedBox(height: 16),

            // 合并按钮
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _isMerging ? null : _startMerge,
                style: ElevatedButton.styleFrom(
                  backgroundColor: XiaoxiaTheme.primaryPink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.merge_type),
                label: const Text('开始合并', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),

            // 进度条
            if (_isMerging) _buildProgressIndicator(_mergeProgress, '正在合并...'),
          ],
        ],
      ),
    );
  }

  Widget _buildMergeFileItem(int index, Map<String, dynamic> file) {
    return Container(
      key: ValueKey(file['path']),
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  file['name']!,
                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  file['size']!,
                  style: TextStyle(fontSize: 12, color: XiaoxiaTheme.textTertiary),
                ),
              ],
            ),
          ),
          Text(
            '${index + 1}',
            style: TextStyle(
              color: XiaoxiaTheme.primaryPink,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.drag_handle, color: XiaoxiaTheme.textTertiary),
        ],
      ),
    );
  }

  // ========== 拆分视图 ==========
  Widget _buildSplitView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // 选择文件
          GestureDetector(
            onTap: _isSplitting ? null : _selectSplitFile,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: _splitFile == null
                  ? Column(
                      children: [
                        Icon(Icons.folder_open, size: 48, color: XiaoxiaTheme.primaryPink),
                        const SizedBox(height: 12),
                        const Text('选择PDF文件', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
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
                          child: const Icon(Icons.picture_as_pdf, color: Colors.red),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_splitFile!, style: const TextStyle(fontWeight: FontWeight.w500)),
                              Text('共 $_splitFilePages 页', style: TextStyle(color: XiaoxiaTheme.textTertiary, fontSize: 12)),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: _isSplitting ? null : () => setState(() => _splitFile = null),
                          icon: const Icon(Icons.close),
                        ),
                      ],
                    ),
            ),
          ),
          const SizedBox(height: 24),

          // 页码选择
          if (_splitFile != null) ...[
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '选择拆分范围',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: _buildPageInput('起始页', _splitStartPage, (value) {
                          setState(() => _splitStartPage = value.clamp(1, _splitFilePages));
                        }),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16),
                        child: Icon(Icons.arrow_forward, color: XiaoxiaTheme.textTertiary),
                      ),
                      Expanded(
                        child: _buildPageInput('结束页', _splitEndPage, (value) {
                          setState(() => _splitEndPage = value.clamp(1, _splitFilePages));
                        }),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '将提取第 $_splitStartPage 页到第 $_splitEndPage 页，共 ${_splitEndPage - _splitStartPage + 1} 页',
                    style: TextStyle(fontSize: 12, color: XiaoxiaTheme.textTertiary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // 拆分按钮
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton.icon(
                onPressed: _isSplitting ? null : _startSplit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: XiaoxiaTheme.primaryPink,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                icon: const Icon(Icons.splitscreen),
                label: const Text('开始拆分', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),

            // 进度条
            if (_isSplitting) _buildProgressIndicator(_splitProgress, '正在拆分...'),
          ],
        ],
      ),
    );
  }

  Widget _buildPageInput(String label, int value, Function(int) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 12, color: XiaoxiaTheme.textTertiary)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: XiaoxiaTheme.softPink,
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            controller: TextEditingController(text: value.toString()),
            decoration: const InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            onChanged: (text) => onChanged(int.tryParse(text) ?? 1),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressIndicator(double progress, String label) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(XiaoxiaTheme.primaryPink)),
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(label, style: TextStyle(color: XiaoxiaTheme.textSecondary))),
              Text('${(progress * 100).toInt()}%', style: const TextStyle(fontWeight: FontWeight.w600, color: XiaoxiaTheme.primaryPink)),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: XiaoxiaTheme.softPink,
            valueColor: const AlwaysStoppedAnimation(XiaoxiaTheme.primaryPink),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}
