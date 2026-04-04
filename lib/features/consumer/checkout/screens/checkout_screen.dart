import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../../consumer_auth/providers/consumer_auth_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  final double totalAmount;
  
  const CheckoutScreen({super.key, required this.totalAmount});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  String _selectedPaymentMethod = 'upi';
  bool _isProcessing = false;

  @override
  Widget build(BuildContext context) {
    // Basic auth check
    final consumer = ref.watch(consumerAuthProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Secure Checkout', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Amount Summary
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [AppColors.primaryGreen, Colors.green.shade700]),
                boxShadow: [
                  BoxShadow(color: AppColors.primaryGreen.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))
                ],
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Text('Total Amount to Pay', style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text(
                    '₹${widget.totalAmount.toStringAsFixed(1)}',
                    style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 32),

            if (consumer != null) ...[
              const Text('Delivery Address', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on, color: AppColors.primaryGreen, size: 28),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(consumer.fullName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 4),
                          Text('${consumer.address}, ${consumer.city} - ${consumer.pincode}', style: TextStyle(color: Colors.grey.shade700)),
                          const SizedBox(height: 4),
                          Text(consumer.phone, style: TextStyle(color: Colors.grey.shade700, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red),
                    const SizedBox(width: 12),
                    Expanded(child: Text('You must be logged in to place an order.', style: TextStyle(color: Colors.red.shade800, fontWeight: FontWeight.bold))),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],

            const Text('Payment Method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            // Payment Options
            _buildPaymentOption(
              'upi',
              'UPI (GPay, PhonePe, Paytm)',
              Icons.qr_code_scanner,
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              'card',
              'Credit / Debit Card',
              Icons.credit_card,
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              'netbanking',
              'Net Banking',
              Icons.account_balance,
            ),
            const SizedBox(height: 12),
            _buildPaymentOption(
              'cod',
              'Cash on Delivery',
              Icons.money,
            ),

            const SizedBox(height: 64),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: (consumer == null || _isProcessing) ? null : _processPayment,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                backgroundColor: AppColors.primaryGreen,
                foregroundColor: Colors.white,
                elevation: 0,
              ),
              child: _isProcessing 
                  ? const SizedBox(width: 24, height: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const Text('Confirm Order & Pay', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String value, String title, IconData icon) {
    final isSelected = _selectedPaymentMethod == value;
    
    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = value),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.grey.shade200,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
          color: isSelected ? Colors.green.shade50 : Colors.white,
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primaryGreen : Colors.grey.shade600),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? AppColors.primaryGreen : Colors.black87,
                ),
              ),
            ),
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primaryGreen),
          ],
        ),
      ),
    );
  }

  void _processPayment() async {
    final items = ref.read(cartProvider);
    final consumer = ref.read(consumerAuthProvider);
    if (items.isEmpty || consumer == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Cart is empty or not logged in')));
      return;
    }

    setState(() => _isProcessing = true);

    try {
      final orderNotifier = ref.read(activeOrdersProvider.notifier);
      final cartNotifier = ref.read(cartProvider.notifier);
      
      final fullAddress = '${consumer.address}, ${consumer.city} - ${consumer.pincode}';

      await orderNotifier.placeOrder(
        items: items,
        totalAmount: widget.totalAmount,
        deliveryFee: cartNotifier.deliveryFee,
        deliveryAddress: fullAddress,
      );

      // Successfully placed, clear cart
      cartNotifier.clearCart();

      if (mounted) {
        setState(() => _isProcessing = false);
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isProcessing = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Order failed: $e')));
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
              child: const Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 80),
            ),
            const SizedBox(height: 24),
            const Text(
              'Order Confirmed!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: AppColors.primaryGreen),
            ),
            const SizedBox(height: 12),
            Text(
              'Your direct-to-farm organic order has been placed. The farmer is preparing your fresh harvest.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14, height: 1.5),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
                onPressed: () {
                  Navigator.pop(context); // Close dialog
                  context.go('/orders'); // Go to orders tracking
                },
                child: const Text('Track Order Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
