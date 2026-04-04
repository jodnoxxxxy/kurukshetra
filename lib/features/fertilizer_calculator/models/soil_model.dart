class SoilData {
  final String crop;
  final double area;
  final String unit;
  final double nitrogen;
  final double phosphorus;
  final double potassium;

  SoilData({
    required this.crop,
    required this.area,
    required this.unit,
    required this.nitrogen,
    required this.phosphorus,
    required this.potassium,
  });
}

enum NutrientLevel { low, medium, high }

class NutrientAnalysis {
  final NutrientLevel nitrogenLevel;
  final NutrientLevel phosphorusLevel;
  final NutrientLevel potassiumLevel;

  NutrientAnalysis({
    required this.nitrogenLevel,
    required this.phosphorusLevel,
    required this.potassiumLevel,
  });
}
