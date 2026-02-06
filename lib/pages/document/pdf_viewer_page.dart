import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../../theme.dart';

/// PDF查看页面
class PDFViewerPage extends StatefulWidget {
  final String? filePath;
  
  const PDFViewerPage({super.key, this.filePath});

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  int _currentPage = 0;
  int _totalPages = 0;
  bool _isReady = false;
  String _errorMessage = '';
  PDFViewController? _pdfViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: XiaoxiaDecorations.softGradient,
        child: SafeArea(
          child: Column(
            children: [
              _buildToolbar(),
              
              Expanded(
                child: widget.filePath == null || widget.filePath!.isEmpty
                    ? _buildEmptyView()
                    : _buildPDFView(),
              ),
              
              if (_isReady && _totalPages > 0) _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back_ios, color: XiaoxiaTheme.textDark),
          ),
          Expanded(
            child: Text(
              'PDF查看器',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: _showMoreOptions,
            icon: const Icon(Icons.more_vert, color: XiaoxiaTheme.textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.picture_as_pdf,
            size: 80,
            color: XiaoxiaTheme.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            '未选择PDF文件',
            style: TextStyle(
              color: XiaoxiaTheme.textTertiary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPDFView() {
    if (_errorMessage.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              '无法打开PDF',
              style: TextStyle(color: XiaoxiaTheme.textSecondary),
            ),
            Text(
              _errorMessage,
              style: TextStyle(
                color: XiaoxiaTheme.textTertiary,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: PDFView(
          filePath: widget.filePath!,
          enableSwipe: true,
          swipeHorizontal: true,
          autoSpacing: false,
          pageFling: false,
          onRender: (pages) {
            setState(() {
              _totalPages = pages ?? 0;
              _isReady = true;
            });
          },
          onError: (error) {
            setState(() {
              _errorMessage = error.toString();
            });
          },
          onPageError: (page, error) {
            setState(() {
              _errorMessage = '第$page页加载失败';
            });
          },
          onViewCreated: (controller) {
            _pdfViewController = controller;
          },
          onPageChanged: (page, total) {
            setState(() {
              _currentPage = page ?? 0;
            });
          },
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: _currentPage > 0
                      ? () => _pdfViewController?.setPage(_currentPage - 1)
                      : null,
                  icon: const Icon(Icons.chevron_left),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: XiaoxiaTheme.softPink,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_currentPage + 1} / $_totalPages',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: XiaoxiaTheme.primaryPink,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: _currentPage < _totalPages - 1
                      ? () => _pdfViewController?.setPage(_currentPage + 1)
                      : null,
                  icon: const Icon(Icons.chevron_right),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: const EdgeInsets.only(top: 8),
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('分享'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.print),
              title: const Text('打印'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }
}
