import 'package:dio/dio.dart';
import '../models/soil_model.dart';
import 'package:kurukshetra/core/network/api_client.dart';
import 'package:kurukshetra/core/network/api_response.dart';

abstract class SoilRepository {
  Future<ApiResponse<SoilAnalysisResult>> analyzeSoil(SoilNutrientInput input);
  Future<ApiResponse<List<OrganicRecommendation>>> getOrganicRecommendations(SoilAnalysisResult analysis);
  Future<ApiResponse<List<String>>> getRecommendedCrops(SoilNutrientInput input);
}

class SoilRepositoryImpl implements SoilRepository {
  // Using singleton ApiClient for future HTTP endpoints
  // ignore: unused_field
  final _apiClient = ApiClient();

  @override
  Future<ApiResponse<SoilAnalysisResult>> analyzeSoil(SoilNutrientInput input) async {
    try {
      // Simulating backend processing
      await Future.delayed(const Duration(milliseconds: 600));

      // Logic based on requirements
      SoilCategory nCategory = _evaluateN(input.nitrogen);
      SoilCategory pCategory = _evaluateP(input.phosphorus);
      SoilCategory kCategory = _evaluateK(input.potassium);
      SoilCategory phStatus = _evaluatePh(input.phLevel);

      // Calculate score (Out of 100)
      int score = 100;
      if (nCategory.status == 'Low') score -= 15;
      if (pCategory.status == 'Low') score -= 15;
      if (kCategory.status == 'Low') score -= 15;
      if (phStatus.status != 'Neutral') score -= 10;
      if (input.organicCarbon < 0.5) score -= 10;

      final result = SoilAnalysisResult(
        nitrogen: nCategory,
        phosphorus: pCategory,
        potassium: kCategory,
        phLevel: phStatus,
        healthScore: score < 0 ? 0 : score,
      );
      
      return ApiResponse.success(result);
    } on DioException {
      return ApiResponse.error("Network error analyzing soil. Please check your connection.");
    } catch (e) {
      return ApiResponse.error("An unexpected error occurred during soil analysis. Please try again.");
    }
  }

  @override
  Future<ApiResponse<List<OrganicRecommendation>>> getOrganicRecommendations(SoilAnalysisResult analysis) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      List<OrganicRecommendation> recs = [];

      if (analysis.nitrogen.status == 'Low') {
        recs.add(OrganicRecommendation(
          title: 'Improve Nitrogen',
          suggestions: ['Apply Vermicompost', 'Incorporate Farmyard manure (FYM)', 'Grow Green manure or Legume crops'],
          iconName: 'grass',
        ));
      }

      if (analysis.phosphorus.status == 'Low') {
        recs.add(OrganicRecommendation(
          title: 'Fix Phosphorus Deficiency',
          suggestions: ['Use Bone meal', 'Apply Rock phosphate', 'Add phosphorus solubilizing bio-fertilizers'],
          iconName: 'eco',
        ));
      }

      if (analysis.potassium.status == 'Low') {
        recs.add(OrganicRecommendation(
          title: 'Enhance Potassium',
          suggestions: ['Spread Wood ash', 'Use Banana peel compost'],
          iconName: 'compost',
        ));
      }

      if (analysis.phLevel.status == 'Acidic') {
        recs.add(OrganicRecommendation(
          title: 'Neutralize Acidic Soil',
          suggestions: ['Apply agricultural lime or crushed limestone'],
          iconName: 'science',
        ));
      }

      if (recs.isEmpty) {
        recs.add(OrganicRecommendation(
          title: 'Maintain Soil Health',
          suggestions: ['Continue applying organic compost annually', 'Practice crop rotation with legumes'],
          iconName: 'thumb_up',
        ));
      }

      return ApiResponse.success(recs);
    } catch (e) {
      return ApiResponse.error("Failed to generate recommendations. Please try again.");
    }
  }

  @override
  Future<ApiResponse<List<String>>> getRecommendedCrops(SoilNutrientInput input) async {
    try {
      await Future.delayed(const Duration(milliseconds: 400));
      List<String> crops = [];

      if (input.phLevel >= 6.0 && input.phLevel <= 7.5) {
        crops.addAll(['Wheat', 'Maize', 'Soybean', 'Groundnut', 'Sunflower']);
      } else if (input.phLevel < 6.0) {
        crops.addAll(['Paddy', 'Potato', 'Tea', 'Pineapple']);
      } else {
        crops.addAll(['Barley', 'Cotton', 'Sugarbeet', 'Mustard']);
      }

      // Limit to 4 suggestions for UI sake
      return ApiResponse.success(crops.take(4).toList());
    } catch (e) {
      return ApiResponse.error("Failed to generate crop recommendations. Please try again.");
    }
  }

  // --- Logic Helpers ---

  SoilCategory _evaluateN(double val) {
    if (val < 280) return SoilCategory(status: 'Low', message: 'Needs replenishment');
    if (val > 560) return SoilCategory(status: 'High', message: 'Avoid excess application');
    return SoilCategory(status: 'Medium', message: 'Optimal range');
  }

  SoilCategory _evaluateP(double val) {
    if (val < 10) return SoilCategory(status: 'Low', message: 'Deficient, needs boosting');
    if (val > 25) return SoilCategory(status: 'High', message: 'Sufficient supply');
    return SoilCategory(status: 'Medium', message: 'Adequate range');
  }

  SoilCategory _evaluateK(double val) {
    if (val < 110) return SoilCategory(status: 'Low', message: 'Very low, impacts growth');
    if (val > 280) return SoilCategory(status: 'High', message: 'Excellent reserves');
    return SoilCategory(status: 'Medium', message: 'Balanced levels');
  }

  SoilCategory _evaluatePh(double val) {
    if (val < 6.5) return SoilCategory(status: 'Acidic', message: 'Requires liming');
    if (val > 7.5) return SoilCategory(status: 'Alkaline', message: 'Requires gypsum or sulfur');
    return SoilCategory(status: 'Neutral', message: 'Ideal for most crops');
  }
}
