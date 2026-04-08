import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/market_price_model.dart';
import '../repositories/market_repository.dart';

final marketPricesRepoProvider = Provider<MarketPricesRepository>((ref) {
  return MarketPricesRepositoryImpl();
});

final marketCropsProvider = FutureProvider<List<MarketCrop>>((ref) async {
  final repo = ref.watch(marketPricesRepoProvider);
  return repo.getMarketCrops();
});

class SelectedCropNotifier extends Notifier<MarketCrop?> {
  @override
  MarketCrop? build() => null;
  void setCrop(MarketCrop? crop) => state = crop;
}

final marketSelectedCropProvider = NotifierProvider<SelectedCropNotifier, MarketCrop?>(SelectedCropNotifier.new);

class SelectedMarketPriceNotifier extends Notifier<MarketPriceData?> {
  @override
  MarketPriceData? build() => null;
  void setMarketPrice(MarketPriceData? data) => state = data;
}

final selectedMarketPriceProvider = NotifierProvider<SelectedMarketPriceNotifier, MarketPriceData?>(SelectedMarketPriceNotifier.new);

final marketPricesProvider = FutureProvider<List<MarketPriceData>>((ref) async {
  final crop = ref.watch(marketSelectedCropProvider);
  if (crop == null) return [];

  final repo = ref.watch(marketPricesRepoProvider);
  return repo.getMarketPricesForCrop(crop.id);
});

final marketTrendProvider = FutureProvider<List<PriceTrendData>>((ref) async {
  final crop = ref.watch(marketSelectedCropProvider);
  final marketInfo = ref.watch(selectedMarketPriceProvider);

  if (crop == null || marketInfo == null) return [];
  
  final repo = ref.watch(marketPricesRepoProvider);
  return repo.getPriceTrends(marketInfo.id, crop.id);
});
