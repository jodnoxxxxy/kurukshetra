import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum FarmNotificationType { weather, pest, fertilizer, system }

class FarmNotification {
  final String id;
  final String title;
  final String body;
  final FarmNotificationType type;
  final DateTime createdAt;
  final bool isRead;

  const FarmNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    this.isRead = false,
  });

  FarmNotification copyWith({bool? isRead}) {
    return FarmNotification(
      id: id,
      title: title,
      body: body,
      type: type,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }
}

class NotificationCenterNotifier extends Notifier<List<FarmNotification>> {
  @override
  List<FarmNotification> build() => const [];

  void addNotification(FarmNotification notification) {
    final exists = state.any((n) => n.id == notification.id);
    if (exists) {
      return;
    }
    state = [notification, ...state];
  }

  void addSmartAlert({
    required String title,
    required String body,
    required FarmNotificationType type,
  }) {
    final recentDuplicate = state.any(
      (n) =>
          n.title == title &&
          DateTime.now().difference(n.createdAt) < const Duration(minutes: 30),
    );
    if (recentDuplicate) {
      return;
    }

    final id = '${type.name}-${DateTime.now().millisecondsSinceEpoch}';
    addNotification(
      FarmNotification(
        id: id,
        title: title,
        body: body,
        type: type,
        createdAt: DateTime.now(),
      ),
    );
  }

  void addFromRemoteMessage(RemoteMessage message) {
    addNotification(
      FarmNotification(
        id: message.messageId ??
            'fcm-${DateTime.now().millisecondsSinceEpoch}',
        title: message.notification?.title ?? 'New update',
        body: message.notification?.body ?? 'You have a new alert.',
        type: FarmNotificationType.system,
        createdAt: DateTime.now(),
      ),
    );
  }

  void markAllRead() {
    state = state.map((n) => n.copyWith(isRead: true)).toList();
  }

  void markRead(String id) {
    state = state
        .map((n) => n.id == id ? n.copyWith(isRead: true) : n)
        .toList();
  }

  void clearAll() {
    state = const [];
  }
}

final notificationCenterProvider =
    NotifierProvider<NotificationCenterNotifier, List<FarmNotification>>(
  NotificationCenterNotifier.new,
);

final unreadNotificationCountProvider = Provider<int>((ref) {
  final items = ref.watch(notificationCenterProvider);
  return items.where((n) => !n.isRead).length;
});

final fcmBootstrapProvider = Provider<void>((ref) {
  unawaited(_initializeFcm(ref));

  final subMessage = FirebaseMessaging.onMessage.listen((message) {
    ref
        .read(notificationCenterProvider.notifier)
        .addFromRemoteMessage(message);
  });

  final subOpen = FirebaseMessaging.onMessageOpenedApp.listen((message) {
    ref
        .read(notificationCenterProvider.notifier)
        .addFromRemoteMessage(message);
  });

  ref.onDispose(() {
    subMessage.cancel();
    subOpen.cancel();
  });
});

Future<void> _initializeFcm(Ref ref) async {
  try {
    final messaging = FirebaseMessaging.instance;
    await messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    final settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    if (settings.authorizationStatus == AuthorizationStatus.denied) {
      debugPrint('FCM permission denied');
      return;
    }

    final token = await messaging.getToken();
    debugPrint('FCM token: $token');
  } catch (e) {
    debugPrint('FCM initialization failed: $e');
  }
}
