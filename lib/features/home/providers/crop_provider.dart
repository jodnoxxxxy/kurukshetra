import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kurukshetra/features/home/models/crop.dart';
import 'package:kurukshetra/features/home/repositories/crop_repository.dart';

final cropRepositoryProvider = Provider<CropRepository>((ref) {
  return CropRepositoryImpl();
});

class CropState {
  final List<dynamic> crops;
  final bool isLoading;
  final String? error;
  final List<dynamic> availableCrops;
  final List<dynamic> marketPrices;
  final List<dynamic> pestDiseaseAlerts;

  CropState({
    this.crops = const [],
    this.isLoading = false,
    this.error,
    this.availableCrops = const [],
    this.marketPrices = const [],
    this.pestDiseaseAlerts = const [],
  });

  CropState copyWith({
    List<dynamic>? crops,
    bool? isLoading,
    String? error,
    List<dynamic>? availableCrops,
    List<dynamic>? marketPrices,
    List<dynamic>? pestDiseaseAlerts,
  }) {
    return CropState(
      crops: crops ?? this.crops,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      availableCrops: availableCrops ?? this.availableCrops,
      marketPrices: marketPrices ?? this.marketPrices,
      pestDiseaseAlerts: pestDiseaseAlerts ?? this.pestDiseaseAlerts,
    );
  }

  List<dynamic> getActiveCrops() {
    return crops.where((crop) => crop['status'] != 'harvested').toList();
  }

  List<dynamic> getReadyToHarvest() {
    return crops.where((crop) => crop['status'] == 'ready').toList();
  }
}

// ---------------------------------------------------------------------------
// MyCropState — simple state for the home screen My Crops card
// ---------------------------------------------------------------------------

class MyCropState {
  final List<CropModel> myCrops;
  final bool isLoading;
  final String? error;

  MyCropState({
    this.myCrops = const [],
    this.isLoading = false,
    this.error,
  });

  MyCropState copyWith({
    List<CropModel>? myCrops,
    bool? isLoading,
    String? error,
  }) {
    return MyCropState(
      myCrops: myCrops ?? this.myCrops,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// ---------------------------------------------------------------------------
// CropNotifier — full crop management with backend repo
// ---------------------------------------------------------------------------

class CropNotifier extends Notifier<CropState> {
  late final CropRepository _repository;

  @override
  CropState build() {
    _repository = ref.read(cropRepositoryProvider);
    _loadData();
    return CropState(isLoading: true);
  }

  Future<void> _loadData() async {
    try {
      final crops = await _repository.getCrops();
      final availableCrops = await _repository.getAvailableCrops();
      final marketPrices = await _repository.getMarketPrices();
      final pestDiseaseAlerts = await _repository.getPestDiseaseAlerts();

      state = state.copyWith(
        crops: crops,
        availableCrops: availableCrops,
        marketPrices: marketPrices,
        pestDiseaseAlerts: pestDiseaseAlerts,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> addCrop({
    required String name,
    required String icon,
    required DateTime sowingDate,
    required double area,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final newCrop = Crop(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        icon: icon,
        sowingDate: sowingDate,
        expectedHarvestDate: sowingDate.add(const Duration(days: 120)),
        status: 'growing',
        area: area,
        areaUnit: 'Acres',
        notes: [],
      );
      await _repository.addCrop(newCrop);
      final updatedCrops = [...state.crops, newCrop];
      state = state.copyWith(crops: updatedCrops, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> updateCrop(Crop crop) async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.updateCrop(crop);
      final updatedCrops = state.crops.map((c) {
        final existing = c as Crop;
        return existing.id == crop.id ? crop : existing;
      }).toList();
      state = state.copyWith(crops: updatedCrops, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> deleteCrop(String cropId) async {
    state = state.copyWith(isLoading: true);
    try {
      await _repository.deleteCrop(cropId);
      final updatedCrops = state.crops
          .where((c) => (c as Crop).id != cropId)
          .toList();
      state = state.copyWith(crops: updatedCrops, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  MarketPrice? getMarketPriceForCrop(String cropName) {
    try {
      return state.marketPrices.firstWhere(
        (mp) => (mp as MarketPrice).cropName.toLowerCase() == cropName.toLowerCase(),
      ) as MarketPrice;
    } catch (_) {
      return null;
    }
  }

  Future<void> refresh() async {
    state = state.copyWith(isLoading: true);
    await _loadData();
  }
}

// ---------------------------------------------------------------------------
// MyCropNotifier — persists farmer's personal crops via SharedPreferences
// ---------------------------------------------------------------------------

const _kMyCropsKey = 'my_crops_data';

class MyCropNotifier extends Notifier<MyCropState> {
  @override
  MyCropState build() {
    _loadCrops();
    return MyCropState(isLoading: true);
  }

  Future<void> _loadCrops() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_kMyCropsKey);

      List<CropModel> savedCrops = [];
      if (raw != null) {
        final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
        savedCrops = decoded.map((e) => CropModel.fromJson(e as Map<String, dynamic>)).toList();
      }

      // Seed with example data only if nothing saved yet
      if (savedCrops.isEmpty) {
        savedCrops = [
          CropModel(
            id: '1',
            name: 'Ragi',
            sowingDate: DateTime.now().subtract(const Duration(days: 30)),
            farmerId: 'farmer_001',
          ),
          CropModel(
            id: '2',
            name: 'Soybean',
            sowingDate: DateTime.now().subtract(const Duration(days: 45)),
            farmerId: 'farmer_001',
          ),
        ];
        // Persist the seed data
        await _persist(savedCrops);
      }

      state = state.copyWith(myCrops: savedCrops, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> addCrop(String cropName, DateTime sowingDate) async {
    state = state.copyWith(isLoading: true);
    try {
      final newCrop = CropModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: cropName,
        sowingDate: sowingDate,
        farmerId: 'farmer_001',
      );
      final updatedCrops = [...state.myCrops, newCrop];
      await _persist(updatedCrops);
      state = state.copyWith(myCrops: updatedCrops, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  Future<void> deleteCrop(String cropId) async {
    state = state.copyWith(isLoading: true);
    try {
      final updatedCrops = state.myCrops.where((crop) => crop.id != cropId).toList();
      await _persist(updatedCrops);
      state = state.copyWith(myCrops: updatedCrops, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  /// Serialise and save the crop list to SharedPreferences.
  Future<void> _persist(List<CropModel> crops) async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(crops.map((c) => c.toJson()).toList());
    await prefs.setString(_kMyCropsKey, encoded);
  }
}

// ---------------------------------------------------------------------------
// Providers
// ---------------------------------------------------------------------------

final cropProvider = NotifierProvider<CropNotifier, CropState>(CropNotifier.new);
final myCropProvider = NotifierProvider<MyCropNotifier, MyCropState>(MyCropNotifier.new);
