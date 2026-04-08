import 'package:flutter/material.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';

class DbtScreen extends StatelessWidget {
  const DbtScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final schemes = [
      {'name': 'PM-KISAN', 'amount': '₹2000', 'date': '15 Mar 2026', 'status': 'Credited', 'icon': Icons.currency_rupee},
      {'name': 'Fasal Bima Yojana', 'amount': '₹15,400', 'date': '02 Feb 2026', 'status': 'Processing', 'icon': Icons.shield},
      {'name': 'Fertilizer Subsidy', 'amount': '₹3,500', 'date': '14 Jan 2026', 'status': 'Credited', 'icon': Icons.science},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Direct Benefit Transfer (DBT)')),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: schemes.length,
        itemBuilder: (context, index) {
          final scheme = schemes[index];
          final isCredited = scheme['status'] == 'Credited';
          
          return Card(
            elevation: 1,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: isCredited ? Colors.green.shade50 : Colors.orange.shade50,
                radius: 24,
                child: Icon(
                  scheme['icon'] as IconData,
                  color: isCredited ? AppColors.primaryGreen : Colors.orange,
                  size: 24,
                ),
              ),
              title: Text(scheme['name'] as String, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    Icon(Icons.calendar_today, size: 14, color: Colors.grey.shade600),
                    const SizedBox(width: 4),
                    Text(scheme['date'] as String, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
              ),
              trailing: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    scheme['amount'] as String,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: isCredited ? AppColors.primaryGreen : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: isCredited ? Colors.green.shade50 : Colors.orange.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      scheme['status'] as String,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isCredited ? Colors.green.shade700 : Colors.orange.shade800,
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
