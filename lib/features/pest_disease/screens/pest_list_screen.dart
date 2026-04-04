import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/pest_provider.dart';
import '../widgets/pest_disease_widgets.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';

class PestListScreen extends ConsumerWidget {
  const PestListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final crop = ref.watch(selectedPestCropProvider);
    final pestsAsync = ref.watch(pestListByCropProvider);

    if (crop == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Pests & Diseases')),
        body: const Center(child: Text('No crop selected.')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text('${crop.name} Pests', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.document_scanner),
            tooltip: 'Detect via Image (Coming soon)',
            onPressed: () {
              // Stub for AI scanning module
            },
          )
        ],
      ),
      body: pestsAsync.when(
        data: (pests) {
          if (pests.isEmpty) return const Center(child: Text('No pests logged for this crop yet.'));

          return Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                color: Colors.white,
                child: const Text('Select a disease to view 100% organic solutions and Upays.', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: pests.length,
                  itemBuilder: (context, index) {
                    final pest = pests[index];
                    return PestCard(
                      pest: pest,
                      onTap: () {
                        ref.read(selectedPestDiseaseProvider.notifier).setPest(pest);
                        context.push('/pest-disease/detail');
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('Scan Affected Leaf'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryGreen,
                      side: const BorderSide(color: AppColors.primaryGreen, width: 2),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }
}
