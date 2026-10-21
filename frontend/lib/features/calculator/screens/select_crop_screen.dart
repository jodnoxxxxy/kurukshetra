import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/calculator_provider.dart';
import '../models/calculator_models.dart';

class SelectCropScreen extends ConsumerWidget {
  const SelectCropScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final crops = ref.watch(availableCropsProvider);
    final grouped = <String, List<CalcCrop>>{};
    for (final crop in crops) {
      grouped.putIfAbsent(crop.category, () => []).add(crop);
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Crop'),
        backgroundColor: const Color(0xFF0A8F3D),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: grouped.entries.map((entry) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(entry.key, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              ),
              GridView.count(
                crossAxisCount: 4,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: entry.value.map((crop) {
                  return GestureDetector(
                    onTap: () {
                      ref.read(calculatorProvider.notifier).addCrop(crop);
                      Navigator.pop(context);
                    },
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircleAvatar(
                          radius: 28,
                          child: Text(crop.imageUrl, style: const TextStyle(fontSize: 28)),
                          backgroundColor: Colors.green[100],
                        ),
                        const SizedBox(height: 4),
                        Text(crop.name, style: const TextStyle(fontSize: 13)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
