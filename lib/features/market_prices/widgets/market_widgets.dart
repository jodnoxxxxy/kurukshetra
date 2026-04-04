import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import '../models/market_price_model.dart';
import 'package:intl/intl.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';
import 'package:kurukshetra/core/utils/l10n_utils.dart';

class MarketCropCard extends StatelessWidget {
  final MarketCrop crop;
  final VoidCallback onTap;

  const MarketCropCard({super.key, required this.crop, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 15, offset: const Offset(0, 8))],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: AppColors.primaryGreen.withValues(alpha: 0.05), shape: BoxShape.circle),
                  child: Text(crop.iconStr, style: const TextStyle(fontSize: 32)),
                ),
                const SizedBox(height: 8),
                Text(L10nUtils.translateCrop(context, crop.name), maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(L10nUtils.translateCategory(context, crop.category).toUpperCase(), maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.grey.shade400, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MarketPriceRow extends StatelessWidget {
  final MarketPriceData priceData;
  final bool isHighestPrice;
  final VoidCallback onTap;

  const MarketPriceRow({
    super.key,
    required this.priceData,
    this.isHighestPrice = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
        border: isHighestPrice ? Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.2), width: 1.5) : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(priceData.marketName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: Colors.black87)),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.location_on_rounded, size: 14, color: Colors.grey.shade400),
                              const SizedBox(width: 4),
                              Text(l10n.kmAway(priceData.distanceKm.toString()), style: TextStyle(fontSize: 12, color: Colors.grey.shade500, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (isHighestPrice)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(color: AppColors.primaryGreen, borderRadius: BorderRadius.circular(10)),
                        child: Text(l10n.topPrice.toUpperCase(), style: const TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.w900, letterSpacing: 1)),
                      ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _priceCol(l10n.minLabel, priceData.minPrice, Colors.grey.shade600),
                    _priceCol(l10n.maxLabel, priceData.maxPrice, Colors.grey.shade600),
                    _priceCol(l10n.modalLabel, priceData.modalPrice, isHighestPrice ? AppColors.primaryGreen : Colors.black87, isMain: true),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _priceCol(String label, int price, Color color, {bool isMain = false}) {
    return Column(
      children: [
        Text(label.toUpperCase(), style: TextStyle(fontSize: 9, color: Colors.grey.shade400, fontWeight: FontWeight.w900, letterSpacing: 1)),
        const SizedBox(height: 4),
        Text('₹$price', style: TextStyle(fontSize: isMain ? 18 : 14, fontWeight: FontWeight.w900, color: color)),
      ],
    );
  }
}

class PriceTrendChart extends StatelessWidget {
  final List<PriceTrendData> data;

  const PriceTrendChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) return const SizedBox.shrink();

    double minP = data.first.price.toDouble();
    double maxP = data.first.price.toDouble();
    List<FlSpot> spots = [];

    for (int i = 0; i < data.length; i++) {
        double p = data[i].price.toDouble();
        if (p < minP) minP = p;
        if (p > maxP) maxP = p;
        spots.add(FlSpot(i.toDouble(), p));
    }

    return Container(
      height: 280,
      padding: const EdgeInsets.fromLTRB(16, 32, 24, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15)],
      ),
      child: LineChart(
        LineChartData(
          minY: minP - 200,
          maxY: maxP + 200,
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 45, getTitlesWidget: (v, _) => Text('₹${v.toInt()}', style: TextStyle(color: Colors.grey.shade400, fontSize: 9, fontWeight: FontWeight.bold)))),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (v, _) {
                        if (v.toInt() >= 0 && v.toInt() < data.length && v.toInt() % 2 == 0) {
                             return Padding(
                               padding: const EdgeInsets.only(top: 10),
                               child: Text(DateFormat('dd MMM').format(data[v.toInt()].date), style: TextStyle(color: Colors.grey.shade400, fontSize: 9, fontWeight: FontWeight.bold)),
                             );
                        }
                        return const Text('');
                    }
                )
            ),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.primaryGreen,
              barWidth: 4,
              isStrokeCapRound: true,
              dotData: FlDotData(show: true, getDotPainter: (_, __, ___, ____) => FlDotCirclePainter(radius: 4, color: Colors.white, strokeWidth: 3, strokeColor: AppColors.primaryGreen)),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(colors: [AppColors.primaryGreen.withValues(alpha: 0.2), AppColors.primaryGreen.withValues(alpha: 0.0)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
            )
          ],
        )
      ),
    );
  }
}
