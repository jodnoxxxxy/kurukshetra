import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kurukshetra/features/ai/crop/models/crop_inspection.dart';
import 'package:kurukshetra/features/ai/crop/repositories/crop_inspection_repository.dart';

class SelectedInspectionFieldNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void setFieldId(String? fieldId) => state = fieldId;
}

final selectedInspectionFieldProvider =
    NotifierProvider<SelectedInspectionFieldNotifier, String?>(
  SelectedInspectionFieldNotifier.new,
);

final latestInspectionProvider =
    FutureProvider.autoDispose.family<CropInspection?, String?>((ref, fieldId) async {
  if (fieldId == null || fieldId.isEmpty) return null;
  final repo = ref.watch(cropInspectionRepositoryProvider);
  return repo.getLatestInspection(fieldId);
});

final fieldInspectionsProvider =
    FutureProvider.autoDispose.family<List<CropInspection>, String>((ref, fieldId) async {
  final repo = ref.watch(cropInspectionRepositoryProvider);
  return repo.getInspectionsByField(fieldId);
});

final inspectionByIdProvider =
    FutureProvider.autoDispose.family<CropInspection, String>((ref, inspectionId) async {
  final repo = ref.watch(cropInspectionRepositoryProvider);
  return repo.getInspectionById(inspectionId);
});

final farmInspectionSummaryProvider =
    FutureProvider.autoDispose.family<Map<String, dynamic>, String>((ref, farmId) async {
  final repo = ref.watch(cropInspectionRepositoryProvider);
  return repo.getFarmInspectionSummary(farmId);
});
