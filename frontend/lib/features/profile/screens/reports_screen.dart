import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/features/profile/providers/profile_provider.dart';

class FarmReportsScreen extends ConsumerWidget {
  const FarmReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Farm Reports'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Download Reports',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Generate and download detailed reports about your farm',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 24),

          // Soil Health Report
          _buildReportCard(
            context,
            title: 'Soil Health Report',
            description: 'Detailed analysis of soil nutrients, pH levels, and recommendations',
            icon: Icons.grass,
            color: Colors.brown,
            reportType: 'soil_health',
            profileState: profileState,
          ),
          const SizedBox(height: 16),

          // Organic Farming Report
          _buildReportCard(
            context,
            title: 'Organic Farming Report',
            description: 'Compliance status, certification progress, and improvement recommendations',
            icon: Icons.eco,
            color: Colors.green,
            reportType: 'organic_farming',
            profileState: profileState,
          ),
          const SizedBox(height: 16),

          // Crop Advisory Report
          _buildReportCard(
            context,
            title: 'Crop Advisory Report',
            description: 'Season-wise crop performance, yield analysis, and future recommendations',
            icon: Icons.agriculture,
            color: AppColors.primaryGreen,
            reportType: 'crop_advisory',
            profileState: profileState,
          ),
          const SizedBox(height: 16),

          // Profit & Loss Report
          _buildReportCard(
            context,
            title: 'Profit & Loss Report',
            description: 'Financial analysis, income sources, expense breakdown, and profitability',
            icon: Icons.account_balance,
            color: Colors.blue,
            reportType: 'profit_loss',
            profileState: profileState,
          ),
          const SizedBox(height: 16),

          // Weather Impact Report
          _buildReportCard(
            context,
            title: 'Weather Impact Report',
            description: 'Weather patterns, impact on crops, and climate adaptation strategies',
            icon: Icons.cloud,
            color: Colors.indigo,
            reportType: 'weather_impact',
            profileState: profileState,
          ),
          const SizedBox(height: 16),

          // Market Analysis Report
          _buildReportCard(
            context,
            title: 'Market Analysis Report',
            description: 'Market trends, price analysis, and selling recommendations',
            icon: Icons.trending_up,
            color: Colors.purple,
            reportType: 'market_analysis',
            profileState: profileState,
          ),
          const SizedBox(height: 32),

          // Recent Downloads
          const Text(
            'Recent Downloads',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildRecentDownloads(context),
        ],
      ),
    );
  }

  Widget _buildReportCard(
    BuildContext context, {
    required String title,
    required String description,
    required IconData icon,
    required Color color,
    required String reportType,
    required profileState,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _previewReport(context, reportType),
                    icon: const Icon(Icons.visibility, size: 16),
                    label: const Text('Preview'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: color,
                      side: BorderSide(color: color),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _downloadReport(context, reportType, title),
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Download PDF'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentDownloads(BuildContext context) {
    final recentReports = [
      {'name': 'Soil Health Report', 'date': '2 days ago', 'size': '2.3 MB'},
      {'name': 'Crop Advisory Report', 'date': '1 week ago', 'size': '1.8 MB'},
      {'name': 'Profit & Loss Report', 'date': '2 weeks ago', 'size': '3.1 MB'},
    ];

    return Column(
      children: recentReports.map((report) {
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryGreen.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.picture_as_pdf,
                color: AppColors.primaryGreen,
                size: 20,
              ),
            ),
            title: Text(report['name']!),
            subtitle: Text('${report['date']} • ${report['size']}'),
            trailing: IconButton(
              icon: const Icon(Icons.download),
              onPressed: () => _reDownloadReport(context, report['name']!),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _previewReport(BuildContext context, String reportType) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getReportTitle(reportType)),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: Column(
            children: [
              // Mock report preview
              Container(
                height: 300,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.picture_as_pdf, size: 48, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('Report Preview'),
                      SizedBox(height: 8),
                      Text('This would show a preview of the report'),
                      SizedBox(height: 8),
                      Text('with actual data and charts'),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Report includes detailed analysis, charts, and recommendations based on your farm data.',
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _downloadReport(context, reportType, _getReportTitle(reportType));
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Download'),
          ),
        ],
      ),
    );
  }

  void _downloadReport(BuildContext context, String reportType, String reportName) {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Generating report...'),
          ],
        ),
      ),
    );

    // Simulate report generation
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop(); // Close loading dialog
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('$reportName downloaded successfully!'),
          backgroundColor: AppColors.primaryGreen,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'View',
            onPressed: () => _openDownloadedFile(context, reportName),
          ),
        ),
      );
    });
  }

  void _reDownloadReport(BuildContext context, String reportName) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Downloading previous report...')),
    );
  }

  // ignore: unused_element
  void _openDownloadedFile(BuildContext context, String reportName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $reportName...')),
    );
  }

  String _getReportTitle(String reportType) {
    switch (reportType) {
      case 'soil_health':
        return 'Soil Health Report';
      case 'organic_farming':
        return 'Organic Farming Report';
      case 'crop_advisory':
        return 'Crop Advisory Report';
      case 'profit_loss':
        return 'Profit & Loss Report';
      case 'weather_impact':
        return 'Weather Impact Report';
      case 'market_analysis':
        return 'Market Analysis Report';
      default:
        return 'Farm Report';
    }
  }
}
