class SoilNutrientInput {
  final double nitrogen;
  final double phosphorus;
  final double potassium;
  final double phLevel;
  final double organicCarbon;

  SoilNutrientInput({
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.phLevel,
    required this.organicCarbon,
  });
}

class SoilCategory {
  final String status; // Low, Medium, High
  final String message;

  SoilCategory({required this.status, required this.message});
}

class SoilAnalysisResult {
  final SoilCategory nitrogen;
  final SoilCategory phosphorus;
  final SoilCategory potassium;
  final SoilCategory phLevel;
  final int healthScore;

  SoilAnalysisResult({
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
    required this.phLevel,
    required this.healthScore,
  });
}

class OrganicRecommendation {
  final String title;
  final List<String> suggestions;
  final String iconName;

  OrganicRecommendation({
    required this.title,
    required this.suggestions,
    required this.iconName,
  });
}
