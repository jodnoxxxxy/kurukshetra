import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../calculator/models/calculator_models.dart';

// Represents the global, reactive Single Source of Truth for Farm Data
class FarmDataState {
  final Map<String, double> soilNutrients;
  final double fertilizerRequiredKg;
  final double expectedYieldQuintals;
  final double marketPricePerQuintal;
  final List<Transaction> operationalCosts;
  
  FarmDataState({
    this.soilNutrients = const {'N': 0.0, 'P': 0.0, 'K': 0.0},
    this.fertilizerRequiredKg = 0.0,
    this.expectedYieldQuintals = 0.0,
    this.marketPricePerQuintal = 0.0,
    this.operationalCosts = const [],
  });

  double get totalCost => operationalCosts.fold(0.0, (sum, t) => sum + t.amount);
  double get estimatedRevenue => expectedYieldQuintals * marketPricePerQuintal;
  double get netProfit => estimatedRevenue - totalCost;

  FarmDataState copyWith({
    Map<String, double>? soilNutrients,
    double? fertilizerRequiredKg,
    double? expectedYieldQuintals,
    double? marketPricePerQuintal,
    List<Transaction>? operationalCosts,
  }) {
    return FarmDataState(
      soilNutrients: soilNutrients ?? this.soilNutrients,
      fertilizerRequiredKg: fertilizerRequiredKg ?? this.fertilizerRequiredKg,
      expectedYieldQuintals: expectedYieldQuintals ?? this.expectedYieldQuintals,
      marketPricePerQuintal: marketPricePerQuintal ?? this.marketPricePerQuintal,
      operationalCosts: operationalCosts ?? this.operationalCosts,
    );
  }
}

class FarmDataNotifier extends Notifier<FarmDataState> {
  @override
  FarmDataState build() {
    return FarmDataState();
  }

  void updateSoil(double n, double p, double k) {
    // Cascading logic: updating soil updates fertilizer need implicitly
    // Assume simple logic for demonstration: Ideal NPK is 100, 50, 100 respectively.
    // If deficit, we need fertilizer. 1 kg of fertilizer provides approx 1 unit of combined nutrient.
    final deficitN = 100 - n;
    final deficitP = 50 - p;
    final deficitK = 100 - k;
    
    final fertilizer = (deficitN > 0 ? deficitN : 0) + 
                       (deficitP > 0 ? deficitP : 0) + 
                       (deficitK > 0 ? deficitK : 0);
                       
    state = state.copyWith(
      soilNutrients: {'N': n, 'P': p, 'K': k},
      fertilizerRequiredKg: fertilizer.toDouble(),
    );
  }

  void updateMarketPrice(double price) {
    state = state.copyWith(marketPricePerQuintal: price);
  }
  
  void updateExpectedYield(double yieldAmount) {
    state = state.copyWith(expectedYieldQuintals: yieldAmount);
  }

  void addOperationalCost(Transaction cost) {
    state = state.copyWith(
      operationalCosts: [...state.operationalCosts, cost]
    );
  }

  void removeCost(String id) {
    state = state.copyWith(
      operationalCosts: state.operationalCosts.where((t) => t.id != id).toList()
    );
  }
}

final farmDataProvider = NotifierProvider<FarmDataNotifier, FarmDataState>(FarmDataNotifier.new);
