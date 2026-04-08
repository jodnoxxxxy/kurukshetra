import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            expandedHeight: 0,
            floating: true,
            pinned: true,
            title: Text(
              l10n.helpSupport,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
            ),
            backgroundColor: const Color(0xFFF9FBF9),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeroBanner(l10n),
                  const SizedBox(height: 32),
                  _buildSectionLabel('PRIMARY SUPPORT'),
                  _buildSupportTile(
                    icon: Icons.smart_toy_rounded,
                    title: l10n.aiChatSupport,
                    subtitle: l10n.aiChatSupportSubtitle,
                    color: AppColors.primaryGreen,
                    onTap: () => context.push('/chat'),
                  ),
                  _buildSupportTile(
                    icon: Icons.call_rounded,
                    title: l10n.callExpert,
                    subtitle: '+91 1551-286-001 • Kisan Call Centre',
                    color: Colors.blue,
                    onTap: () => _showCallDialog(context),
                  ),
                  const SizedBox(height: 24),
                  _buildSectionLabel('RESOURCES'),
                  _buildSupportTile(
                    icon: Icons.help_outline_rounded,
                    title: l10n.faqs,
                    subtitle: l10n.faqsSubtitle,
                    color: Colors.orange,
                    onTap: () => _showFAQs(context),
                  ),
                  _buildSupportTile(
                    icon: Icons.menu_book_rounded,
                    title: l10n.userGuide,
                    subtitle: l10n.userGuideSubtitle,
                    color: Colors.purple,
                    onTap: () {},
                  ),
                  _buildSupportTile(
                    icon: Icons.bug_report_rounded,
                    title: l10n.reportIssue,
                    subtitle: l10n.reportIssueSubtitle,
                    color: Colors.redAccent,
                    onTap: () {},
                  ),
                  const SizedBox(height: 40),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          l10n.supportHours,
                          style: TextStyle(color: Colors.grey.shade500, fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.supportLanguages,
                          style: TextStyle(color: Colors.grey.shade400, fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w800,
          color: Colors.grey,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildHeroBanner(AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withValues(alpha: 0.2),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(16)),
            child: const Icon(Icons.support_agent_rounded, color: Colors.white, size: 32),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.howCanWeHelp,
            style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900, letterSpacing: -0.5),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.chooseSupportOption,
            style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildSupportTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
                  child: Icon(icon, color: color, size: 24),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87)),
                      const SizedBox(height: 4),
                      Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.3)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: Colors.grey.shade300),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showCallDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        title: Text(l10n.callExpert, style: const TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('National Kisan Call Centre', style: TextStyle(fontWeight: FontWeight.w900, color: AppColors.primaryGreen, fontSize: 16)),
            const SizedBox(height: 16),
            const Row(children: [Icon(Icons.phone_rounded, size: 16), SizedBox(width: 8), Text('+91 1551-286-001', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))]),
            const SizedBox(height: 8),
            Row(children: [const Icon(Icons.access_time_rounded, size: 16), const SizedBox(width: 8), Expanded(child: Text(l10n.supportHours, style: const TextStyle(fontSize: 13)))]),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('CANCEL')),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen, foregroundColor: Colors.white, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: const Text('CALL NOW'),
          ),
        ],
      ),
    );
  }

  void _showFAQs(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.95,
        minChildSize: 0.5,
        builder: (_, ctrl) => Container(
          decoration: const BoxDecoration(color: Color(0xFFF9FBF9), borderRadius: BorderRadius.vertical(top: Radius.circular(32))),
          child: Column(
            children: [
              Container(margin: const EdgeInsets.symmetric(vertical: 16), width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(2))),
              Text(l10n.faqs.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.5, fontSize: 14)),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  controller: ctrl,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                  children: [
                    _FAQItem(l10n.faq1Q, l10n.faq1A),
                    _FAQItem(l10n.faq2Q, l10n.faq2A),
                    _FAQItem(l10n.faq3Q, l10n.faq3A),
                    _FAQItem(l10n.faq4Q, l10n.faq4A),
                    _FAQItem(l10n.faq5Q, l10n.faq5A),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FAQItem extends StatelessWidget {
  final String q, a;
  const _FAQItem(this.q, this.a);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: ExpansionTile(
        title: Text(q, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.black87)),
        shape: const RoundedRectangleBorder(side: BorderSide.none),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        expandedAlignment: Alignment.topLeft,
        children: [Text(a, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, height: 1.5))],
      ),
    );
  }
}
