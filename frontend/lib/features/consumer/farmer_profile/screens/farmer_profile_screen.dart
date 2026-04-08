import 'package:flutter/material.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import '../../models/consumer_product.dart';

class FarmerProfileScreen extends StatelessWidget {
  final ConsumerProduct seedProduct;

  const FarmerProfileScreen({super.key, required this.seedProduct});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Farmer Profile', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header Profile Banner
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              color: AppColors.primaryGreen.withValues(alpha: 0.1),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: AppColors.primaryGreen,
                    child: Icon(Icons.person, color: Colors.white, size: 60),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    seedProduct.farmerName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.location_on, size: 16, color: AppColors.textSecondary),
                      const SizedBox(width: 4),
                      Text(
                        seedProduct.farmLocation,
                        style: const TextStyle(fontSize: 14, color: AppColors.textSecondary, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.primaryGreen),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.eco, color: AppColors.primaryGreen, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'Organic Score: ${seedProduct.organicScore}%',
                              style: const TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Profile Detailed Stats
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Transparency Dashboard', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  Card(
                    elevation: 0,
                    color: Colors.grey.shade50,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          _buildStatRow(Icons.compost, 'Primary Fertilizer', seedProduct.organicFertilizer),
                          const Divider(height: 24),
                          _buildStatRow(Icons.pest_control, 'Pest Control', seedProduct.chemicalPesticides),
                          const Divider(height: 24),
                          _buildStatRow(Icons.calendar_month, 'Farming Since', '2019'),
                          const Divider(height: 24),
                          _buildStatRow(Icons.verified, 'Certifications', seedProduct.certification),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                  const Text('Available Produce', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  
                  // Mock Grid of other products by this farmer
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      _buildCropChip(seedProduct.imageUrl, seedProduct.name),
                      if (seedProduct.category != 'Grains') _buildCropChip('🌽', 'Organic Maize'),
                      if (seedProduct.category == 'Vegetables') _buildCropChip('🍆', 'Brinjal'),
                    ],
                  ),

                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Launch map or chat
                      },
                      icon: const Icon(Icons.chat),
                      label: const Text('Message Farmer', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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

  Widget _buildStatRow(IconData icon, String title, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.grey.shade700, size: 24),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          ],
        ),
      ],
    );
  }

  Widget _buildCropChip(String emoji, String name) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.shade100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryGreen)),
        ],
      ),
    );
  }
}
