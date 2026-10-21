import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_provider.dart';

class CostCalculatorScreen extends ConsumerWidget {
  const CostCalculatorScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(calculatorProvider);
    final season = ref.watch(selectedSeasonProvider);
    final year = ref.watch(selectedYearProvider);
    final profit = state.getProfit(null);
    final crops = state.crops;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cost Calculator'),
        backgroundColor: const Color(0xFF0A8F3D),
        leading: BackButton(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: season,
                    decoration: const InputDecoration(labelText: 'Season'),
                    items: ['Kharif', 'Rabi', 'Zaid']
                        .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                        .toList(),
                    onChanged: (val) {
                      if (val != null) ref.read(selectedSeasonProvider.notifier).update(val);
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: year,
                    decoration: const InputDecoration(labelText: 'Year'),
                    items: List.generate(5, (i) {
                      final y = DateTime.now().year - i;
                      return DropdownMenuItem(value: y.toString(), child: Text(y.toString()));
                    }),
                    onChanged: (val) {
                      if (val != null) ref.read(selectedYearProvider.notifier).update(val);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.green[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Estimated total profit', style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('₹${profit.toStringAsFixed(2)}', style: const TextStyle(fontSize: 20, color: Color(0xFF0A8F3D), fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Crops', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0A8F3D)),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Crop'),
                  onPressed: () {
                    Navigator.pushNamed(context, '/calculator/select-crop');
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: crops.isEmpty
                  ? const Center(child: Text('No crops added yet.'))
                  : ListView.builder(
                      itemCount: crops.length,
                      itemBuilder: (context, idx) {
                        final crop = crops[idx];
                        return Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: Text(crop.imageUrl, style: const TextStyle(fontSize: 32)),
                            title: Text(crop.name),
                            subtitle: Text(crop.category),
                            trailing: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                ref.read(calculatorProvider.notifier).removeCrop(crop.id);
                              },
                            ),
                            onTap: () {
                              Navigator.pushNamed(context, '/calculator/expenses', arguments: crop);
                            },
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
