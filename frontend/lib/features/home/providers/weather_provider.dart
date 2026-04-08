import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/features/home/repositories/weather_repository.dart';
import 'package:kurukshetra/features/home/models/weather.dart';

final weatherRepositoryProvider = Provider<WeatherRepository>((ref) {
  return WeatherRepositoryImpl();
});

final weatherProvider = FutureProvider<WeatherInfo>((ref) async {
  final repository = ref.read(weatherRepositoryProvider);
  return repository.getCurrentWeather('Pune');
});

// For better city selection later, we could have a selectedCityStateProvider
// and make weatherProvider a Family provider or react to that city change.

final weatherRefreshProvider = FutureProvider.autoDispose<void>((ref) async {
  // Invalidate to force a new fetch
  ref.invalidate(weatherProvider);
  return;
});
