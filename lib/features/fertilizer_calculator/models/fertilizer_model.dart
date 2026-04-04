import 'soil_model.dart';

class FertilizerRecommendation {
  final String name;
  final String amount;
  final String unit;
  final bool isOrganic;
  final String description;
  final String targetNutrient; // N, P, K, or Mixed

  FertilizerRecommendation({
    required this.name,
    required this.amount,
    required this.unit,
    required this.isOrganic,
    required this.description,
    required this.targetNutrient,
  });
}

class RecommendationResponse {
  final NutrientAnalysis analysis;
  final List<FertilizerRecommendation> organic;
  final List<FertilizerRecommendation> chemical;

  RecommendationResponse({
    required this.analysis,
    required this.organic,
    required this.chemical,
  });
}
