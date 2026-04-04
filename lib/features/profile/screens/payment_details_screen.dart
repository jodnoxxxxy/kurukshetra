import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/features/profile/providers/profile_provider.dart';

class PaymentDetailsScreen extends ConsumerStatefulWidget {
  const PaymentDetailsScreen({super.key});

  @override
  ConsumerState<PaymentDetailsScreen> createState() => _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends ConsumerState<PaymentDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);

    if (profileState.profile == null) {
      return const Scaffold(
        backgroundColor: Color(0xFFF9FBF9),
        body: Center(child: CircularProgressIndicator(color: AppColors.primaryGreen)),
      );
    }

    final paymentDetails = profileState.profile!.paymentDetails;

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: const Text('Secure Payments', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: const Color(0xFFF9FBF9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
              ),
              child: TabBar(
                controller: _tabController,
                indicator: BoxDecoration(color: AppColors.primaryGreen, borderRadius: BorderRadius.circular(12)),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.grey,
                indicatorSize: TabBarIndicatorSize.tab,
                dividerColor: Colors.transparent,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                tabs: const [
                  Tab(text: 'BANK'),
                  Tab(text: 'UPI'),
                  Tab(text: 'HISTORY'),
                ],
              ),
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildBankDetails(paymentDetails),
                _buildUPISection(paymentDetails),
                _buildTransactionHistory(paymentDetails),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBankDetails(dynamic paymentDetails) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildPremiumCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                      child: const Icon(Icons.account_balance_rounded, color: AppColors.primaryGreen, size: 24),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.edit_note_rounded, color: Colors.grey),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(paymentDetails.bankName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(paymentDetails.accountHolder, style: TextStyle(fontSize: 14, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 20),
                _buildInfoRow('Account Number', paymentDetails.accountNumber, isMasked: true),
                _buildInfoRow('IFSC Code', paymentDetails.ifscCode),
                _buildInfoRow('Account Type', 'Savings'),
                _buildInfoRow('Branch', 'Khadavali Main'),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Text('QUICK ACTIONS', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey, letterSpacing: 1.2)),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildActionTile('Verify ID', Icons.verified_user_rounded, Colors.blue)),
              const SizedBox(width: 12),
              Expanded(child: _buildActionTile('Statement', Icons.description_rounded, AppColors.primaryGreen)),
            ],
          ),
          const SizedBox(height: 32),
          _buildPremiumCard(
            child: Column(
              children: [
                _buildSettingsToggle('Payment Alerts', true),
                const Divider(height: 24),
                _buildSettingsToggle('Quick Settle', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUPISection(dynamic paymentDetails) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          _buildPremiumCard(
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                      child: const Icon(Icons.qr_code_2_rounded, color: Colors.orange, size: 24),
                    ),
                    const SizedBox(width: 16),
                    const Text('Unified Payments Interface', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 32),
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(24), border: Border.all(color: Colors.grey.shade100)),
                  child: Column(
                    children: [
                      const Icon(Icons.qr_code_scanner_rounded, size: 160, color: Colors.black87),
                      const SizedBox(height: 16),
                      Text(paymentDetails.upiId, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryGreen)),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.share_rounded, size: 18),
                    label: const Text('SHARE QR CODE', style: TextStyle(fontWeight: FontWeight.bold)),
                    style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildPartnerIcon('Google Pay'),
              const SizedBox(width: 20),
              _buildPartnerIcon('PhonePe'),
              const SizedBox(width: 20),
              _buildPartnerIcon('Paytm'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionHistory(dynamic paymentDetails) {
    final txns = [
      {'title': 'Wheat Harvest Sale', 'date': '24 Mar 2026', 'amt': '₹32,400', 'type': 'in'},
      {'title': 'NPK Fertilizer Purchase', 'date': '21 Mar 2026', 'amt': '₹4,200', 'type': 'out'},
      {'title': 'Subsidy Credit (PM-K)', 'date': '15 Mar 2026', 'amt': '₹2,000', 'type': 'in'},
      {'title': 'Seed Purchase (Rice)', 'date': '10 Mar 2026', 'amt': '₹1,500', 'type': 'out'},
    ];

    return Column(
      children: [
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)], begin: Alignment.topLeft, end: Alignment.bottomRight),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('AVAILABLE BALANCE', style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
              const Text('₹48,210.50', style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.trending_up, color: Colors.greenAccent, size: 14),
                  const SizedBox(width: 4),
                  Text('8% increase this month', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: txns.length,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemBuilder: (ctx, i) => Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: (txns[i]['type'] == 'in' ? Colors.green : Colors.red).withValues(alpha: 0.05), shape: BoxShape.circle),
                    child: Icon(txns[i]['type'] == 'in' ? Icons.call_received_rounded : Icons.call_made_rounded, color: txns[i]['type'] == 'in' ? Colors.green : Colors.red, size: 18),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(txns[i]['title']!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        Text(txns[i]['date']!, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)),
                      ],
                    ),
                  ),
                  Text(txns[i]['amt']!, style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: txns[i]['type'] == 'in' ? Colors.green : Colors.black87)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPremiumCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: child,
    );
  }

  Widget _buildInfoRow(String label, String value, {bool isMasked = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.w500)),
          Text(isMasked ? '**** ${value.substring(value.length - 4)}' : value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildActionTile(String label, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(20), border: Border.all(color: color.withValues(alpha: 0.1))),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: color)),
        ],
      ),
    );
  }

  Widget _buildSettingsToggle(String title, bool value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        Switch(value: value, onChanged: (v) {}, activeThumbColor: AppColors.primaryGreen),
      ],
    );
  }

  Widget _buildPartnerIcon(String name) {
    return Column(
      children: [
        Container(
          width: 48, height: 48,
          decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)]),
          child: const Icon(Icons.account_balance_wallet_rounded, color: Colors.grey, size: 20),
        ),
        const SizedBox(height: 4),
        Text(name, style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: Colors.grey)),
      ],
    );
  }
}
