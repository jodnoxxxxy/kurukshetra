import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/features/home/models/crop.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class NotificationsState {
  final List<NotificationItem> notifications;
  final bool isLoading;

  const NotificationsState({
    this.notifications = const [],
    this.isLoading = false,
  });

  int get unreadCount => notifications.where((n) => !n.isRead).length;

  NotificationsState copyWith({
    List<NotificationItem>? notifications,
    bool? isLoading,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class NotificationsNotifier extends Notifier<NotificationsState> {
  @override
  NotificationsState build() {
    _loadNotifications();
    return const NotificationsState(isLoading: true);
  }

  void _loadNotifications() {
    // Mock notifications — replace with backend fetch in production
    final items = <NotificationItem>[
      NotificationItem(
        id: '1',
        title: '⚠️ Rain Expected Tomorrow',
        message: 'Light to moderate rainfall expected in your area. Consider adjusting irrigation schedule.',
        type: 'weather',
        createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      NotificationItem(
        id: '2',
        title: '🐛 Pest Risk Alert – Aphid',
        message: 'High aphid activity detected in your region for wheat and maize crops.',
        type: 'pest',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      NotificationItem(
        id: '3',
        title: '📈 Soybean Price Increased',
        message: 'Soybean prices increased by ₹200/quintal at Nagpur market.',
        type: 'market',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      NotificationItem(
        id: '4',
        title: '🏛️ PM-KISAN Scheme Update',
        message: 'New PM-KISAN instalment released. Check your bank account.',
        type: 'scheme',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        isRead: true,
      ),
      NotificationItem(
        id: '5',
        title: '📦 Warehouse Booking Confirmed',
        message: 'Your warehouse booking for Wheat has been confirmed.',
        type: 'order',
        createdAt: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
      ),
    ];

    state = NotificationsState(notifications: items);
  }

  void markAsRead(String id) {
    final updated = state.notifications.map((n) {
      return n.id == id ? _markRead(n) : n;
    }).toList();
    state = state.copyWith(notifications: updated);
  }

  void markAllAsRead() {
    final updated = state.notifications.map(_markRead).toList();
    state = state.copyWith(notifications: updated);
  }

  void clearAll() {
    state = state.copyWith(notifications: []);
  }

  /// Returns a new [NotificationItem] with [isRead] = true.
  NotificationItem _markRead(NotificationItem n) {
    return NotificationItem(
      id: n.id,
      title: n.title,
      message: n.message,
      type: n.type,
      createdAt: n.createdAt,
      isRead: true,
      data: n.data,
    );
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final notificationsProvider =
    NotifierProvider<NotificationsNotifier, NotificationsState>(
  NotificationsNotifier.new,
);
