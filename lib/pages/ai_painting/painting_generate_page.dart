import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme.dart';
import '../../models/painting_model.dart';
import '../../services/painting_service.dart';

/// AI绘画生成页面
class PaintingGeneratePage extends StatefulWidget {
  final PaintingStyle? initialStyle;
  
  const PaintingGeneratePage({super.key, this.initialStyle});

  @override
  State<PaintingGeneratePage> createState() => _PaintingGeneratePageState();
}

class _PaintingGeneratePageState extends State<PaintingGeneratePage> {
  final TextEditingController _promptController = TextEditingController();
  final TextEditingController _negativePromptController = TextEditingController();
  final PaintingService _paintingService = PaintingService();
  
  PaintingStyle? _selectedStyle;
  bool _isGenerating = false;
  double _progress = 0;
  String? _generatedImageUrl;
  double _aspectRatio = 1.0; // 1:1
  int _seed = -1;
  
  final List<Map<String, dynamic>> _aspectRatios = [
    {'name': '1:1', 'value': 1.0, 'icon': Icons.crop_square},
    {'name': '3:4', 'value': 0.75, 'icon': Icons.crop_portrait},
    {'name': '4:3', 'value': 4/3, 'icon': Icons.crop_landscape},
    {'name': '9:16', 'value': 9/16, 'icon': Icons.smartphone},
    {'name': '16:9', 'value': 16/9, 'icon': Icons.desktop_windows},
  ];
  
  final List<String> _quickPrompts = [
    '一只可爱的猫咪在樱花树下',
    '未来城市夜景，霓虹灯',
    '古装美女，水墨画风格',
    '宇宙星空，梦幻色彩',
    '小猫咪，粉色房间',
    '赛博朋克风格街道',
  ];

  @override
  void initState() {
    super.initState();
    _selectedStyle = widget.initialStyle;
    _seed = Random().nextInt(999999);
  }

  @override
  void dispose() {
    _promptController.dispose();
    _negativePromptController.dispose();
    super.dispose();
  }

