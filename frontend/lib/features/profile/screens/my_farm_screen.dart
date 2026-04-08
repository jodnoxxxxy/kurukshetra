import 'package:flutter/material.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';

class MyFarmScreen extends StatelessWidget {
  const MyFarmScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: Text(l10n.myFarm, style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_location_alt_outlined),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFarmBanner(context, l10n),
            const SizedBox(height: 20),
            _buildQuickStats(l10n),
            const SizedBox(height: 24),
            _buildFarmInformation(l10n),
            const SizedBox(height: 24),
            Text(l10n.cropsTrackedLabel, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildCropsTrackedList(),
            const SizedBox(height: 24),
            _buildLandRecordsSection(l10n),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFarmBanner(BuildContext context, AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1B5E20),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.agriculture_rounded, size: 48, color: Colors.white),
          ),
          const SizedBox(height: 16),
          const Text(
            'Dalvi Organic Farm',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on_rounded, color: Colors.white.withValues(alpha: 0.8), size: 14),
              const SizedBox(width: 4),
              Text(
                'Khadavali, Shahapur, Maharashtra',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 13),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(child: _buildStatItem('Total Area', '5.0', 'Acres', Icons.square_foot)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatItem('Active Crops', '3', 'Current', Icons.eco_outlined)),
        const SizedBox(width: 12),
        Expanded(child: _buildStatItem('Ownership', 'Self', 'Owned', Icons.card_membership)),
      ],
    );
  }

  Widget _buildStatItem(String label, String value, String unit, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryGreen, size: 18),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text('$unit $label', style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildFarmInformation(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.info_outline, color: AppColors.primaryGreen, size: 20),
              const SizedBox(width: 8),
              Text(l10n.farmInformation, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 16),
          _buildInfoRow('Farm Type', 'Mixed Organic Farming'),
          const Divider(height: 24),
          _buildInfoRow('Soil Quality', 'High - Black Loamy Soil'),
          const Divider(height: 24),
          _buildInfoRow('Water Availability', 'Year-round (River + Borewell)'),
          const Divider(height: 24),
          _buildInfoRow('Irrigation System', 'Drip + Sprinkler'),
          const Divider(height: 24),
          _buildInfoRow('Certified Since', 'June 2023'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 13)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
      ],
    );
  }

  Widget _buildCropsTrackedList() {
    return Column(
      children: [
        _buildCropItem('Wheat', 'Growing', '2.5 Acres', '🌾', Colors.orange),
        const SizedBox(height: 12),
        _buildCropItem('Soybean', 'Planted', '1.5 Acres', '🌱', Colors.green),
        const SizedBox(height: 12),
        _buildCropItem('Tomato', 'Fruiting', '1.0 Acre', '🍅', Colors.red),
      ],
    );
  }

  Widget _buildCropItem(String name, String status, String area, String icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(icon, style: const TextStyle(fontSize: 24)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                Text(area, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildLandRecordsSection(AppLocalizations l10n) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Row(
        children: [
          Icon(Icons.description_outlined, color: Colors.blue.shade700, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Land Records Managed',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  '7/12 Utara, mutation and ownership docs.',
                  style: TextStyle(fontSize: 12, color: Colors.blue.shade900),
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('View All', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
