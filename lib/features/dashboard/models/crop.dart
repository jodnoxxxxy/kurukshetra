class Crop {
  final String id;
  final String name;
  final String farmerId;
  final double acres;
  final DateTime plantedDate;
  final String expectedHarvest;
  
  Crop({
    required this.id,
    required this.name,
    required this.farmerId,
    required this.acres,
    required this.plantedDate,
    required this.expectedHarvest,
  });

  factory Crop.fromJson(Map<String, dynamic> json) {
    return Crop(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      farmerId: json['farmerId'] ?? '',
      acres: (json['acres'] ?? 0).toDouble(),
      plantedDate: DateTime.parse(json['plantedDate'] ?? DateTime.now().toIso8601String()),
      expectedHarvest: json['expectedHarvest'] ?? '',
    );
  }
}

class CropHealth {
  final String cropId;
  final double healthScore;
  final String status;
  final List<String> issues;
  final DateTime lastChecked;

  CropHealth({
    required this.cropId,
    required this.healthScore,
    required this.status,
    required this.issues,
    required this.lastChecked,
  });
}
