import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/pest_provider.dart';
import '../widgets/pest_disease_widgets.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';

class PestDetailScreen extends ConsumerWidget {
  const PestDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pest = ref.watch(selectedPestDiseaseProvider);

    if (pest == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: const Center(child: Text('No disease selected.')),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
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
                  Text(pest.name, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(pest.shortDescription, style: TextStyle(fontSize: 14, color: Colors.grey.shade600)),
                  const Divider(height: 32),
                  
                  // Diagnostic Info
                  _buildSection('Symptoms', pest.symptoms, Icons.sick_outlined),
                  const SizedBox(height: 20),
                  _buildSection('Cause', pest.cause, Icons.science_outlined),
                  const SizedBox(height: 20),
                  _buildSection('Affected Stage', pest.affectedStage, Icons.grass),
                  
                  const Divider(height: 40),
                  
                  // Organic Solutions
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                    child: const Row(
                      children: [
                        Icon(Icons.eco, color: AppColors.primaryGreen, size: 28),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Organic Upay (Treatment Solutions)',
                            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  ...pest.solutions.map((solution) => OrganicSolutionCard(solution: solution)),
                  
                  const SizedBox(height: 32),
                  
                  // Prevention Tips
                  const Text('Prevention Tips', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: Column(
                      children: pest.preventionTips.map((tip) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 2),
                                child: Icon(Icons.shield, size: 18, color: Colors.orange),
                              ),
                              const SizedBox(width: 12),
                              Expanded(child: Text(tip, style: TextStyle(color: Colors.amber.shade900, height: 1.4))),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 48),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey.shade700, size: 20),
            const SizedBox(width: 8),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 8),
        Text(content, style: TextStyle(fontSize: 15, color: Colors.grey.shade800, height: 1.5)),
      ],
    );
  }
}
