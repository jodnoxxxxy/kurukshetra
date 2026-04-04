import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kurukshetra/features/profile/providers/profile_provider.dart';
import 'package:kurukshetra/features/home/providers/crop_provider.dart';
import 'package:kurukshetra/features/profile/repositories/profile_repository.dart';
import 'package:kurukshetra/features/home/repositories/crop_repository.dart';

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
    // Watch providers to trigger rebuilds on data changes
    ref.listen(profileProvider, (previous, next) {
      _loadDashboardData();
    });
    ref.listen(cropProvider, (previous, next) {
      _loadDashboardData();
    });

    // Schedule load for after the build phase
    Future.microtask(() => _loadDashboardData());
    return FarmerDashboardState();
  }

  Future<void> _loadDashboardData() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token') ?? 'demo_farmer';
      
      final profileRepo = ref.read(profileRepositoryProvider);
      final cropRepo = ref.read(cropRepositoryProvider);

      // Fetch Profile and Crops in parallel
      final results = await Future.wait([
        profileRepo.getFarmerProfile(),
        cropRepo.getCrops(),
        cropRepo.getMarketPrices(),
      ]);

      final profile = results[0] as dynamic; // FarmerProfile
      final realCrops = results[1] as List<dynamic>; // List<Crop>
      final marketPrices = results[2] as List<dynamic>; // List<MarketPrice>

      // Map backend crops to dashboard format
      final activeCrops = realCrops.map((c) => {
        'id': c.id,
        'name': c.name,
        'stage': c.status == 'growing' ? 'Vegetative' : 'Growing',
        'days': DateTime.now().difference(c.sowingDate).inDays,
        'icon': c.icon,
      }).toList();

      final cropHealth = realCrops.map((c) => {
        'name': c.name,
        'status': 'Healthy',
        'riskLevel': 'Low',
        'icon': c.icon,
      }).toList();

      // Fetch financial analytics from backend
      try {
        final analyticsRes = await http.get(
          Uri.parse('http://localhost:5000/api/v1/farmers/analytics'),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ).timeout(const Duration(seconds: 10));

        if (analyticsRes.statusCode == 200) {
          final analyticsRaw = jsonDecode(analyticsRes.body)['data'];
          state = state.copyWith(
            totalInvestment: (analyticsRaw['totalInvestment'] as num).toDouble(),
            totalSales: (analyticsRaw['totalSales'] as num).toDouble(),
            expectedProfit: (analyticsRaw['expectedProfit'] as num).toDouble(),
            organicScore: (analyticsRaw['organicScore'] as num).toDouble(),
          );
        }
      } catch (analyticsError) {
        print('Analytics fetch failed: $analyticsError');
      }

      state = state.copyWith(
        isLoading: false,
        farmAreaAcres: profile.farmArea,
        totalCrops: realCrops.length,
        currentSeason: 'Current',
        location: profile.location,
        activeCrops: activeCrops,
        cropHealthOverview: cropHealth,
        organicScore: profile.organicScore,
        marketPrices: marketPrices.map((m) => {
          'crop': m.cropName,
          'price': '₹${m.pricePerQuintal.toInt()}',
          'unit': 'quintal',
          'trend': m.trend,
        }).toList(),
        soilHealth: {
          'Nitrogen (N)': 'Optimal',
          'Phosphorus (P)': 'Good',
          'Potassium (K)': 'Optimal',
          'pH': '6.5',
        },
      );
    } catch (e) {
      print('Dashboard error: $e');
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
