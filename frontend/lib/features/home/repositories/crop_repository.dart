import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kurukshetra/features/home/models/crop.dart';

abstract class CropRepository {
  Future<List<Crop>> getCrops();
  Future<void> addCrop(Crop crop);
  Future<void> updateCrop(Crop crop);
  Future<void> deleteCrop(String cropId);
  Future<List<CropInfo>> getAvailableCrops();
  Future<List<MarketPrice>> getMarketPrices();
  Future<List<PestDiseaseAlert>> getPestDiseaseAlerts();
}

class CropRepositoryImpl implements CropRepository {
  final String _baseUrl = 'http://localhost:5000/api/v1/farmers';

  @override
  Future<List<Crop>> getCrops() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null || token == 'demo_farmer') return [];

      final response = await http.get(
        Uri.parse('$_baseUrl/farms'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> farms = jsonDecode(response.body)['data']['farms'];
        final List<Crop> allCrops = [];
        
        for (var farm in farms) {
          final List<dynamic> crops = farm['crops'] ?? [];
          for (var cropData in crops) {
            allCrops.add(Crop(
              id: cropData['id'],
              name: cropData['cropName'],
              icon: '🌾', // Default icon for backend crops
              sowingDate: DateTime.tryParse(cropData['plantingDate'] ?? '') ?? DateTime.now(),
              expectedHarvestDate: DateTime.tryParse(cropData['expectedHarvest'] ?? '') ?? DateTime.now(),
              status: cropData['status'] ?? 'growing',
              area: double.tryParse(farm['areaAcres']?.toString() ?? '1.0') ?? 1.0,
            ));
          }
        }
        return allCrops;
      }
      return [];
    } catch (e) {
      print("Error fetching crops: $e");
      return [];
    }
  }

  @override
  Future<void> addCrop(Crop crop) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null || token == 'demo_farmer') return;

      final response = await http.post(
        Uri.parse('$_baseUrl/farms/default/crops'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'cropName': crop.name,
          'plantingDate': crop.sowingDate.toIso8601String(),
          'expectedHarvest': crop.expectedHarvestDate?.toIso8601String(),
          'areaPlanted': crop.area,
          'status': crop.status,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 201) {
        throw Exception('Failed to add crop: ${response.statusCode}');
      }
      print('Crop added successfully to backend');
    } catch (e) {
      print("Error adding crop: $e");
      throw e;
    }
  }

  @override
  Future<void> updateCrop(Crop crop) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null || token == 'demo_farmer') return;

      final response = await http.put(
        Uri.parse('$_baseUrl/crops/${crop.id}'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'cropName': crop.name,
          'plantingDate': crop.sowingDate.toIso8601String(),
          'areaPlanted': crop.area,
          'status': crop.status,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to update crop: ${response.statusCode}');
      }
      print('Crop updated successfully on backend');
    } catch (e) {
      print("Error updating crop: $e");
      throw e;
    }
  }

  @override
  Future<void> deleteCrop(String cropId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      if (token == null || token == 'demo_farmer') return;

      final response = await http.delete(
        Uri.parse('$_baseUrl/crops/$cropId'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Failed to delete crop: ${response.statusCode}');
      }
      print('Crop deleted successfully from backend');
    } catch (e) {
      print("Error deleting crop: $e");
      throw e;
    }
  }

  @override
  Future<List<CropInfo>> getAvailableCrops() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return [
      CropInfo(
        name: 'Wheat',
        icon: '🌾',
        description: 'Wheat is a cereal grain widely grown for its seed, a staple food worldwide.',
        requirements: ['Well-drained soil', 'Moderate temperature', '6-8 hours sunlight'],
        growingPeriodDays: 120,
        bestSeason: 'Rabi',
        waterRequirement: 450.0,
        commonPests: ['Aphids', 'Armyworms', 'Hessian Fly'],
        commonDiseases: ['Wheat Rust', 'Powdery Mildew', 'Septoria'],
        fertilizers: ['Urea', 'DAP', 'MOP'],
      ),
      CropInfo(
        name: 'Rice',
        icon: '🌾',
        description: 'Rice is the seed of grass species, serving as a staple food for over half of the world\'s population.',
        requirements: ['Flooded fields', 'High humidity', 'Warm temperature'],
        growingPeriodDays: 140,
        bestSeason: 'Kharif',
        waterRequirement: 1200.0,
        commonPests: ['Brown Planthopper', 'Rice Hispa', 'Stem Borer'],
        commonDiseases: ['Blast', 'Bacterial Leaf Blight', 'Sheath Blight'],
        fertilizers: ['Urea', 'DAP', 'MOP'],
      ),
      CropInfo(
        name: 'Soybean',
        icon: '🫘',
        description: 'Soybean is a species of legume native to East Asia, widely grown for its edible bean.',
        requirements: ['Well-drained soil', 'Moderate rainfall', 'Warm temperature'],
        growingPeriodDays: 100,
        bestSeason: 'Kharif',
        waterRequirement: 350.0,
        commonPests: ['Soybean Aphid', 'Corn Earworm', 'Stink Bug'],
        commonDiseases: ['Soybean Cyst Nematode', 'Phytophthora Root Rot', 'Sudden Death Syndrome'],
        fertilizers: ['DAP', 'MOP', 'Gypsum'],
      ),
      CropInfo(
        name: 'Cotton',
        icon: '🌿',
        description: 'Cotton is a soft, fluffy staple fiber that grows in a boll around the seeds of cotton plants.',
        requirements: ['Black soil', 'High temperature', 'Low humidity'],
        growingPeriodDays: 160,
        bestSeason: 'Kharif',
        waterRequirement: 550.0,
        commonPests: ['Bollworm', 'Aphids', 'Whitefly'],
        commonDiseases: ['Boll Rot', 'Leaf Curl Virus', 'Wilt'],
        fertilizers: ['Urea', 'DAP', 'MOP', 'Zinc Sulphate'],
      ),
      CropInfo(
        name: 'Sugarcane',
        icon: '🎋',
        description: 'Sugarcane is a species of tall perennial grasses used for sugar production.',
        requirements: ['Deep soil', 'High rainfall', 'Warm temperature'],
        growingPeriodDays: 365,
        bestSeason: 'Perennial',
        waterRequirement: 1500.0,
        commonPests: ['Early Shoot Borer', 'Pyrilla', 'Whitefly'],
        commonDiseases: ['Red Rot', 'Smut', 'Grassy Shoot Disease'],
        fertilizers: ['Urea', 'DAP', 'MOP', 'Zinc Sulphate'],
      ),
      CropInfo(
        name: 'Maize',
        icon: '🌽',
        description: 'Maize, also known as corn, is a cereal grain first domesticated by indigenous peoples in southern Mexico.',
        requirements: ['Well-drained soil', 'Moderate rainfall', 'Warm temperature'],
        growingPeriodDays: 90,
        bestSeason: 'Kharif',
        waterRequirement: 400.0,
        commonPests: ['Fall Armyworm', 'Corn Earworm', 'Aphids'],
        commonDiseases: ['Northern Leaf Blight', 'Gray Leaf Spot', 'Common Rust'],
        fertilizers: ['Urea', 'DAP', 'MOP'],
      ),
      CropInfo(
        name: 'Ragi',
        icon: '🌱',
        description: 'Ragi, also known as finger millet, is an annual herbaceous plant widely grown as a cereal crop.',
        requirements: ['Well-drained soil', 'Moderate rainfall', 'Warm temperature'],
        growingPeriodDays: 110,
        bestSeason: 'Kharif',
        waterRequirement: 300.0,
        commonPests: ['Shoot Fly', 'Blast', 'Termites'],
        commonDiseases: ['Blast', 'Brown Spot', 'Leaf Blight'],
        fertilizers: ['Urea', 'DAP', 'MOP'],
      ),
      CropInfo(
        name: 'Bajra',
        icon: '🌾',
        description: 'Bajra, also known as pearl millet, is the most widely grown type of millet.',
        requirements: ['Sandy soil', 'Low rainfall', 'High temperature'],
        growingPeriodDays: 85,
        bestSeason: 'Kharif',
        waterRequirement: 250.0,
        commonPests: ['Shoot Fly', 'Earhead Bug', 'Grasshopper'],
        commonDiseases: ['Downy Mildew', 'Ergot', 'Smut'],
        fertilizers: ['Urea', 'DAP', 'MOP'],
      ),
      CropInfo(
        name: 'Jowar',
        icon: '🌾',
        description: 'Jowar, also known as sorghum, is a genus of flowering plants in the grass family.',
        requirements: ['Well-drained soil', 'Moderate rainfall', 'Warm temperature'],
        growingPeriodDays: 95,
        bestSeason: 'Kharif',
        waterRequirement: 350.0,
        commonPests: ['Shoot Fly', 'Sorghum Midge', 'Aphids'],
        commonDiseases: ['Grain Smut', 'Leaf Blight', 'Rust'],
        fertilizers: ['Urea', 'DAP', 'MOP'],
      ),
      CropInfo(
        name: 'Pulses',
        icon: '🫘',
        description: 'Pulses are the edible seeds of plants in the legume family.',
        requirements: ['Well-drained soil', 'Moderate rainfall', 'Warm temperature'],
        growingPeriodDays: 80,
        bestSeason: 'Rabi',
        waterRequirement: 280.0,
        commonPests: ['Pod Borer', 'Aphids', 'Thrips'],
        commonDiseases: ['Powdery Mildew', 'Rust', 'Leaf Spot'],
        fertilizers: ['DAP', 'MOP', 'Gypsum'],
      ),
    ];
  }

  @override
  Future<List<MarketPrice>> getMarketPrices() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/v1/market/prices'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> prices = jsonDecode(response.body)['data']['prices'];
        if (prices.isNotEmpty) {
          return prices.map((m) => MarketPrice(
            cropName: m['cropName'],
            pricePerQuintal: (m['pricePerQuintal'] ?? 0.0).toDouble(),
            trend: m['trend'] ?? 'stable',
            market: m['mandiName'],
            lastUpdated: DateTime.tryParse(m['priceDate'] ?? '') ?? DateTime.now(),
          )).toList();
        }
      }
    } catch (e) {
      print('Error fetching market prices: $e');
    }

    // Default mock data if backend empty or fails
    return [
      MarketPrice(
        cropName: 'Wheat',
        pricePerQuintal: 2850.0,
        trend: 'up',
        market: 'Pune',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      MarketPrice(
        cropName: 'Rice',
        pricePerQuintal: 3200.0,
        trend: 'stable',
        market: 'Mumbai',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 3)),
      ),
      MarketPrice(
        cropName: 'Soybean',
        pricePerQuintal: 4200.0,
        trend: 'up',
        market: 'Nagpur',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      MarketPrice(
        cropName: 'Cotton',
        pricePerQuintal: 6500.0,
        trend: 'down',
        market: 'Akola',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 4)),
      ),
    ];
  }

  @override
  Future<List<PestDiseaseAlert>> getPestDiseaseAlerts() async {
    await Future.delayed(const Duration(milliseconds: 300));
    
    return [
      PestDiseaseAlert(
        id: '1',
        type: 'pest',
        name: 'Aphid Alert',
        description: 'High aphid activity detected in the region. Monitor your crops closely.',
        severity: 'medium',
        affectedCrops: ['Wheat', 'Maize', 'Cotton'],
        solution: 'Apply neem oil spray or contact local agriculture office for recommended pesticides.',
        createdAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      PestDiseaseAlert(
        id: '2',
        type: 'disease',
        name: 'Wheat Rust Warning',
        description: 'Favorable conditions for wheat rust development observed.',
        severity: 'high',
        affectedCrops: ['Wheat'],
        solution: 'Apply fungicide preventively and ensure proper field drainage.',
        createdAt: DateTime.now().subtract(const Duration(hours: 12)),
      ),
      PestDiseaseAlert(
        id: '3',
        type: 'pest',
        name: 'Bollworm Activity',
        description: 'Moderate bollworm activity reported in cotton growing areas.',
        severity: 'low',
        affectedCrops: ['Cotton'],
        solution: 'Regular monitoring and use pheromone traps for early detection.',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
    ];
  }
}
