import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/sop_model.dart';
import '../repositories/sop_repository.dart';

final sopRepositoryProvider = Provider<SopRepository>((ref) {
  return SopRepositoryImpl();
});

final sopCategoriesProvider = FutureProvider<List<SopCategory>>((ref) {
  return ref.watch(sopRepositoryProvider).getCategories();
});

class SelectedSopCropNotifier extends Notifier<SopCrop?> {
  @override
  SopCrop? build() => null;
  void setCrop(SopCrop? crop) => state = crop;
}

final selectedSopCropProvider = NotifierProvider<SelectedSopCropNotifier, SopCrop?>(SelectedSopCropNotifier.new);

final sopStepsProvider = FutureProvider<SopData?>((ref) {
  final crop = ref.watch(selectedSopCropProvider);
  if (crop == null) return Future.value(null);
  
  return ref.watch(sopRepositoryProvider).getSopForCrop(crop.id);
});

class SelectedSopStepNotifier extends Notifier<SopStep?> {
  @override
  SopStep? build() => null;
  void setStep(SopStep? step) => state = step;
}

final selectedSopStepProvider = NotifierProvider<SelectedSopStepNotifier, SopStep?>(SelectedSopStepNotifier.new);
