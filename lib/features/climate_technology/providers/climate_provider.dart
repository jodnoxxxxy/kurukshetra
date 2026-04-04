import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/climate_model.dart';
import 'notification_provider.dart';
import '../repositories/climate_repository.dart';

final climateRepositoryProvider = Provider<ClimateRepository>((ref) {
  return ClimateRepositoryImpl();
});

class WeatherLocationNotifier extends Notifier<String> {
  @override
  String build() => 'Pune';
  void setLocation(String loc) => state = loc;
}

final weatherLocationProvider = NotifierProvider<WeatherLocationNotifier, String>(WeatherLocationNotifier.new);

final weatherRefreshTickProvider = StreamProvider<int>((ref) {
  final controller = StreamController<int>();
  int tick = 0;
  controller.add(tick);
  final timer = Timer.periodic(const Duration(minutes: 10), (_) {
    tick++;
    controller.add(tick);
  });
  ref.onDispose(() {
    timer.cancel();
    controller.close();
  });
  return controller.stream;
});

final climateWeatherProvider = FutureProvider<DetailedWeather>((ref) async {
  ref.watch(weatherRefreshTickProvider);
  final location = ref.watch(weatherLocationProvider);
  final repo = ref.watch(climateRepositoryProvider);
  final weather = await repo.getWeatherData(location);
  _triggerSmartAlerts(ref, weather);
  return weather;
});

final climateRiskProvider = FutureProvider<List<ClimateRisk>>((ref) async {
  final weatherAsync = ref.watch(climateWeatherProvider);
  
  return weatherAsync.when(
    data: (weather) {
      final repo = ref.watch(climateRepositoryProvider);
      return repo.getClimateRisks(weather);
    },
    loading: () => Future.value([]),
    error: (_, __) => Future.value([]),
  );
});

final climateAdvisoryProvider = FutureProvider<List<ClimateAdvisory>>((ref) async {
  final weatherAsync = ref.watch(climateWeatherProvider);
  
  return weatherAsync.when(
    data: (weather) {
      final repo = ref.watch(climateRepositoryProvider);
      return repo.getAdvisories(weather);
    },
    loading: () => Future.value([]),
    error: (_, __) => Future.value([]),
  );
});

class SelectedClimateAdvisoryNotifier extends Notifier<ClimateAdvisory?> {
  @override
  ClimateAdvisory? build() => null;
  void setAdvisory(ClimateAdvisory? advisory) => state = advisory;
}

final selectedClimateAdvisoryProvider = NotifierProvider<SelectedClimateAdvisoryNotifier, ClimateAdvisory?>(SelectedClimateAdvisoryNotifier.new);

void _triggerSmartAlerts(Ref ref, DetailedWeather weather) {
  final notifications = ref.read(notificationCenterProvider.notifier);

  if (weather.humidity >= 80) {
    notifications.addSmartAlert(
      title: 'Pest Alert: High Humidity',
      body:
          'Humidity is ${weather.humidity}%. High moisture can trigger pest and fungal outbreaks. Start field scouting.',
      type: FarmNotificationType.pest,
    );
  }

  if (weather.rainfallProbability >= 60) {
    notifications.addSmartAlert(
      title: 'Fertilizer Warning: Rain Forecast',
      body:
          'Rain probability is ${weather.rainfallProbability}%. Delay fertilizer spray to avoid nutrient runoff.',
      type: FarmNotificationType.fertilizer,
    );
  }
}
