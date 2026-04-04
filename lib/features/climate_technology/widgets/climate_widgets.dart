import 'package:flutter/material.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import '../models/climate_model.dart';
import '../providers/notification_provider.dart';

class ClimateWeatherCard extends StatelessWidget {
  final DetailedWeather weather;

  const ClimateWeatherCard({super.key, required this.weather});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen, // Fallback if gradient fails
        gradient: LinearGradient(
          colors: [AppColors.primaryGreen, Colors.green.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.green.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.white, size: 20),
                  const SizedBox(width: 4),
                  Text(
                    weather.location,
                    style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Text(
                '${weather.temperature}°C',
                style: const TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              const Icon(Icons.wb_cloudy_outlined, color: Colors.white70, size: 24),
              const SizedBox(width: 8),
              Text(
                weather.condition,
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Colors.white30),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMiniStat(Icons.water_drop, '${weather.humidity}%', 'Humidity'),
              _buildMiniStat(Icons.air, '${weather.windSpeed} km/h', 'Wind'),
              _buildMiniStat(Icons.umbrella, '${weather.rainfallProbability}%', 'Rain Prob.'),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildMiniStat(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 20),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10)),
      ],
    );
  }
}

class ClimateAlertCard extends StatelessWidget {
  final ClimateRisk risk;

  const ClimateAlertCard({super.key, required this.risk});

  @override
  Widget build(BuildContext context) {
    Color badgeColor;
    IconData icon;

    switch (risk.severity) {
      case 'High':
        badgeColor = Colors.red;
        icon = Icons.warning_amber_rounded;
        break;
      case 'Medium':
        badgeColor = Colors.orange;
        icon = Icons.error_outline;
        break;
      default:
        badgeColor = Colors.green;
        icon = Icons.check_circle_outline;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: badgeColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: badgeColor, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text(risk.title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: badgeColor.withValues(alpha: 1.0)))),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: badgeColor, borderRadius: BorderRadius.circular(8)),
                      child: Text(risk.severity, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(risk.description, style: const TextStyle(color: Colors.black87, fontSize: 13)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.6), borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      const Icon(Icons.lightbulb_outline, size: 16, color: Colors.blueGrey),
                      const SizedBox(width: 8),
                      Expanded(child: Text('Rec: ${risk.recommendation}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold))),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

class ClimateNotificationCard extends StatelessWidget {
  const ClimateNotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
  });

  final FarmNotification notification;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = _colorForType(notification.type);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: notification.isRead
              ? Colors.grey.shade100
              : color.withValues(alpha: 0.12),
          border: Border.all(
            color: notification.isRead
                ? Colors.grey.shade300
                : color.withValues(alpha: 0.35),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.notifications_active, color: color),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    notification.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(notification.body),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _colorForType(FarmNotificationType type) {
    switch (type) {
      case FarmNotificationType.pest:
        return Colors.orange;
      case FarmNotificationType.fertilizer:
        return Colors.deepPurple;
      case FarmNotificationType.weather:
        return Colors.blue;
      case FarmNotificationType.system:
        return Colors.teal;
    }
  }
}
