import 'package:flutter/material.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/features/warehouse/providers/warehouse_provider.dart';
import 'package:kurukshetra/features/warehouse/models/warehouse_model.dart';
import 'package:kurukshetra/features/warehouse/screens/warehouse_detail_screen.dart';

class WarehouseListScreen extends ConsumerStatefulWidget {
  const WarehouseListScreen({super.key});

  @override
  ConsumerState<WarehouseListScreen> createState() => _WarehouseListScreenState();
}

class _WarehouseListScreenState extends ConsumerState<WarehouseListScreen> {
  StorageType? _selectedStorageType;
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final warehouseState = ref.watch(warehouseProvider);
    
    List<Warehouse> filteredWarehouses = warehouseState.warehouses;
    
    if (_selectedStorageType != null) {
      filteredWarehouses = filteredWarehouses
          .where((w) => w.storageType == _selectedStorageType)
          .toList();
    }
    
    if (_searchController.text.isNotEmpty) {
      filteredWarehouses = filteredWarehouses
          .where((w) => w.name.toLowerCase().contains(_searchController.text.toLowerCase()) ||
                      w.location.toLowerCase().contains(_searchController.text.toLowerCase()))
          .toList();
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Warehouses'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search warehouses by name or location...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              onChanged: (value) => setState(() {}),
            ),
          ),
          
          // Storage Type Filter Chips
          if (_selectedStorageType != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Chip(
                    label: Text(_getStorageTypeText(_selectedStorageType!)),
                    backgroundColor: AppColors.primaryGreen,
                    labelStyle: const TextStyle(color: Colors.white),
                    deleteIcon: const Icon(Icons.close, color: Colors.white),
                    onDeleted: () => setState(() => _selectedStorageType = null),
                  ),
                ],
              ),
            ),

          // Warehouse List
          Expanded(
            child: warehouseState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : filteredWarehouses.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: filteredWarehouses.length,
                        itemBuilder: (context, index) {
                          final warehouse = filteredWarehouses[index];
                          return _buildWarehouseCard(warehouse);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warehouse,
            size: 80,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'No warehouses found',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWarehouseCard(Warehouse warehouse) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      elevation: 2,
      child: InkWell(
        onTap: () {
          ref.read(warehouseProvider.notifier).selectWarehouse(warehouse);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => WarehouseDetailScreen(warehouse: warehouse),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          warehouse.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              size: 16,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              warehouse.location,
                              style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: warehouse.isAvailable 
                          ? Colors.green.shade100 
                          : Colors.red.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      warehouse.isAvailable ? 'Available' : 'Full',
                      style: TextStyle(
                        color: warehouse.isAvailable 
                            ? Colors.green.shade800 
                            : Colors.red.shade800,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Storage Type and Capacity
              Row(
                children: [
                  _buildInfoChip(
                    icon: Icons.ac_unit,
                    label: _getStorageTypeText(warehouse.storageType),
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 8),
                  _buildInfoChip(
                    icon: Icons.inventory_2,
                    label: '${warehouse.capacity.toInt()} tons',
                    color: Colors.blue.shade700,
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Occupancy Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Occupancy',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Text(
                        '${warehouse.currentOccupancy.toInt()} / ${warehouse.capacity.toInt()} tons',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: warehouse.occupancyPercentage / 100,
                    backgroundColor: Colors.grey.shade300,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      warehouse.occupancyPercentage > 80
                          ? Colors.red
                          : warehouse.occupancyPercentage > 60
                              ? Colors.orange
                              : Colors.green,
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Price and Contact
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '₹${warehouse.pricePerTonPerDay.toInt()}/ton/day',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  Text(
                    warehouse.contactPerson,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Storage Type'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: StorageType.values.map((type) {
            return InkWell(
              onTap: () {
                setState(() => _selectedStorageType = type);
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    // ignore: deprecated_member_use
                    Radio<StorageType>(
                      value: type, // ignore: deprecated_member_use
                      groupValue: _selectedStorageType, // ignore: deprecated_member_use
                      // ignore: deprecated_member_use
                      onChanged: (v) {
                        setState(() => _selectedStorageType = v);
                        Navigator.of(context).pop();
                      },
                    ),
                    Text(_getStorageTypeText(type)),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          if (_selectedStorageType != null)
            TextButton(
              onPressed: () {
                setState(() => _selectedStorageType = null);
                Navigator.of(context).pop();
              },
              child: const Text('Clear Filter'),
            ),
        ],
      ),
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
