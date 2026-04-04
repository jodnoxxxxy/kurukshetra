import 'package:flutter_riverpod/flutter_riverpod.dart';

class FarmerDashboardState {
  final bool isLoading;
  final String? error;

  // 1. Farm Overview
  final double farmAreaAcres;
  final int totalCrops;
  final String currentSeason;
  final String location;

  // 2. My Crops
  final List<Map<String, dynamic>> activeCrops;

  // 3. Crop Health
  final List<Map<String, dynamic>> cropHealthOverview;

  // 4. Soil Health
  final Map<String, String> soilHealth;

  // 5. Organic Score
  final double organicScore;

  // 6. Profit & Loss
  final double totalInvestment;
  final double totalSales;
  final double expectedProfit;

  // 7. Market Prices
  final List<Map<String, dynamic>> marketPrices;

  // 8. AI Crop Recommendation
  final List<Map<String, dynamic>> cropRecommendations;

  FarmerDashboardState({
    this.isLoading = true,
    this.error,
    this.farmAreaAcres = 0.0,
    this.totalCrops = 0,
    this.currentSeason = '',
    this.location = '',
    this.activeCrops = const [],
    this.cropHealthOverview = const [],
    this.soilHealth = const {},
    this.organicScore = 0.0,
    this.totalInvestment = 0.0,
    this.totalSales = 0.0,
    this.expectedProfit = 0.0,
    this.marketPrices = const [],
    this.cropRecommendations = const [],
  });

  FarmerDashboardState copyWith({
    bool? isLoading,
    String? error,
    double? farmAreaAcres,
    int? totalCrops,
    String? currentSeason,
    String? location,
    List<Map<String, dynamic>>? activeCrops,
    List<Map<String, dynamic>>? cropHealthOverview,
    Map<String, String>? soilHealth,
    double? organicScore,
    double? totalInvestment,
    double? totalSales,
    double? expectedProfit,
    List<Map<String, dynamic>>? marketPrices,
    List<Map<String, dynamic>>? cropRecommendations,
  }) {
    return FarmerDashboardState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
      farmAreaAcres: farmAreaAcres ?? this.farmAreaAcres,
      totalCrops: totalCrops ?? this.totalCrops,
      currentSeason: currentSeason ?? this.currentSeason,
      location: location ?? this.location,
      activeCrops: activeCrops ?? this.activeCrops,
      cropHealthOverview: cropHealthOverview ?? this.cropHealthOverview,
      soilHealth: soilHealth ?? this.soilHealth,
      organicScore: organicScore ?? this.organicScore,
      totalInvestment: totalInvestment ?? this.totalInvestment,
      totalSales: totalSales ?? this.totalSales,
      expectedProfit: expectedProfit ?? this.expectedProfit,
      marketPrices: marketPrices ?? this.marketPrices,
      cropRecommendations: cropRecommendations ?? this.cropRecommendations,
    );
  }
}

class DashboardNotifier extends Notifier<FarmerDashboardState> {
  @override
  FarmerDashboardState build() {
    // Schedule load for after the build phase
    Future.microtask(() => _loadDashboardData());
    return FarmerDashboardState();
  }

  Future<void> _loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // API call simulation
      await Future.delayed(const Duration(seconds: 1));

      // MOCk Data aggregated from different conceptual modules
      state = state.copyWith(
        isLoading: false,
        farmAreaAcres: 5.0,
        totalCrops: 3,
        currentSeason: 'Rabi',
        location: 'Khadavali',
        activeCrops: [
          {'name': 'Soybean', 'stage': 'Vegetative', 'days': 25, 'icon': '🌱'},
          {'name': 'Tomato', 'stage': 'Flowering', 'days': 40, 'icon': '🍅'},
          {'name': 'Wheat', 'stage': 'Harvesting', 'days': 90, 'icon': '🌾'},
        ],
        cropHealthOverview: [
          {'name': 'Soybean', 'status': 'Healthy', 'riskLevel': 'Low', 'icon': '🌱'},
          {'name': 'Tomato', 'status': 'Moderate Risk', 'riskLevel': 'Medium', 'icon': '🍅', 'alert': 'High humidity. Risk of blights.'},
        ],
        soilHealth: {
          'Nitrogen (N)': 'Medium',
          'Phosphorus (P)': 'High',
          'Potassium (K)': 'Medium',
          'pH': '6.8 (Optimal)',
        },
        organicScore: 82.0,
        totalInvestment: 20000.0,
        totalSales: 32000.0,
        expectedProfit: 12000.0,
        marketPrices: [
          {'crop': 'Soybean', 'price': '₹5100', 'unit': 'quintal', 'trend': 'up'},
          {'crop': 'Tomato', 'price': '₹32', 'unit': 'kg', 'trend': 'down'},
          {'crop': 'Wheat', 'price': '₹2400', 'unit': 'quintal', 'trend': 'stable'},
        ],
        cropRecommendations: [
          {'crop': 'Soybean', 'suitability': 92, 'reason': 'Optimal soil pH and upcoming monsoon.'},
          {'crop': 'Groundnut', 'suitability': 88, 'reason': 'Good market demand, suitable for sandy loam.'},
          {'crop': 'Ragi', 'suitability': 85, 'reason': 'Drought resistant, good for current soil N levels.'},
        ],
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load dashboard data. Please pull down to refresh.');
    }
  }

  Future<void> refresh() async {
    await _loadDashboardData();
  }
}

final dashboardProvider = NotifierProvider<DashboardNotifier, FarmerDashboardState>(
  DashboardNotifier.new,
);
