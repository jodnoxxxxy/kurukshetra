import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartNotifier = ref.read(cartProvider.notifier);

    if (cartItems.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Your Cart', style: TextStyle(fontWeight: FontWeight.bold)),
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart_outlined, size: 80, color: Colors.grey),
              const SizedBox(height: 16),
              const Text('Your cart is empty', style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go('/marketplace'),
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen, foregroundColor: Colors.white),
                child: const Text('Browse Products'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Your Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep, color: AppColors.errorRed),
            tooltip: 'Clear Cart',
            onPressed: () {
              cartNotifier.clearCart();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: cartItems.length,
              separatorBuilder: (context, index) => const Divider(height: 24),
              itemBuilder: (context, index) {
                final item = cartItems[index];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Image Box
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: Text(item.product.imageUrl, style: const TextStyle(fontSize: 40)),
                      ),
                    ),
                    const SizedBox(width: 16),
                    
                    // Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.product.name,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '₹${item.product.pricePerUnit} / ${item.product.unit}',
                            style: TextStyle(color: Colors.grey.shade600, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 12),
                          
                          // Qty Selector
                          Row(
                            children: [
                              _buildQtyBtn(Icons.remove, () {
                                cartNotifier.updateQuantity(item.product.id, item.quantity - 1);
                              }),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                child: Text('${item.quantity}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              ),
                              _buildQtyBtn(Icons.add, () {
                                cartNotifier.updateQuantity(item.product.id, item.quantity + 1);
                              }),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Price and Delete
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${item.totalPrice.toStringAsFixed(1)}',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: AppColors.primaryGreen),
                        ),
                        const SizedBox(height: 16),
                        IconButton(
                          icon: const Icon(Icons.delete, color: AppColors.errorRed, size: 24),
                          onPressed: () {
                            cartNotifier.removeFromCart(item.product.id);
                          },
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
          
          // Order Summary & Checkout Bottom Bar
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withValues(alpha: 0.2),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
              borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSummaryRow('Subtotal', '₹${cartNotifier.subtotal.toStringAsFixed(1)}'),
                  const SizedBox(height: 8),
                  _buildSummaryRow('Delivery Fee (Distance Based)', '₹${cartNotifier.deliveryFee.toStringAsFixed(1)}'),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(),
                  ),
                  _buildSummaryRow('Total', '₹${cartNotifier.total.toStringAsFixed(1)}', isTotal: true),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => context.push('/checkout', extra: cartNotifier.total),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: const Text('Proceed to Secure Checkout', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16),
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: isTotal ? 18 : 15,
            fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
            color: isTotal ? Colors.black : Colors.grey.shade600,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isTotal ? 22 : 16,
            fontWeight: FontWeight.w900,
            color: isTotal ? AppColors.primaryGreen : Colors.black,
          ),
        ),
      ],
    );
  }
}
