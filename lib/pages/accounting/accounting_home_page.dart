import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../models/expense_model.dart';
import '../../services/expense_service.dart';
import 'add_expense_page.dart';
import 'analysis_page.dart';
import 'expense_list_page.dart';

/// 记账首页
class AccountingHomePage extends StatefulWidget {
  const AccountingHomePage({super.key});

  @override
  State<AccountingHomePage> createState() => _AccountingHomePageState();
}

class _AccountingHomePageState extends State<AccountingHomePage> {
  double _todayTotal = 0;
  double _monthTotal = 0;
  List<Expense> _recentExpenses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    
    final today = await ExpenseService.getTodayTotal();
    final month = await ExpenseService.getMonthTotal();
    final all = await ExpenseService.getAllExpenses();
    
    setState(() {
      _todayTotal = today;
      _monthTotal = month;
      _recentExpenses = all.take(5).toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: XiaoxiaDecorations.softGradient,
        child: SafeArea(
          child: RefreshIndicator(
            onRefresh: _loadData,
            color: XiaoxiaTheme.primaryPink,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 页面标题
                  _buildHeader(),
                  const SizedBox(height: 20),
                  
                  // 今日支出卡片
                  _buildTodayCard(),
                  const SizedBox(height: 16),
                  
                  // 快捷入口
                  _buildQuickActions(),
                  const SizedBox(height: 24),
                  
                  // 本月支出
                  _buildMonthOverview(),
                  const SizedBox(height: 24),
                  
                  // 最近记录
                  _buildRecentExpenses(),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddExpense(),
        backgroundColor: XiaoxiaTheme.primaryPink,
        elevation: 4,
        child: const Icon(Icons.add, color: Colors.white, size: 28),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: XiaoxiaTheme.textDark),
        ),
        Expanded(
          child: Text(
            '记账本',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          onPressed: () => _openExpenseList(),
          icon: const Icon(Icons.list, color: XiaoxiaTheme.textDark),
        ),
      ],
    );
  }

  Widget _buildTodayCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            XiaoxiaTheme.primaryPink,
            XiaoxiaTheme.primaryPink.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: XiaoxiaTheme.primaryPink.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.today,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '今日支出',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _isLoading
              ? const CircularProgressIndicator(color: Colors.white)
              : Text(
                  '¥${_todayTotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          const SizedBox(height: 8),
          Text(
            '${DateTime.now().month}月${DateTime.now().day}日',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            icon: Icons.analytics,
            label: '统计分析',
            color: Colors.orange,
            onTap: () => _openAnalysis(),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildActionCard(
            icon: Icons.history,
            label: '历史记录',
            color: Colors.blue,
            onTap: () => _openExpenseList(),
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
        padding: const EdgeInsets.all(16),
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
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMonthOverview() {
    return Container(
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '本月支出',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 12),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : Row(
                  children: [
                    Text(
                      '¥${_monthTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: XiaoxiaTheme.textDark,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: XiaoxiaTheme.softPink,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${DateTime.now().month}月',
                        style: const TextStyle(
                          color: XiaoxiaTheme.primaryPink,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildRecentExpenses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '最近记录',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => _openExpenseList(),
              child: const Text('查看全部'),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _recentExpenses.isEmpty
                ? _buildEmptyState()
                : Column(
                    children: _recentExpenses
                        .map((e) => _buildExpenseItem(e))
                        .toList(),
                  ),
      ],
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
            Icons.receipt_long_outlined,
            size: 48,
            color: XiaoxiaTheme.textTertiary,
          ),
          const SizedBox(height: 12),
          Text(
            '暂无支出记录',
            style: TextStyle(color: XiaoxiaTheme.textTertiary),
          ),
          const SizedBox(height: 8),
          Text(
            '点击右下角 + 开始记账',
            style: TextStyle(
              color: XiaoxiaTheme.textSecondary,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseItem(Expense expense) {
    final category = ExpenseCategory.getByName(expense.category);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: XiaoxiaTheme.primaryPink.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: Color(category.color).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                category.icon,
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  expense.category,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                if (expense.note.isNotEmpty)
                  Text(
                    expense.note,
                    style: TextStyle(
                      color: XiaoxiaTheme.textTertiary,
                      fontSize: 12,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          Text(
            '-¥${expense.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: XiaoxiaTheme.primaryPink,
            ),
          ),
        ],
      ),
    );
  }

  void _openAddExpense() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddExpensePage()),
    ).then((_) => _loadData());
  }

  void _openAnalysis() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AnalysisPage()),
    );
  }

  void _openExpenseList() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ExpenseListPage()),
    ).then((_) => _loadData());
  }
}
