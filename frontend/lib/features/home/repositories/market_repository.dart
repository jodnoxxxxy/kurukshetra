
import 'package:kurukshetra/core/network/api_client.dart';
import 'package:kurukshetra/features/home/models/market_price.dart';

abstract class MarketRepository {
  Future<List<MarketPrice>> getCurrentPrices();
  Future<List<Mandi>> getNearbyMandis(String location);
}

class MarketRepositoryImpl implements MarketRepository {
  final _apiClient = ApiClient();

  @override
  Future<List<MarketPrice>> getCurrentPrices() async {
    try {
      final response = await _apiClient.dio.get('/market/prices');
      final data = response.data['data'] as List?;
      
      if (data != null && data.isNotEmpty) {
        return data.map((json) => MarketPrice(
          cropId: json['cropId'],
          cropName: json['cropName'],
          currentPrice: json['currentPrice'].toDouble(),
          percentChange: json['percentChange'].toDouble(),
          mandiName: json['mandiName'],
          updatedAt: DateTime.parse(json['updatedAt']),
        )).toList();
      }
    } catch (e) {
      // API is currently unavailable (No local backend running)
      // We will gracefully fall back to the built-in mock data for a workable experience.
    }

    // Fallback Mock Data returned while backend DB logic is unfinished
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      MarketPrice(
        cropId: 'c1',
        cropName: 'Wheat',
        currentPrice: 2400.0,
        percentChange: 2.5,
        mandiName: 'Pune APMC',
        updatedAt: DateTime.now(),
      ),
      MarketPrice(
        cropId: 'c2',
        cropName: 'Soybean',
        currentPrice: 4200.0,
        percentChange: 1.8,
        mandiName: 'Pune APMC',
        updatedAt: DateTime.now(),
      ),
      MarketPrice(
        cropId: 'c3',
        cropName: 'Sugarcane',
        currentPrice: 3100.0,
        percentChange: -0.5,
        mandiName: 'Pune APMC',
        updatedAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<List<Mandi>> getNearbyMandis(String location) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return [
      Mandi(id: 'm1', name: 'Pune APMC', distance: 12.0, isOpen: true),
      Mandi(id: 'm2', name: 'Vashi APMC', distance: 145.0, isOpen: true),
      Mandi(id: 'm3', name: 'Nashik APMC', distance: 210.0, isOpen: false),
    ];
  }
}
