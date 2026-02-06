import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../models/expense_model.dart';
import '../../services/expense_service.dart';
import 'add_expense_page.dart';

/// 历史记录页面
class ExpenseListPage extends StatefulWidget {
  const ExpenseListPage({super.key});

  @override
  State<ExpenseListPage> createState() => _ExpenseListPageState();
}

class _ExpenseListPageState extends State<ExpenseListPage> {
  List<Expense> _expenses = [];
  String _selectedFilter = '全部';
  bool _isLoading = true;

  final List<String> _filters = ['全部', ...ExpenseCategory.categories.map((c) => c.name)];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    List<Expense> expenses;
    if (_selectedFilter == '全部') {
      expenses = await ExpenseService.getAllExpenses();
    } else {
      expenses = await ExpenseService.getExpensesByCategory(_selectedFilter);
    }

    setState(() {
      _expenses = expenses;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // 按日期分组
    final groupedExpenses = _groupByDate(_expenses);

    return Scaffold(
      body: Container(
        decoration: XiaoxiaDecorations.softGradient,
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(),
              _buildFilterBar(),
              Expanded(
                child: _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : RefreshIndicator(
                        onRefresh: _loadData,
                        color: XiaoxiaTheme.primaryPink,
                        child: _expenses.isEmpty
                            ? _buildEmptyState()
                            : ListView.builder(
                                padding: const EdgeInsets.all(16),
                                itemCount: groupedExpenses.length,
                                itemBuilder: (context, index) {
                                  final entry = groupedExpenses.entries.elementAt(index);
                                  return _buildDateGroup(entry.key, entry.value);
                                },
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
              '历史记录',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            onPressed: () => _showFilterSheet(),
            icon: const Icon(Icons.filter_list, color: XiaoxiaTheme.textDark),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterBar() {
    return Container(
      height: 44,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: _filters.length,
        itemBuilder: (context, index) {
          final filter = _filters[index];
          final isSelected = filter == _selectedFilter;

          return GestureDetector(
            onTap: () {
              setState(() => _selectedFilter = filter);
              _loadData();
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? XiaoxiaTheme.primaryPink
                    : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                filter,
                style: TextStyle(
                  color: isSelected ? Colors.white : XiaoxiaTheme.textSecondary,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 64,
            color: XiaoxiaTheme.textTertiary,
          ),
          const SizedBox(height: 16),
          Text(
            '暂无记录',
            style: TextStyle(
              color: XiaoxiaTheme.textTertiary,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '快去记一笔吧',
            style: TextStyle(
              color: XiaoxiaTheme.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateGroup(String date, List<Expense> expenses) {
    final dayTotal = expenses.fold(0.0, (sum, e) => sum + e.amount);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: TextStyle(
                  color: XiaoxiaTheme.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '¥${dayTotal.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: XiaoxiaTheme.primaryPink,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        ...expenses.map((expense) => _buildExpenseItem(expense)),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildExpenseItem(Expense expense) {
    final category = ExpenseCategory.getByName(expense.category);

    return Dismissible(
      key: Key(expense.id),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => _deleteExpense(expense),
      child: GestureDetector(
        onTap: () => _editExpense(expense),
        child: Container(
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
                        fontSize: 15,
                      ),
                    ),
                    if (expense.note.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          expense.note,
                          style: TextStyle(
                            color: XiaoxiaTheme.textTertiary,
                            fontSize: 13,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
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
        ),
      ),
    );
  }

  Map<String, List<Expense>> _groupByDate(List<Expense> expenses) {
    final groups = <String, List<Expense>>{};

    for (final expense in expenses) {
      final dateKey = '${expense.date.year}年${expense.date.month}月${expense.date.day}日';
      groups.putIfAbsent(dateKey, () => []).add(expense);
    }

    return groups;
  }

  void _editExpense(Expense expense) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddExpensePage(expense: expense),
      ),
    ).then((_) => _loadData());
  }

  Future<void> _deleteExpense(Expense expense) async {
    await ExpenseService.deleteExpense(expense.id);
    _loadData();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('已删除'),
          duration: Duration(seconds: 1),
        ),
      );
    }
  }

  void _showFilterSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
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
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                '筛选分类',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _filters.map((filter) {
                final isSelected = filter == _selectedFilter;
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    setState(() => _selectedFilter = filter);
                    _loadData();
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? XiaoxiaTheme.primaryPink
                          : XiaoxiaTheme.softPink,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      filter,
                      style: TextStyle(
                        color: isSelected ? Colors.white : XiaoxiaTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
