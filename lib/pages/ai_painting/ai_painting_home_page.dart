import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../models/painting_model.dart';
import '../../services/painting_service.dart';
import 'painting_generate_page.dart';
import 'painting_history_page.dart';

/// AI绘画首页
class AIPaintingHomePage extends StatelessWidget {
  const AIPaintingHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final styles = PaintingService.getStyles();

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
                      // 快捷操作
                      _buildQuickActions(context),
                      const SizedBox(height: 24),

                      // 风格选择
                      Text(
                        '选择风格',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 12),

                      // 风格网格
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.85,
                        ),
                        itemCount: styles.length,
                        itemBuilder: (context, index) {
                          return _buildStyleCard(context, styles[index]);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openGenerate(context),
        backgroundColor: XiaoxiaTheme.primaryPink,
        icon: const Icon(Icons.auto_fix_high, color: Colors.white),
        label: const Text(
          '开始创作',
          style: TextStyle(color: Colors.white),
        ),
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
              'AI绘画',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () => _openHistory(context),
            icon: const Icon(Icons.history, color: XiaoxiaTheme.textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            icon: Icons.auto_fix_high,
            label: '智能生成',
            color: XiaoxiaTheme.primaryPink,
            onTap: () => _openGenerate(context),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            icon: Icons.photo_library,
            label: '作品库',
            color: Colors.purple,
            onTap: () => _openHistory(context),
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: color, size: 28),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStyleCard(BuildContext context, PaintingStyle style) {
    return GestureDetector(
      onTap: () => _openGenerate(context, style: style),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: style.color.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: style.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Center(
                child: Text(
                  style.icon,
                  style: const TextStyle(fontSize: 32),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              style.name,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                style.description,
                style: TextStyle(
                  fontSize: 12,
                  color: XiaoxiaTheme.textTertiary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openGenerate(BuildContext context, {PaintingStyle? style}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaintingGeneratePage(initialStyle: style),
      ),
    );
  }

  void _openHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaintingHistoryPage(),
      ),
    );
  }
}
