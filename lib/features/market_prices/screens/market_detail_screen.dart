import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import '../providers/market_price_provider.dart';
import 'package:intl/intl.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import 'package:kurukshetra/core/utils/l10n_utils.dart';

class MarketDetailScreen extends ConsumerWidget {
  const MarketDetailScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final crop = ref.watch(marketSelectedCropProvider);
    final market = ref.watch(selectedMarketPriceProvider);

    if (crop == null || market == null) {
      return Scaffold(
        backgroundColor: const Color(0xFFF9FBF9),
        appBar: AppBar(title: Text(l10n.marketDetailsTitle), backgroundColor: const Color(0xFFF9FBF9), elevation: 0),
        body: Center(child: Text(l10n.noDetailsFound)),
      );
    }

    final currencyFmt = NumberFormat.currency(locale: Localizations.localeOf(context).toString(), symbol: '₹', decimalDigits: 0);
    final translatedCropName = L10nUtils.translateCrop(context, crop.name);

    return Scaffold(
      backgroundColor: const Color(0xFFF9FBF9),
      appBar: AppBar(
        title: Text(market.marketName, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
        backgroundColor: const Color(0xFFF9FBF9),
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPriceHeroCard(context, translatedCropName, market, currencyFmt, l10n),
                  const SizedBox(height: 32),
                  _buildSectionLabel('MARKET LOGISTICS'),
                  _buildInfoTile(Icons.location_on_rounded, l10n.marketAddress, market.address, Colors.orange),
                  const SizedBox(height: 16),
                  _buildInfoTile(Icons.directions_car_rounded, l10n.distanceFromYou, l10n.distanceKmText(market.distanceKm.toString(), '45'), Colors.blue),
                  const SizedBox(height: 16),
                  _buildInfoTile(Icons.update_rounded, l10n.lastUpdated, DateFormat('dd MMM yyyy, hh:mm a').format(market.lastUpdated), Colors.grey),
                  const SizedBox(height: 48),
                  SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton.icon(
                      onPressed: () => context.push('/market-prices/trends'),
                      icon: const Icon(Icons.analytics_rounded),
                      label: Text(l10n.view7DayPriceTrend.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1, fontSize: 13)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: AppColors.primaryGreen.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
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
      padding: const EdgeInsets.only(left: 4, bottom: 16),
      child: Text(text.toUpperCase(), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: Colors.grey, letterSpacing: 1.5)),
    );
  }

  Widget _buildPriceHeroCard(BuildContext context, String cropName, dynamic market, NumberFormat currencyFmt, AppLocalizations l10n) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1B5E20), Color(0xFF2E7D32)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.green.withValues(alpha: 0.2), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Text(cropName.toUpperCase(), style: TextStyle(color: Colors.white.withValues(alpha: 0.6), fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 2)),
          const SizedBox(height: 12),
          Text(currencyFmt.format(market.modalPrice), style: const TextStyle(color: Colors.white, fontSize: 48, fontWeight: FontWeight.w900, letterSpacing: -1)),
          Text(l10n.modalPricePerQuintal, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 12, fontWeight: FontWeight.bold)),
          const SizedBox(height: 32),
          Container(height: 1, color: Colors.white12),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _heroStat(l10n.minPrice, currencyFmt.format(market.minPrice)),
              Container(width: 1, height: 30, color: Colors.white12),
              _heroStat(l10n.maxPrice, currencyFmt.format(market.maxPrice)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroStat(String label, String value) {
    return Column(
      children: [
        Text(label.toUpperCase(), style: TextStyle(color: Colors.white.withValues(alpha: 0.5), fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(24), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10)]),
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
                Text(title.toUpperCase(), style: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w900, fontSize: 9, letterSpacing: 1)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: Colors.black87, height: 1.3)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
