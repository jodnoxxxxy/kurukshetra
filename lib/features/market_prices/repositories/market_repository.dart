import '../models/market_price_model.dart';
import 'package:kurukshetra/core/network/api_client.dart';

abstract class MarketPricesRepository {
  Future<List<MarketCrop>> getMarketCrops();
  Future<List<MarketPriceData>> getMarketPricesForCrop(String cropId);
  Future<List<PriceTrendData>> getPriceTrends(String marketId, String cropId);
}

class MarketPricesRepositoryImpl implements MarketPricesRepository {
  // ignore: unused_field
  final _apiClient = ApiClient();

  final List<MarketCrop> _mockCrops = [
    MarketCrop(id: 'c1', name: 'wheat', category: 'categoryCereals', iconStr: '🌾'),
    MarketCrop(id: 'c2', name: 'rice', category: 'categoryCereals', iconStr: '🍚'),
    MarketCrop(id: 'c3', name: 'maize', category: 'categoryCereals', iconStr: '🌽'),
    MarketCrop(id: 'c4', name: 'gram', category: 'categoryPulses', iconStr: '🌰'),
    MarketCrop(id: 'c5', name: 'blackGram', category: 'categoryPulses', iconStr: '🫘'),
    MarketCrop(id: 'c6', name: 'greenGram', category: 'categoryPulses', iconStr: '🌱'),
    MarketCrop(id: 'c7', name: 'soybean', category: 'categoryOilseeds', iconStr: '🫛'),
    MarketCrop(id: 'c8', name: 'groundnut', category: 'categoryOilseeds', iconStr: '🥜'),
    MarketCrop(id: 'c9', name: 'sunflower', category: 'categoryOilseeds', iconStr: '🌻'),
    MarketCrop(id: 'c10', name: 'tomato', category: 'categoryVegetables', iconStr: '🍅'),
    MarketCrop(id: 'c11', name: 'onion', category: 'categoryVegetables', iconStr: '🧅'),
    MarketCrop(id: 'c12', name: 'potato', category: 'categoryVegetables', iconStr: '🥔'),
    MarketCrop(id: 'c13', name: 'apple', category: 'categoryFruits', iconStr: '🍎'),
    MarketCrop(id: 'c14', name: 'banana', category: 'categoryFruits', iconStr: '🍌'),
  ];

  @override
  Future<List<MarketCrop>> getMarketCrops() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockCrops;
  }

  @override
  Future<List<MarketPriceData>> getMarketPricesForCrop(String cropId) async {
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Generating mock pricing logic based on a base value
    int basePrice = 4500;
    if (cropId == 'c1') {
      basePrice = 2200; // Wheat
    } else if (cropId == 'c7') {
      basePrice = 4800; // Soybean
    } else if (cropId == 'c10') {
      basePrice = 1800; // Tomato
    } else if (cropId == 'c11') {
      basePrice = 2500; // Onion
    } else if (cropId == 'c12') {
      basePrice = 1200; // Potato
    } else if (cropId == 'c13') {
      basePrice = 8500; // Apple
    } else if (cropId == 'c14') {
      basePrice = 3000; // Banana
    }

    return [
      MarketPriceData(
        id: 'm1',
        marketName: 'Pune APMC',
        address: 'Gultekdi, Pune, Maharashtra',
        distanceKm: 25.5,
        minPrice: basePrice,
        maxPrice: basePrice + 400,
        modalPrice: basePrice + 200,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      MarketPriceData(
        id: 'm2',
        marketName: 'Nashik Mandi',
        address: 'Panchavati, Nashik, Maharashtra',
        distanceKm: 180.2,
        minPrice: basePrice - 100,
        maxPrice: basePrice + 500,
        modalPrice: basePrice + 300,
        lastUpdated: DateTime.now().subtract(const Duration(hours: 5)),
      ),
      MarketPriceData(
        id: 'm3',
        marketName: 'Nagpur APMC',
        address: 'Kalamna Market, Nagpur, Maharashtra',
        distanceKm: 420.0,
        minPrice: basePrice - 200,
        maxPrice: basePrice + 200,
        modalPrice: basePrice,
        lastUpdated: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  Future<List<PriceTrendData>> getPriceTrends(String marketId, String cropId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    List<PriceTrendData> trends = [];
    DateTime now = DateTime.now();
    int base = 4800;

    if (cropId == 'c1') {
      base = 2100;
    } else if (cropId == 'c10') {
      base = 1750;
    } else if (cropId == 'c11') {
      base = 2400;
    } else if (cropId == 'c13') {
      base = 8300;
    }
    
    // Simulate last 7 days trends
    for (int i = 6; i >= 0; i--) {
      trends.add(
        PriceTrendData(
          date: now.subtract(Duration(days: i)),
          price: base + (i % 2 == 0 ? 100 : -50) + (i * 20),
        )
      );
    }
    return trends;
  }
}
