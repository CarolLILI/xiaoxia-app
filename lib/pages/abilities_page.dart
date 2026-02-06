import 'package:flutter/material.dart';
import '../theme.dart';
import 'code/code_home_page.dart';
import 'ai_painting/ai_painting_home_page.dart';
import 'document/document_home_page.dart';
import 'translate/translate_home_page.dart';
import 'health/health_home_page.dart';

/// 能力展示页面
class AbilitiesPage extends StatelessWidget {
  const AbilitiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 顶部标题区域
              _buildHeader(context),
              const SizedBox(height: 24),
              // 能力卡片网格
              _buildAbilitiesGrid(context),
            ],
          ),
        ),
      ),
    );
  }

  /// 构建顶部标题
  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '我的能力',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 8),
        Text(
          '探索小虾助手的各项技能，让我来帮助你完成更多任务',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  /// 构建能力卡片网格
  Widget _buildAbilitiesGrid(BuildContext context) {
    final abilities = [
      _AbilityItem(
        icon: Icons.code,
        title: '代码开发',
        description: '编写、调试和优化代码，支持多种编程语言和框架',
        color: Colors.blue,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const CodeHomePage()),
        ),
      ),
      _AbilityItem(
        icon: Icons.auto_fix_high,
        title: 'AI绘画',
        description: '智能生成图片，支持多种艺术风格',
        color: Colors.purple,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const AIPaintingHomePage()),
        ),
      ),
      _AbilityItem(
        icon: Icons.description,
        title: '文档处理',
        description: 'PDF查看、格式转换、文档压缩',
        color: Colors.orange,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const DocumentHomePage()),
        ),
      ),
      _AbilityItem(
        icon: Icons.translate,
        title: '翻译助手',
        description: '多语言翻译，支持语音朗读',
        color: Colors.green,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TranslateHomePage()),
        ),
      ),
      _AbilityItem(
        icon: Icons.favorite,
        title: '健康助手',
        description: 'BMI计算、步数记录、睡眠监测',
        color: Colors.red,
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HealthHomePage()),
        ),
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 0.85,
      ),
      itemCount: abilities.length,
      itemBuilder: (context, index) {
        return _AbilityCard(ability: abilities[index]);
      },
    );
  }
}

/// 能力项数据模型
class _AbilityItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final VoidCallback onTap;

  _AbilityItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.onTap,
  });
}

/// 能力卡片组件
class _AbilityCard extends StatefulWidget {
  final _AbilityItem ability;

  const _AbilityCard({required this.ability});

  @override
  State<_AbilityCard> createState() => _AbilityCardState();
}

class _AbilityCardState extends State<_AbilityCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isHovered = true),
        onTapUp: (_) => setState(() => _isHovered = false),
        onTapCancel: () => setState(() => _isHovered = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translate(0.0, _isHovered ? -4.0 : 0.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _isHovered
                    ? widget.ability.color.withOpacity(0.3)
                    : XiaoxiaTheme.primaryPink.withOpacity(0.1),
                blurRadius: _isHovered ? 20 : 10,
                offset: Offset(0, _isHovered ? 8 : 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(16),
              onTap: widget.ability.onTap,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 图标容器
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: widget.ability.color.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        widget.ability.icon,
                        color: widget.ability.color,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // 标题
                    Text(
                      widget.ability.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    // 描述（限制2行）
                    Expanded(
                      child: Text(
                        widget.ability.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: XiaoxiaTheme.textSecondary,
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
