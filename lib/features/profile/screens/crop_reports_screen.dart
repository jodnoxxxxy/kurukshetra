import 'package:flutter/material.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';

class CropReportsScreen extends StatelessWidget {
  const CropReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crop Reports'),
        backgroundColor: AppColors.primaryGreen,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildReportCard(
            '📊 Organic Report',
            'Download detailed organic farming status report',
            Icons.download_rounded,
            () {},
          ),
          const SizedBox(height: 12),
          _buildReportCard(
            '🌱 Soil Health Report',
            'Comprehensive soil analysis and recommendations',
            Icons.download_rounded,
            () {},
          ),
          const SizedBox(height: 12),
          _buildReportCard(
            '📋 Crop Advisory Report',
            'Expert recommendations for crop management',
            Icons.download_rounded,
            () {},
          ),
          const SizedBox(height: 12),
          _buildReportCard(
            '💰 Market Analysis Report',
            'Price trends and market insights',
            Icons.download_rounded,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _buildReportCard(String title, String description, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primaryGreen, size: 28),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(description, style: const TextStyle(color: AppColors.textSecondary)),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, size: 18),
          onPressed: onTap,
        ),
      ),
    );
  }
}
