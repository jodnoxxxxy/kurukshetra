import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../integration/providers/farm_data_provider.dart';
import '../models/calculator_models.dart';
import '../../../core/theme/app_text_styles.dart';

class AdvancedCropCalculatorScreen extends ConsumerStatefulWidget {
  const AdvancedCropCalculatorScreen({super.key});

  @override
  ConsumerState<AdvancedCropCalculatorScreen> createState() => _AdvancedCropCalculatorScreenState();
}

class _AdvancedCropCalculatorScreenState extends ConsumerState<AdvancedCropCalculatorScreen> {
  final _nController = TextEditingController(text: '0');
  final _pController = TextEditingController(text: '0');
  final _kController = TextEditingController(text: '0');
  final _yieldController = TextEditingController(text: '0');
  final _priceController = TextEditingController(text: '0');
  final _costNameController = TextEditingController();
  final _costAmountController = TextEditingController();

  @override
  void dispose() {
    _nController.dispose();
    _pController.dispose();
    _kController.dispose();
    _yieldController.dispose();
    _priceController.dispose();
    _costNameController.dispose();
    _costAmountController.dispose();
    super.dispose();
  }

  void _updateSoil(WidgetRef ref) {
    final n = double.tryParse(_nController.text) ?? 0;
    final p = double.tryParse(_pController.text) ?? 0;
    final k = double.tryParse(_kController.text) ?? 0;
    ref.read(farmDataProvider.notifier).updateSoil(n, p, k);
  }

  void _updateYieldPrice(WidgetRef ref) {
    final y = double.tryParse(_yieldController.text) ?? 0;
    final p = double.tryParse(_priceController.text) ?? 0;
    ref.read(farmDataProvider.notifier).updateExpectedYield(y);
    ref.read(farmDataProvider.notifier).updateMarketPrice(p);
  }

  @override
  Widget build(BuildContext context) {
    final farmData = ref.watch(farmDataProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reactive Crop Calculator'),
        backgroundColor: const Color(0xFF0A8F3D),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. Live Profit Projection Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.green.shade50,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text('Live Profit Projection', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.green)),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Column(
                          children: [
                            const Text('Est. Revenue', style: TextStyle(color: Colors.black54)),
                            Text('₹${farmData.estimatedRevenue.toStringAsFixed(0)}', style: AppTextStyles.h3.copyWith(color: Colors.blue)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Total Cost', style: TextStyle(color: Colors.black54)),
                            Text('₹${farmData.totalCost.toStringAsFixed(0)}', style: AppTextStyles.h3.copyWith(color: Colors.red)),
                          ],
                        ),
                        Column(
                          children: [
                            const Text('Net Profit', style: TextStyle(color: Colors.black54)),
                            Text('₹${farmData.netProfit.toStringAsFixed(0)}', style: AppTextStyles.h3.copyWith(color: farmData.netProfit >= 0 ? Colors.green : Colors.red, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. Soil Status -> Cascades into Fertilizer Need
            const Text('1. Soil Analysis', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: _buildTextField(_nController, 'N (Nitrogen)', () => _updateSoil(ref))),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTextField(_pController, 'P (Phosphorus)', () => _updateSoil(ref))),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTextField(_kController, 'K (Potassium)', () => _updateSoil(ref))),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(8)),
                      child: Row(
                        children: [
                          const Icon(Icons.science, color: Colors.orange),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Cascading Action: Based on current NPK, your farm needs ${farmData.fertilizerRequiredKg.toStringAsFixed(1)} kg of combined fertilizer.',
                              style: const TextStyle(color: Colors.black87),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (farmData.fertilizerRequiredKg > 0)
                      ElevatedButton(
                        onPressed: () {
                          // Auto add cost
                          final cost = farmData.fertilizerRequiredKg * 50; // Assume 50 rs / kg
                          ref.read(farmDataProvider.notifier).addOperationalCost(Transaction(
                            id: const Uuid().v4(),
                            cropId: 'global',
                            type: 'expense',
                            category: 'Fertilizer',
                            name: 'Auto-Calculated Fertilizer',
                            amount: cost,
                            date: DateTime.now(),
                          ));
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Fertilizer Cost Added!')));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                        child: Text('+ Auto Add ₹${(farmData.fertilizerRequiredKg * 50).toStringAsFixed(0)} to Costs'),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 3. Market Pricing Yield Model
            const Text('2. Market Projection', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(child: _buildTextField(_yieldController, 'Est. Yield (Qtly)', () => _updateYieldPrice(ref))),
                    const SizedBox(width: 16),
                    Expanded(child: _buildTextField(_priceController, 'Price (₹/Qtl)', () => _updateYieldPrice(ref))),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 4. Operational Costs 
            const Text('3. Operational Costs', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(flex: 2, child: _buildTextField(_costNameController, 'Expense Name', null, isNumber: false)),
                        const SizedBox(width: 8),
                        Expanded(child: _buildTextField(_costAmountController, 'Amount (₹)', null)),
                        IconButton(
                          icon: const Icon(Icons.add_circle, color: Color(0xFF0A8F3D), size: 32),
                          onPressed: () {
                            if (_costNameController.text.isNotEmpty && _costAmountController.text.isNotEmpty) {
                              ref.read(farmDataProvider.notifier).addOperationalCost(Transaction(
                                id: const Uuid().v4(),
                                cropId: 'global',
                                type: 'expense',
                                category: 'Custom',
                                name: _costNameController.text,
                                amount: double.parse(_costAmountController.text),
                                date: DateTime.now(),
                              ));
                              _costNameController.clear();
                              _costAmountController.clear();
                            }
                          },
                        ),
                      ],
                    ),
                    const Divider(height: 32),
                    if (farmData.operationalCosts.isEmpty)
                      const Text('No operational costs added.')
                    else
                      ...farmData.operationalCosts.map((c) => ListTile(
                        leading: const Icon(Icons.money_off, color: Colors.red),
                        title: Text(c.name),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('-₹${c.amount.toStringAsFixed(0)}', style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.grey),
                              onPressed: () => ref.read(farmDataProvider.notifier).removeCost(c.id),
                            )
                          ],
                        ),
                      )).toList(),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, VoidCallback? onChanged, {bool isNumber = true}) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      onChanged: (_) {
        if (onChanged != null) onChanged();
      },
    );
  }
}
