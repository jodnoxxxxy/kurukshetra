import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/climate_service.dart';
import '../models/climate_model.dart';

final climateServiceProvider = Provider((ref) => ClimateService());

// Real-time weather and risk analysis cache
final climateAdvisoryProvider = FutureProvider.autoDispose<ClimateAdvisoryResponse>((ref) async {
  final service = ref.watch(climateServiceProvider);
  return await service.fetchClimateAdvisory();
});
