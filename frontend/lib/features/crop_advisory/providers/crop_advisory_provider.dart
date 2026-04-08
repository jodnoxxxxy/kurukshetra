import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import '../models/crop_recommendation.dart';
import '../models/soil_data.dart';
import '../repositories/crop_advisory_repository.dart';

class CropAdvisoryState {
  final bool isLoading;
  final String? error;
  final SoilType? selectedSoil;
  final WaterAvailability? selectedWater;
  final Map<String, dynamic>? weatherData;
  final List<CropRecommendation> recommendations;
  final CropRecommendation? selectedCrop;

  CropAdvisoryState({
    this.isLoading = false,
    this.error,
    this.selectedSoil,
    this.selectedWater,
    this.weatherData,
    this.recommendations = const [],
    this.selectedCrop,
  });

  CropAdvisoryState copyWith({
    bool? isLoading,
    String? error,
    SoilType? selectedSoil,
    WaterAvailability? selectedWater,
    Map<String, dynamic>? weatherData,
    List<CropRecommendation>? recommendations,
    CropRecommendation? selectedCrop,
  }) {
    return CropAdvisoryState(
      isLoading: isLoading ?? this.isLoading,
      error: error, // Can be null
      selectedSoil: selectedSoil ?? this.selectedSoil,
      selectedWater: selectedWater ?? this.selectedWater,
      weatherData: weatherData ?? this.weatherData,
      recommendations: recommendations ?? this.recommendations,
      selectedCrop: selectedCrop ?? this.selectedCrop,
    );
  }
}

class CropAdvisoryNotifier extends Notifier<CropAdvisoryState> {
  CropAdvisoryRepository get _repository => ref.read(cropAdvisoryRepositoryProvider);

  @override
  CropAdvisoryState build() {
    return CropAdvisoryState();
  }

  void setSoilType(SoilType type) {
    state = state.copyWith(selectedSoil: type);
  }

  void setWaterAvailability(WaterAvailability availability) {
    state = state.copyWith(selectedWater: availability);
  }

  Future<void> fetchLocationAndWeather() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        state = state.copyWith(isLoading: false, error: 'Location services are disabled.');
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          state = state.copyWith(isLoading: false, error: 'Location permissions are denied');
          return;
        }
      }

      Position position = await Geolocator.getCurrentPosition();
      final weather = await _repository.fetchWeatherData(position);
      state = state.copyWith(isLoading: false, weatherData: weather);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> generateRecommendations() async {
    if (state.selectedSoil == null || state.selectedWater == null) {
      state = state.copyWith(error: 'Please select soil type and water availability.');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    final temp = (state.weatherData?['main']?['temp'] ?? 25.0).toDouble();
    final season = _repository.getCurrentSeason();

    final recommendations = await _repository.getRecommendations(
      soilType: state.selectedSoil!,
      waterAvailability: state.selectedWater!,
      currentTemp: temp,
      season: season,
    );

    state = state.copyWith(recommendations: recommendations, isLoading: false);
  }

  void selectCrop(CropRecommendation crop) {
    state = state.copyWith(selectedCrop: crop);
  }
}

final cropAdvisoryRepositoryProvider = Provider((ref) => CropAdvisoryRepository());

final cropAdvisoryProvider = NotifierProvider<CropAdvisoryNotifier, CropAdvisoryState>(CropAdvisoryNotifier.new);
