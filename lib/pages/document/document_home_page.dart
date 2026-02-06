import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../theme.dart';
import 'pdf_viewer_page.dart';
import 'document_convert_page.dart';
import 'document_compress_page.dart';
import 'document_merge_page.dart';

/// 文档处理首页
class DocumentHomePage extends StatefulWidget {
  const DocumentHomePage({super.key});

  @override
  State<DocumentHomePage> createState() => _DocumentHomePageState();
}

class _DocumentHomePageState extends State<DocumentHomePage> {
  List<Map<String, dynamic>> _documents = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    if (Platform.isAndroid) {
      await Permission.storage.request();
    }
  }

  Future<bool> _checkAndRequestPermission() async {
    if (Platform.isAndroid) {
      var status = await Permission.storage.status;
      if (status.isDenied) {
        status = await Permission.storage.request();
      }

      if (status.isPermanentlyDenied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('需要存储权限才能选择文件，请在设置中开启'),
              action: SnackBarAction(
                label: '去设置',
                onPressed: () => openAppSettings(),
              ),
            ),
          );
        }
        return false;
      }
      return status.isGranted;
    }
    return true;
  }

  Future<void> _pickFile() async {
    // 先检查权限
    final hasPermission = await _checkAndRequestPermission();
    if (!hasPermission) {
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx', 'xls', 'xlsx', 'ppt', 'pptx', 'jpg', 'png'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final stat = await file.stat();
        
        setState(() {
          _documents.insert(0, {
            'name': result.files.single.name,
            'path': result.files.single.path,
            'size': _formatFileSize(stat.size),
            'date': '刚刚',
          });
        });

        // 如果是PDF，自动打开
        if (result.files.single.extension?.toLowerCase() == 'pdf') {
          _openPDF(result.files.single.path!);
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('选择文件失败: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _openPDF(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewerPage(filePath: path),
      ),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    } else if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '$bytes B';
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 快捷入口
                      _buildQuickActions(context),
                      const SizedBox(height: 24),

                      // 最近文档
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '最近文档',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          if (_documents.isNotEmpty)
                            TextButton(
                              onPressed: () => setState(() => _documents.clear()),
                              child: const Text('清空'),
                            ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      if (_isLoading)
                        const Center(child: CircularProgressIndicator())
                      else if (_documents.isEmpty)
                        _buildEmptyState()
                      else
                        _buildDocumentList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _pickFile,
        backgroundColor: XiaoxiaTheme.primaryPink,
        child: const Icon(Icons.add, color: Colors.white),
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
              '文档处理',
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

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(
            Icons.folder_open,
            size: 64,
            color: XiaoxiaTheme.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无文档',
            style: TextStyle(
              color: XiaoxiaTheme.textTertiary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '点击右下角 + 添加文件',
            style: TextStyle(
              color: XiaoxiaTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 0.8,
      children: [
        _buildActionItem(
          icon: Icons.picture_as_pdf,
          label: 'PDF查看',
          color: Colors.red,
          onTap: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: ['pdf'],
            );
            if (result != null && result.files.single.path != null) {
              _openPDF(result.files.single.path!);
            }
          },
        ),
        _buildActionItem(
          icon: Icons.transform,
          label: '格式转换',
          color: Colors.blue,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DocumentConvertPage()),
          ),
        ),
        _buildActionItem(
          icon: Icons.compress,
          label: '文档压缩',
          color: Colors.green,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DocumentCompressPage()),
          ),
        ),
        _buildActionItem(
          icon: Icons.merge_type,
          label: '合并拆分',
          color: Colors.orange,
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DocumentMergePage()),
          ),
        ),
      ],
    );
  }

  Widget _buildActionItem({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: color,
              size: 28,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentList() {
    return Column(
      children: _documents.map((doc) {
        final isPDF = doc['name'].toString().toLowerCase().endsWith('.pdf');
        
        return GestureDetector(
          onTap: () {
            if (isPDF && doc['path'] != null) {
              _openPDF(doc['path']);
            }
          },
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
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: isPDF ? Colors.red.withOpacity(0.1) : XiaoxiaTheme.softPink,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    isPDF ? Icons.picture_as_pdf : Icons.insert_drive_file,
                    color: isPDF ? Colors.red : XiaoxiaTheme.primaryPink,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc['name']!,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        '${doc['size']} · ${doc['date']}',
                        style: TextStyle(
                          color: XiaoxiaTheme.textTertiary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isPDF)
                  const Icon(
                    Icons.visibility,
                    color: XiaoxiaTheme.primaryPink,
                    size: 20,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
