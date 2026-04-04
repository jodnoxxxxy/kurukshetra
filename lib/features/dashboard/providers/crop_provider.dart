import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/features/dashboard/models/crop.dart';
import 'package:kurukshetra/features/dashboard/repositories/crop_repository.dart';

final cropRepositoryProvider = Provider<CropRepository>((ref) {
  return CropRepositoryImpl();
});

class CropData {
  final Crop crop;
  final CropHealth? healthStatus;
  
  CropData({
    required this.crop,
    this.healthStatus,
  });
}

// Active crops
final plantedCropsProvider = FutureProvider<List<Crop>>((ref) async {
  final repository = ref.read(cropRepositoryProvider);
  return repository.getPlantedCrops('FM-1234'); // Expected current Farmer ID
});

// Single crop health
final cropHealthProvider = FutureProvider.family<CropHealth, String>((ref, cropId) async {
  final repository = ref.read(cropRepositoryProvider);
  return repository.getHealthStatus(cropId);
});

// Harvest predictions
final harvestPredictionProvider = FutureProvider.family<String, String>((ref, cropId) async {
  await Future.delayed(const Duration(milliseconds: 300));
  if (cropId == 'c1') return 'Expected Yield: 35 quintals';
  return 'Expected Yield: 120 tonnes';
});
