import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/pest_model.dart';
import '../repositories/pest_repository.dart';

final pestDiseaseRepoProvider = Provider<PestDiseaseRepository>((ref) {
  return PestDiseaseRepositoryImpl();
});

class SelectedPestCropNotifier extends Notifier<PestCrop?> {
  @override
  PestCrop? build() => null;
  void setCrop(PestCrop? crop) => state = crop;
}

final selectedPestCropProvider = NotifierProvider<SelectedPestCropNotifier, PestCrop?>(SelectedPestCropNotifier.new);

class SelectedPestDiseaseNotifier extends Notifier<PestDisease?> {
  @override
  PestDisease? build() => null;
  void setPest(PestDisease? pest) => state = pest;
}

final selectedPestDiseaseProvider = NotifierProvider<SelectedPestDiseaseNotifier, PestDisease?>(SelectedPestDiseaseNotifier.new);

final pestDiseaseCropsProvider = FutureProvider<List<PestCrop>>((ref) async {
  return ref.watch(pestDiseaseRepoProvider).getCrops();
});

final pestListByCropProvider = FutureProvider<List<PestDisease>>((ref) async {
  final crop = ref.watch(selectedPestCropProvider);
  if (crop == null) return [];
  
  return ref.watch(pestDiseaseRepoProvider).getPestsForCrop(crop.id);
});
