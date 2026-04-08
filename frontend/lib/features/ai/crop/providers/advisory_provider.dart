import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/crop_advisory.dart';
import '../repositories/advisory_repository.dart';

final advisoryRepositoryProvider = Provider<AdvisoryRepository>((ref) {
  return AdvisoryRepositoryImpl();
});

final cropCategoriesProvider = FutureProvider<List<CropCategory>>((ref) {
  final repo = ref.watch(advisoryRepositoryProvider);
  return repo.getCropCategories();
});

class SelectedCropNotifier extends Notifier<CropInfo?> {
  @override
  CropInfo? build() => null;
  void setCrop(CropInfo? crop) => state = crop;
}

final selectedCropProvider = NotifierProvider<SelectedCropNotifier, CropInfo?>(SelectedCropNotifier.new);

class SelectedSowingDateNotifier extends Notifier<DateTime?> {
  @override
  DateTime? build() => null;
  void setDate(DateTime? date) => state = date;
}

final selectedSowingDateProvider = NotifierProvider<SelectedSowingDateNotifier, DateTime?>(SelectedSowingDateNotifier.new);

final cropStagesProvider = FutureProvider<List<CropStage>>((ref) {
  final crop = ref.watch(selectedCropProvider);
  if (crop == null) return Future.value([]);
  
  final repo = ref.watch(advisoryRepositoryProvider);
  return repo.getCropStages(crop.id);
});

final currentStageDayProvider = Provider<int>((ref) {
  final sowingDate = ref.watch(selectedSowingDateProvider);
  if (sowingDate == null) return 0;
  
  final now = DateTime.now();
  final difference = now.difference(sowingDate).inDays;
  return difference < 0 ? 0 : difference;
});
