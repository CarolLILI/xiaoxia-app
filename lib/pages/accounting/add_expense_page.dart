import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../theme.dart';
import '../../models/expense_model.dart';
import '../../services/expense_service.dart';

/// 添加支出页面
class AddExpensePage extends StatefulWidget {
  final Expense? expense;
  
  const AddExpensePage({super.key, this.expense});

  @override
  State<AddExpensePage> createState() => _AddExpensePageState();
}

class _AddExpensePageState extends State<AddExpensePage> {
  final _amountController = TextEditingController();
  final _noteController = TextEditingController();
  String _selectedCategory = '餐饮';
  DateTime _selectedDate = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.expense != null) {
      _amountController.text = widget.expense!.amount.toString();
      _noteController.text = widget.expense!.note;
      _selectedCategory = widget.expense!.category;
      _selectedDate = widget.expense!.date;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
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
                      // 金额输入
                      _buildAmountInput(),
                      const SizedBox(height: 24),
                      
                      // 分类选择
                      _buildCategorySelection(),
                      const SizedBox(height: 24),
                      
                      // 日期选择
                      _buildDateSelection(),
                      const SizedBox(height: 24),
                      
                      // 备注
                      _buildNoteInput(),
                      const SizedBox(height: 32),
                      
                      // 保存按钮
                      _buildSaveButton(),
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
            icon: const Icon(Icons.close, color: XiaoxiaTheme.textDark),
          ),
          Expanded(
            child: Text(
              widget.expense == null ? '记一笔' : '编辑支出',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          if (widget.expense != null)
            IconButton(
              onPressed: _deleteExpense,
              icon: const Icon(Icons.delete_outline, color: Colors.red),
            )
          else
            const SizedBox(width: 48),
        ],
      ),
    );
  }

  Widget _buildAmountInput() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: XiaoxiaTheme.primaryPink.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Text(
            '金额',
            style: TextStyle(
              color: XiaoxiaTheme.textSecondary,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                '¥',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: XiaoxiaTheme.primaryPink,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: XiaoxiaTheme.textDark,
                  ),
                  decoration: const InputDecoration(
                    hintText: '0.00',
                    hintStyle: TextStyle(color: XiaoxiaTheme.textTertiary),
                    border: InputBorder.none,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '分类',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 4,
          childAspectRatio: 0.85,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          children: ExpenseCategory.categories.map((category) {
            final isSelected = category.name == _selectedCategory;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = category.name),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected 
                      ? Color(category.color).withOpacity(0.2)
                      : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected 
                        ? Color(category.color)
                        : Colors.transparent,
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: XiaoxiaTheme.primaryPink.withOpacity(0.05),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(category.icon, style: const TextStyle(fontSize: 28)),
                    const SizedBox(height: 4),
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected 
                            ? Color(category.color)
                            : XiaoxiaTheme.textSecondary,
                        fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildDateSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '日期',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: XiaoxiaTheme.primaryPink.withOpacity(0.05),
                  blurRadius: 8,
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: XiaoxiaTheme.softPink,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.calendar_today,
                    color: XiaoxiaTheme.primaryPink,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${_selectedDate.year}年${_selectedDate.month}月${_selectedDate.day}日',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right,
                  color: XiaoxiaTheme.textTertiary,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoteInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '备注（选填）',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: XiaoxiaTheme.primaryPink.withOpacity(0.05),
                blurRadius: 8,
              ),
            ],
          ),
          child: TextField(
            controller: _noteController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '写点什么...',
              hintStyle: TextStyle(color: XiaoxiaTheme.textTertiary),
              contentPadding: const EdgeInsets.all(16),
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _saveExpense,
        style: ElevatedButton.styleFrom(
          backgroundColor: XiaoxiaTheme.primaryPink,
          foregroundColor: Colors.white,
          elevation: 4,
          shadowColor: XiaoxiaTheme.primaryPink.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: _isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                '保存',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: XiaoxiaTheme.primaryPink,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _saveExpense() async {
    final amount = double.tryParse(_amountController.text);
    if (amount == null || amount <= 0) {
      _showError('请输入有效金额');
      return;
    }

    setState(() => _isLoading = true);

    try {
      final expense = Expense(
        id: widget.expense?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        amount: amount,
        category: _selectedCategory,
        note: _noteController.text,
        date: _selectedDate,
        createdAt: widget.expense?.createdAt ?? DateTime.now(),
      );

      if (widget.expense != null) {
        await ExpenseService.updateExpense(expense);
      } else {
        await ExpenseService.addExpense(expense);
      }

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      _showError('保存失败: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteExpense() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定要删除这条记录吗？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('取消'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true && widget.expense != null) {
      await ExpenseService.deleteExpense(widget.expense!.id);
      if (mounted) {
        Navigator.pop(context, true);
      }
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
