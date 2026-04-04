import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/core/network/realtime_database_health_provider.dart';
import '../providers/climate_provider.dart';
import '../providers/notification_provider.dart';
import '../widgets/climate_widgets.dart';

class ClimateDashboardScreen extends ConsumerWidget {
  const ClimateDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(fcmBootstrapProvider);
    final weatherAsync = ref.watch(climateWeatherProvider);
    final risksAsync = ref.watch(climateRiskProvider);
    final notifications = ref.watch(notificationCenterProvider);
    final unreadCount = ref.watch(unreadNotificationCountProvider);
    final dbHealthAsync = ref.watch(realtimeDatabaseHealthProvider);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Climate Tech', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) {
                  return SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Notifications',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  ref
                                      .read(notificationCenterProvider.notifier)
                                      .markAllRead();
                                },
                                child: const Text('Mark all read'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (notifications.isEmpty)
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Text('No notifications yet.'),
                            )
                          else
                            SizedBox(
                              height: 320,
                              child: ListView.builder(
                                itemCount: notifications.length,
                                itemBuilder: (context, index) {
                                  final item = notifications[index];
                                  return ClimateNotificationCard(
                                    notification: item,
                                    onTap: () {
                                      ref
                                          .read(
                                            notificationCenterProvider.notifier,
                                          )
                                          .markRead(item.id);
                                    },
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                const Icon(Icons.notifications_outlined),
                if (unreadCount > 0)
                  Positioned(
                    right: -6,
                    top: -6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        unreadCount > 99 ? '99+' : '$unreadCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            dbHealthAsync.when(
              data: (health) {
                Color color;
                switch (health.state) {
                  case RealtimeDatabaseState.connected:
                    color = Colors.green;
                    break;
                  case RealtimeDatabaseState.connectedButRestricted:
                    color = Colors.orange;
                    break;
                  case RealtimeDatabaseState.disconnected:
                    color = Colors.grey;
                    break;
                  case RealtimeDatabaseState.error:
                    color = Colors.red;
                    break;
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: color.withValues(alpha: 0.30)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.storage_rounded, color: color),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          health.message,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                );
              },
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
            weatherAsync.when(
              data: (weather) => ClimateWeatherCard(weather: weather),
              loading: () => const SizedBox(height: 180, child: Center(child: CircularProgressIndicator())),
              error: (err, stack) => Center(child: Text('Failed loading weather: $err')),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Climate Risk Indicators', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () {
                    ref.invalidate(climateWeatherProvider);
                    ref.invalidate(climateRiskProvider);
                  },
                  child: const Text('Update'),
                )
              ],
            ),
            const SizedBox(height: 8),
            risksAsync.when(
              data: (risks) => Column(
                children: risks.map((risk) => ClimateAlertCard(risk: risk)).toList(),
              ),
              loading: () => const Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error loading risks: $err'),
            ),
            const SizedBox(height: 24),
            const Text(
              'Smart Alerts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            if (notifications.isEmpty)
              const Text(
                'No active alerts. Alerts will appear automatically for risky weather.',
              )
            else
              Column(
                children: notifications
                    .take(3)
                    .map(
                      (n) => ClimateNotificationCard(
                        notification: n,
                        onTap: () => ref
                            .read(notificationCenterProvider.notifier)
                            .markRead(n.id),
                      ),
                    )
                    .toList(),
              ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => context.push('/climate-tech/advisories'),
                icon: const Icon(Icons.bolt),
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
      ),
    );
  }
}
