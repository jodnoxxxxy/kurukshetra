import 'growth_step.dart';

class CropRecommendation {
  final String name;
  final String reason;
  final String description;
  final String imageUrl;
  final List<GrowthStep> steps;

  const CropRecommendation({
    required this.name,
    required this.reason,
    required this.description,
    required this.imageUrl,
    required this.steps,
  });
}
