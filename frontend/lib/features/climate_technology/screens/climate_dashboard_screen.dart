import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import '../../climate_advisory/providers/climate_provider.dart';

class ClimateDashboardScreen extends ConsumerWidget {
  const ClimateDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final advisoryAsync = ref.watch(climateAdvisoryProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Climate Tech', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            onPressed: () => ref.refresh(climateAdvisoryProvider),
            icon: const Icon(Icons.notifications_outlined),
          ),
        ],
      ),
      body: advisoryAsync.when(
        data: (data) {
          final weather = data.currentWeather;
          final risk = data.riskAnalysis;
          final alerts = data.smartAlerts;
          
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Weather Card (Green)
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.location_on, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text('Detecting Location...', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                            ],
                          ),
                          Text('${weather.temperature.toStringAsFixed(1)}°C', style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      const Row(
                        children: [
                          Icon(Icons.cloud_queue, color: Colors.white),
                          SizedBox(width: 8),
                          Text('Clear', style: TextStyle(color: Colors.white, fontSize: 16)),
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Divider(color: Colors.white24),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _weatherMetric(Icons.water_drop, '${weather.humidity.toStringAsFixed(0)}%', 'Humidity'),
                          _weatherMetric(Icons.air, '${weather.windSpeed.toStringAsFixed(1)} km/h', 'Wind'),
                          _weatherMetric(Icons.umbrella, '0%', 'Rain Prob.'), // Mocked probability
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Risk Indicators
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Climate Risk Indicators', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextButton(
                      onPressed: () => ref.refresh(climateAdvisoryProvider),
                      child: const Text('Update', style: TextStyle(color: AppColors.primaryGreen)),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: risk.level == 'Low' ? Colors.green.shade50 : (risk.level == 'Medium' ? Colors.amber.shade50 : Colors.red.shade50),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: risk.level == 'Low' ? Colors.green.withOpacity(0.3) : (risk.level == 'Medium' ? Colors.amber.withOpacity(0.3) : Colors.red.withOpacity(0.3))),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.check_circle_outline, color: risk.level == 'Low' ? Colors.green : (risk.level == 'Medium' ? Colors.amber : Colors.red)),
                          const SizedBox(width: 8),
                          Text('${risk.level == 'Low' ? 'Favorable' : risk.level} Conditions', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: risk.level == 'Low' ? Colors.green.shade700 : (risk.level == 'Medium' ? Colors.amber.shade700 : Colors.red.shade700))),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: risk.level == 'Low' ? Colors.green : (risk.level == 'Medium' ? Colors.amber : Colors.red),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(risk.level, style: const TextStyle(color: Colors.white, fontSize: 12)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text('Weather conditions are currently ${risk.level == 'Low' ? 'optimal' : 'not optimal'} for standard operations.', style: TextStyle(color: Colors.grey.shade700)),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.lightbulb_outline, size: 16, color: Colors.grey.shade600),
                            const SizedBox(width: 8),
                            Expanded(child: Text('Rec: ${data.advisorySuggestions.isNotEmpty ? data.advisorySuggestions.first : 'Continue with standard SOPs.'}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500))),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Smart Alerts
                const Text('Smart Alerts', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                if (alerts.isEmpty)
                  const Text('No active alerts. Alerts will appear automatically for risky weather.', style: TextStyle(color: Colors.grey))
                else
                  Column(
                    children: alerts.map((alert) => Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border(left: BorderSide(color: Colors.red.shade600, width: 4)),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning, color: Colors.red.shade600, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(alert.type, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade800)),
                                Text(alert.message, style: TextStyle(fontSize: 13, color: Colors.red.shade800)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )).toList(),
                  ),
                const SizedBox(height: 24),
                
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/climate-tech/advisories'),
                    icon: const Icon(Icons.bolt, color: Colors.white,),
                    label: const Text('View All Climate Advisories'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: $err')),
      ),
    );
  }

  Widget _weatherMetric(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }
}
