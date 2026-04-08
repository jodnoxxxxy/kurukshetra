import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/pest_provider.dart';
import '../widgets/pest_disease_widgets.dart';

class CropSelectionScreen extends ConsumerWidget {
  const CropSelectionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cropsAsync = ref.watch(pestDiseaseCropsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Select Crop', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: cropsAsync.when(
        data: (crops) {
          final Map<String, List<dynamic>> categorical = {};
          for (var c in crops) {
            categorical.putIfAbsent(c.category, () => []).add(c);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: categorical.entries.map((entry) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(entry.key, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 12),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.9,
                    ),
                    itemCount: entry.value.length,
                    itemBuilder: (context, index) {
                      final crop = entry.value[index];
                      return CropCard(
                        crop: crop,
                        onTap: () {
                          ref.read(selectedPestCropProvider.notifier).setCrop(crop);
                          context.push('/pest-disease/list');
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 24),
                ],
              );
            }).toList(),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
