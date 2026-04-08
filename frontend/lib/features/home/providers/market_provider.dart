import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/features/home/models/market_price.dart';
import 'package:kurukshetra/features/home/repositories/market_repository.dart';

final marketRepositoryProvider = Provider<MarketRepository>((ref) {
  return MarketRepositoryImpl();
});

final marketPricesProvider = FutureProvider<List<MarketPrice>>((ref) async {
  final repository = ref.read(marketRepositoryProvider);
  return repository.getCurrentPrices();
});

final mandiLocationsProvider = FutureProvider<List<Mandi>>((ref) async {
  final repository = ref.read(marketRepositoryProvider);
  return repository.getNearbyMandis('Pune');
});
