import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_image_labeling/google_mlkit_image_labeling.dart';
import '../../theme.dart';

/// 图像识别示例页面 - 使用 Google ML Kit (本地识别)
class ImageRecognitionPage extends StatefulWidget {
  const ImageRecognitionPage({super.key});

  @override
  State<ImageRecognitionPage> createState() => _ImageRecognitionPageState();
}

class _ImageRecognitionPageState extends State<ImageRecognitionPage> {
  ImageLabeler? _imageLabeler;
  bool _isModelLoaded = false;
  bool _isAnalyzing = false;
  bool _showResult = false;
  double _analysisProgress = 0.0;
  File? _selectedImage;
  final ImagePicker _picker = ImagePicker();

  // 识别结果
  List<Map<String, dynamic>> _recognitionResults = [];

  @override
  void initState() {
    super.initState();
    _initModel();
  }

  Future<void> _initModel() async {
    try {
      // 使用默认模型（MobileNet）
      final options = ImageLabelerOptions(
        confidenceThreshold: 0.5,
      );
      _imageLabeler = ImageLabeler(options: options);
      
      setState(() {
        _isModelLoaded = true;
      });
      
      print('ML Kit 模型加载成功');
    } catch (e) {
      print('模型加载失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('模型加载失败: $e')),
      );
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = File(pickedFile.path);
          _showResult = false;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('选择图片失败: $e')),
      );
    }
  }

  Future<void> _startAnalysis() async {
    if (_imageLabeler == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('模型尚未加载完成，请稍候')),
      );
      return;
    }

    final imageFile = _selectedImage;
    if (imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请先选择一张图片')),
      );
      return;
    }

    setState(() {
      _isAnalyzing = true;
      _showResult = false;
      _analysisProgress = 0.0;
    });

    try {
      // 模拟进度动画
      _updateProgress(0.3);
      await Future.delayed(const Duration(milliseconds: 200));
      _updateProgress(0.6);
      
      // 创建 InputImage
      final inputImage = InputImage.fromFile(imageFile);
      
      _updateProgress(0.8);
      
      // 运行 ML Kit 识别
      final labels = await _imageLabeler!.processImage(inputImage);
      
      _updateProgress(1.0);
      
      // 处理结果
      _processResults(labels);
      
    } catch (e) {
      print('识别失败: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('识别失败: $e')),
      );
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  void _processResults(List<ImageLabel> labels) {
    final results = labels.map((label) => {
      'label': label.label,
      'confidence': label.confidence * 100,
      'index': label.index,
    }).toList();
    
    setState(() {
      _recognitionResults = results;
      _showResult = true;
    });
  }

  void _updateProgress(double value) {
    setState(() {
      _analysisProgress = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: XiaoxiaTheme.softPink,
      appBar: AppBar(
        title: const Text('AI 图像识别'),
        backgroundColor: XiaoxiaTheme.primaryPink,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!_isModelLoaded)
            const Center(
              child: Padding(
                padding: EdgeInsets.only(right: 16),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                ),
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.check_circle, color: Colors.white),
            ),
        ],
      ),
      body: Container(
        decoration: XiaoxiaDecorations.softGradient,
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 模型状态
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _isModelLoaded ? Colors.green.withOpacity(0.1) : Colors.orange.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _isModelLoaded ? Colors.green : Colors.orange,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isModelLoaded ? Icons.check_circle : Icons.sync,
                        color: _isModelLoaded ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          _isModelLoaded 
                            ? 'ML Kit 模型已加载 (本地离线识别)'
                            : '正在加载模型...',
                          style: TextStyle(
                            color: _isModelLoaded ? Colors.green : Colors.orange,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 图片上传区域
                Container(
                  width: double.infinity,
                  height: 280,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // 图片
                        _selectedImage != null
                            ? Image.file(
                                _selectedImage!,
                                fit: BoxFit.cover,
                              )
                            : Container(
                                color: Colors.grey[100],
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image_search,
                                      size: 64,
                                      color: Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      '选择或拍摄图片',
                                      style: TextStyle(
                                        color: Colors.grey[500],
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                        // 分析进度遮罩
                        if (_isAnalyzing)
                          Container(
                            color: Colors.black.withOpacity(0.7),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: CircularProgressIndicator(
                                    value: _analysisProgress,
                                    strokeWidth: 6,
                                    backgroundColor: Colors.white24,
                                    valueColor:
                                        const AlwaysStoppedAnimation<Color>(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'AI 分析中... ${(_analysisProgress * 100).toInt()}%',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 操作按钮（放在图片下方）
                if (!_isAnalyzing && !_showResult)
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionButton(
                          Icons.camera_alt,
                          '拍照',
                          _isModelLoaded ? () => _pickImage(ImageSource.camera) : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          Icons.photo_library,
                          '相册',
                          _isModelLoaded ? () => _pickImage(ImageSource.gallery) : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildActionButton(
                          Icons.auto_awesome,
                          '识别',
                          _isModelLoaded && _selectedImage != null
                              ? _startAnalysis
                              : null,
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 24),

                // 识别结果
                if (_showResult) ...[
                  Text(
                    '识别结果 (本地 ML Kit 推理)',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (_recognitionResults.isEmpty)
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text('未能识别出明显物体'),
                      ),
                    )
                  else
                    ..._recognitionResults.map((result) => _buildResultCard(result)),
                  const SizedBox(height: 24),

                  // 操作按钮
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() {
                              _showResult = false;
                              _selectedImage = null;
                              _recognitionResults = [];
                            });
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('重新识别'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: XiaoxiaTheme.primaryPink,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            if (_recognitionResults.isNotEmpty) {
                              final resultText = _recognitionResults
                                  .map((r) => '${r['label']}: ${(r['confidence'] as double).toStringAsFixed(1)}%')
                                  .join('\n');
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('识别结果:\n$resultText'),
                                  duration: const Duration(seconds: 3),
                                ),
                              );
                            }
                          },
                          icon: const Icon(Icons.share),
                          label: const Text('分享结果'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: XiaoxiaTheme.primaryPink,
                            side: const BorderSide(color: XiaoxiaTheme.primaryPink),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback? onTap) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: enabled
              ? Colors.white.withOpacity(0.95)
              : Colors.grey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: enabled ? XiaoxiaTheme.primaryPink : Colors.grey,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: enabled ? Colors.black87 : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultCard(Map<String, dynamic> result) {
    final confidence = result['confidence'] as double;
    Color color;
    if (confidence >= 70) {
      color = Colors.green;
    } else if (confidence >= 50) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    final label = result['label'] as String;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
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
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${confidence.toInt()}%',
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
                  label,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: confidence / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 8,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _imageLabeler?.close();
    super.dispose();
  }
}
