import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/core/constants/app_colors.dart';
import 'package:kurukshetra/features/climate_technology/providers/notification_provider.dart';
import 'package:kurukshetra/features/profile/providers/profile_provider.dart';
import 'package:kurukshetra/features/profile/widgets/settings_item.dart';
import 'package:kurukshetra/l10n/app_localizations.dart';

class NotificationsScreen extends ConsumerStatefulWidget {
  const NotificationsScreen({super.key});

  @override
  ConsumerState<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends ConsumerState<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileProvider);
    final notifications = ref.watch(notificationCenterProvider);
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.notifications),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: l10n.notifications),
            Tab(text: l10n.preferencesTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildNotificationsList(context, notifications),
          _buildNotificationPreferences(context, profileState),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(BuildContext context, List<FarmNotification> notifications) {
    final l10n = AppLocalizations.of(context)!;
    if (notifications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.notifications_none_rounded, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            Text(
              l10n.noNotifications,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: notifications.map((n) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: _buildNotificationItem(
            context,
            '${_emojiForType(n.type)} ${n.title}',
            n.body,
            _colorForType(n.type),
            _relativeTime(n.createdAt),
            id: n.id,
            isRead: n.isRead,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildNotificationItem(
    BuildContext context,
    String title,
    String message,
    Color color,
    String time, {
    required String id,
    bool isRead = false,
  }) {
    final l10n = AppLocalizations.of(context)!;
    return Card(
      elevation: isRead ? 1 : 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _markAsRead(context, id),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: isRead
                ? Border.all(color: Colors.grey.shade200)
                : Border.all(color: color.withValues(alpha: 0.3), width: 1.5),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isRead ? Colors.grey : color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              title,
                              style: TextStyle(
                                fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
                                fontSize: 15,
                                color: isRead ? Colors.grey.shade700 : Colors.black87,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: color,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        message,
                        style: TextStyle(
                          color: isRead ? Colors.grey.shade500 : AppColors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                            time,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade500,
                            ),
                          ),
                          const Spacer(),
                          TextButton(
                            onPressed: () => _markAsRead(context, id),
                            style: TextButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                              minimumSize: const Size(0, 32),
                            ),
                            child: Text(
                              l10n.markAsRead,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _colorForType(FarmNotificationType type) {
    switch (type) {
      case FarmNotificationType.weather:
        return Colors.blue;
      case FarmNotificationType.pest:
        return Colors.orange;
      case FarmNotificationType.fertilizer:
        return Colors.purple;
      case FarmNotificationType.system:
        return Colors.teal;
    }
  }

  String _emojiForType(FarmNotificationType type) {
    switch (type) {
      case FarmNotificationType.weather:
        return '🌦️';
      case FarmNotificationType.pest:
        return '🐛';
      case FarmNotificationType.fertilizer:
        return '🧪';
      case FarmNotificationType.system:
        return '🔔';
    }
  }

  String _relativeTime(DateTime dateTime) {
    final diff = DateTime.now().difference(dateTime);
    if (diff.inMinutes < 1) return 'just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} day ago';
  }

  Widget _buildNotificationPreferences(BuildContext context, profileState) {
    if (profileState.profile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final l10n = AppLocalizations.of(context)!;
    final preferences = profileState.profile!.notificationPreferences;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          l10n.preferencesTab,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          l10n.notificationSubtitle,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),

        // Weather Alerts
        ToggleSettingsItem(
          icon: Icons.cloud,
          title: l10n.weatherAlert,
          subtitle: 'Get notified about weather changes and forecasts',
          value: preferences['weather_alerts'] ?? true,
          onChanged: (value) => _updatePreference(context, 'weather_alerts', value),
          iconColor: Colors.blue,
        ),
        const SizedBox(height: 12),

        // Pest Alerts
        ToggleSettingsItem(
          icon: Icons.bug_report,
          title: l10n.pestRiskAlert,
          subtitle: 'Receive warnings about pest and disease risks',
          value: preferences['pest_alerts'] ?? true,
          onChanged: (value) => _updatePreference(context, 'pest_alerts', value),
          iconColor: Colors.orange,
        ),
        const SizedBox(height: 12),

        // Market Price Alerts
        ToggleSettingsItem(
          icon: Icons.trending_up,
          title: l10n.marketPriceAlert,
          subtitle: 'Get updates on market price changes',
          value: preferences['market_price_alerts'] ?? true,
          onChanged: (value) => _updatePreference(context, 'market_price_alerts', value),
          iconColor: Colors.purple,
        ),
        const SizedBox(height: 12),

        // Order Notifications
        ToggleSettingsItem(
          icon: Icons.inventory,
          title: l10n.orderUpdate,
          subtitle: 'Updates on your warehouse bookings and orders',
          value: preferences['order_notifications'] ?? true,
          onChanged: (value) => _updatePreference(context, 'order_notifications', value),
          iconColor: Colors.teal,
        ),
        const SizedBox(height: 12),

        // Government Schemes
        ToggleSettingsItem(
          icon: Icons.policy,
          title: l10n.governmentSchemeUpdate,
          subtitle: 'Information about new agricultural schemes',
          value: preferences['government_schemes'] ?? true,
          onChanged: (value) => _updatePreference(context, 'government_schemes', value),
          iconColor: Colors.green,
        ),
        const SizedBox(height: 32),

        // Additional Settings
        Text(
          l10n.preferences,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Notification Time
        SettingsItem(
          icon: Icons.schedule,
          title: l10n.quietHours,
          subtitle: l10n.quietHoursSubtitle,
          onTap: () => _showQuietHoursDialog(context),
          iconColor: Colors.indigo,
        ),
        const SizedBox(height: 12),

        // Sound Settings
        SettingsItem(
          icon: Icons.volume_up,
          title: l10n.soundVibration,
          subtitle: l10n.soundVibrationSubtitle,
          onTap: () => _showSoundSettings(context),
          iconColor: Colors.red,
        ),
        const SizedBox(height: 24),

        // Clear All Button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => _clearAllNotifications(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(l10n.clearAll),
          ),
        ),
      ],
    );
  }

  void _updatePreference(BuildContext context, String key, bool value) {
    final l10n = AppLocalizations.of(context)!;
    ref.read(profileProvider.notifier).updateNotificationPreferences(key, value);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.notificationPrefUpdated),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _markAsRead(BuildContext context, String id) {
    ref.read(notificationCenterProvider.notifier).markRead(id);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notification marked as read'),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showQuietHoursDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.quietHours),
        content: Text(l10n.quietHoursConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.quietHoursUpdated)),
              );
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showSoundSettings(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.soundVibration),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.notificationSound),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: 'Default',
              items: ['Default', 'Bell', 'Chime', 'Silent'].map((sound) {
                return DropdownMenuItem(value: sound, child: Text(sound));
              }).toList(),
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            Text(l10n.vibration),
            const SizedBox(height: 8),
            Switch(
              value: true,
              onChanged: (value) {},
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.soundSettingsUpdated)),
              );
            },
            child: Text(l10n.save),
          ),
        ],
      ),
    );
  }

  void _clearAllNotifications(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearAll),
        content: Text(l10n.clearAllNotificationsConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              ref.read(notificationCenterProvider.notifier).clearAll();
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.allNotificationsCleared)),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text(l10n.clearAll),
          ),
        ],
      ),
    );
  }
}
