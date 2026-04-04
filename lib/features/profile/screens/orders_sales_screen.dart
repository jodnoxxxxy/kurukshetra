import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/core/theme/app_text_styles.dart';
import 'package:kurukshetra/core/widgets/app_card.dart';
import 'package:kurukshetra/core/widgets/status_badge.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';

class OrdersSalesScreen extends ConsumerWidget {
  const OrdersSalesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFFF9FBF9),
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            _buildSliverAppBar(l10n),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: _buildSummarySection(l10n),
              ),
            ),
            const SliverPersistentHeader(
              pinned: true,
              delegate: _TabBarDelegate(),
            ),
            SliverFillRemaining(
              child: TabBarView(
                children: [
                  _buildOrderList(context, 'pending', l10n),
                  _buildOrderList(context, 'completed', l10n),
                  _buildOrderList(context, 'returns', l10n),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSliverAppBar(AppLocalizations l10n) {
    return SliverAppBar(
      expandedHeight: 0,
      floating: true,
      pinned: true,
      elevation: 0,
       backgroundColor: const Color(0xFFF9FBF9),
      centerTitle: true,
      title: Text(
        'Orders & Sales',
        style: AppTextStyles.h2.copyWith(fontSize: 18),
      ),
      leading: const BackButton(color: Colors.black87),
    );
  }

  Widget _buildSummarySection(AppLocalizations l10n) {
    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard('Earnings', '₹4.2L', Icons.trending_up_rounded, Colors.blue),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildSummaryCard('Active', '12', Icons.shopping_bag_rounded, AppColors.primaryGreen),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String label, String value, IconData icon, Color color) {
    return AppCard(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 16),
          Text(value, style: AppTextStyles.h1.copyWith(fontSize: 22)),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: Colors.grey.shade500, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildOrderList(BuildContext context, String type, AppLocalizations l10n) {
    final List<Map<String, dynamic>> orders = _getMockOrders(type);

    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inventory_2_outlined, size: 64, color: Colors.grey.shade200),
            const SizedBox(height: 16),
            Text('No activity here yet', style: AppTextStyles.bodyBold.copyWith(color: Colors.grey.shade400)),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 100),
      itemCount: orders.length,
      separatorBuilder: (ctx, i) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order, l10n);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, AppLocalizations l10n) {
    return AppCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('ORDER ${order['id']}', style: AppTextStyles.labelCaps),
                  const SizedBox(height: 4),
                  Text(order['date'], style: AppTextStyles.bodySmall.copyWith(color: Colors.grey.shade500)),
                ],
              ),
              _buildModernStatusBadge(order['status']),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Divider(height: 1),
          ),
          Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(child: Text(order['icon'], style: const TextStyle(fontSize: 28))),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order['product'], style: AppTextStyles.bodyBold),
                    const SizedBox(height: 4),
                    Text('${order['quantity']} kg', style: AppTextStyles.bodySmall.copyWith(color: Colors.grey.shade500)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text('₹${order['price']}', style: AppTextStyles.h3.copyWith(color: AppColors.primaryGreen)),
                  const SizedBox(height: 4),
                  Text(order['paymentStatus'], style: AppTextStyles.badgeText.copyWith(color: Colors.blue, fontWeight: FontWeight.w800)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      side: BorderSide(color: Colors.grey.shade200),
                    ),
                    child: Text('Track', style: AppTextStyles.bodyBold.copyWith(fontSize: 13)),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF263238),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text('Details', style: AppTextStyles.bodyBold.copyWith(fontSize: 13, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildModernStatusBadge(String status) {
    StatusType type;
    switch (status.toLowerCase()) {
      case 'pending':
        type = StatusType.warning;
        break;
      case 'shipped':
        type = StatusType.info;
        break;
      case 'delivered':
        type = StatusType.success;
        break;
      case 'returned':
        type = StatusType.error;
        break;
      default:
        type = StatusType.neutral;
    }
    return StatusBadge(label: status.toUpperCase(), statusType: type);
  }

  List<Map<String, dynamic>> _getMockOrders(String type) {
    if (type == 'pending') {
      return [
        {
          'id': '#K-9832',
          'date': 'Mar 18, 2026',
          'status': 'Pending',
          'product': 'Organic Wheat (Sharbati)',
          'quantity': '200',
          'price': '8,500',
          'paymentStatus': 'Paid',
          'icon': '🌾',
        },
        {
          'id': '#K-9835',
          'date': 'Mar 17, 2026',
          'status': 'Shipped',
          'product': 'Fresh Tomatoes',
          'quantity': '50',
          'price': '1,250',
          'paymentStatus': 'COD',
          'icon': '🍅',
        },
      ];
    } else if (type == 'completed') {
      return [
        {
          'id': '#K-9812',
          'date': 'Mar 10, 2026',
          'status': 'Delivered',
          'product': 'Basmati Rice',
          'quantity': '100',
          'price': '12,000',
          'paymentStatus': 'Paid',
          'icon': '🌾',
        },
      ];
    } else {
      return [
        {
          'id': '#K-9745',
          'date': 'Feb 20, 2026',
          'status': 'Returned',
          'product': 'Onions',
          'quantity': '40',
          'price': '800',
          'paymentStatus': 'Refunded',
          'icon': '🧅',
        },
      ];
    }
  }
}

class _TabBarDelegate extends SliverPersistentHeaderDelegate {
  const _TabBarDelegate();

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: const Color(0xFFF9FBF9),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
        ),
        child: TabBar(
          indicator: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: AppColors.primaryGreen,
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.grey.shade500,
          labelStyle: AppTextStyles.bodyBold.copyWith(fontSize: 13),
          tabs: const [
            Tab(text: 'Pending'),
            Tab(text: 'History'),
            Tab(text: 'Returns'),
          ],
        ),
      ),
    );
  }

  @override
  double get maxExtent => 72;
  @override
  double get minExtent => 72;
  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) => false;
}
