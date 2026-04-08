import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/climate_provider.dart';
import '../models/climate_model.dart';
import 'package:kurukshetra/core/constants/app_colors.dart'; // Standard colors if needed

class ClimateAdvisoryScreen extends ConsumerWidget {
  const ClimateAdvisoryScreen({Key? key}) : super(key: key);

  Color _getRiskColor(String level) {
    if (level == 'Low') return Colors.green.shade600;
    if (level == 'Medium') return Colors.amber.shade700;
    return Colors.red.shade600;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final advisoryAsync = ref.watch(climateAdvisoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Climate Smart Advisory', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.refresh(climateAdvisoryProvider),
          )
        ],
      ),
      body: advisoryAsync.when(
        data: (data) => _buildBody(context, data, ref),
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Fetching real-time weather & analyzing risk...')
            ],
          ),
        ),
        error: (err, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.cloud_off, size: 80, color: Colors.grey.shade400),
                const SizedBox(height: 16),
                Text('Cannot load climate data', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text(err.toString(), textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => ref.refresh(climateAdvisoryProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, ClimateAdvisoryResponse data, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: () async => ref.refresh(climateAdvisoryProvider),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 2. Weather Card
            _buildWeatherCard(context, data.currentWeather),
            const SizedBox(height: 20),

            // 5. Risk Indicator Component
            _buildRiskIndicator(context, data.riskAnalysis),
            const SizedBox(height: 20),

            // 6. Smart Alerts System
            const Text('Smart Alerts 🔥', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (data.smartAlerts.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green),
                    SizedBox(width: 12),
                    Expanded(child: Text('No active alerts. Conditions are stable and safe for operations.', style: TextStyle(color: Colors.black87))),
                  ],
                ),
              )
            else
              _buildSmartAlerts(context, data.smartAlerts),
            const SizedBox(height: 20),

            // 7. Climate Advisory Suggestions
            _buildAdvisorySection(context, data.advisorySuggestions),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherCard(BuildContext context, ClimateData weather) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearBinding(begin: Alignment.topLeft, end: Alignment.bottomRight, colors: [Colors.blue.shade700, Colors.blue.shade900]),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Current Weather', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                const Icon(Icons.wb_sunny, color: Colors.amber, size: 30),
              ],
            ),
            const Divider(color: Colors.white24, height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _weatherItem(Icons.thermostat, '${weather.temperature.toStringAsFixed(1)}°C', 'Temp'),
                _weatherItem(Icons.water_drop, '${weather.rainfall.toStringAsFixed(1)} mm', 'Rain'),
                _weatherItem(Icons.air, '${weather.humidity.toStringAsFixed(0)}%', 'Humidity'),
                _weatherItem(Icons.storm, '${weather.windSpeed.toStringAsFixed(1)} km/h', 'Wind'),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _weatherItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white, size: 28),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12)),
      ],
    );
  }

  Widget _buildRiskIndicator(BuildContext context, RiskAnalysis risk) {
    final color = _getRiskColor(risk.level);
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color, width: 2),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: color,
            radius: 28,
            child: Icon(
              risk.level == 'High' ? Icons.warning_amber_rounded 
                  : risk.level == 'Medium' ? Icons.info_outline 
                  : Icons.check_circle_outline,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Climate Risk Level', style: TextStyle(fontSize: 14, color: Colors.grey)),
                Text(
                  risk.level == 'Low' ? 'Favorable' : '${risk.level} Risk',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSmartAlerts(BuildContext context, List<SmartAlert> alerts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...alerts.map((alert) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border(left: BorderSide(color: Colors.red.shade700, width: 4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.notifications_active, color: Colors.red.shade700),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alert.type, style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red.shade900)),
                    const SizedBox(height: 4),
                    Text(alert.message, style: TextStyle(color: Colors.red.shade900)),
                  ],
                ),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildAdvisorySection(BuildContext context, List<String> suggestions) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Icon(Icons.lightbulb, color: Colors.amber),
                SizedBox(width: 8),
                Text('Actionable Advisory', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 24),
            ...suggestions.map((suggestion) => Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
                  const SizedBox(width: 12),
                  Expanded(child: Text(suggestion, style: const TextStyle(fontSize: 15, height: 1.4))),
                ],
              ),
            )).toList(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Detailed view launching...')));
                },
                child: const Text('View Detailed Climate Report'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
// Helper missing class Binding
class LinearBinding extends LinearGradient {
  const LinearBinding({required Alignment begin, required Alignment end, required List<Color> colors}) : super(begin: begin, end: end, colors: colors);
}