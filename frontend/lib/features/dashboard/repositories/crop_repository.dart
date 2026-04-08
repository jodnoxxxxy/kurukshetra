import 'package:kurukshetra/features/dashboard/models/crop.dart';

abstract class CropRepository {
  Future<List<Crop>> getPlantedCrops(String farmerId);
  Future<CropHealth> getHealthStatus(String cropId);
  Future<void> addCrop(Crop crop);
}

class CropRepositoryImpl implements CropRepository {
  @override
  Future<List<Crop>> getPlantedCrops(String farmerId) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      Crop(
        id: 'c1',
        name: 'Wheat',
        farmerId: farmerId,
        acres: 2.5,
        plantedDate: DateTime.now().subtract(const Duration(days: 45)),
        expectedHarvest: 'April 2026',
      ),
      Crop(
        id: 'c2',
        name: 'Sugarcane',
        farmerId: farmerId,
        acres: 3.5,
        plantedDate: DateTime.now().subtract(const Duration(days: 120)),
        expectedHarvest: 'December 2026',
      ),
    ];
  }

  @override
  Future<CropHealth> getHealthStatus(String cropId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (cropId == 'c1') {
      return CropHealth(
        cropId: cropId,
        healthScore: 85.0,
        status: 'Excellent',
        issues: [],
        lastChecked: DateTime.now(),
      );
    }
    return CropHealth(
      cropId: cropId,
      healthScore: 60.0,
      status: 'Good',
      issues: ['Mild nitrogen deficiency'],
      lastChecked: DateTime.now(),
    );
  }

  @override
  Future<void> addCrop(Crop crop) async {
    await Future.delayed(const Duration(milliseconds: 800));
    // Implementation for adding a crop will go here
  }
}
