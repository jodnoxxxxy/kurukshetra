import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/soil_model.dart';
import '../repositories/soil_repository.dart';

final soilRepositoryProvider = Provider<SoilRepository>((ref) {
  return SoilRepositoryImpl();
});

class CurrentSoilInputNotifier extends Notifier<SoilNutrientInput?> {
  @override
  SoilNutrientInput? build() => null;
  void setInput(SoilNutrientInput? input) => state = input;
}

final currentSoilInputProvider = NotifierProvider<CurrentSoilInputNotifier, SoilNutrientInput?>(CurrentSoilInputNotifier.new);

class CurrentSoilAnalysisNotifier extends Notifier<SoilAnalysisResult?> {
  @override
  SoilAnalysisResult? build() => null;
  void setAnalysis(SoilAnalysisResult? result) => state = result;
}

final currentSoilAnalysisProvider = NotifierProvider<CurrentSoilAnalysisNotifier, SoilAnalysisResult?>(CurrentSoilAnalysisNotifier.new);

// For Recommendations Screen
final organicRecommendationsProvider = FutureProvider.autoDispose<List<OrganicRecommendation>>((ref) async {
  final analysis = ref.watch(currentSoilAnalysisProvider);
  if (analysis == null) return [];
  
  final repo = ref.watch(soilRepositoryProvider);
  final response = await repo.getOrganicRecommendations(analysis);
  if (response.hasError) throw Exception(response.error);
  return response.data!;
});

final cropSuggestionsProvider = FutureProvider.autoDispose<List<String>>((ref) async {
  final input = ref.watch(currentSoilInputProvider);
  if (input == null) return [];

  final repo = ref.watch(soilRepositoryProvider);
  final response = await repo.getRecommendedCrops(input);
  if (response.hasError) throw Exception(response.error);
  return response.data!;
});
