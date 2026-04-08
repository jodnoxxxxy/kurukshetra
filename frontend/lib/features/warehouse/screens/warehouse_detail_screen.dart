import 'package:flutter/material.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/features/warehouse/models/warehouse_model.dart';
import 'package:kurukshetra/features/warehouse/screens/booking_screen.dart';

class WarehouseDetailScreen extends StatefulWidget {
  final Warehouse warehouse;

  const WarehouseDetailScreen({super.key, required this.warehouse});

  @override
  State<WarehouseDetailScreen> createState() => _WarehouseDetailScreenState();
}

class _WarehouseDetailScreenState extends State<WarehouseDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // App Bar with Image
          SliverAppBar(
            expandedHeight: 250,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    widget.warehouse.images.isNotEmpty 
                        ? widget.warehouse.images.first
                        : 'https://images.unsplash.com/photo-1589927986089-35812388d1b4?q=80&w=1470&auto=format&fit=crop',
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.favorite_border),
                onPressed: () {},
              ),
            ],
          ),
          
          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Status
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          widget.warehouse.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: widget.warehouse.isAvailable 
                              ? Colors.green.shade100 
                              : Colors.red.shade100,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          widget.warehouse.isAvailable ? 'Available' : 'Full',
                          style: TextStyle(
                            color: widget.warehouse.isAvailable 
                                ? Colors.green.shade800 
                                : Colors.red.shade800,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.grey.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          widget.warehouse.address,
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Key Information Cards
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.inventory_2,
                          title: 'Capacity',
                          value: '${widget.warehouse.capacity.toInt()} tons',
                          color: Colors.blue.shade700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.ac_unit,
                          title: 'Storage Type',
                          value: _getStorageTypeText(widget.warehouse.storageType),
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 16),
                  
                  Row(
                    children: [
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.thermostat,
                          title: 'Temperature',
                          value: '${widget.warehouse.temperature.toInt()}°C',
                          color: Colors.orange.shade700,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInfoCard(
                          icon: Icons.water_drop,
                          title: 'Humidity',
                          value: '${widget.warehouse.humidity.toInt()}%',
                          color: Colors.cyan.shade700,
                        ),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Occupancy Section
                  _buildOccupancySection(),
                  
                  const SizedBox(height: 24),
                  
                  // Available Products
                  _buildAvailableProductsSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Contact Information
                  _buildContactSection(),
                  
                  const SizedBox(height: 24),
                  
                  // Price Information
                  _buildPriceSection(),
                  
                  const SizedBox(height: 32),
                  
                  // Book Now Button
                  if (widget.warehouse.isAvailable)
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => BookingScreen(warehouse: widget.warehouse),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Book Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOccupancySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Current Occupancy',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Occupied Space',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  Text(
                    '${widget.warehouse.currentOccupancy.toInt()} / ${widget.warehouse.capacity.toInt()} tons',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: widget.warehouse.occupancyPercentage / 100,
                backgroundColor: Colors.grey.shade300,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.warehouse.occupancyPercentage > 80
                      ? Colors.red
                      : widget.warehouse.occupancyPercentage > 60
                          ? Colors.orange
                          : Colors.green,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${widget.warehouse.occupancyPercentage.toInt()}% occupied',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAvailableProductsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Products',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.warehouse.availableProducts.map((product) {
            return Chip(
              label: Text(product),
              backgroundColor: AppColors.primaryGreen.withValues(alpha: 0.1),
              labelStyle: TextStyle(
                color: AppColors.primaryGreen,
                fontSize: 12,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildContactSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Contact Information',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Icon(Icons.person, color: Colors.grey.shade600),
                  const SizedBox(width: 12),
                  Text(
                    widget.warehouse.contactPerson,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.phone, color: Colors.grey.shade600),
                  const SizedBox(width: 12),
                  Text(
                    widget.warehouse.contactPhone,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Pricing',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryGreen.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primaryGreen.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Storage Cost',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '₹${widget.warehouse.pricePerTonPerDay.toInt()}/ton/day',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _getStorageTypeText(StorageType type) {
    switch (type) {
      case StorageType.cold:
        return 'Cold Storage';
      case StorageType.dry:
        return 'Dry Storage';
      case StorageType.refrigerated:
        return 'Refrigerated';
      case StorageType.ventilated:
        return 'Ventilated';
    }
  }
}
