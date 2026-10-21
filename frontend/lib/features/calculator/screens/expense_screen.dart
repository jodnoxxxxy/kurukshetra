import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/calculator_models.dart';
import '../providers/calculator_provider.dart';

class ExpenseScreen extends ConsumerWidget {
  final CalcCrop crop;
  const ExpenseScreen({Key? key, required this.crop}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);
    final transactions = state.transactions.where((t) => t.cropId == crop.id).toList();
    final expense = state.getTotalExpense(crop.id);
    final income = state.getTotalIncome(crop.id);
    final profit = state.getProfit(crop.id);

    return Scaffold(
      appBar: AppBar(
        title: Text('${crop.name} Expenses'),
        backgroundColor: const Color(0xFF0A8F3D),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: Text(crop.imageUrl, style: const TextStyle(fontSize: 32)),
                title: Text(crop.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(crop.category),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        const Text('Expense', style: TextStyle(color: Colors.red)),
                        Text('₹${expense.toStringAsFixed(2)}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Income', style: TextStyle(color: Colors.green)),
                        Text('₹${income.toStringAsFixed(2)}', style: const TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    Column(
                      children: [
                        const Text('Profit', style: TextStyle(color: Colors.black)),
                        Text('₹${profit.toStringAsFixed(2)}', style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Transactions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A8F3D)),
                  icon: const Icon(Icons.add),
                  label: const Text('Add new'),
                  onPressed: () async {
                    await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                      ),
                      builder: (context) => AddTransactionModal(cropId: crop.id),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: transactions.isEmpty
                  ? const Center(child: Text('No Transactions Found'))
                  : ListView.builder(
                      itemCount: transactions.length,
                      itemBuilder: (context, idx) {
                        final t = transactions[idx];
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: Icon(t.type == 'expense' ? Icons.remove_circle : Icons.add_circle, color: t.type == 'expense' ? Colors.red : Colors.green),
                            title: Text(t.name),
                            subtitle: Text('${t.type == 'expense' ? 'Expense' : 'Income'} - ${t.category}'),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('₹${t.amount.toStringAsFixed(2)}', style: TextStyle(color: t.type == 'expense' ? Colors.red : Colors.green, fontWeight: FontWeight.bold)),
                                Text('${t.date.day}/${t.date.month}/${t.date.year}', style: const TextStyle(fontSize: 12)),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class AddTransactionModal extends ConsumerStatefulWidget {
  final String cropId;
  const AddTransactionModal({Key? key, required this.cropId}) : super(key: key);

  @override
  ConsumerState<AddTransactionModal> createState() => _AddTransactionModalState();
}

class _AddTransactionModalState extends ConsumerState<AddTransactionModal> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _expenseFormKey = GlobalKey<FormState>();
  final _incomeFormKey = GlobalKey<FormState>();

  // Expense fields
  String _expenseCategory = 'Seeds';
  String _expenseName = '';
  DateTime _expenseDate = DateTime.now();
  double? _expensePrice;

  // Income fields
  String _incomeName = '';
  DateTime _incomeDate = DateTime.now();
  double? _yield;
  double? _pricePerUnit;

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: 420,
        child: Column(
          children: [
            TabBar(
              controller: _tabController,
              tabs: const [
                Tab(text: 'Expense'),
                Tab(text: 'Income'),
              ],
              labelColor: Color(0xFF0A8F3D),
              unselectedLabelColor: Colors.black,
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  // Expense Tab
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _expenseFormKey,
                      child: Column(
                        children: [
                          DropdownButtonFormField<String>(
                            value: _expenseCategory,
                            decoration: const InputDecoration(labelText: 'Category'),
                            items: ['Seeds', 'Fertilizer', 'Labor', 'Irrigation', 'Pesticide', 'Transport', 'Other']
                                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                                .toList(),
                            onChanged: (val) {
                              setState(() => _expenseCategory = val!);
                            },
                          ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Expense Name (optional)'),
                            onChanged: (val) => _expenseName = val,
                          ),
                          Row(
                            children: [
                              const Text('Date: '),
                              TextButton(
                                child: Text('${_expenseDate.day}/${_expenseDate.month}/${_expenseDate.year}'),
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _expenseDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) setState(() => _expenseDate = picked);
                                },
                              ),
                            ],
                          ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Price (₹)'),
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              if (val == null || val.isEmpty) return 'Price required';
                              final v = double.tryParse(val);
                              if (v == null || v <= 0) return 'Enter valid price';
                              return null;
                            },
                            onChanged: (val) => _expensePrice = double.tryParse(val),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A8F3D)),
                            onPressed: () {
                              if (_expenseFormKey.currentState!.validate()) {
                                ref.read(calculatorProvider.notifier).addTransaction(
                                  widget.cropId,
                                  'expense',
                                  _expenseCategory,
                                  _expenseName,
                                  _expensePrice!,
                                  _expenseDate,
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Save Expense'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Income Tab
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Form(
                      key: _incomeFormKey,
                      child: Column(
                        children: [
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Income Name (optional)'),
                            onChanged: (val) => _incomeName = val,
                          ),
                          Row(
                            children: [
                              const Text('Date: '),
                              TextButton(
                                child: Text('${_incomeDate.day}/${_incomeDate.month}/${_incomeDate.year}'),
                                onPressed: () async {
                                  final picked = await showDatePicker(
                                    context: context,
                                    initialDate: _incomeDate,
                                    firstDate: DateTime(2020),
                                    lastDate: DateTime(2100),
                                  );
                                  if (picked != null) setState(() => _incomeDate = picked);
                                },
                              ),
                            ],
                          ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Yield (kg/quintal/ton)'),
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              if (val == null || val.isEmpty) return 'Yield required';
                              final v = double.tryParse(val);
                              if (v == null || v <= 0) return 'Enter valid yield';
                              return null;
                            },
                            onChanged: (val) => _yield = double.tryParse(val),
                          ),
                          TextFormField(
                            decoration: const InputDecoration(labelText: 'Price per unit (₹)'),
                            keyboardType: TextInputType.number,
                            validator: (val) {
                              if (val == null || val.isEmpty) return 'Price required';
                              final v = double.tryParse(val);
                              if (v == null || v <= 0) return 'Enter valid price';
                              return null;
                            },
                            onChanged: (val) => _pricePerUnit = double.tryParse(val),
                          ),
                          const Spacer(),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A8F3D)),
                            onPressed: () {
                              if (_incomeFormKey.currentState!.validate()) {
                                final totalIncome = (_yield ?? 0) * (_pricePerUnit ?? 0);
                                ref.read(calculatorProvider.notifier).addTransaction(
                                  widget.cropId,
                                  'income',
                                  'yield',
                                  _incomeName,
                                  totalIncome,
                                  _incomeDate,
                                  yieldAmount: _yield,
                                  pricePerUnit: _pricePerUnit,
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Save Income'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