  Future<void> _generateImage() async {
    if (_promptController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('请输入绘画描述')),
      );
      return;
    }

    setState(() {
      _isGenerating = true;
      _progress = 0;
      _generatedImageUrl = null;
    });

    // 模拟生成进度
    for (int i = 0; i <= 10; i++) {
      await Future.delayed(const Duration(milliseconds: 400));
      setState(() {
        _progress = i / 10;
      });
    }

    // 模拟生成结果（使用随机颜色作为占位图）
    await Future.delayed(const Duration(milliseconds: 500));
    
    setState(() {
      _isGenerating = false;
      _generatedImageUrl = 'generated_${DateTime.now().millisecondsSinceEpoch}';
    });

    // 保存到历史
    final painting = Painting(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      prompt: _promptController.text,
      style: _selectedStyle?.name ?? '自由创作',
      imageUrl: _generatedImageUrl!,
      createdAt: DateTime.now(),
      aspectRatio: _aspectRatio,
      seed: _seed,
    );
    await _paintingService.savePainting(painting);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('生成完成！'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  void _applyQuickPrompt(String prompt) {
    setState(() {
      _promptController.text = prompt;
    });
  }

  void _randomizeSeed() {
    setState(() {
      _seed = Random().nextInt(999999);
    });
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 风格选择
                      _buildStyleSelector(),
                      const SizedBox(height: 20),
                      
                      // 提示词输入
                      _buildPromptInput(),
                      const SizedBox(height: 16),
                      
                      // 快捷提示词
                      _buildQuickPrompts(),
                      const SizedBox(height: 20),
                      
                      // 参数设置
                      _buildParameters(),
                      const SizedBox(height: 20),
                      
                      // 生成按钮
                      _buildGenerateButton(),
                      const SizedBox(height: 20),
                      
                      // 生成进度/结果
                      if (_isGenerating) _buildProgressIndicator(),
                      if (_generatedImageUrl != null) _buildResultPreview(),
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
              'AI绘画',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () {
              // 清空所有输入
              setState(() {
                _promptController.clear();
                _negativePromptController.clear();
                _generatedImageUrl = null;
              });
            },
            icon: const Icon(Icons.refresh, color: XiaoxiaTheme.textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildStyleSelector() {
    final styles = PaintingService.getAllStyles();
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '选择风格',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: styles.length,
            itemBuilder: (context, index) {
              final style = styles[index];
              final isSelected = _selectedStyle?.id == style.id;
              
              return GestureDetector(
                onTap: () => setState(() => _selectedStyle = style),
                child: Container(
                  width: 80,
                  margin: const EdgeInsets.only(right: 12),
                  decoration: BoxDecoration(
                    color: isSelected ? XiaoxiaTheme.primaryPink : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isSelected ? XiaoxiaTheme.primaryPink : Colors.transparent,
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _getStyleIcon(style.iconName),
                        color: isSelected ? Colors.white : style.color,
                        size: 28,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        style.name,
                        style: TextStyle(
                          fontSize: 12,
                          color: isSelected ? Colors.white : XiaoxiaTheme.textDark,
                          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  IconData _getStyleIcon(String iconName) {
    switch (iconName) {
      case 'anime':
        return Icons.face;
      case 'realistic':
        return Icons.camera_alt;
      case 'oil':
        return Icons.palette;
      case 'watercolor':
        return Icons.water_drop;
      case 'sketch':
        return Icons.edit;
      case 'cyberpunk':
        return Icons.computer;
      default:
        return Icons.image;
    }
  }

  Widget _buildPromptInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '绘画描述',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${_promptController.text.length}/500',
              style: TextStyle(
                fontSize: 12,
                color: XiaoxiaTheme.textTertiary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: TextField(
            controller: _promptController,
            maxLines: 4,
            maxLength: 500,
            decoration: InputDecoration(
              hintText: '描述你想要的画面，例如：一只可爱的猫咪在樱花树下，粉色花瓣飘落...',
              hintStyle: TextStyle(color: XiaoxiaTheme.textTertiary),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(16),
              counterText: '',
            ),
            onChanged: (_) => setState(() {}),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickPrompts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '灵感提示',
          style: TextStyle(
            fontSize: 14,
            color: XiaoxiaTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _quickPrompts.map((prompt) {
            return GestureDetector(
              onTap: () => _applyQuickPrompt(prompt),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: XiaoxiaTheme.softPink,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  prompt,
                  style: TextStyle(
                    fontSize: 12,
                    color: XiaoxiaTheme.primaryPink,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildParameters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '参数设置',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          
          // 画面比例
          Text(
            '画面比例',
            style: TextStyle(fontSize: 14, color: XiaoxiaTheme.textSecondary),
          ),
          const SizedBox(height: 8),
          Row(
            children: _aspectRatios.map((ratio) {
              final isSelected = _aspectRatio == ratio['value'];
              return Expanded(
                child: GestureDetector(
                  onTap: () => setState(() => _aspectRatio = ratio['value']),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isSelected ? XiaoxiaTheme.primaryPink : XiaoxiaTheme.softPink,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          ratio['icon'] as IconData,
                          size: 20,
                          color: isSelected ? Colors.white : XiaoxiaTheme.primaryPink,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          ratio['name'] as String,
                          style: TextStyle(
                            fontSize: 10,
                            color: isSelected ? Colors.white : XiaoxiaTheme.primaryPink,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          
          // 随机种子
          Row(
            children: [
              Text(
                '随机种子',
                style: TextStyle(fontSize: 14, color: XiaoxiaTheme.textSecondary),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: XiaoxiaTheme.softPink,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _seed.toString(),
                  style: TextStyle(
                    color: XiaoxiaTheme.primaryPink,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _randomizeSeed,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: XiaoxiaTheme.softPink,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.casino,
                    size: 20,
                    color: XiaoxiaTheme.primaryPink,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGenerateButton() {
    final bool canGenerate = _promptController.text.trim().isNotEmpty && !_isGenerating;
    
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton.icon(
        onPressed: canGenerate ? _generateImage : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: XiaoxiaTheme.primaryPink,
          foregroundColor: Colors.white,
          disabledBackgroundColor: XiaoxiaTheme.primaryPink.withOpacity(0.3),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: canGenerate ? 4 : 0,
        ),
        icon: _isGenerating 
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation(Colors.white),
                ),
              )
            : const Icon(Icons.auto_fix_high),
        label: Text(
          _isGenerating ? '生成中...' : '开始创作',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: XiaoxiaTheme.softPink,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(XiaoxiaTheme.primaryPink),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '正在创作中...',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'AI正在根据你的描述创作，请稍候',
                      style: TextStyle(
                        fontSize: 12,
                        color: XiaoxiaTheme.textTertiary,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${(_progress * 100).toInt()}%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: XiaoxiaTheme.primaryPink,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: _progress,
              backgroundColor: XiaoxiaTheme.softPink,
              valueColor: const AlwaysStoppedAnimation(XiaoxiaTheme.primaryPink),
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultPreview() {
    // 生成随机渐变色作为占位图
    final random = Random(_seed);
    final color1 = Color.fromRGBO(
      random.nextInt(255),
      random.nextInt(255),
      random.nextInt(255),
      1,
    );
    final color2 = Color.fromRGBO(
      random.nextInt(255),
      random.nextInt(255),
      random.nextInt(255),
      1,
    );
    
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
              Text(
                '生成结果',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // 重新生成
                      _generateImage();
                    },
                    icon: const Icon(Icons.refresh),
                    color: XiaoxiaTheme.primaryPink,
                  ),
                  IconButton(
                    onPressed: () {
                      // 保存图片（模拟）
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('已保存到相册')),
                      );
                    },
                    icon: const Icon(Icons.download),
                    color: XiaoxiaTheme.primaryPink,
                  ),
                  IconButton(
                    onPressed: () {
                      // 分享（模拟）
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('分享功能')),
                      );
                    },
                    icon: const Icon(Icons.share),
                    color: XiaoxiaTheme.primaryPink,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: AspectRatio(
              aspectRatio: _aspectRatio,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color1, color2],
                  ),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.image,
                        size: 64,
                        color: Colors.white.withOpacity(0.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _selectedStyle?.name ?? 'AI创作',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Seed: $_seed',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: XiaoxiaTheme.softPink,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.format_quote, color: XiaoxiaTheme.primaryPink),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    _promptController.text,
                    style: TextStyle(
                      color: XiaoxiaTheme.textSecondary,
                      fontSize: 13,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
