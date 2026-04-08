import '../models/soil_model.dart';
import '../models/fertilizer_model.dart';

abstract class FertilizerRepository {
  Future<RecommendationResponse> getRecommendations(SoilData data);
}

class FertilizerRepositoryImpl implements FertilizerRepository {

  @override
  Future<RecommendationResponse> getRecommendations(SoilData data) async {
    // Determine analysis
    final analysis = _analyzeSoil(data);
    
    // Future API call stub
    /*
    try {
      final response = await _apiClient.dio.post('/fertilizer-recommendation', data: {
        'crop': data.crop,
        'area': data.area,
        'nitrogen': data.nitrogen,
        'phosphorus': data.phosphorus,
        'potassium': data.potassium,
      });
      // Return parsed data dynamically here
    } catch(e) {}
    */

    // Fallback: Local Rule Engine
    await Future.delayed(const Duration(milliseconds: 600));

    List<FertilizerRecommendation> organic = [];
    List<FertilizerRecommendation> chemical = [];

    // Nitrogen Logic
    if (analysis.nitrogenLevel == NutrientLevel.low) {
      organic.add(FertilizerRecommendation(
        name: 'Vermicompost',
        amount: (2 * data.area).toStringAsFixed(1),
        unit: 'tons',
        isOrganic: true,
        description: 'Excellent source of organic nitrogen and beneficial microbes.',
        targetNutrient: 'Nitrogen (N)'
      ));
      organic.add(FertilizerRecommendation(
        name: 'Farmyard Manure (FYM)',
        amount: (3 * data.area).toStringAsFixed(1),
        unit: 'tons',
        isOrganic: true,
        description: 'Improves soil texture, water holding capacity, and provides slow-release N.',
        targetNutrient: 'Nitrogen (N)'
      ));
      chemical.add(FertilizerRecommendation(
        name: 'Urea (46% N)',
        amount: (45 * data.area).toStringAsFixed(1),
        unit: 'kg',
        isOrganic: false,
        description: 'Apply as top dressing if organic sources are insufficient. Splitting dose recommended.',
        targetNutrient: 'Nitrogen (N)'
      ));
    }

    // Phosphorus Logic
    if (analysis.phosphorusLevel == NutrientLevel.low) {
      organic.add(FertilizerRecommendation(
        name: 'Bone Meal',
        amount: (150 * data.area).toStringAsFixed(0),
        unit: 'kg',
        isOrganic: true,
        description: 'Excellent slow-release phosphorus source, improves root growth.',
        targetNutrient: 'Phosphorus (P)'
      ));
      organic.add(FertilizerRecommendation(
        name: 'Rock Phosphate',
        amount: (200 * data.area).toStringAsFixed(0),
        unit: 'kg',
        isOrganic: true,
        description: 'Best used in acidic soils, providing long-lasting P availability.',
        targetNutrient: 'Phosphorus (P)'
      ));
      chemical.add(FertilizerRecommendation(
        name: 'DAP (18% N, 46% P)',
        amount: (30 * data.area).toStringAsFixed(1),
        unit: 'kg',
        isOrganic: false,
        description: 'Highly concentrated, apply as basal dose at the time of sowing.',
        targetNutrient: 'Phosphorus (P)'
      ));
    }

    // Potassium Logic
    if (analysis.potassiumLevel == NutrientLevel.low) {
      organic.add(FertilizerRecommendation(
        name: 'Wood Ash',
        amount: (200 * data.area).toStringAsFixed(0),
        unit: 'kg',
        isOrganic: true,
        description: 'Rich in potassium and calcium. Avoid in highly alkaline soils.',
        targetNutrient: 'Potassium (K)'
      ));
      organic.add(FertilizerRecommendation(
        name: 'Banana Peel Compost',
        amount: (1.5 * data.area).toStringAsFixed(1),
        unit: 'tons',
        isOrganic: true,
        description: 'Excellent source of fast-acting organic potassium.',
        targetNutrient: 'Potassium (K)'
      ));
      chemical.add(FertilizerRecommendation(
        name: 'MOP (60% K)',
        amount: (20 * data.area).toStringAsFixed(1),
        unit: 'kg',
        isOrganic: false,
        description: 'Apply during vegetative growth for better grain/fruit filling.',
        targetNutrient: 'Potassium (K)'
      ));
    }

    // If everything is not low, just suggest minimal maintenance doses
    if (analysis.nitrogenLevel != NutrientLevel.low && analysis.phosphorusLevel != NutrientLevel.low && analysis.potassiumLevel != NutrientLevel.low) {
      organic.add(FertilizerRecommendation(
        name: 'Jivamrut',
        amount: (200 * data.area).toStringAsFixed(0),
        unit: 'liters',
        isOrganic: true,
        description: 'Liquid bio-fertilizer to maintain high microbial activity and soil health.',
        targetNutrient: 'Maintenance'
      ));
    }

    return RecommendationResponse(
      analysis: analysis,
      organic: organic,
      chemical: chemical,
    );
  }

  NutrientAnalysis _analyzeSoil(SoilData data) {
    // Nitrogen thresholds
    NutrientLevel nLevel = NutrientLevel.medium;
    if (data.nitrogen < 280) {
      nLevel = NutrientLevel.low;
    } else if (data.nitrogen > 560) {
      nLevel = NutrientLevel.high;
    }

    // Phosphorus thresholds
    NutrientLevel pLevel = NutrientLevel.medium;
    if (data.phosphorus < 10) {
      pLevel = NutrientLevel.low;
    } else if (data.phosphorus > 25) {
      pLevel = NutrientLevel.high;
    }

    // Potassium thresholds
    NutrientLevel kLevel = NutrientLevel.medium;
    if (data.potassium < 110) {
      kLevel = NutrientLevel.low;
    } else if (data.potassium > 280) {
      kLevel = NutrientLevel.high;
    }

    return NutrientAnalysis(
      nitrogenLevel: nLevel,
      phosphorusLevel: pLevel,
      potassiumLevel: kLevel,
    );
  }
}
