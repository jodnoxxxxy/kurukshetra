import 'package:flutter/material.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';

class FarmAnalyticsScreen extends StatelessWidget {
  const FarmAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Farm Analytics', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildYearSelector(),
            const SizedBox(height: 20),
            _buildFinancialSummary(),
            const SizedBox(height: 24),
            _buildSectionHeader('Yield Performance'),
            const SizedBox(height: 12),
            _buildYieldSection(),
            const SizedBox(height: 24),
            _buildSectionHeader('Monthly Revenue'),
            const SizedBox(height: 12),
            _buildRevenueChart(),
            const SizedBox(height: 24),
            _buildSectionHeader('Input Costs Breakdown'),
            const SizedBox(height: 12),
            _buildCostsBreakdown(),
            const SizedBox(height: 40), // Spacer for bottom
          ],
        ),
      ),
    );
  }

  Widget _buildYearSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Detailed Statistics',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            children: [
              Text('2025-26', style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold, fontSize: 13)),
              const Icon(Icons.arrow_drop_down, color: AppColors.primaryGreen),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFinancialSummary() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildSummaryCard(
                'Total Revenue',
                '₹4,25,000',
                '+12.5%',
                Colors.green,
                Icons.account_balance_wallet_outlined,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildSummaryCard(
                'Operating Costs',
                '₹1,75,000',
                '-5.2%',
                Colors.red,
                Icons.trending_down,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFF1B5E20),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Net Profit',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    '₹2,50,000',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.trending_up, color: Colors.white, size: 16),
                    SizedBox(width: 4),
                    Text('18.2%', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String label, String value, String percent, Color color, IconData icon) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(icon, color: Colors.grey.shade400, size: 20),
                Text(
                  percent,
                  style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Text(
          'Details',
          style: TextStyle(color: AppColors.primaryGreen, fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildYieldSection() {
    return Row(
      children: [
        Expanded(child: _buildYieldItem('Wheat', '4.2', 'Tons/Acre', '🌾', Colors.orange)),
        const SizedBox(width: 8),
        Expanded(child: _buildYieldItem('Soybean', '1.8', 'Tons/Acre', '🌱', Colors.green)),
        const SizedBox(width: 8),
        Expanded(child: _buildYieldItem('Tomato', '12', 'Tons/Acre', '🍅', Colors.red)),
      ],
    );
  }

  Widget _buildYieldItem(String crop, String value, String unit, String emoji, Color color) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: color.withValues(alpha: 0.1)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            Text(unit, style: const TextStyle(fontSize: 10, color: Colors.grey)),
            const SizedBox(height: 4),
            Text(crop, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildRevenueChart() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                _buildBar(40, 'Oct'),
                _buildBar(65, 'Nov'),
                _buildBar(30, 'Dec'),
                _buildBar(90, 'Jan', isHigh: true),
                _buildBar(50, 'Feb'),
                _buildBar(75, 'Mar'),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Revenue peaked in January due to wheat harvest.',
              style: TextStyle(fontSize: 12, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBar(double height, String label, {bool isHigh = false}) {
    return Column(
      children: [
        Container(
          width: 24,
          height: height,
          decoration: BoxDecoration(
            color: isHigh ? AppColors.primaryGreen : AppColors.primaryGreen.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildCostsBreakdown() {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCostRow('Seeds & Fertilisers', '42%', Colors.green),
            const Divider(),
            _buildCostRow('Labour', '28%', Colors.orange),
            const Divider(),
            _buildCostRow('Irrigation & Electricity', '15%', Colors.blue),
            const Divider(),
            _buildCostRow('Equipment Rental', '10%', Colors.purple),
            const Divider(),
            _buildCostRow('Others', '5%', Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, String percent, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 12),
        Expanded(child: Text(label, style: const TextStyle(fontSize: 14))),
        Text(
          percent,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
      ],
    );
  }
}
