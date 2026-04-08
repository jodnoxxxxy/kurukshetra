import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pest_model.dart';
import '../repositories/pest_repository.dart';

final pestRepositoryProvider = Provider<PestRepository>((ref) {
  return PestRepositoryImpl();
});

final pestLibraryProvider = FutureProvider<List<PestInfo>>((ref) async {
  final repo = ref.watch(pestRepositoryProvider);
  final response = await repo.getPestLibrary();
  if (response.hasError) throw Exception(response.error);
  return response.data!;
});

class CurrentDetectionNotifier extends Notifier<DetectionResult?> {
  @override
  DetectionResult? build() => null;
  void setResult(DetectionResult? result) => state = result;
  void clear() => state = null;
}

final currentDetectionProvider = NotifierProvider<CurrentDetectionNotifier, DetectionResult?>(CurrentDetectionNotifier.new);

class SelectedPestNotifier extends Notifier<PestInfo?> {
  @override
  PestInfo? build() => null;
  void setPest(PestInfo? pest) => state = pest;
}

final selectedPestProvider = NotifierProvider<SelectedPestNotifier, PestInfo?>(SelectedPestNotifier.new);
