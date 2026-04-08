import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/utils/l10n_utils.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import '../providers/pest_provider.dart';
import '../widgets/pest_widgets.dart';

class PestInfoScreen extends ConsumerWidget {
  const PestInfoScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pest = ref.watch(selectedPestProvider);
    final l10n = AppLocalizations.of(context)!;

    if (pest == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.pestLibrary)),
        body: Center(child: Text(l10n.noPestSelected)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                pest.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(color: Colors.grey.shade300),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(L10nUtils.translatePest(context, pest.name), style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
                        child: Text(L10nUtils.translatePestCategory(context, pest.category), style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12)),
                      )
                    ],
                  ),
                  const SizedBox(height: 24),
                  _buildSection(l10n.symptomsLabel, pest.symptoms),
                  const SizedBox(height: 16),
                  _buildSection(l10n.causeLabel, pest.cause),
                  const SizedBox(height: 16),
                  _buildSection(l10n.preventionLabel, pest.prevention),
                  const SizedBox(height: 32),
                  Text(l10n.organicTreatmentRecommendations, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                  const SizedBox(height: 16),
                  ...pest.solutions.map((solution) => PestSolutionCard(solution: solution)),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Text(content, style: TextStyle(fontSize: 15, color: Colors.grey.shade800, height: 1.5)),
      ],
    );
  }
}

// Temporary Screen to list the Library
class PestLibraryScreen extends ConsumerWidget {
  const PestLibraryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final libraryAsync = ref.watch(pestLibraryProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.pestAndDiseaseLibrary),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: libraryAsync.when(
        data: (library) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: library.length,
            itemBuilder: (context, index) {
              return PestCard(
                pest: library[index],
                onTap: () {
                  ref.read(selectedPestProvider.notifier).setPest(library[index]);
                  context.push('/pest-detection/info');
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('${l10n.error}: $err')),
      ),
    );
  }
}
