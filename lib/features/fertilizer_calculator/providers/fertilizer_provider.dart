import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/soil_model.dart';
import '../models/fertilizer_model.dart';
import '../repositories/fertilizer_repository.dart';

final fertilizerRepoProvider = Provider<FertilizerRepository>((ref) {
  return FertilizerRepositoryImpl();
});

class CurrentSoilDataNotifier extends Notifier<SoilData?> {
  @override
  SoilData? build() => null;
  void setSoilData(SoilData? data) => state = data;
}

final currentSoilDataProvider = NotifierProvider<CurrentSoilDataNotifier, SoilData?>(CurrentSoilDataNotifier.new);

class OrganicModeNotifier extends Notifier<bool> {
  @override
  bool build() => true;
  void toggle() => state = !state;
}

final organicModeProvider = NotifierProvider<OrganicModeNotifier, bool>(OrganicModeNotifier.new);

final recommendationProvider = FutureProvider.autoDispose<RecommendationResponse?>((ref) async {
  final soilData = ref.watch(currentSoilDataProvider);
  if (soilData == null) return null;

  final repo = ref.watch(fertilizerRepoProvider);
  return repo.getRecommendations(soilData);
});
