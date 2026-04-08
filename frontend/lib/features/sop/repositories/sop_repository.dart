import 'package:kurukshetra/core/network/api_client.dart';
import '../models/sop_model.dart';

abstract class SopRepository {
  Future<List<SopCategory>> getCategories();
  Future<SopData> getSopForCrop(String cropId);
}

class SopRepositoryImpl implements SopRepository {
  final _apiClient = ApiClient();

  @override
  Future<List<SopCategory>> getCategories() async {
    // Mock Data mimicking the API response
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      SopCategory(
        name: 'Cereals',
        crops: [
          SopCrop(id: 'ragi', name: 'Ragi', imageUrl: 'https://images.unsplash.com/photo-1574323347407-293e17ce4f52?auto=format&fit=crop&q=80&w=300'),
          SopCrop(id: 'bajra', name: 'Bajra', imageUrl: 'https://images.unsplash.com/photo-1627920769212-04fb736636ce?auto=format&fit=crop&q=80&w=300'),
          SopCrop(id: 'wheat', name: 'Wheat', imageUrl: 'https://images.unsplash.com/photo-1574323347407-293e17ce4f52?auto=format&fit=crop&q=80&w=300'),
          SopCrop(id: 'paddy', name: 'Paddy', imageUrl: 'https://images.unsplash.com/photo-1586208559288-518aebcf023f?auto=format&fit=crop&q=80&w=300'),
          SopCrop(id: 'maize', name: 'Maize', imageUrl: 'https://images.unsplash.com/photo-1551754655-cd27e38d2076?auto=format&fit=crop&q=80&w=300'),
        ],
      ),
      SopCategory(
        name: 'Pulses',
        crops: [
          SopCrop(id: 'blackgram', name: 'Black Gram', imageUrl: 'https://images.unsplash.com/photo-1615485906857-e637841bd614?auto=format&fit=crop&q=80&w=300'),
          SopCrop(id: 'greengram', name: 'Green Gram', imageUrl: 'https://images.unsplash.com/photo-1615485906857-e637841bd614?auto=format&fit=crop&q=80&w=300'),
          SopCrop(id: 'pigeonpea', name: 'Pigeon Pea', imageUrl: 'https://images.unsplash.com/photo-1615485906857-e637841bd614?auto=format&fit=crop&q=80&w=300'),
          SopCrop(id: 'gram', name: 'Gram', imageUrl: 'https://images.unsplash.com/photo-1615485906857-e637841bd614?auto=format&fit=crop&q=80&w=300'),
        ],
      ),
      SopCategory(
        name: 'Oilseeds',
        crops: [
          SopCrop(id: 'sfl', name: 'Sunflower', imageUrl: 'https://images.unsplash.com/photo-1597848212624-a19eb35e2651?auto=format&fit=crop&q=80&w=300'),
          SopCrop(id: 'soy', name: 'Soybean', imageUrl: 'https://images.unsplash.com/photo-1615485906857-e637841bd614?auto=format&fit=crop&q=80&w=300'),
          SopCrop(id: 'gna', name: 'Groundnut', imageUrl: 'https://images.unsplash.com/photo-1615485906857-e637841bd614?auto=format&fit=crop&q=80&w=300'),
        ],
      ),
    ];
  }

  @override
  Future<SopData> getSopForCrop(String cropId) async {
    // Attempting to fetch from Node.js backend if reachable
    try {
      final response = await _apiClient.dio.get('/sop/$cropId');
      if (response.data != null && response.data['data'] != null) {
        final data = response.data['data'];
        return SopData(
          cropName: data['cropName'],
          steps: (data['steps'] as List).map((s) => SopStep(
            title: s['title'],
            description: s['description'],
            detailedContent: s['detailedContent'],
            imageUrl: s['imageUrl'] ?? '',
            tips: s['tips'] ?? '',
          )).toList(),
        );
      }
    } catch (e) {
      // API not available, fall back to mock data
    }

    await Future.delayed(const Duration(milliseconds: 500));
    
    // Fallback Mock Reference
    return SopData(
      cropName: 'Ragi',
      steps: [
        SopStep(
          title: 'Land Preparation',
          description: 'Deep ploughing and leveling of land.',
          detailedContent: 'For ragi, the land should be ploughed deep followed by 2-3 harrowings to bring the soil to a fine tilth. Ensure proper drainage before proceeding.',
          imageUrl: 'https://images.unsplash.com/photo-1589923188900-85dae523342b?auto=format&fit=crop&q=80&w=600',
          tips: 'Avoid water stagnation. Proper leveling prevents water accumulation.',
        ),
        SopStep(
          title: 'Seed Treatment',
          description: 'Treat seeds with fungicide before sowing.',
          detailedContent: 'Treat seeds with Carbendazim (2g/kg of seeds) before sowing to prevent fungal diseases from affecting the germination stage.',
          imageUrl: 'https://images.unsplash.com/photo-1644919531551-40ffc2419ec8?auto=format&fit=crop&q=80&w=600',
          tips: 'Always wear gloves while treating seeds with chemicals.',
        ),
        SopStep(
          title: 'Sowing Method',
          description: 'Drilling or transplanting depending on conditions.',
          detailedContent: 'Sowing should be done at a spacing of 30 cm between rows and 10 cm between plants. The optimum depth of sowing is 2-3 cm.',
          imageUrl: 'https://images.unsplash.com/photo-1500937386664-56d1dfef3854?auto=format&fit=crop&q=80&w=600',
          tips: 'Ensure adequate moisture in soil before sowing.',
        ),
        SopStep(
          title: 'Fertilizer Application',
          description: 'Apply balanced NPK dose.',
          detailedContent: 'Apply half the recommended dose of nitrogen and full dose of phosphorus and potassium as basal. Appy remaining nitrogen 30 days after sowing.',
          imageUrl: 'https://images.unsplash.com/photo-1464226184884-fa280b87c399?auto=format&fit=crop&q=80&w=600',
          tips: 'Do not apply fertilizer on wet leaves to avoid burning.',
        ),
        SopStep(
          title: 'Irrigation Management',
          description: 'Maintain adequate moisture during critical stages.',
          detailedContent: 'Irrigate immediately after sowing if soil is dry. Critical stages for irrigation are tillering, flowering, and grain filling.',
          imageUrl: 'https://images.unsplash.com/photo-1560493676-04071c5f467b?auto=format&fit=crop&q=80&w=600',
          tips: 'Ragi is a highly drought-tolerant crop but responds well to timely irrigation.',
        ),
        SopStep(
          title: 'Weed Management',
          description: 'Keep the field weed-free initially.',
          detailedContent: 'Two initial hand weedings at 15 and 30 days after sowing are critical to prevent yield losses due to weed competition.',
          imageUrl: 'https://images.unsplash.com/photo-1592424001815-1888ba37ec9b?auto=format&fit=crop&q=80&w=600',
          tips: 'Pre-emergence herbicides can also be used following expert advice.',
        ),
        SopStep(
          title: 'Pest & Disease Control',
          description: 'Monitor fields regularly for blast and stem borer.',
          detailedContent: 'For blast disease, spray Mancozeb or Tricyclazole if symptoms appear on leaves or neck. Utilize pheromone traps for borers.',
          imageUrl: 'https://images.unsplash.com/photo-1590492476563-8cfb05eff1fa?auto=format&fit=crop&q=80&w=600',
          tips: 'Use integrated pest management instead of totally relying on chemicals.',
        ),
        SopStep(
          title: 'Harvesting',
          description: 'Harvest when ears turn brown.',
          detailedContent: 'Harvesting should be done when earheads turn completely brown and dry. Cut the earheads, dry them in the sun, and thresh.',
          imageUrl: 'https://images.unsplash.com/photo-1605370215714-d029fbf9ccb7?auto=format&fit=crop&q=80&w=600',
          tips: 'Store the grain safely in a dry warehouse environment to prevent post-harvest losses.',
        ),
      ]
    );
  }
}
