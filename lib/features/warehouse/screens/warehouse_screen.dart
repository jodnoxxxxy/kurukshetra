import 'package:flutter/material.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';

class WarehouseScreen extends StatelessWidget {
  const WarehouseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final warehouses = [
      {'name': 'State Cold Storage', 'dist': '4.2 km', 'capacity': '75%', 'status': 'Open'},
      {'name': 'Kisan Godam', 'dist': '12.5 km', 'capacity': '90%', 'status': 'Full'},
      {'name': 'AgriLogistics Hub', 'dist': '18.1 km', 'capacity': '40%', 'status': 'Open'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Nearby Warehouses')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: warehouses.length,
        itemBuilder: (context, index) {
          final warehouse = warehouses[index];
          final isFull = warehouse['status'] == 'Full';
          
          return Card(
            elevation: 2,
            margin: const EdgeInsets.only(bottom: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        warehouse['name']!,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: isFull ? Colors.red.shade100 : Colors.green.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          warehouse['status']!,
                          style: TextStyle(
                            color: isFull ? Colors.red.shade800 : Colors.green.shade800,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.location_on, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text(warehouse['dist']!, style: const TextStyle(color: Colors.grey)),
                      const SizedBox(width: 24),
                      const Icon(Icons.inventory, size: 16, color: Colors.grey),
                      const SizedBox(width: 4),
                      Text('Filled: ${warehouse['capacity']}', style: const TextStyle(color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: isFull ? null : () {},
                      icon: const Icon(Icons.book_online),
                      label: const Text('Book Space'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryGreen,
                        side: const BorderSide(color: AppColors.primaryGreen),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
