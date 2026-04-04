import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/consumer_product.dart';
import '../../providers/cart_provider.dart';

class ProductDetailsScreen extends ConsumerStatefulWidget {
  final ConsumerProduct product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  ConsumerState<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends ConsumerState<ProductDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    final curProduct = widget.product;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(curProduct.isWeeklyBasket ? 'Weekly Basket' : 'Product Details', style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Product Image/Emoji
            Container(
              height: 250,
              color: curProduct.isWeeklyBasket ? Colors.orange.shade50 : Colors.green.shade50,
              child: Stack(
                children: [
                   Center(
                    child: Text(
                      curProduct.imageUrl,
                      style: const TextStyle(fontSize: 100),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    right: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primaryGreen, width: 2),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.verified_user, color: AppColors.primaryGreen, size: 20),
                          const SizedBox(width: 8),
                          Text(
                            '${curProduct.organicScore}% Trust Score',
                            style: const TextStyle(color: AppColors.primaryGreen, fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          curProduct.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        '₹${curProduct.pricePerUnit}/${curProduct.unit}',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  
                  // Tags Row
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (curProduct.isWeeklyBasket)
                        _buildTag(Icons.local_shipping, 'Direct Subscription', Colors.purple)
                      else
                        _buildTag(Icons.category, curProduct.category, Colors.orange),
                        
                      _buildTag(Icons.location_on, '${curProduct.distance} km away', Colors.teal),
                      
                      _buildTag(
                        Icons.timer, 
                        '${curProduct.harvestDate} (${curProduct.freshnessScore}% Fresh)', 
                        curProduct.freshnessScore > 90 ? Colors.green : Colors.blue
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Smart Price Comparison Panel
                  if (!curProduct.isWeeklyBasket)
                     _buildSmartPricingPanel(),
                  
                  const Divider(height: 32),

                  // Transparency & Organics Panel
                  const Text('Organic Traceability & Trust', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 4),
                  const Text('We pull this data transparently from the farmer\'s records.', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  const SizedBox(height: 16),
                  
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _buildDetailRow(Icons.grass, 'Soil Health', curProduct.soilHealth),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider()),
                        _buildDetailRow(Icons.compost, 'Fertilizer Used', curProduct.organicFertilizer),
                        const Padding(padding: EdgeInsets.symmetric(vertical: 8), child: Divider()),
                        _buildDetailRow(Icons.pest_control, 'Chemical Pesticides', curProduct.chemicalPesticides),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Farmer Profile Section
                  const Text('Farmer Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  InkWell(
                    onTap: () {
                      context.push('/farmer-profile', extra: curProduct);
                    },
                    child: Row(
                      children: [
                        const CircleAvatar(
                          radius: 28,
                          backgroundColor: AppColors.primaryGreen,
                          child: Icon(Icons.person, color: Colors.white, size: 32),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(curProduct.farmerName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.location_on, size: 14, color: AppColors.textSecondary),
                                  const SizedBox(width: 4),
                                  Text(curProduct.farmLocation, style: const TextStyle(color: AppColors.textSecondary)),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text('View Profile →', style: TextStyle(color: AppColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),

                  // Description
                  const Text('About the Produce', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 8),
                  Text(
                    curProduct.description,
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade800, height: 1.5),
                  ),
                  
                  // Nutritional & Recipes
                  if (curProduct.nutritionalBenefits.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text('Nutritional Benefits', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...curProduct.nutritionalBenefits.map((b) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle, color: AppColors.primaryGreen, size: 16),
                          const SizedBox(width: 8),
                          Expanded(child: Text(b, style: TextStyle(color: Colors.grey.shade800))),
                        ],
                      ),
                    )),
                  ],

                  if (curProduct.recipeSuggestions.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    const Text('Top Recipe Suggestions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    ...curProduct.recipeSuggestions.map((r) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.orange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange.shade200)
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.restaurant_menu, color: Colors.orange),
                            const SizedBox(width: 12),
                            Text(r, style: const TextStyle(fontWeight: FontWeight.bold)),
                          ]
                        )
                      )
                    )),
                  ],

                  const SizedBox(height: 48), // Bottom padding for FAB
                ],
              ),
            ),
          ],
        ),
      ),

      // Bottom Add to Cart Bar
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, -5),
              ),
            ],
          ),
          child: Row(
            children: [
              // Quantity Selector
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (quantity > 1) setState(() => quantity--);
                      },
                    ),
                    Text('$quantity', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () => setState(() => quantity++),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              
              // Add to Cart Button
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    ref.read(cartProvider.notifier).addToCart(curProduct, quantity);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Added $quantity ${curProduct.unit} of ${curProduct.name} to cart.')),
                    );
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Add to Cart', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmartPricingPanel() {
    final curProduct = widget.product;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.shade100)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.insights, color: Colors.blue),
              SizedBox(width: 8),
              Text('Smart Price Transparency', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Market Avg Price', style: TextStyle(color: Colors.grey, fontSize: 12)),
                  Text('₹${curProduct.marketPrice}/${curProduct.unit}', style: const TextStyle(decoration: TextDecoration.lineThrough, color: Colors.grey, fontWeight: FontWeight.bold)),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('Direct Organic Price', style: TextStyle(color: Colors.blue, fontSize: 12, fontWeight: FontWeight.bold)),
                  Text('₹${curProduct.pricePerUnit}/${curProduct.unit}', style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.w900, fontSize: 18)),
                ],
              )
            ],
          ),
          const SizedBox(height: 8),
          Text(curProduct.pricingReason, style: TextStyle(fontSize: 12, color: Colors.blue.shade800)),
        ],
      ),
    );
  }

  Widget _buildTag(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String title, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.grey.shade700, size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey.shade600, fontSize: 13, fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
            ],
          ),
        ),
      ],
    );
  }
}
