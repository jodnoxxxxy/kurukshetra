import 'package:flutter/material.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/consumer_product.dart';
import '../providers/cart_provider.dart';

class ConsumerProductCard extends ConsumerWidget {
  final ConsumerProduct product;

  const ConsumerProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: () => context.push('/product-details', extra: product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Area
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    color: product.isWeeklyBasket ? Colors.orange.shade50 : Colors.green.shade50,
                    child: Center(
                      child: Text(
                        product.imageUrl,
                        style: const TextStyle(fontSize: 60),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.9),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.primaryGreen, width: 1),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.verified, color: AppColors.primaryGreen, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            '${product.organicScore}% Trust',
                            style: const TextStyle(color: AppColors.primaryGreen, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            
            // Details Area
            Expanded(
              flex: 5,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.isWeeklyBasket ? 'Subscription Basket' : 'Harvest: ${product.harvestDate}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 10),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      '₹${product.pricePerUnit}/${product.unit}',
                      style: const TextStyle(
                        color: AppColors.primaryGreen,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.landscape, size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            product.farmerName,
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.location_on, size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            '${product.distance} km away',
                            style: const TextStyle(fontSize: 11, color: AppColors.textSecondary),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      height: 32,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: AppColors.primaryGreen,
                          side: BorderSide(color: product.isWeeklyBasket ? Colors.orange : AppColors.primaryGreen),
                          padding: EdgeInsets.zero,
                          textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          elevation: 0,
                        ),
                        onPressed: () {
                          ref.read(cartProvider.notifier).addToCart(product, 1);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${product.name} added to cart'),
                              action: SnackBarAction(
                                label: 'VIEW CART',
                                onPressed: () => context.push('/cart'),
                              ),
                            ),
                          );
                        },
                        child: Text(product.isWeeklyBasket ? 'SUBSCRIBE' : 'ADD'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
