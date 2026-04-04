import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:intl/intl.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';
import '../../../consumer_auth/providers/consumer_auth_provider.dart';

class OrderTrackingScreen extends ConsumerStatefulWidget {
  final bool isEmbedded;
  const OrderTrackingScreen({super.key, this.isEmbedded = false});

  @override
  ConsumerState<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends ConsumerState<OrderTrackingScreen> {
  @override
  void initState() {
    super.initState();
    // Load orders immediately when viewing the screen
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activeOrdersProvider.notifier).loadOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final consumer = ref.watch(consumerAuthProvider);
    final orders = ref.watch(activeOrdersProvider);

    if (consumer == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('My Orders')),
        body: const Center(
          child: Text('Please login to view your orders', style: TextStyle(fontSize: 18, color: Colors.grey)),
        ),
      );
    }

    if (orders.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold)),
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.receipt_long, size: 80, color: Colors.grey.shade300),
              const SizedBox(height: 16),
              const Text('No Active Orders', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              const Text('Your fresh farm orders will appear here.', style: TextStyle(color: Colors.grey)),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.all(16.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final groupTitle = index == 0 ? 'Active Tracking' : (index == 1 && orders.length > 1 ? 'Past Orders' : null);
                  final order = orders[index];
                  
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (groupTitle != null) ...[
                        Text(groupTitle, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                        const SizedBox(height: 16),
                      ],
                      _buildLiveOrderCard(context, order),
                      const SizedBox(height: 24),
                    ],
                  );
                },
                childCount: orders.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLiveOrderCard(BuildContext context, OrderModel order) {
    final DateFormat formatter = DateFormat('MMM d, yyyy - hh:mm a');
    final String dateString = formatter.format(order.orderDate);
    final String itemsSummary = order.items.map((e) => '${e.product.name} (${e.quantity})').join(', ');

    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: BorderSide(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.id, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                    const SizedBox(height: 4),
                    Text(dateString, style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w500)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.sync, color: Colors.orange, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        order.formattedStatus,
                        style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          const Divider(height: 1),
          
          // Body Details
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(itemsSummary, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, height: 1.4)),
                const SizedBox(height: 12),
                
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                      child: const Icon(Icons.landscape, size: 16, color: AppColors.primaryGreen),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Sourced From', style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w600)),
                          Text(order.farmerName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ],
                      ),
                    ),
                    Text(
                      '₹${order.totalAmount.toStringAsFixed(1)}',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18, color: AppColors.primaryGreen),
                    ),
                  ],
                ),
                
                const SizedBox(height: 24),
                
                // Live Tracking Stepper
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      _buildTrackingStep(Icons.check_circle, 'Order Placed', 'Awaiting farmer confirmation', isCompleted: true, isCurrent: order.status == OrderStatus.pending),
                      _buildTrackingStep(Icons.inventory, 'Confirmed by Farmer', 'Packing fresh harvest', isCompleted: order.status.index >= OrderStatus.confirmed.index, isCurrent: order.status == OrderStatus.confirmed),
                      _buildTrackingStep(Icons.local_shipping, 'Out for Delivery', 'En route to your location', isCompleted: order.status.index >= OrderStatus.outForDelivery.index, isCurrent: order.status == OrderStatus.outForDelivery),
                      _buildTrackingStep(Icons.home, 'Delivered', 'Enjoy your organic meal', isCompleted: order.status == OrderStatus.delivered, isCurrent: order.status == OrderStatus.delivered, isLast: true),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.chat, size: 18),
                        label: const Text('Chat', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryGreen,
                          side: const BorderSide(color: AppColors.primaryGreen),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.call, size: 18),
                        label: const Text('Call Farm', style: TextStyle(fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingStep(IconData icon, String title, String subtitle, {bool isCompleted = false, bool isCurrent = false, bool isLast = false}) {
    final color = isCompleted || isCurrent ? AppColors.primaryGreen : Colors.grey.shade300;
    
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: isCurrent ? AppColors.primaryGreen.withValues(alpha: 0.1) : Colors.transparent,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 24,
                color: isCompleted ? AppColors.primaryGreen : Colors.grey.shade200,
                margin: const EdgeInsets.symmetric(vertical: 4),
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w600,
                  color: isCurrent || isCompleted ? Colors.black : Colors.grey.shade500,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
              if (!isLast) const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}
